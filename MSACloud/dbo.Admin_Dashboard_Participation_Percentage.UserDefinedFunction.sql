USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Dashboard_Participation_Percentage]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Farrukh M.
-- Create date: 1/04/2016
-- Description:	Get the Participation Percentage for the Dashboard
-- =============================================
CREATE FUNCTION [dbo].[Admin_Dashboard_Participation_Percentage]
(	
	-- Add the parameters for the function here
	@ClientID BIGINT
)
RETURNS TABLE 
AS
RETURN 
(		SELECT ISNULL(dbo.GetPercentage(TodaySum,TodayCount),0)  AS TodayParticipation,
			   ISNULL(dbo.GetPercentage(YesterdaySum,YesterdayCount),0) AS YesterdayParticipation,
			   ISNULL(dbo.GetPercentage(LastWeekSum,LastWeekCount),0) AS LastWeekParticipation FROM

		( SELECT  ISNULL(SUM(Participated),0) AS TodaySum, COUNT(Participated) AS TodayCount from CustomerParticipationByDay
			WHERE ClientID = @ClientID AND CONVERT(varchar, GDate, 101) = CONVERT(VARCHAR,GETDATE(),101)
		) AS ParticipatedToday,
		
		( SELECT  ISNULL(SUM(Participated),0) AS YesterdaySum, COUNT(Participated) AS  YesterdayCount from CustomerParticipationByDay
			WHERE ClientID = @ClientID AND CONVERT(varchar, GDate, 101) = CONVERT(VARCHAR,DATEADD(d,-1,GETDATE()),101)
		) AS ParticipatedYesterday,
		
		( SELECT  ISNULL(SUM(Participated),0) AS LastWeekSum, COUNT(Participated) AS  LastWeekCount from CustomerParticipationByDay
			WHERE ClientID = @ClientID AND GDate between CONVERT(VARCHAR,DATEADD(d,-7,GETDATE()),101) AND CONVERT(VARCHAR,DATEADD(d,-1,GETDATE()),101)
		) AS ParticipatedLastWeek
)
GO
