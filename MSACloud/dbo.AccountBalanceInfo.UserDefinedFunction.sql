USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[AccountBalanceInfo]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat
-- Create date: 9-Aug-2016
-- Description:	this function returns the account balances for cafeteria report.
-- =============================================
CREATE FUNCTION [dbo].[AccountBalanceInfo] 
(
	@ClientID bigint,
	@StartDate datetime,
	@EndDate datetime,
	@OrderDate datetime,
	@SCHLIST varchar(2048) = ''
)
RETURNS  TABLE 
AS RETURN
(
	SELECT
		SUM(ISNULL(ABalance, 0)) AS ABalance, 
		SUM(ISNULL(MBalance, 0)) AS MBalance, 
		SUM(ISNULL(BonusBalance, 0)) AS BonusBalance, 
		ROUND(SUM(CASE WHEN sb.Balance IS NOT NULL AND sb.Balance < 0.0 THEN sb.Balance ELSE 0.0 END), 2) as BalNegative, 
		ROUND(SUM(CASE WHEN sb.Balance IS NOT NULL AND sb.Balance > 0.0 THEN sb.Balance ELSE 0.0 END), 2) as BalPositive, 
		ROUND(SUM(CASE WHEN sb.Balance IS NULL OR sb.Balance = 0.0 THEN 0.0 ELSE 0.0 END), 2) as BalZero, 
		SUM(CASE WHEN sb.Balance IS NOT NULL AND sb.Balance < 0.0 THEN 1 ELSE 0 END) as TotalNegativeBal, 
		SUM(CASE WHEN sb.Balance IS NOT NULL AND sb.Balance > 0.0 THEN 1 ELSE 0 END) as TotalPositiveBal, 
		SUM(CASE WHEN sb.Balance IS NULL OR sb.Balance = 0.0 THEN 1 ELSE 0 END) as TotalZeroBal, 
		ROUND(SUM(ISNULL(sb.Balance, 0.0)), 2) AS TotalBalance 
	FROM  
		(
			SELECT cb.Customer_Id, cb.ABalance, cb.MBalance, cb.BonusBalance, cb.Balance FROM dbo.CustomerBalances(@ClientID, DEFAULT, @SCHLIST, DEFAULT, DEFAULT, DEFAULT,
			 1, 0, 0, @StartDate, @EndDate, DEFAULT, @EndDate, 1) AS cb
		) sb
)
GO
