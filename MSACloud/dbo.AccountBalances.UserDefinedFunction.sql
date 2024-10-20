USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[AccountBalances]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[AccountBalances]
(	
	@ClientID bigint,
	@StartDate datetime,
	@EndDate datetime,
	@OrderDate datetime,
	@SCHLIST varchar(2048) = ''
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		0.0 as ABalance, 
		0.0 as MBalance, 
		0.0 as BonusBalance, 
		ROUND(SUM(CASE WHEN sb.Balance IS NOT NULL AND sb.Balance < 0.0 THEN sb.Balance ELSE 0.0 END), 2) as BalNegative, 
		ROUND(SUM(CASE WHEN sb.Balance IS NOT NULL AND sb.Balance > 0.0 THEN sb.Balance ELSE 0.0 END), 2) as BalPositive, 
		ROUND(SUM(CASE WHEN sb.Balance IS NULL OR sb.Balance = 0.0 THEN 0.0 ELSE 0.0 END), 2) as BalZero, 
		SUM(CASE WHEN sb.Balance IS NOT NULL AND sb.Balance < 0.0 THEN 1 ELSE 0 END) as TotalNegativeBal, 
		SUM(CASE WHEN sb.Balance IS NOT NULL AND sb.Balance > 0.0 THEN 1 ELSE 0 END) as TotalPositiveBal, 
		SUM(CASE WHEN sb.Balance IS NULL OR sb.Balance = 0.0 THEN 1 ELSE 0 END) as TotalZeroBal, 
		ROUND(SUM(ISNULL(sb.Balance, 0.0)), 2) AS TotalBalance 
	FROM  
		(
			SELECT 
				c.Id as Customer_Id, 
				ROUND(SUM((ISNULL(ca.Debit,0.0) - ISNULL(ca.Credit,0.0)) + ISNULL(dbo.BonusPaymentTotal(ca.ClientID, @StartDate, @EndDate, c.Id),0.0)),2) as Balance 
			FROM Customers c 
				LEFT OUTER JOIN CustomerActivity ca ON (ca.Customer_Id = c.Id) 
				LEFT OUTER JOIN Customer_School cs ON (cs.Customer_Id = c.Id AND cs.isPrimary = 1) 
			WHERE 
				c.isActive = 1 AND 
				c.isDeleted = 0 AND 
				c.Id IS NOT NULL AND 
				c.Id > 0 AND 
				(ca.isVoid = 0 OR ca.TransType = 1500) AND 
				((ca.OrderDate <= @OrderDate) OR (ca.Emp_Cashier_Id = -99)) AND 
				(ca.Customer_Id > 0) AND
				((cs.School_Id IN (SELECT Value FROM Reporting_fn_Split(@SCHLIST, ',')) AND @SCHLIST <> '') OR  (@SCHLIST = ''))
			GROUP BY  c.ClientID, c.Id
		) sb
)
GO
