USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[FetchGraduateSeniors]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Adeel Siddiqui  
-- Create date: 30-MAR-2018
-- Description: Returns Graduate Customer non paginated List using search criteria provided.  
-- =============================================  
--exec FetchGraduateSeniors 44,'','1',''
--exec FetchGraduateSeniors 44,null,null,null,null,null
--exec FetchGraduateSeniors 44,'14','Food Service School','','1','asc'
--exec FetchGraduateSeniors 44,'','','','1','asc'
-- =============================================
CREATE PROCEDURE [dbo].[FetchGraduateSeniors] (
	@ClientID BIGINT
	,@SearchString VARCHAR(60) = ''
	,@SchoolFilter VARCHAR(50) = ''
	,@GradeFilter VARCHAR(50) = ''
	,@DistrictFilter VARCHAR(50) = ''
	,@SortColumn VARCHAR(50) = 'CustomerName'
	,@SortOrder VARCHAR(50) = 'ASC'
	)
AS
BEGIN
	DECLARE @lPageNbr INT
		,@lPageSize INT
		,@lSortCol NVARCHAR(20)
		,@SkipRows INT

	--SET @lPageNbr = @PageNo
	--SET @lPageSize = @PageSize
	SET @lSortCol = LTRIM(RTRIM(@SortColumn))

	--print @lSortCol
	SELECT *
	FROM (
		SELECT C.id
			,C.UserId
			,C.FirstName + ', ' + C.LastName AS CustomerName
			,CONVERT(BIT, 1) AS Graduate
			,ISNULL(AI.MBalance, 0) AS MBalance
			,ISNULL(AI.ABalance, 0) AS ABalance
			,ISNULL(AI.MBalance, 0) + ISNULL(AI.ABalance, 0) AS TotalBalance
			,CASE 
				WHEN ((C.isStudent = 1) AND (G.NAME IS NULL)) THEN 'Not Assigned'  
				WHEN ((C.isStudent = 0) AND (G.NAME IS NULL)) THEN 'FACULTY'  
			ELSE g.NAME END AS Grade
			,S.SchoolName
			,S.Id AS SchoolID
			,G.Id AS GradeID
			,D.Id AS DistrictId
		FROM Customers C
		LEFT OUTER JOIN District D ON D.ClientID = C.ClientID
			AND D.Id = c.District_Id
		LEFT OUTER JOIN AccountInfo AI ON AI.ClientID = C.ClientID
			AND C.ID = AI.Customer_Id
		LEFT OUTER JOIN Grades G ON G.ClientID = c.ClientID
			AND G.Id = c.Grade_Id
		LEFT OUTER JOIN Customer_School CS ON cs.ClientID = C.ClientID
			AND CS.Customer_Id = c.Id
			AND CS.isPrimary = 1
		LEFT OUTER JOIN Schools S ON S.ClientID = CS.ClientID
			AND S.Id = CS.School_Id
		WHERE C.IsActive = 1
			AND c.isDeleted = 0
			AND D.IsDeleted = 0
			AND C.ClientID = @ClientID
		) tbl
	WHERE (
			(
				CustomerName LIKE '%' + @SearchString + '%'
				--AND @SearchBy IN (0)
				)
			OR (
				SchoolName LIKE '%' + @SearchString + '%'
				--AND @SearchBy IN (1)
				)
			OR (
				Grade LIKE '%' + @SearchString + '%'
				--AND @SearchBy IN (2)
				)
			OR (
				UserId LIKE '%' + @SearchString + '%'
				--AND @SearchBy IN (2)
				)
			OR (
				MBalance LIKE '%' + @SearchString + '%'
				--AND @SearchBy IN (2)
				)
			OR (
				ABalance LIKE '%' + @SearchString + '%'
				--AND @SearchBy IN (2)
				)
			OR (
				TotalBalance LIKE '%' + @SearchString + '%'
				--AND @SearchBy IN (2)
				)
			)
		AND (
			(
				isNull(SchoolID, 0) = CASE 
					WHEN @SchoolFilter = ''
						THEN IsNull(SchoolID, 0)
					ELSE @SchoolFilter
					END
				) --school filter  
			AND (
				IsNull(GradeID, 0) = CASE 
					WHEN @GradeFilter = ''
						THEN IsNull(GradeID, 0)
					WHEN @GradeFilter = '0'
						THEN 0
					ELSE @GradeFilter
					END
				) -- Grade Filter  
			AND (
				IsNull(DistrictId, 0) = CASE 
					WHEN @DistrictFilter = ''
						THEN IsNull(DistrictId, 0)
					ELSE @DistrictFilter
					END
				) -- District Filter
			)
	ORDER BY
		--Customer Name
		CASE 
			WHEN (
					@lSortCol = '2'
					AND @SortOrder = 'ASC'
					)
				THEN CustomerName
			END ASC
		,CASE 
			WHEN (
					@lSortCol = '2'
					AND @SortOrder = 'DESC'
					)
				THEN CustomerName
			END DESC
		--Grade
		,CASE 
			WHEN (
					@lSortCol = '4'
					AND @SortOrder = 'ASC'
					)
				THEN Grade
			END ASC
		,CASE 
			WHEN (
					@lSortCol = '4'
					AND @SortOrder = 'DESC'
					)
				THEN Grade
			END DESC
		--School Name
		,CASE 
			WHEN (
					@lSortCol = '5'
					AND @SortOrder = 'ASC'
					)
				THEN SchoolName
			END ASC
		,CASE 
			WHEN (
					@lSortCol = '5'
					AND @SortOrder = 'DESC'
					)
				THEN SchoolName
			END DESC
		--User Id
		,CASE 
			WHEN (
					@lSortCol = '1'
					AND @SortOrder = 'ASC'
					)
				THEN UserId
			END ASC
		,CASE 
			WHEN (
					@lSortCol = '1'
					AND @SortOrder = 'DESC'
					)
				THEN UserId
			END DESC
		--Meal Balance
		,CASE 
			WHEN (
					@lSortCol = '6'
					AND @SortOrder = 'ASC'
					)
				THEN MBalance
			END ASC
		,CASE 
			WHEN (
					@lSortCol = '6'
					AND @SortOrder = 'DESC'
					)
				THEN MBalance
			END DESC
		--Ala Carte Balance
		,CASE 
			WHEN (
					@lSortCol = '7'
					AND @SortOrder = 'ASC'
					)
				THEN ABalance
			END ASC
		,CASE 
			WHEN (
					@lSortCol = '7'
					AND @SortOrder = 'DESC'
					)
				THEN ABalance
			END DESC
		-- Total Balance
		,CASE 
			WHEN (
					@lSortCol = '8'
					AND @SortOrder = 'ASC'
					)
				THEN TotalBalance
			END ASC
		,CASE 
			WHEN (
					@lSortCol = '8'
					AND @SortOrder = 'DESC'
					)
				THEN TotalBalance
			END DESC
END
GO
