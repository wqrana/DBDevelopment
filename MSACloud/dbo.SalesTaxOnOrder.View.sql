USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[SalesTaxOnOrder]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE VIEW [dbo].[SalesTaxOnOrder]
AS
	SELECT
		o.ClientID,
		o.Id as ORDID,
		ROUND(SUM(CASE 
			WHEN (o.Customer_Id = -2 OR o.Customer_Id = -3) 
				THEN ISNULL(st.SalesTax,0.0)
			ELSE 0.0
		END),2) as CashSaleSalesTax,
		ROUND(SUM(CASE 
			WHEN (o.Customer_Id > 0.0) 
				THEN ISNULL(st.SalesTax,0.0)
			ELSE 0.0
		END),2) as AccountSaleSalesTax,
		ROUND(SUM(ISNULL(st.SalesTax,0.0)),2) as SalesTax
	FROM dbo.Orders o
		LEFT OUTER JOIN dbo.SalesTax st ON st.ClientID = o.ClientID and st.Order_Id = o.Id
	WHERE o.isVoid = 0
	GROUP BY o.ClientID, o.Id
GO
