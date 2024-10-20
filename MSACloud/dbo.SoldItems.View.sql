USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[SoldItems]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[SoldItems]
AS
SELECT
	o.clientid, 
	it.Menu_Id as ItemMenuID,
	m.Id as MenuID,
	cat.Id as CategoryID,
	ct.Id as CategoryTypeID,
	o.POS_Id as POSID,
	o.School_Id as SCHID,
	o.Customer_Pr_School_Id as PRIMSCHID,
	o.Emp_Cashier_Id as EMPCASHID,
	o.OrderDate,
	o.GDate,
	o.TransType,
	CASE
		WHEN ct.Name IS NULL THEN 'Misc'
		ELSE ct.Name
	END as CategoryTypeName,
	CASE
		WHEN cat.Name IS NULL THEN 'Misc'
		ELSE cat.Name
	END as CategoryName,
	CASE
		WHEN m.ItemName IS NULL THEN 'Misc Item: $' + LTRIM(STR(it.PaidPrice, 10, 2))
		ELSE m.ItemName
	END as MenuItem,
	CASE
		WHEN o.LunchType IS NULL THEN 4
		WHEN (c.Id = -2) THEN 6
		WHEN (c.Id = -3) THEN 7
		WHEN (c.isStudent = 1 AND o.LunchType = 1) THEN 1
		WHEN (c.isStudent = 1 AND o.LunchType = 2) THEN 2
		WHEN (c.isStudent = 1 AND o.LunchType = 3) THEN 3
		WHEN (o.LunchType = 5) THEN 5
		ELSE 4
	END as LunchType,
	CASE
		WHEN o.LunchType IS NULL THEN 'Adult'
		WHEN (c.Id = -2) THEN 'Guest Cash Sale'
		WHEN (c.Id = -3) THEN 'Student Cash Sale'
		WHEN (c.isStudent = 1 AND o.LunchType = 1) THEN 'Paid'
		WHEN (c.isStudent = 1 AND o.LunchType = 2) THEN 'Reduced'
		WHEN (c.isStudent = 1 AND o.LunchType = 3) THEN 'Free'
		WHEN (o.LunchType = 5) THEN 'Meal Plan'
		ELSE 'Adult'
	END as LunchTypeStatus,
	it.qty as Qty, 
	it.FullPrice as RegularPrice,
	it.paidprice as Price, 
	it.SoldType,
	(it.qty*it.paidprice) as Total,
	CASE
		WHEN it.PreOrderItem_Id IS NOT NULL THEN 'Preorder Pickup'
		ELSE 'POS Sale'
	END as PreOrderStatus,
	CAST(CASE
		WHEN it.PreOrderItem_Id IS NOT NULL THEN 1
		ELSE 0
	END as BIT) as PreOrderPickup
FROM Orders o
	LEFT OUTER JOIN Customers c on (c.Id = o.Customer_Id) and c.clientid = o.clientid
	INNER JOIN Items it on ((o.Id = it.Order_Id) AND (it.isVoid = 0)) and it.clientid = o.clientid
	LEFT OUTER JOIN Menu m on (m.Id = it.Menu_Id) and m.clientid = it.clientid 
	LEFT OUTER JOIN Category cat on (cat.Id = m.Category_Id) and cat.clientid = m.clientid
	LEFT OUTER JOIN CategoryTypes ct on (ct.Id = cat.CategoryType_Id) and ct.clientid = cat.clientid
WHERE (o.isVoid = 0 AND o.Emp_Cashier_Id <> -99)
GO
