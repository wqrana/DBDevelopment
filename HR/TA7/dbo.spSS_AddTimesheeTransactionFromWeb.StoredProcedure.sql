USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spSS_AddTimesheeTransactionFromWeb]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		WaqarQ
-- Create date: 02/14/2024
-- Description:	Insert the transaction detail in tpunchpair for pocessing for timesheet editor in web
-- =============================================
CREATE PROCEDURE [dbo].[spSS_AddTimesheeTransactionFromWeb]
	@ReferenceIds as nvarchar(100),
	@TransType nvarchar(50),
	@DayHours decimal,
	@TransNote as nvarchar(500)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @query as nvarchar(500)
	DECLARE	@transDateTbl as table(e_Id int, PunchDate datetime, nWeekID int)	
	
	Set @query= N'Select e_id,DTPunchDate,nWeekID 
	From tPunchDate
	Where tpdID in ('+@ReferenceIds+')'
	
	Insert 
	Into @transDateTbl
	Exec (@query)

	--select * from @transDateTbl
	BEGIN
		INSERT 
			INTO [dbo].[tPunchPair]
			([e_id],[e_idno],[e_name],[DTPunchDate],[DTimeIn],[DTimeOut],[HoursWorked],[sType],[pCode],[b_Processed],[DayID],[bTrans],[sTCode]
			,[sTDesc],[sTimeIn],[sTimeOut],[nWeekID],[nIsTransAbsent],[nPunchDateDayOfWeek],[nHRAttendanceCat],[nHRProcessedCode],[nHRReportCode],[nJobCodeID]
			)
		OUtPUT inserted.e_id,inserted.e_name,inserted.DTPunchDate,inserted.nWeekID,inserted.HoursWorked,inserted.sType
		SELECT 
			u.id,'',u.name,trDatetbl.PunchDate,trDatetbl.PunchDate,dateadd(MINUTE,@DayHours*60,  trDatetbl.PunchDate),@DayHours,@TransType,'TI',0,'',1,1
			,SUBSTRING(@TransNote,0,49),'','',nWeekID,0,0,0,0,0,0 
		FROM @transDateTbl trDatetbl 
		INNER JOIN tuser u on trDatetbl.e_Id = u.id 
		
	END
END
GO
