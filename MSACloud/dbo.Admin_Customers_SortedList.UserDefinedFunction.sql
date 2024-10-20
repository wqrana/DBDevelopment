USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Customers_SortedList]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Abid
-- Create date: 12/21/2016
-- Description:	Returns Customer List using search criteria provided.
-- =============================================
 --select * from Admin_Customers_SortedList (44,'',0,1,'','5','',0,0,1,25,'Customer_Id', 'ASC')

-- =============================================
CREATE FUNCTION [dbo].[Admin_Customers_SortedList]
(
	@ClientID bigint,
	@SearchString varchar(60) = '',
		-- 0 - (LN, FN, & USERID); 1 - LN; 2 - FN; 3 - USERID; 4 - Grade; 5 - Homeroom; 
		-- 6 - PIN; 
	@SearchBy int = 0 ,


	/*– Filters */
	@isAnyFilter bit = 0,
	@SchoolFilter varchar(50) = '',
	@GradeFilter  varchar(50) = '',
	@HomeRoomFilter  varchar(50) = '',
	@OnlyActive bit = null,
	@OnlyAdult bit = null,
	@ExcludeCashSale bit = 0,
	@IsBalanceRequired bit = 0,


	/*– Pagination Parameters */
	@PageNo INT = 1,
	@PageSize INT = 10,
	
	/*– Sorting Parameters */
	@SortColumn varchar(50) = 'LastName',
	@SortOrder varchar(50) = 'ASC'
)
RETURNS @MyCustList TABLE(
	allRecordsCount int,
	Customer_Id int,
	UserID varchar(16), 
	Last_Name varchar(30), 
	First_Name varchar(30), 
	Middle_Initial varchar(1), 
	Adult bit, 
	Active bit,
	Grade varchar(30), 
	Homeroom varchar(30), 
	School_Name varchar(60),
	PIN varchar(20),
	M_Balance decimal(18,2),
	A_Balance decimal(18,2),
	Total_Balance decimal(18,2))
