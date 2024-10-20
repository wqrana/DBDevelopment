USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnSS_GetScheduledDayCount]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 10/24/2018
-- Description:	Returns the number of wirkdays accoriding to schedules
--		1) Checks if a schedule has been created in tSchedModDailyDetail
--		2) Otherwise, uses base schedule if exists
--		3) Last, just counts the days because scheduling doesn't help
-- =============================================
CREATE FUNCTION [dbo].[fnSS_GetScheduledDayCount] 
(
		@USERID int,
		@StartDate date,
		@EndDate date
	)
RETURNS int
AS
BEGIN
	DECLARE @WorkDayCount integer
	SET @WorkDayCount = 0
	while @StartDate <= @EndDate
	BEGIN
		IF exists(select nWorkDayType FROM tSchedModDailyDetail where dPunchDate = @StartDate and nUserID = @USERID)  
			--IF A SCHEDULE EXISTS, USE THAT
			BEGIN
				select @WorkDayCount= @WorkDayCount+ iif(nWorkDayType>=1,1,0) from tSchedModDailyDetail where dPunchDate = @StartDate and nUserID = @USERID
			END
		ELSE
			BEGIN
				IF Exists(select bRight from tuser u inner join tScheduleDayInfo sdi on u.nScheduleID = sdi.nSchedID where u.id = @USERID and nDayofWeek = DATEPART(WEEKDAY,@startdate)-1)
					--BASE SCHEDULE EXISTS, USE THAT
					BEGIN
						select @WorkDayCount= @WorkDayCount+ iif(bRight=1,1,0) from tuser u inner join tScheduleDayInfo sdi on u.nScheduleID = sdi.nSchedID where u.id = @USERID and nDayofWeek = DATEPART(WEEKDAY,@startdate)-1
					END
				ELSE
					--NO SCHEDULE, JUST COUNT
					BEGIN
						SET @WorkDayCount = @WorkDayCount +1
					END
			END
		--select @StartDate
	SET @StartDate = DATEADD(DAY,1,@StartDate)
	END
	RETURN @WorkDayCount
END
GO
