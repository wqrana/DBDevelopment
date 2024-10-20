USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Customer_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Neil Heverly
-- Create date: 2/10/2014
-- Description:	Returns Customer List using search criteria provided.
-- =============================================
/* 
	Revisions:
	2/19/2014 - Added Active Field to result
	2/26/2014 - Added Customer ID field to result
	2/28/2014 - Added Filter parameters (Allows to set filters on search)
	3/27/2014 - Geting Meal Balance and Ala Carta Balanace 
	4/27/2016 - Change Balances to be Recalculated
	select * from Admin_Customer_List(6,'Huss',0,'',0)
	4/29/2016 - Change Adult column case statement (by farrukh to fix PA-505)
*/

--select * from Admin_Customer_List(6,'Huss',0,'',0)

-- =============================================
CREATE FUNCTION [dbo].[Admin_Customer_List]
(
	@ClientID bigint,
	@SearchString varchar(60) = '',
	
	-- 0 - (LN, FN, & USERID); 1 - LN; 2 - FN; 3 - USERID; 4 - Grade; 5 - Homeroom;
	@SearchBy int = 0 ,
	@FilterString varchar(max) = '',
	-- 0 - No Filter; 1 - Student;
	@FilterBy int = 0
)
RETURNS @MyCustList TABLE(
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
	M_Balance decimal(10,2),
	A_Balance decimal(10,2),
	Total_Balance decimal(10,2))
AS
BEGIN
	/*** TESTING ONLY ***
	DECLARE 
		@ClientID bigint,
		@SearchString varchar(60),
		@SearchBy int

	SET @ClientID = 44
	SET @SearchString = 'George'
	SET @SearchBy = 0	
	**** END TESTING ****/

	INSERT INTO @MyCustList
	SELECT 
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
		/*
		ROUND(ISNULL(ai.MBalance,0.0),2) as M_Balance,
		ROUND(ISNULL(ai.ABalance,0.0),2) as A_Balance,
		ROUND(ISNULL(ai.MBalance,0.0) + ISNULL(ai.ABalance,0.0),2) as Total_Balance
		*/
		ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, c.Id, ISNULL(do.UsingBonus,0), 2, GETUTCDATE()), 0), 2) as M_Balance,
		ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, c.Id, ISNULL(do.UsingBonus,0), 1, GETUTCDATE()), 0), 2) as A_Balance,
		ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, c.Id, ISNULL(do.UsingBonus,0), 0, GETUTCDATE()), 0), 2) as Total_Balance
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
			)
			AND
			(
				(@FilterBy = 0)
				OR
				(c.isStudent = CAST(@FilterString as bit) AND @FilterBy in (1))
			) 
			AND
			(
			c.isDeleted = 0
			)
	ORDER BY LastName, FirstName, Middle

	RETURN
END
GO
