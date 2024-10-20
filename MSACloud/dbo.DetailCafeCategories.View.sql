USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[DetailCafeCategories]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[DetailCafeCategories]
AS

SELECT ClientID,ORDID,DISTID,SCHID,ItemMenuID,MENUID,CATID,PREORDITEMID,OrderDate,
		GDate,CSTID,CategoryName,CategoryType,canFree,canReduce,QualifiedSort,QualifiedDisplay,
		AccountType,NetPrice,AccountTotal,CashTotal,PreorderTotal,TotalCount,AccountCount,CashCount,PreorderCount,PaidPrice,
		CASE
		WHEN ordSaleTaxSeq = 1 THEN
		CashSaleSalesTax
		ELSE 0.00
		END AS CashSaleSalesTax,
		CASE
		WHEN ordSaleTaxSeq = 1 THEN
		AccountSaleSalesTax
		ELSE 0.00
		END AS AccountSaleSalesTax

FROM(
	SELECT
		o.ClientID as ClientID, 
		o.Id as ORDID,
		d.Id as DISTID,
		o.School_Id as SCHID,
		it.Menu_Id as ItemMenuID,
		m.Id as MENUID,
		cat.Id as CATID,
		poi.Id as PREORDITEMID,
		o.OrderDate,
		o.GDate,
		o.Customer_Id as CSTID,
		ISNULL(cat.Name, 'Misc') as CategoryName,
		ISNULL(ct.Name, 'Misc') as CategoryType,
		CAST(ISNULL(ct.canFree, 0) as BIT) as canFree,
		CAST(ISNULL(ct.canReduce, 0) as BIT) as canReduce,
		CASE
			WHEN (ct.canFree = 1 OR ct.canReduce = 1) THEN 0
			ELSE 1
		END as QualifiedSort,
		CASE
			WHEN (ct.canFree = 1 OR ct.canReduce = 1) THEN 'REIMBURSABLE'
			ELSE 'NON-REIMBURSABLE'
		END as QualifiedDisplay,

		CASE
			WHEN ((it.PreOrderItem_Id IS NOT NULL) AND (ct.canFree = 1 OR ct.canReduce = 1) AND (o.LunchType = 1)) THEN 'Preorder: Paid'
			WHEN ((it.PreOrderItem_Id IS NOT NULL) AND (ct.canFree = 1 OR ct.canReduce = 1) AND (o.LunchType = 2)) THEN 'Preorder: Reduced'
			WHEN ((it.PreOrderItem_Id IS NOT NULL) AND (ct.canFree = 1 OR ct.canReduce = 1) AND (o.LunchType = 3)) THEN 'Preorder: Free'
			WHEN ((it.PreOrderItem_Id IS NOT NULL) AND (ct.canFree = 1 OR ct.canReduce = 1) AND (o.LunchType = 5)) THEN 'Preorder: Meal Plan'
			WHEN ((it.PreOrderItem_Id IS NOT NULL) AND (ct.canFree = 1 OR ct.canReduce = 1) AND (ISNULL(o.LunchType,4) = 4)) THEN 'Preorder: Employee'
			WHEN (it.PreOrderItem_Id IS NOT NULL) THEN 'Preorder'
			WHEN (o.Customer_Id = -2) THEN 'Cash Sale: Guest'
			WHEN (o.Customer_Id = -3) THEN 'Cash Sale: Student' 
			--WHEN (o.Customer_Id = -2 OR o.Customer_Id = -3) THEN 'Cash Sale'
			WHEN ((ct.canFree = 1 OR ct.canReduce = 1) AND (o.LunchType = 1)) THEN 'Account: Paid'
			WHEN ((ct.canFree = 1 OR ct.canReduce = 1) AND (o.LunchType = 2)) THEN 'Account: Reduced'
			WHEN ((ct.canFree = 1 OR ct.canReduce = 1) AND (o.LunchType = 3)) THEN 'Account: Free'
			WHEN (ISNULL(o.LunchType,4) = 5) THEN 'Account: Meal Plan'
			WHEN ((ISNULL(o.LunchType,4) = 4) OR (SUBSTRING(CAST(o.TransType as varchar),3,1) = '4')) THEN 'Account: Employee'
			WHEN (ISNULL(o.LunchType,4) in (1,2,3)) THEN 'Account: Student'
			ELSE 'Account'
		END as AccountType,
		--(it.PaidPrice * it.Qty) as NetPrice,
		CASE
			WHEN (it.PreOrderItem_Id IS NOT NULL) THEN (poi.PaidPrice * it.Qty) 
			ELSE (it.PaidPrice * it.Qty)
		END as NetPrice,
		CASE
			WHEN (o.Customer_Id > 0 AND it.PreOrderItem_Id IS NULL) THEN (it.PaidPrice * it.Qty)
			ELSE 0.0
		END as AccountTotal,
		CASE
			WHEN (o.Customer_Id < 0 AND it.PreOrderItem_Id IS NULL) THEN (it.PaidPrice * it.Qty)
			ELSE 0.0
		END as CashTotal,
		CASE
			WHEN (it.PreOrderItem_Id IS NOT NULL) THEN (poi.PaidPrice * it.Qty)
			ELSE 0.0
		END as PreorderTotal,
		it.Qty as TotalCount,
		CASE
			WHEN ((o.Customer_Id > 0) AND (it.PreOrderItem_Id IS NULL)) THEN it.Qty
			ELSE 0
		END as AccountCount,
		CASE
			WHEN ((o.Customer_Id = -2 OR o.Customer_Id = -3) AND (it.PreOrderItem_Id IS NULL)) THEN it.Qty
			ELSE 0
		END as CashCount,
		CASE
			WHEN (it.PreOrderItem_Id IS NOT NULL) THEN it.Qty
			ELSE 0
		END as PreorderCount,
		CASE
			WHEN ((ct.canFree = 1 OR ct.canReduce = 1) AND it.PreOrderItem_Id IS NOT NULL) THEN poi.PaidPrice
			WHEN ((ct.canFree = 1 OR ct.canReduce = 1)) THEN it.PaidPrice
			ELSE 0.0
		END as PaidPrice,
		sto.CashSaleSalesTax,
		sto.AccountSaleSalesTax,
		ROW_NUMBER() OVER(PARTITION BY sto.ORDID ORDER BY sto.ORDID) ordSaleTaxSeq
	FROM Items it
		INNER JOIN Orders o ON o.Id = it.Order_Id
		LEFT OUTER JOIN Schools s on s.Id = o.School_Id
		LEFT OUTER JOIN District d on d.Id = s.District_Id
		LEFT OUTER JOIN PreOrderItems poi ON poi.Id = it.PreOrderItem_Id
		LEFT OUTER JOIN Menu m ON m.Id = it.Menu_Id
		LEFT OUTER JOIN Category cat ON cat.Id = m.Category_Id
		LEFT OUTER JOIN CategoryTypes ct ON ct.Id = cat.CategoryType_Id
		LEFT OUTER JOIN SalesTaxOnOrder sto ON o.id = sto.ORDID
	WHERE
		o.isVoid = 0 AND o.Emp_Cashier_Id <> -99 AND it.isVoid = 0
	) tbDetailCafe
GO
