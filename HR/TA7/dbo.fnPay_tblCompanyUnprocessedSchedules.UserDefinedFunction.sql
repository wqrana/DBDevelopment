USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCompanyUnprocessedSchedules]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 4/16/2017
-- Description:	Returns the unprocessed schedule periods for a Payroll Company.  Returns all periods if none have been processed.
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblCompanyUnprocessedSchedules]
(
	@COMPANY_NAME as nvarchar(50),
	@COMPANY_SCHEDULEID as int
)
RETURNS
@tblUnprocessedPaySchedules TABLE 
(
	strCompanyName nvarchar(50),
	intPayWeekNum  int,
	dtStartDate  datetime,
	dtEndDate  Datetime
)
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @LastProcessedStartDate date

	Select @LastProcessedStartDate = DTStartDate FROM viewPay_CompanyPayrollScheduleProcessed vp 
	where  not strBatchID is null and strCompanyName = @COMPANY_NAME and intPayrollScheduleID = @COMPANY_SCHEDULEID

	if @LastProcessedStartDate is null SET @LastProcessedStartDate = '1/1/2000'
	--Get all the periods since the last processed date.
	insert into @tblUnprocessedPaySchedules
	Select 	strCompanyName , nPayWeekNum,	dtStartDate  ,	dtEndDate
	FROM viewPay_CompanyPayrollScheduleProcessed vp 
	where  DTStartDate between @LastProcessedStartDate and getdate() and strCompanyName = @COMPANY_NAME and intPayrollScheduleID = @COMPANY_SCHEDULEID and strBatchID is null

	RETURN
END

GO
