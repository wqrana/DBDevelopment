USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Dashboard_Sales]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Farrukh M
-- Create date: 03/29/2016
-- Description:	Return Sales
-- =============================================
CREATE FUNCTION [dbo].[Admin_Dashboard_Sales]
(	
	-- Add the parameters for the function here
	@FromDate DATE, 
	@ToDate DATE,
	@ClientID BIGINT
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT TOP 100 PERCENT 
		convert(varchar, OrderDate,1) as SaleDate,
		ROUND(SUM(ISNULL(MCredit,0) + ISNULL(ACredit,0) + ISNULL(BCredit,0)),0) as TotalSales,
		cast(OrderDate as date) as SortDate
	FROM dbo.Orders 
	WHERE 
		ClientID = @ClientID AND 
		(ISNULL(MCredit,0) + ISNULL(ACredit,0) + ISNULL(BCredit,0)) > 0 AND 
		isVoid = 0 AND 
		convert(varchar, OrderDate, 101) BETWEEN @FromDate AND @ToDate
	GROUP BY convert(varchar, OrderDate, 1), cast(OrderDate as date)
	ORDER BY cast(OrderDate as date)
)
GO
