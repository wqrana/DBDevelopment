USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_BeginningBalance_Get]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Adeel Siddiqui    
-- Create date: 12-APR-2018  
-- Description: Returns Beginning Balance for customer non paginated List using search criteria provided.    
-- =============================================    
--exec FetchBeginningBalance 44,'','1',''  
--exec FetchBeginningBalance 44,null,null,null,null,null  
--exec FetchBeginningBalance 44,'14','Food Service School','','1','asc'  
--exec FetchBeginningBalance 44,'','','','1','asc'  
-- =============================================  
CREATE PROCEDURE [dbo].[Admin_BeginningBalance_Get] (  
	@ClientID BIGINT  
	,@SearchString VARCHAR(60) = ''  
	,@SchoolFilter VARCHAR(50) = ''  
	,@GradeFilter VARCHAR(50) = ''  
	,@HomeRoomFilter VARCHAR(50) = ''  
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
  
 SELECT *  
 FROM (  
  SELECT 
	c.ID AS Customer_Id,
	c.UserID, 
	RTRIM(c.LastName) + ', ' + RTRIM(c.FirstName) + ' ' + ISNULL(c.Middle, ' ') AS CustomerName,
	CASE 
		WHEN ((c.isStudent = 1) AND (g.NAME IS NULL)) THEN 'No Grade'  
		WHEN ((c.isStudent = 0) AND (g.NAME IS NULL)) THEN 'FACULTY'  
		ELSE g.NAME  
    END AS Grade,  
   cast(0 AS BIT) AS DBUpdate,
   round(SUM(ISNULL(o.ADebit,0.0)), 2) AS Alacarte,  
   round(SUM(ISNULL(o.MDebit,0.0)), 2) AS MealPlan,
   ai.ABalance, 
   ai.MBalance,  
   ai.BonusBalance,  
   round(SUM(ISNULL(o.ADebit,0.0)) + SUM(ISNULL(o.MDebit,0.0)), 2) AS Balance, 
   round(SUM(ISNULL(o.ADebit,0.0)), 2) AS PrevAlaCarte, 
   round(SUM(ISNULL(o.MDebit,0.0)), 2) AS PrevMealPlan, 
   round((ai.ABalance + ai.MBalance + ai.BonusBalance), 2) AS CustomerBalance, 
   s.SchoolName, 
   s.Id AS SchoolID,   
   g.Id AS GradeID,   
   h.Id AS HomeRoomId,   
   h.NAME AS HomeRoomName,   
   D.id as DistrictId
FROM Customers c  
	LEFT OUTER JOIN District d on d.ClientID = c.ClientID AND D.Id = c.District_Id
	LEFT OUTER JOIN Orders o ON o.ClientID = c.ClientID AND o.Customer_Id = c.Id AND (o.TransType = 1700 OR o.Emp_Cashier_Id = -99)
	LEFT OUTER JOIN Customer_School cs ON cs.ClientID = c.ClientID AND cs.Customer_Id = c.Id AND cs.isPrimary = 1  
	LEFT OUTER JOIN Schools s ON s.ClientID = cs.ClientID AND s.Id = cs.School_Id  
	LEFT OUTER JOIN Grades g ON g.ClientID = c.ClientID AND g.Id = c.Grade_Id  
	LEFT OUTER JOIN Homeroom h ON h.ClientID = c.ClientID AND h.Id = c.Homeroom_Id  
	LEFT OUTER JOIN AccountInfo ai ON ai.ClientID = c.ClientID AND ai.Customer_Id = c.Id  
WHERE 
	c.ClientID = @ClientID AND
	c.isDeleted = 0 AND 
	c.isActive = 1
GROUP BY c.Id, c.UserID, c.LastName, RTRIM(c.LastName) + ', ' + RTRIM(c.FirstName) + ' ' + ISNULL(c.Middle, ' '),
	s.SchoolName, s.Id, g.Id, h.Id, h.[name], d.Id, 
		CASE 
			WHEN ((c.isStudent = 1) AND (g.NAME IS NULL)) THEN 'No Grade'
			WHEN ((c.isStudent = 0) AND (g.NAME IS NULL)) THEN 'FACULTY'  
			ELSE g.NAME  
		END,
	ai.ABalance, ai.MBalance, ai.BonusBalance, 
	round((ai.ABalance + ai.MBalance + ai.BonusBalance), 2)  
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
    Balance LIKE '%' + @SearchString + '%'  
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
     ELSE @GradeFilter  
     END  
    ) -- Grade Filter   
   AND (  
    IsNull(HomeRoomId, 0) = CASE   
     WHEN @HomeRoomFilter = ''  
      THEN IsNull(HomeRoomId, 0)  
     ELSE @HomeRoomFilter  
     END  
    ) -- Homeroom Filter   
	   AND (  
    IsNull(DistrictId, 0) = CASE   
     WHEN @DistrictFilter = ''  
      THEN IsNull(DistrictId, 0)  
     ELSE @DistrictFilter  
     END  
    )--DistrictFilter     
   )  
 ORDER BY  
  --UserId  
  CASE   
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
  --Customer Name  
  ,CASE   
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
     @lSortCol = '3'  
     AND @SortOrder = 'ASC'  
     )  
    THEN Grade  
   END ASC  
  ,CASE   
   WHEN (  
     @lSortCol = '3'  
     AND @SortOrder = 'DESC'  
     )  
    THEN Grade  
   END DESC  
  --Meal Balance  
  ,CASE   
   WHEN (  
     @lSortCol = '4'  
     AND @SortOrder = 'ASC'  
     )  
    THEN MealPlan  
   END ASC  
  ,CASE   
   WHEN (  
     @lSortCol = '4'  
     AND @SortOrder = 'DESC'  
     )  
    THEN MealPlan  
   END DESC  
  --Ala Carte Balance  
  ,CASE   
   WHEN (  
     @lSortCol = '5'  
     AND @SortOrder = 'ASC'  
     )  
    THEN Alacarte  
   END ASC  
  ,CASE   
   WHEN (  
     @lSortCol = '5'  
     AND @SortOrder = 'DESC'  
     )  
    THEN Alacarte  
   END DESC  
  -- Total Balance  
  ,CASE   
   WHEN (  
     @lSortCol = '6'  
     AND @SortOrder = 'ASC'  
     )  
    THEN Balance  
   END ASC  
  ,CASE   
   WHEN (  
     @lSortCol = '6'  
     AND @SortOrder = 'DESC'  
     )  
    THEN Balance  
   END DESC  
END
GO
