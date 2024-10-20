USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPayrollsByType]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		2016-08-24
-- Description:		Returns the Open and Closed Payrolls for a particular Payroll company
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblPayrollsByType]
(
	@PAYROLLTYPE as int,
	@PAYROLLCOMPANY nvarchar(50),
	@SEARCHDATE datetime
)
RETURNS @tblPayrollsByType TABLE 
(
	strCompanyName nvarchar(50), 
	strPayrollSchedule nvarchar(50), 
	nPayWeekNum int, 
	DTStartDate datetime, 
	DTEndDate datetime, 
	intPayWeekNumber int, 
	strBatchID nvarchar(50), 
	strBatchDescription nvarchar(50), 
	intBatchStatus int, 
	dtPayDate datetime, 
	intCreatedByID int, 
	strCreateByName nvarchar(50), 
	dtBatchCreated datetime, 
	strStatusDescription nvarchar(50), 
	intPayrollScheduleID int,
	strBatchTypeName nvarchar(50),
    [ClosedByUserID] int,
    [ClosedDateTime] datetime
)
-- WITH ENCRYPTION
AS
BEGIN
	--Open Payrolls
	if @PAYROLLTYPE = 0 
	BEGIN
		INSERT INTO @tblPayrollsByType
		SELECT DISTINCT b.strCompanyName,b.strBatchTypeName ,csp.intpayweeknumber
		,isnull((select top(1) dtStartDatePeriod from tblUserBatch ub where ub.strBatchID = b.strBatchid ),dtPayDate) as dtStartDatePeriod 
		,isnull((select top(1) dtEndDatePeriod from tblUserBatch ub where ub.strBatchID = b.strBatchid ),dtPayDate) as dtEndDatePeriod 
		,isnull((select top(1) intPayWeekNum from tblUserBatch ub where ub.strBatchID = b.strBatchid ),0) as intPayWeekNumber, 
						b.strBatchID, b.strBatchDescription, b.intBatchStatus, b.dtPayDate,
                        b.intCreatedByID, b.strCreateByName,b.dtBatchCreated, b.strStatusDescription, csp.intPayrollScheduleID, strBatchTypeName
						,b.ClosedByUserID,b.ClosedDateTime
		FROM			dbo.[tblCompanySchedulesProcessed] AS csp inner JOIN
                        viewPay_Batch b on b.strBatchID = csp.strBatchID
						where csp.intpayweeknumber <> 0 AND intBatchStatus >= 0 and b.strCompanyName = @PAYROLLCOMPANY
						
		
		--Insert Additional Payrolls
		INSERT INTO @tblPayrollsByType
		SELECT DISTINCT b.strCompanyName, 'Additional' as strPayrollSchedule,csp.intpayweeknumber, b.dtPayDate as DTStartDate, b.dtPayDate as DTEndDate, 
						0 as intPayWeekNumber, b.strBatchID, b.strBatchDescription, b.intBatchStatus, b.dtPayDate,
                        b.intCreatedByID, b.strCreateByName,b.dtBatchCreated, b.strStatusDescription, csp.intPayrollScheduleID, strBatchTypeName
						,b.ClosedByUserID,b.ClosedDateTime
		FROM			dbo.[tblCompanySchedulesProcessed] AS csp inner JOIN
                        viewPay_Batch b on b.strBatchID = csp.strBatchID
						where csp.intpayweeknumber = 0 AND intBatchStatus >= 0 and b.strCompanyName = @PAYROLLCOMPANY
	END

	--CLOSED Payrolls
	ELSE IF @PAYROLLTYPE = 1
	BEGIN
		INSERT INTO @tblPayrollsByType
		SELECT DISTINCT b.strCompanyName,b.strBatchTypeName ,csp.intpayweeknumber
		,isnull((select top(1) dtStartDatePeriod from tblUserBatch ub where ub.strBatchID = b.strBatchid ),dtPayDate) as dtStartDatePeriod 
		,isnull((select top(1) dtEndDatePeriod from tblUserBatch ub where ub.strBatchID = b.strBatchid ),dtPayDate) as dtEndDatePeriod 
		,isnull((select top(1) intPayWeekNum from tblUserBatch ub where ub.strBatchID = b.strBatchid ),0) as intPayWeekNumber, 
						b.strBatchID, b.strBatchDescription, b.intBatchStatus, b.dtPayDate,
                        b.intCreatedByID, b.strCreateByName,b.dtBatchCreated, b.strStatusDescription, csp.intPayrollScheduleID, strBatchTypeName
						,b.ClosedByUserID,b.ClosedDateTime
		FROM			dbo.[tblCompanySchedulesProcessed] AS csp inner JOIN
                        viewPay_Batch b on b.strBatchID = csp.strBatchID
						left outer join (select top(1) strBatchID, dtStartDatePeriod, dtEndDatePeriod  from tblUserBatch ) ub
						on b.strBatchID = ub.strBatchID 
						where csp.intpayweeknumber <> 0 and b.strCompanyName = @PAYROLLCOMPANY
		AND intBatchStatus = -1
		
		--Insert Additional Payrolls
		INSERT INTO @tblPayrollsByType
		SELECT DISTINCT b.strCompanyName, 'Additional' as strPayrollSchedule,csp.intpayweeknumber, b.dtPayDate as DTStartDate, b.dtPayDate as DTEndDate, 
						0 as intPayWeekNumber, b.strBatchID, b.strBatchDescription, b.intBatchStatus, b.dtPayDate,
                        b.intCreatedByID, b.strCreateByName,b.dtBatchCreated, b.strStatusDescription, csp.intPayrollScheduleID, strBatchTypeName
						,b.ClosedByUserID,b.ClosedDateTime
		FROM			dbo.[tblCompanySchedulesProcessed] AS csp inner JOIN
                        viewPay_Batch b on b.strBatchID = csp.strBatchID
						where csp.intpayweeknumber = 0 AND intBatchStatus = -1 and b.strCompanyName = @PAYROLLCOMPANY
	END

	RETURN
END
GO
