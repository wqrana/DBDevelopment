USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_UserDashboardNotificationForecast]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UserDashboardNotificationForecast] 
	-- Add the parameters for the stored procedure here
	@userIds nvarchar(max)=''
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	Declare @UserExpiryRecordTbl As Table(UserInformationId int,
	EmployeeId int, EmployeeName nvarchar(250), RecordName nvarchar(100),
	RecordType nvarchar(25) ,ExpirationDate datetime	)
	Declare @RangeStartDate datetime
	Declare @RangeEndDate datetime
	
	Set @RangeStartDate = DATEADD(m, DATEDIFF(m, 0, GETDATE()), 0) 
	Set @RangeEndDate = DATEADD(d,-1,DATEADD(m,7,@RangeStartDate)) 
	
	Insert into @UserExpiryRecordTbl
	exec sp_UserDashboardNotificationForecastDetail @userIds,@RangeStartDate,@RangeEndDate

  Select CONVERT(int, ROW_NUMBER() OVER (ORDER BY ForecastMonthId)) as ForecastId, ForecastMonthId,ForecastMonthName, COUNT(ExpirationDate) as ExpiryRecordCount
  From(
		Select ForecastMonthId,ForecastMonthName, ExpirationDate 
		From(
			Select convert(datetime,thedate) as CalenderDate, TheMonthName+'-'+convert(nvarchar(8),TheYear) as ForecastMonthName, MMYYYY as ForecastMonthId  
			From [dbo].DateCalendar
			Where  convert(datetime,thedate) between @RangeStartDate and @RangeEndDate
		) CalenderData
		Left Join @UserExpiryRecordTbl uertbl On CalenderData.CalenderDate = uertbl.ExpirationDate
	  )ExpiryRecordForGrouping
	  Group by ForecastMonthId,ForecastMonthName
END
GO
