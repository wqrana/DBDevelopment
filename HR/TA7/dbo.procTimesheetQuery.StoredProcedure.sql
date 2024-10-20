USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[procTimesheetQuery]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procTimesheetQuery]
	-- Add the parameters for the stored procedure here
	@UserID int, 
	@PunchDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	---Variables
	declare @UserName as nvarchar(100)
	declare @StartDate as datetime
	declare @EndDate as datetime

	declare @TimeSheet as nvarchar(max)
	declare @ReportWeek as nvarchar(max)
	declare @PunchDateSummary as nvarchar(max)

	select top(1)@UserName = e_name, @StartDate = DTStartDate, @EndDate=DTEndDate, @ReportWeek = sHoursSummary from tReportWeek where e_id = @UserID and DTStartDate <= @PunchDate and @PunchDate <= DTEndDate

	SET @TimeSheet = 'User Name: ' + @UserName
	SET @TimeSheet = @TimeSheet + char(10) + char(13) + 'Start Date: ' + CONVERT(VARCHAR(20), @StartDate,7)
	SET @TimeSheet = @TimeSheet + char(10) + char(13) + 'End Date: ' + CONVERT(VARCHAR(20), @EndDate,7)
	set @TimeSheet = @TimeSheet + char(10) + char(13) 
	set @TimeSheet = @TimeSheet + char(10) + char(13) + 'Total: ' +  @ReportWeek
	set @TimeSheet = @TimeSheet + char(10) + char(13) 
	
	--Get date description
	declare @dLoop as datetime
	set @dLoop = @StartDate
	while @dLoop <= @EndDate
	BEGIN
		select @PunchDateSummary = RTRIM( CONVERT(VARCHAR(20), dtpunchdate , 1)) + space(2) + sPunchSummary from tPunchDate where e_id = @UserID and DTPunchDate = @dLoop
		set @TimeSheet = @TimeSheet + char(10) + char(13) + @PunchDateSummary
		set @dloop = DATEADD(DAY,1, @dLoop)
	END;

	select isnull(@TimeSheet,'')
END
GO
