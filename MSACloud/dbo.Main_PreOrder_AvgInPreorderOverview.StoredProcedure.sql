USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_PreOrder_AvgInPreorderOverview]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Waqar Q.
-- Create date: 2017-06-1
-- Description:	used to retreive the Average Incoming Preorder Overview  Period wise

-- Modification History
/*


*/
-- =============================================
CREATE PROCEDURE [dbo].[Main_PreOrder_AvgInPreorderOverview]
	-- Add the parameters for the stored procedure here
	
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;


	SELECT  1			AS 	PeriodTypeID, 
			'Per Day'	AS	PeriodTypeName,

			ISNULL(AVG(orderCount), 0) AvgCount
	FROM	( SELECT COUNT(po.Id) orderCount 
				FROM PreOrders po 
				GROUP BY CONVERT(datetime,convert(varchar(10),po.PurchasedDate,102),102)
			) avgDaily
           	
	UNION
	SELECT  2			AS 	PeriodTypeID, 
			'Per Week'	AS	PeriodTypeName,

			ISNULL(AVG(orderCount), 0) AvgCount
	FROM (
			SELECT COUNT(po.Id) orderCount 
			FROM PreOrders po 
			GROUP BY DATEPART(wk, po.PurchasedDate), DATEPART(yyyy, po.purchasedDate)

		)	avgWeekly
	UNION

	SELECT  3			AS 	PeriodTypeID, 
			'Per Month'	AS	PeriodTypeName,

			ISNULL(AVG(orderCount), 0) AvgCount
	FROM (
			SELECT COUNT(po.Id) orderCount 
			FROM PreOrders po 
			GROUP BY DATEPART(mm, po.PurchasedDate), DATEPART(yyyy, po.purchasedDate)
		
		)	avgMonthly

	UNION

	SELECT  4			AS 	PeriodTypeID, 
			'Per Year'	AS	PeriodTypeName,

			ISNULL(AVG(orderCount), 0) AvgCount
	FROM (
			SELECT COUNT(po.Id) orderCount 
			FROM PreOrders po 
			GROUP BY  DATEPART(yyyy, po.purchasedDate)
		
		) avgYearly
		
			
	

END
GO
