USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Dashboard_TotalSales]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Farrukh M
-- Create date: 03/29/2016
-- Description:	Return Total Sales
-- =============================================
CREATE FUNCTION [dbo].[Admin_Dashboard_TotalSales]
(	
	-- Add the parameters for the function here

	@ClientID BIGINT
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT TodaySales,YesterdaySales, LastWeekSales FROM

		( SELECT ROUND(ISNULL(SUM(ISNULL(MCredit,0)+ISNULL(ACredit,0)+ISNULL(BCredit,0)),0),0) AS TodaySales
		  FROM dbo.Orders  WHERE ClientID = @ClientID AND (ISNULL(MCredit,0)+ISNULL(ACredit,0)+ISNULL(BCredit,0))>0
		  AND isVoid = 0 AND convert(varchar, OrderDate, 101) = CONVERT(VARCHAR,GETDATE(),101)
		) as Today,

		( SELECT ROUND(ISNULL(SUM(ISNULL(MCredit,0)+ISNULL(ACredit,0)+ISNULL(BCredit,0)),0),0) AS YesterdaySales
		  FROM dbo.Orders  WHERE ClientID = @ClientID AND (ISNULL(MCredit,0)+ISNULL(ACredit,0)+ISNULL(BCredit,0))>0
		  AND isVoid = 0 AND CONVERT(varchar, OrderDate, 101) = CONVERT(VARCHAR,DATEADD(d,-1,GETDATE()),101)
		) AS Yesterday,

		( SELECT ROUND(ISNULL(SUM(ISNULL(MCredit,0)+ISNULL(ACredit,0)+ISNULL(BCredit,0)),0),0) AS LastWeekSales
		  FROM dbo.Orders  WHERE ClientID = @ClientID AND (ISNULL(MCredit,0)+ISNULL(ACredit,0)+ISNULL(BCredit,0))>0
		  AND isVoid = 0 AND CONVERT(varchar, OrderDate, 101) 
		  BETWEEN  CONVERT(VARCHAR,DATEADD(d,-7,GETDATE()),101) AND CONVERT(VARCHAR,DATEADD(d,-1,GETDATE()),101)
		 ) AS LastWeek

)
GO
