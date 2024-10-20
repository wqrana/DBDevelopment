USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_PreOrder_CurrentPreorderOverview]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Waqar Q.
-- Create date: 2017-06-1
-- Description:	used to retreive the Current Preorder Overview (Open & Closed) Period wise

-- Modification History
/*


*/
-- =============================================
CREATE PROCEDURE [dbo].[Main_PreOrder_CurrentPreorderOverview]
	-- Add the parameters for the stored procedure here
	
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	DECLARE @today		datetime
	DECLARE @weekStart	datetime 
	DECLARE @weekEnd	datetime 
	DECLARE @monthStart datetime 
	DECLARE @monthEnd	datetime 
	DECLARE @yearStart	datetime 
	DECLARE @yearEnd	datetime

	DECLARE @poData		AS Table(id int primary key, purchasedDate datetime, isClosed bit) 

	 INSERT INTO @poData (id, purchasedDate, isClosed) 
     SELECT
	 po.Id,
	 po.PurchasedDate,
	 CASE 
            WHEN ((SELECT COUNT(poi.Id) 
					FROM PreOrderItems poi 
					WHERE poi.Qty != poi.PickupCount 
					AND poi.PreOrder_Id = po.Id) = 0)
            THEN 1
            ELSE 0
            END isClosed
	 FROM PreOrders po 
	      
	
	 SELECT @today = convert(datetime,convert(varchar(10),getdate(),102),102),
            @weekStart = Convert(varchar, DateAdd(dd, -(DatePart(dw, GetDate()) - 1), GetDate()), 101),
            @weekEnd = Convert(varchar, DateAdd(dd, (7 - DatePart(dw, GetDate())), GetDate()), 101),
            @monthStart = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@today)-1),@today),101),
            @monthEnd = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@today))),DATEADD(mm,1,@today)),101),
            @yearStart = DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0),
            @yearEnd = DATEADD(DAY,-1, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) + 1, 0))	  
		  
         

SELECT	PeriodTypeID, 
		PeriodTypeName, 
		ISNULL(openCount,0) AS openCount,
		ISNULL(closedCount,0) AS closedCount

FROM(

		SELECT	1		AS PeriodTypeID,
				'Today' AS PeriodTypeName,
				 SUM( CASE WHEN isClosed = 0 THEN 1 ELSE 0 END ) AS openCount,
				 SUM( CASE WHEN isClosed = 1 THEN 1 ELSE 0 END) AS closedCount
			FROM @poData poData
			WHERE CONVERT(DATETIME,CONVERT(DATE,poData.purchasedDate)) = @today 
		UNION
		SELECT	2			AS PeriodTypeID,
				'This Week' AS PeriodTypeName,
				 SUM( CASE WHEN isClosed = 0 THEN 1 ELSE 0 END) AS openCount,
				 SUM( CASE WHEN isClosed = 1 THEN 1 ELSE 0 END) AS closedCount
			FROM @poData poData
			--WHERE poData.purchasedDate BETWEEN 	@weekStart AND DATEADD(dd,1, @weekEnd)
			WHERE CONVERT(DATETIME,CONVERT(DATE,poData.purchasedDate)) BETWEEN 	@weekStart AND @weekEnd
		UNION
		SELECT	3			 AS PeriodTypeID,
				'This Month' AS PeriodTypeName,
				 SUM( CASE WHEN isClosed = 0 THEN 1 ELSE 0 END) AS openCount,
				 SUM( CASE WHEN isClosed = 1 THEN 1 ELSE 0 END) AS closedCount
			FROM @poData poData
		--	WHERE poData.purchasedDate BETWEEN 	@monthStart AND DATEADD(dd,1, @monthEnd)
		WHERE CONVERT(DATETIME,CONVERT(DATE,poData.purchasedDate)) BETWEEN 		@monthStart AND @monthEnd
		UNION	
		SELECT  4			AS PeriodTypeID,
				'This Year' AS PeriodTypeName,
				 SUM( CASE WHEN isClosed = 0 THEN 1 ELSE 0 END ) AS openCount,
				 SUM( CASE WHEN isClosed = 1 THEN 1 ELSE 0 END ) AS closedCount
			FROM @poData poData
			WHERE CONVERT(DATETIME,CONVERT(DATE,poData.purchasedDate)) BETWEEN 	@yearStart AND  @yearEnd
	
	)poDataOverview		
									

END
GO
