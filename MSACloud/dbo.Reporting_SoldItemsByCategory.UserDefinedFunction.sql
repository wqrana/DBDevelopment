USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Reporting_SoldItemsByCategory]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================

-- Author:		Abid H
-- Create date: 01/18/2017
-- select * from [dbo].[Reporting_SoldItemsByCategory] (44,'','1/1/2000','1/1/2017')
-- =============================================
CREATE FUNCTION [dbo].[Reporting_SoldItemsByCategory] 
(	
	@ClientID bigint,
	@SCHLIST varchar(2048) = '',
	@StartDate datetime  = '1/1/2000',
	@EndDate datetime  = '1/1/2000'

)
RETURNS TABLE 
AS
RETURN 
(

SELECT 
si.CategoryName, 
si.MenuItem,
si.LunchTypeStatus, 
si.LunchType, 
SUM(si.Qty) as Qty, 
si.Price, 
SUM(si.Total) as Total 
FROM SoldItems si 
WHERE (si.OrderDate BETWEEN @StartDate AND @EndDate) 
and si.ClientID = @ClientID
and ((si.SCHID IN (SELECT Value FROM Reporting_fn_Split(@SCHLIST, ',')) and @SCHLIST <> '' ) OR (@SCHLIST  = ''))

GROUP BY si.CategoryName, si.MenuItem, si.LunchTypeStatus, si.LunchType, si.Price 
				
)
GO
