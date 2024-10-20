USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spSS_UserScheduleHolidays]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------Modification History------------------
-- Author:		Waqar Q
-- Creation date: 11/14/2021
-- Description:	to get schedule based Holidays for time-off Calendar web
--			
-- =============================================
CREATE PROCEDURE [dbo].[spSS_UserScheduleHolidays]
	@UserID as int,	
	@CalendarStartDate as date,
	@CalendarEndDate as date
AS
BEGIN
	SET NOCOUNT ON;
		--	VALIDATE REQUEST
Select CalendarDate as Holiday
From(
	Select	
		thedate as CalendarDate,
		dbo.fnSS_GetScheduledDayCount(u.id,TheDate,TheDate) as IsWorkingDay
	From DateCalendar dc 
	Cross Join tuser u 
	Where thedate between @CalendarStartDate and @CalendarEndDate 
	And u.id = @UserID
	And nStatus = 1	
	) schDays
Where IsWorkingDay=0
 order by CalendarDate	
END
GO
