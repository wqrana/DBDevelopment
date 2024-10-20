USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchGLPayrollEntry_LancoExport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--==========================
-- Author:		Alexander Rivera Toro
-- Create date: 02/15/2018
-- Description:	For Foam Pack General Ledger Payroll Entry Export
-- 9/8/2017: Includes separate entries for GL Accounts
-- 1/9/2019: Similar to FoamPack for Lanco
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblBatchGLPayrollEntry_LancoExport]
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
	MAX(strAccountName) strAccountName, 
	sum(decDebits) decDebits,
	sum(decCredits) decCredits,
	MIN(intReportOrder) intReportOrder, 
	MAX(strBatchDescription) strBatchDescription,
	MAX(strCompanyName) strCompanyName, 
	MAX(dtPayDate) dtPayDate,
	MAX(dtStartDatePeriod) dtStartDatePeriod,
	MAX(dtEndDatePeriod) dtEndDatePeriod,
	MAX(strExpensePayable) strExpensePayable,
	strGLAccount 
	FROM [dbo].[fnPay_tblBatchGLPayrollEntry] (@batchid)
	GROUP By strBatchID, strGLAccount
	HAVING SUM(decCredits) >=0 AND SUM(decDebits) >=0 
	
	insert into @tblBatchGLPayrollEntry
	select 	strBatchID ,
	MAX(strAccountName) strAccountName, 
	-sum(decCredits) decDebits,
	0 decCredits,
	MIN(intReportOrder) intReportOrder, 
	MAX(strBatchDescription) strBatchDescription,
	MAX(strCompanyName) strCompanyName, 
	MAX(dtPayDate) dtPayDate,
	MAX(dtStartDatePeriod) dtStartDatePeriod,
	MAX(dtEndDatePeriod) dtEndDatePeriod,
	MAX(strExpensePayable) strExpensePayable,
	strGLAccount 
	FROM [dbo].[fnPay_tblBatchGLPayrollEntry] (@batchid)
	GROUP By strBatchID, strGLAccount
	HAVING SUM(decCredits) <0 


	insert into @tblBatchGLPayrollEntry
	select 	strBatchID ,
	MAX(strAccountName) strAccountName, 
	0 decDebits,
	-SUM(decDebits) decCredits,
	MIN(intReportOrder) intReportOrder, 
	MAX(strBatchDescription) strBatchDescription,
	MAX(strCompanyName) strCompanyName, 
	MAX(dtPayDate) dtPayDate,
	MAX(dtStartDatePeriod) dtStartDatePeriod,
	MAX(dtEndDatePeriod) dtEndDatePeriod,
	MAX(strExpensePayable) strExpensePayable,
	strGLAccount 
	FROM [dbo].[fnPay_tblBatchGLPayrollEntry] (@batchid)
	GROUP By strBatchID, strGLAccount
	HAVING SUM(decDebits) <0 

	RETURN
END


GO
