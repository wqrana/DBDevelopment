USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_PreOrder_TopSellingItemOverview]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Waqar Q.
-- Create date: 2017-06-1
-- Description:	used to retreive the Top Selling Items Overview Period wise

-- Modification History
/*
-- Author:		Waqar Q.
-- Modification date: 2017-11-06
-- Description:	Fiscal year period is added, isvoid check is added

*/
-- =============================================
CREATE PROCEDURE [dbo].[Main_PreOrder_TopSellingItemOverview]
	-- Add the parameters for the stored procedure here
	@PeriodTypeID AS INT
		
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	DECLARE @today			DATETIME
	DECLARE @weekStart		DATETIME 
	DECLARE @weekEnd		DATETIME 
	DECLARE @monthStart		DATETIME 
	DECLARE @monthEnd		DATETIME 
	DECLARE @yearStart		DATETIME 
	DECLARE @yearEnd		DATETIME
    DECLARE @fiscalStart	DATETIME
	DECLARE @fiscalEnd		DATETIME

	 SELECT @today = convert(datetime,convert(varchar(10),getdate(),102),102),
            @weekStart = Convert(varchar, DateAdd(dd, -(DatePart(dw, GetDate()) - 1), GetDate()), 101),
            @weekEnd = Convert(varchar, DateAdd(dd, (7 - DatePart(dw, GetDate())), GetDate()), 101),
            @monthStart = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@today)-1),@today),101),
            @monthEnd = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@today))),DATEADD(mm,1,@today)),101),
            @yearStart = DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0),
            @yearEnd = DATEADD(DAY, -1, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()) + 1, 0))	 ,
			@fiscalStart = CASE 
                                WHEN MONTH(GETDATE()) < 7 THEN CAST('7/1/' + CAST(YEAR(GETDATE()) - 1 as varchar) as datetime) 
                                ELSE CAST('7/1/' + CAST(YEAR(GETDATE()) as varchar) as datetime) 
                            END,
            @fiscalEnd = DATEADD(DAY, -1, DATEADD(YEAR, 1, @fiscalStart))


	-- Week
	IF @PeriodTypeID = 0
	BEGIN
		 SELECT TOP 5 m.ItemName, 
					SUM(poi.Qty) qtySold 
		  FROM PreOrderItems poi 
		  INNER JOIN Menu m on poi.Menu_Id = m.Id 
		  WHERE poi.ServingDate BETWEEN @weekStart AND @weekEnd 
		  AND	poi.isVoid = 0
		  GROUP BY m.ItemName 
		  ORDER BY qtySold DESC

	END
	ELSE IF @PeriodTypeID = 1
	--Month
	BEGIN
		  SELECT TOP 5 m.ItemName, 
					SUM(poi.Qty) qtySold 
		  FROM PreOrderItems poi 
		  INNER JOIN Menu m on poi.Menu_Id = m.Id 
		  WHERE poi.ServingDate BETWEEN @monthStart AND  @monthEnd
		  AND	poi.isVoid = 0 
		  GROUP BY m.ItemName 
		  ORDER BY qtySold DESC

	END
	--Year
	ELSE IF @PeriodTypeID = 2
	BEGIN
		 SELECT TOP 5 m.ItemName, 
					SUM(poi.Qty) qtySold 
		  FROM PreOrderItems poi 
		  INNER JOIN Menu m on poi.Menu_Id = m.Id 
		  WHERE poi.ServingDate BETWEEN @yearStart AND  @yearEnd
		  AND	poi.isVoid = 0
		  GROUP BY m.ItemName 
		  ORDER BY qtySold DESC
	END
--Fiscal Year
	ELSE IF @PeriodTypeID = 3
	BEGIN
		SELECT TOP 5 m.ItemName, 
					SUM(poi.Qty) qtySold 
		  FROM PreOrderItems poi 
		  INNER JOIN Menu m on poi.Menu_Id = m.Id 
		  WHERE poi.ServingDate BETWEEN @fiscalStart AND  @fiscalEnd
		  AND	poi.isVoid = 0
		  GROUP BY m.ItemName 
		  ORDER BY qtySold DESC
	END
	
	
	END
GO
