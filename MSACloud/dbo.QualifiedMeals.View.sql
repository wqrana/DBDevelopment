USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[QualifiedMeals]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[QualifiedMeals]
AS
SELECT 
	s.Id as SCHID,
	ps.Id as PRIMSCHID,
	c.Id as CSTID,
	m.Id as MENUID,
	cat.Id as CATID,
	c.UserID,
	--RTRIM(c.LastName) + ', ' + RTRIM(c.FirstName) + ' ' + ISNULL(c.Middle,' ') as StudentName,
	c.LastName,
	c.FirstName,
	c.Middle,
    cat.Name as CategoryName, 
    m.itemname as MenuItem, 
    it.qty as QTY, 
    o.OrderDate as OrderDate, 
    s.SchoolName as SchoolName, 
    ps.SchoolName as PrimarySchool, 
	(CASE o.LunchType WHEN 3 THEN it.qty ELSE 0 END) as FreeCount,
	(CASE o.LunchType WHEN 2 THEN it.qty ELSE 0 END) as ReducedCount,
	(CASE o.LunchType WHEN 1 THEN it.qty ELSE 0 END) as PaidCount,
    CASE o.LunchType
		WHEN 1 THEN 'Paid' 
		WHEN 2 THEN 'Reduced' 
		WHEN 3 THEN 'Free' 
	END AS StudentLunchType 
FROM Orders o 
	INNER JOIN Items it ON (it.Order_Id = o.Id)
	LEFT OUTER JOIN Schools s ON (s.Id = o.School_Id)
	LEFT OUTER JOIN Customers c ON (c.Id = o.Customer_Id)
	LEFT OUTER JOIN Customer_School cs ON (cs.Customer_Id = o.Customer_Id) AND (cs.isPrimary = 1) 
  	LEFT OUTER JOIN Schools ps ON (ps.Id = cs.School_Id) 
    LEFT OUTER JOIN Menu m ON (m.Id = it.Menu_Id) 
    LEFT OUTER JOIN Category cat ON (cat.Id = m.Category_Id) 
    LEFT OUTER JOIN CategoryTypes ct ON (ct.Id = cat.CategoryType_Id)
WHERE (o.isVoid = 0 AND o.Emp_Cashier_Id <> -99) AND (it.isVoid = 0) AND (ct.canFree = 1 OR ct.canReduce = 1)
GO
