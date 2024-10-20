USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Applications_SortedList]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat H
-- Create date: 15-March-2018
-- Description:	Returns the list of applications and filters the data as well.
-- =============================================
CREATE FUNCTION [dbo].[Admin_Applications_SortedList] 
(
	@ClientID bigint,
	@SearchString varchar(60) = '',
		-- 0 Application ID, 1 - Parent Name or Signer, 2 - Student Name (First, Last, User ID)
	@SearchBy int = 0 ,

	/*– Filters */
	@SignedDateFilter Datetime = null,
	@ApprovalStatus int = null,
	@Entered bit = null,
	@Updated bit = null,

	/*– Pagination Parameters */
	@PageNo INT = 1,
	@PageSize INT = 10,
	
	/*– Sorting Parameters */
	@SortColumn varchar(50) = 'LastName',
	@SortOrder varchar(50) = 'ASC'
)
RETURNS 
@ApplicationsList TABLE 
(
	AllRecordsCount int,
	Application_Id int,
	Parent_Name varchar(100),
	Parent_Id int,
	Member_Name varchar(100),
	Member_Id int,
	Student_Name varchar(100),
	Student_Id int,
	District_Name varchar(100),
	Household_Size int,
	No_Of_Students int,
	No_Of_Members int,
	App_Signer_Name varchar(100),
	Approval_Status int,
	Entered bit,
	Updated bit
)
AS
BEGIN
	
	DECLARE

	@lPageNbr INT,
    @lPageSize INT,
    @lSortCol NVARCHAR(20),
	@SkipRows INT

	
	SET @lPageNbr = @PageNo
    SET @lPageSize = @PageSize
    SET @lSortCol = LTRIM(RTRIM(@SortColumn))

	SET @SkipRows = (@lPageNbr - 1) * @lPageSize 

	INSERT INTO @ApplicationsList
	SELECT
	Count(1) Over() as AllRecordsCount,
	Id,
	Parent_Name,
	Parent_Id,
	Member_Name,
	Member_Id,
	Student_Name,
	Student_Id,
	District_Name,
	Household_Size,
	No_Of_Students,
	No_Of_Members,
	App_Signer_Name,
	Status_type_Id,
	Entered,
	Updated
	FROM
	(
	SELECT DISTINCT
	ap.Id,
	null AS Parent_Name,
	ap.Parent_Id,
	CASE WHEN (@SearchBy = 1) THEN
	mem.First_Name + ' ' + mem.Last_Name
	ELSE
	null
	END AS Member_Name,

	0 AS Member_Id,
	CASE WHEN (@SearchBy = 2) THEN
	cust.FirstName + ' ' + cust.LastName
	ELSE
	null
	END AS Student_Name,
	0 AS Student_Id,
	dis.DistrictName AS District_Name,
	ap.Household_Size,

	(Select COUNT(*) FROM App_Members am
	 where am.Application_Id = ap.Id AND am.Member_Id IS null) as No_Of_Students,
	(Select DISTINCT COUNT(*) FROM App_Members am
	 where am.Application_Id = ap.Id AND am.Member_Id IS NOT null) as No_Of_Members,

	 apSig.[Signature] as App_Signer_Name,
	 apSta.Status_type_Id,
	 
	 ISNULL(ap.Entered, 0) AS Entered,
	 ISNULL(ap.Updated, 0) AS Updated

	FROM Applications as ap
	LEFT OUTER JOIN District as dis ON ap.District_Id = dis.Id
	LEFT OUTER JOIN App_Members as apMem ON apMem.Application_Id = ap.Id
	LEFT OUTER JOIN Members as mem ON apMem.Member_Id = mem.Id
	LEFT OUTER JOIN Customers as cust ON apMem.Customer_Id = cust.Id
	LEFT OUTER JOIN App_Signers as apSig ON apSig.Application_Id = ap.Id
	LEFT OUTER JOIN App_Statuses as apSta ON apSta.Application_Id = ap.Id

	WHERE ap.ClientID = @ClientID AND
	(
		(@SearchBy IN (0) AND  (ap.Id Like '%' + @SearchString + '%' OR @SearchString IS NULL))
		OR
		(@SearchBy IN (1) AND apMem.Member_Id IS NOT NULL AND (mem.First_Name Like '%' + @SearchString + '%' OR @SearchString IS NULL))
		 OR
		(@SearchBy IN (1) AND apMem.Member_Id IS NOT NULL AND (mem.Last_Name Like '%' + @SearchString + '%' OR @SearchString IS NULL))
		OR
		-- signer can be either a student or a member. If we search by 'Parent or signer' then we should get
		-- records of students who are signer of their applications as well. With the following case we won't get duplicates.
		(@SearchBy IN (1) AND (1 = (CASE WHEN apMem.Id = apSig.App_Member_Id THEN 1 ELSE 0 END)) AND (apSig.[Signature] Like '%' + @SearchString + '%' OR @SearchString IS NULL))
		OR
		(@SearchBy IN (2) AND apMem.Customer_Id IS NOT NULL AND (cust.FirstName Like '%' + @SearchString + '%' OR @SearchString IS NULL))
		OR
		(@SearchBy IN (2) AND apMem.Customer_Id IS NOT NULL AND (cust.LastName Like '%' + @SearchString + '%' OR @SearchString IS NULL))

	) AND
	(
		(@SignedDateFilter IS NULL OR CONVERT(date, apSig.Signed_Date) = CONVERT(date, @SignedDateFilter))

	) AND
	(
		(@ApprovalStatus IS NULL OR apSta.Status_Type_Id = @ApprovalStatus)

	) AND
	(
		(@Entered IS NULL OR ap.Entered = @Entered)

	) AND
	(
		(@Updated IS NULL OR ap.Updated = @Updated)
	)
	) AS subQuery

	ORDER By 
		CASE WHEN (@lSortCol = 'Application_Id' AND @SortOrder = 'ASC') THEN Id
		END ASC,
		CASE WHEN (@lSortCol = 'Application_Id' AND @SortOrder = 'DESC') THEN Id
		END DESC,

		CASE WHEN (@lSortCol = 'Member_Name' AND  @SortOrder = 'ASC') THEN Member_Name
		END ASC,
		CASE WHEN (@lSortCol = 'Member_Name' AND  @SortOrder = 'DESC') THEN Member_Name
		END DESC,

		CASE WHEN (@lSortCol = 'District_Name' AND  @SortOrder = 'ASC') THEN District_Name
		END ASC,
		CASE WHEN (@lSortCol = 'District_Name' AND  @SortOrder = 'DESC') THEN District_Name
		END DESC,

		CASE WHEN (@lSortCol = 'Household_Size' AND @SortOrder = 'ASC') THEN Household_Size
		END ASC,
		CASE WHEN (@lSortCol = 'Household_Size' AND @SortOrder = 'DESC') THEN Household_Size
		END DESC,

		CASE WHEN (@lSortCol = 'No_Of_Students' AND @SortOrder = 'ASC') THEN No_Of_Students
		END ASC,
		CASE WHEN (@lSortCol = 'No_Of_Students' AND @SortOrder = 'DESC') THEN No_Of_Students
		END DESC,

		CASE WHEN (@lSortCol = 'No_Of_Members' AND @SortOrder = 'ASC') THEN No_Of_Members
		END ASC,
		CASE WHEN (@lSortCol = 'No_Of_Members' AND @SortOrder = 'DESC') THEN No_Of_Members
		END DESC,

		CASE WHEN (@lSortCol = 'App_Signer_Name' AND @SortOrder = 'ASC') THEN App_Signer_Name
		END ASC,
		CASE WHEN (@lSortCol = 'App_Signer_Name' AND @SortOrder = 'DESC') THEN App_Signer_Name
		END DESC,

		CASE WHEN (@lSortCol = 'Approval_Status' AND @SortOrder = 'ASC') THEN Status_type_Id
		END ASC,
		CASE WHEN (@lSortCol = 'Approval_Status' AND @SortOrder = 'DESC') THEN Status_type_Id
		END DESC
		----------------------------------------------------------------
	OFFSET @SkipRows ROWS
	FETCH NEXT @lPageSize ROWS ONLY

	RETURN
END
GO
