USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchGLPayrollEntry]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchGLPayrollEntry]    Script Date: 9/8/2017 5:32:03 PM ******/

--==========================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	For General Ledger Payroll Entry.
-- 9/8/2017: Includes separate entries for GL Accounts
--	USES FUNCTION fnPay_GLEntryContributionPayable to FORCE the payable for now...
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblBatchGLPayrollEntry]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50)
)
RETURNS 
@tblBatchGLPayrollEntry TABLE 
(
	strBatchID nvarchar(50),
	strAccountName nvarchar(50), 
	decDebits decimal(18,2),
	decCredits decimal(18,2),
	intReportOrder int, 
	strBatchDescription nvarchar(50),
	strCompanyName nvarchar(50), 
	dtPayDate datetime,
	dtStartDatePeriod datetime,
	dtEndDatePeriod datetime,
	strExpensePayable nvarchar(50),
	strGLAccount nvarchar(50)
) 
-- WITH ENCRYPTION
AS
BEGIN

	insert into @tblBatchGLPayrollEntry
	select 	strBatchID ,
	strAccountName, 
	sum(decDebits) decDebits,
	sum(decCredits) decCredits,
	MIN(intReportOrder) intReportOrder, 
	MAX(strBatchDescription) strBatchDescription,
	MAX(strCompanyName) strCompanyName, 
	MAX(dtPayDate) dtPayDate,
	MAX(dtStartDatePeriod) dtStartDatePeriod,
	MAX(dtEndDatePeriod) dtEndDatePeriod,
	strExpensePayable,
	strGLAccount 
	FROM [dbo].[fnPay_tblBatchGLPayrollEntryDetail] (@batchid)
	GROUP By strBatchID, strExpensePayable, strAccountName, strGLAccount

	RETURN
END


GO
