USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spSS_UpdateTimeOffRequestFromWeb]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		WaqarQ
-- Create date: 07/16/2021
-- Description:	Update the time-off request detail and transaction table from approved time-off request in timeAide web
-- =============================================
create PROCEDURE [dbo].[spSS_UpdateTimeOffRequestFromWeb]
	@TimeOffRequestID as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE 	@TimeOffRequestType as nvarchar(50)
	DECLARE		@USERID as int	
	   		
	--Mark as Approved
	UPDATE tblSS_TimeOffRequest 
	SET intTORStatusID = 1 
	WHERE intTORUniqueID = @TimeOffRequestID
						
	---------------
	DECLARE				@TORStatusID int
	DECLARE				@StartDate datetime
	DECLARE				@EndDate datetime
	DECLARE				@TransType nvarchar(50)	
	SELECT @TORStatusID =intTORStatusID, @USERID = intUserID,@StartDate =dtStartDate,@EndDate = dtEndDate,@TransType  =strTransType
	FROM tblSS_TimeOffRequest 
	WHERE intTORUniqueID  =@TimeOffRequestID
			
	DECLARE @Counter as datetime = @StartDate
	WHILE @Counter <= @EndDate
	BEGIN
		INSERT INTO [dbo].[tPunchPair]
			(
			 [e_id]
			,[e_idno]
			,[e_name]
			,[DTPunchDate]
			,[DTimeIn]
			,[DTimeOut]
			,[HoursWorked]
			,[sType]
			,[pCode]
			,[b_Processed]
			,[DayID]
			,[bTrans]
			,[sTCode]
			,[sTDesc]
			,[sTimeIn]
			,[sTimeOut]
			,[nWeekID]
			,[nIsTransAbsent]
			,[nPunchDateDayOfWeek]
			,[nHRAttendanceCat]
			,[nHRProcessedCode]
			,[nHRReportCode]
			,[nJobCodeID]
			)
		SELECT 
			intUserID
			,''
			,u.name
			,@Counter
			,@Counter
			,dateadd(MINUTE,decDayHours*60,  @Counter)
			,decDayHours
			,strTransType
			,'TI'
			,0
			,'SSEntry'
			,1
			,1
			,SUBSTRING(strRequestNote,0,49)
			,''
			,''
			,0
			,0
			,0
			,0
			,0
			,0
			,0 
		FROM tblSS_TimeOffRequest tof 
		INNER JOIN tuser u on tof.intUserID = u.id 
		WHERE intTORUniqueID = @TimeOffRequestID

		SET @Counter = dateadd(day,1,@counter)
	END
END
GO