AS
BEGIN
	
	DECLARE 
	
	@MyTempTable TABLE(
	allRecordsCount int,
	Customer_Id int,
	UserID varchar(16), 
	Last_Name varchar(30), 
	First_Name varchar(30), 
	Middle_Initial varchar(1), 
	Adult bit, 
	Active bit,
	Grade varchar(30), 
	Homeroom varchar(30), 
	School_Name varchar(60),
	PIN varchar(20),
	M_Balance decimal(18,2),
	A_Balance decimal(18,2),
	Total_Balance decimal(18,2),
	UsingBonus int
	)

	DECLARE

	@lPageNbr INT,
    @lPageSize INT,
    @lSortCol NVARCHAR(20),
	@SkipRows INT

	
	SET @lPageNbr = @PageNo
    SET @lPageSize = @PageSize
    SET @lSortCol = LTRIM(RTRIM(@SortColumn))

	SET @SkipRows = (@lPageNbr - 1) * @lPageSize 

	
	INSERT INTO @MyTempTable
	SELECT	
		totalCount,
		Customer_Id,
			UserID,
			Last_Name,
			First_Name,
			Middle_Initial,
			Adult,
			Active,
			Grade,
			Homeroom,
			School_Name,
			PIN,
			M_Balance,
			A_Balance,
			Total_Balance,
			UsingBonus

	from (
				SELECT
				COUNT(1) OVER() as totalCount,
				c.Id as Customer_Id,
				c.UserID, 
				c.LastName as Last_Name, 
				c.FirstName as First_Name, 
				ISNULL(c.Middle,'') as Middle_Initial, 
				--CASE c.isStudent WHEN 1 THEN 0 ELSE 1 END as Adult, 
				CASE WHEN c.LunchType IS NULL OR c.LunchType = 4 THEN 1 ELSE 0 END as Adult, 
				c.isActive as Active,
				ISNULL(g.Name,'') as Grade, 
				ISNULL(h.Name,'') as Homeroom,
				ISNULL(s.SchoolName,'') as School_Name,
				ISNULL(c.PIN,'') as PIN,
				/*
				ROUND(ISNULL(ai.MBalance,0.0),2) as M_Balance,
				ROUND(ISNULL(ai.ABalance,0.0),2) as A_Balance,
				ROUND(ISNULL(ai.MBalance,0.0) + ISNULL(ai.ABalance,0.0),2) as Total_Balance
				*/
				case @IsBalanceRequired
				when 1 then ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, c.Id, ISNULL(do.UsingBonus,0), 2, GETUTCDATE()), 0), 2)
				else 1 
				end as M_Balance,

				case @IsBalanceRequired
				when 1 then ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, c.Id, ISNULL(do.UsingBonus,0), 1, GETUTCDATE()), 0), 2)
				else 1
				end as A_Balance,
				case @IsBalanceRequired
				when 1 then ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, c.Id, ISNULL(do.UsingBonus,0), 0, GETUTCDATE()), 0), 2) 
				else 1
				end as Total_Balance,
				ISNULL(do.UsingBonus,0) as UsingBonus

			FROM Customers c
				LEFT OUTER JOIN Grades g ON g.ClientID = c.ClientID AND g.Id = c.Grade_Id
				LEFT OUTER JOIN Homeroom h ON h.ClientID = c.ClientID AND h.Id = c.Homeroom_Id
				LEFT OUTER JOIN Customer_School cs ON cs.ClientID = c.ClientID AND cs.Customer_Id = c.Id AND cs.isPrimary = 1
				LEFT OUTER JOIN Schools s ON s.ClientID = cs.ClientID AND s.Id = cs.School_Id
				LEFT OUTER JOIN DistrictOptions do ON do.ClientID = c.ClientID and do.District_Id = c.District_Id
				--LEFT OUTER JOIN AccountInfo ai ON ai.ClientID = c.ClientID AND ai.Customer_Id = c.Id
			WHERE c.ClientID = @ClientID AND 
					(
						(c.LastName like '%' +  @SearchString + '%'   AND @SearchBy in (0,1))
							OR
						(c.FirstName like '%' +  @SearchString + '%' AND @SearchBy in (0,2))
							OR
						(c.UserID like '%' +  @SearchString + '%' AND @SearchBy in (0,3))
							OR
						(g.Name like '%' +  @SearchString + '%' AND @SearchBy in (4))
							OR
						(h.Name like '%' +  @SearchString + '%' AND @SearchBy in (5))
						OR
						(C.PIN like '%' +  @SearchString + '%' AND @SearchBy in (6))
					)
			
					AND
					(				
						(isNull(s.SchoolName,'') like '%' + @SchoolFilter + '%') --school filter
				
						AND
						( IsNull(g.ID,0) =  case when @GradeFilter= '' then IsNull(g.ID,0) else @GradeFilter end) -- Grade Filter
				
						AND
						( isnull(h.Name,'') = case when @HomeRoomFilter='' then isnull(h.Name,'') else @HomeRoomFilter end) -- HomeRoom filter
				
						AND
						isNULL(c.isActive,0) = IsNull(@OnlyActive,isNULL(c.isActive,0)) -- Status filter
				
						AND
						(
							(IsNull(c.LunchType,4)  = case when @OnlyAdult is null then IsNull(c.LunchType,4) when @OnlyAdult = 1 then 4 end)
							OR 
							(@OnlyAdult = 0 AND IsNull(c.LunchType,4) != 4)					-- Adult Filter
						)
				
						AND
						(
							(@ExcludeCashSale = 1 AND c.LastName  <> 'Cash Sale')
							OR
							(@ExcludeCashSale = 0 )										--Exclude Cash Sale customer
						)
				
					)
							 
					AND
					(
						c.isDeleted = 0 
					)
		) as subQuery
	ORDER BY 
		CASE WHEN (@lSortCol = 'Customer_Id' AND @SortOrder='ASC') THEN Customer_Id
        END ASC,
        CASE WHEN (@lSortCol = 'Customer_Id' AND @SortOrder='DESC') THEN Customer_Id
        END DESC,
		----------
		CASE WHEN (@lSortCol = 'UserID' AND @SortOrder='ASC') THEN UserID
        END ASC,
        CASE WHEN (@lSortCol = 'UserID' AND @SortOrder='DESC') THEN UserID
        END DESC,
		----------
		CASE WHEN (@lSortCol = 'Last_Name' AND @SortOrder='ASC') THEN Last_Name
        END ASC,
        CASE WHEN (@lSortCol = 'Last_Name' AND @SortOrder='DESC') THEN Last_Name
        END DESC,
		----------
		CASE WHEN (@lSortCol = 'First_Name' AND @SortOrder='ASC') THEN First_Name
        END ASC,
        CASE WHEN (@lSortCol = 'First_Name' AND @SortOrder='DESC') THEN First_Name
        END DESC,
		----------
		CASE WHEN (@lSortCol = 'Middle_Initial' AND @SortOrder='ASC') THEN Middle_Initial
        END ASC,
        CASE WHEN (@lSortCol = 'Middle_Initial' AND @SortOrder='DESC') THEN Middle_Initial
        END DESC,
		----------
		CASE WHEN (@lSortCol = 'Adult' AND @SortOrder='ASC') THEN Adult
        END ASC,
        CASE WHEN (@lSortCol = 'Adult' AND @SortOrder='DESC') THEN Adult
        END DESC,
		----------
		CASE WHEN (@lSortCol = 'Active' AND @SortOrder='ASC') THEN Active
        END ASC,
        CASE WHEN (@lSortCol = 'Active' AND @SortOrder='DESC') THEN Active
        END DESC,
		----------
		CASE WHEN (@lSortCol = 'Grade' AND @SortOrder='ASC') THEN Grade
        END ASC,
        CASE WHEN (@lSortCol = 'Grade' AND @SortOrder='DESC') THEN Grade
        END DESC,
		-----------
		CASE WHEN (@lSortCol = 'Homeroom' AND @SortOrder='ASC') THEN Homeroom
        END ASC,
        CASE WHEN (@lSortCol = 'Homeroom' AND @SortOrder='DESC') THEN Homeroom
        END DESC,
		-----------
		CASE WHEN (@lSortCol = 'School_Name' AND @SortOrder='ASC') THEN School_Name
        END ASC,
        CASE WHEN (@lSortCol = 'School_Name' AND @SortOrder='DESC') THEN School_Name
        END DESC,
		-----------
		CASE WHEN (@lSortCol = 'PIN' AND @SortOrder='ASC') THEN PIN
        END ASC,
        CASE WHEN (@lSortCol = 'PIN' AND @SortOrder='DESC') THEN PIN
        END DESC,
		-----------
		CASE WHEN (@lSortCol = 'Total_Balance' AND @SortOrder='ASC') THEN Total_Balance
        END ASC,
        CASE WHEN (@lSortCol = 'Total_Balance' AND @SortOrder='DESC') THEN Total_Balance
        END DESC
		-----------
	

	OFFSET @SkipRows ROWS
	FETCH NEXT @lPageSize ROWS ONLY

	insert into @MyCustList
	select allRecordsCount, Customer_Id, UserID, Last_Name, First_Name, Middle_Initial, Adult, Active,
	Grade, 	Homeroom, 	School_Name,	PIN,

	CASE @IsBalanceRequired
	when 0 then ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, t.Customer_Id, ISNULL(t.UsingBonus,0), 2, GETUTCDATE()), 0), 2)
	else t.Total_Balance
	end
	as M_Balance,

	CASE @IsBalanceRequired
	when 0 then ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, t.Customer_Id, ISNULL(t.UsingBonus,0), 1, GETUTCDATE()), 0), 2)
	else t.Total_Balance
	end
	as A_Balance,

	CASE @IsBalanceRequired
	when 0 then ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, t.Customer_Id, ISNULL(t.UsingBonus,0), 0, GETUTCDATE()), 0), 2)
	else t.Total_Balance
	end
	as Total_Balance from @MyTempTable t

	RETURN
END
GO
