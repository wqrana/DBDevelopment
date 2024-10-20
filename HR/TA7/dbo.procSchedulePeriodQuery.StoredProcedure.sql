USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[procSchedulePeriodQuery]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procSchedulePeriodQuery]
	-- Add the parameters for the stored procedure here
	@UserID int, 
	@PunchDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--
	-- Schedule Period Query
	--

	---VARIABLES
	declare @UserName as nvarchar(100)
	declare @StartDate as datetime
	declare @EndDate as datetime

	declare @PunchNum as int
	declare @Punch1 as datetime
	declare @Punch2 as datetime
	declare @Punch3 as datetime
	declare @Punch4 as datetime
	declare @Note as nvarchar(50)
	declare @Workday as int
	declare @DayHours as float
	declare @JobCode as int 
	declare @Schedule as nvarchar(max)
	declare @ScheduleSummary as nvarchar(max)

	declare @Unscheduled as nvarchar(11)
	set @Unscheduled = 'Unscheduled'
	declare @DisplayDate as nvarchar(5)

	select top(1)@UserName = sUserName, @StartDate = DStartDate, @EndDate=DEndDate from tSchedModPeriodSumm where nUserID = @UserID and DStartDate <= @PunchDate and @PunchDate <= DEndDate

	--SET HEADER
	SET @Schedule = 'User Name: ' + @UserName
	SET @Schedule = @Schedule + char(10) + 'Start Date:   ' + CONVERT(VARCHAR(20), @StartDate,1)
	SET @Schedule = @Schedule + char(10) + 'End Date:     ' + CONVERT(VARCHAR(20), @EndDate,1)
	set @Schedule = @Schedule + char(10) + char(13) 

	--GET SCHEDULE DATES DESCRIPTION
	set @Schedule = @Schedule + char(10) + 'Date:  P: In:            Out:          In:            Out:' 

	declare @dLoop as datetime
	set @dLoop = @StartDate
	while @dLoop <= @EndDate
	BEGIN
		select	@PunchNum = nPunchNum, 
				@Note= sNote, 
				@PunchDate= dPunchDate,
				@Punch1 = dPunchIn1, 
				@Punch2 = dPunchOut1, 
				@Punch3 = dPunchIn2, 
				@Punch4 = dPunchOut2, 
				@Workday= nWorkDayType, 
				@DayHours= dblDayHours, 
				@JobCode= isnull(jc.sjobcodename,'') --iif(jc.sJobCodeName is null,'',jc.sJobCodeName)  
		from [dbo].[tSchedModDailyDetail] smd 
			left outer join [dbo].[tJobCode] jc ON smd.nJobCodeID = jc.nJobCodeID 
		where nUserID = @UserID and DPunchDate = @dLoop

		set @DisplayDate = left(CONVERT(VARCHAR(20), @dLoop , 1),5)
		IF @Workday <> 1
			set @ScheduleSummary =	@DisplayDate 
			+ space(3) 
			+  @Unscheduled

		ELSE
		BEGIN
			if @PunchNum = 1
			set @ScheduleSummary =			@DisplayDate --RTRIM( CONVERT(VARCHAR(20), @PunchDate , 1)) 
										+ SPACE(1)
										+ CONVERT(varchar(1), @PunchNum) 
										+ SPACE(1) 
										+  replace(right(convert(varchar(25), @Punch1, 100), 7),' ','0')
			if @PunchNum = 2
			set @ScheduleSummary =		@DisplayDate --RTRIM( CONVERT(VARCHAR(20), @PunchDate , 1)) 
										+ SPACE(1)
										+ CONVERT(varchar(1), @PunchNum) 
										+ SPACE(1) 
										+  replace(right(convert(varchar(25), @Punch1, 100), 7),' ','0')
										+ space(1) 
										+  replace(right(convert(varchar(25), @Punch2, 100), 7),' ','0')

			if @PunchNum = 4
				set @ScheduleSummary =  @DisplayDate --RTRIM( CONVERT(VARCHAR(20), @dLoop , 1)) 
										+ SPACE(1)
										+ CONVERT(varchar(1), @PunchNum) 
										+ SPACE(1) 
										+  replace(right(convert(varchar(25), @Punch1, 100), 7),' ','0') 
										+ space(1) 
										+  replace(right(convert(varchar(25), @Punch2, 100), 7),' ','0') 
										+ space(1) 
										+  replace(right(convert(varchar(25), @Punch3, 100), 7),' ','0') 
										+ space(1) 
										+  replace(right(convert(varchar(25), @Punch4, 100), 7),' ','0')
			END
		set @Schedule = @Schedule + char(10) + @ScheduleSummary
		set @dloop = DATEADD(DAY,1, @dLoop)
	END;
	set @Schedule = @Schedule + char(10) 
	select isnull(@Schedule,'')
END
GO
