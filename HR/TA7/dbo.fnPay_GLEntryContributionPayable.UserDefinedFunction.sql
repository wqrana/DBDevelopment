USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_GLEntryContributionPayable]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CREATE FUNCTION [dbo].[fnPay_tblBatchGLPayrollEntry_LancoExport]
--(	
--	-- Add the parameters for the function here
--	@BATCHID nvarchar(50)
--)
--RETURNS 
--@tblBatchGLPayrollEntry TABLE 
--(
--	strBatchID nvarchar(50),
--	strAccountName nvarchar(50), 
--	decDebits decimal(18,2),
--	decCredits decimal(18,2),
--	intReportOrder int, 
--	strBatchDescription nvarchar(50),
--	strCompanyName nvarchar(50), 
--	dtPayDate datetime,
--	dtStartDatePeriod datetime,
--	dtEndDatePeriod datetime,
--	strExpensePayable nvarchar(50),
--	strGLAccount nvarchar(50)
--) 
---- WITH ENCRYPTION
--AS
--BEGIN
--	DECLARE 	@strBatchDescription nvarchar(50)
--	DECLARE 	@strCompanyName nvarchar(50)
--	DECLARE 	@dtPayDate datetime
--	DECLARE 	@dtStartDatePeriod datetime
--	DECLARE 	@dtEndDatePeriod datetime

--	SELECT TOP(1) @strBatchDescription =strBatchDescription, @strCompanyName= strCompanyName,@dtPayDate = dtPayDate,@dtStartDatePeriod =dtStartDatePeriod, @dtEndDatePeriod =dtEndDatePeriod  FROM viewPay_UserBatchStatus where strBatchID = @BATCHID

--	-- User Compensations per GL Account Expense
--	insert into @tblBatchGLPayrollEntry
--	select @BATCHID as strBatchID, cc.strCompensationName as strAccountName, iif(ubc.decPay IS NULL, 0,ubc.decPay)  as decDebits , 0 as decCredits, ROW_NUMBER() OVER (ORDER BY intReportOrder)
--	, @strBatchDescription , @strCompanyName,@dtPayDate ,@dtStartDatePeriod , @dtEndDatePeriod , 'EXPENSE', iif(ubc.strGLAccount IS NULL, '',ubc.strGLAccount ) as strGLAccount
--	from tblCompanyCompensations cc left outer join 
--	(SELECT strCompensationName, strGLAccount, sum(decPay) as decPay FROM viewPay_UserBatchCompensations where strBatchID = @BATCHID GROUP BY strCompensationName, strGLAccount) as ubc 
--	on cc.strCompensationname = ubc.strCompensationName
--	where strCompanyName = (select strCompanyName from tblBatch where strBatchID = @BATCHID) 
--	ORDER by intReportOrder
	
--	-- Company Contributions per GL Account Expense
--	insert into @tblBatchGLPayrollEntry
--	select @BATCHID as strBatchID, cw.strWithHoldingsName as strAccountName, iif(decWithholdingsAmount is null, 0, -decWithholdingsAmount) as decDebits , 0 as decCredits,100 + ROW_NUMBER() OVER (ORDER BY intReportOrder)
--	, @strBatchDescription , @strCompanyName,@dtPayDate ,@dtStartDatePeriod , @dtEndDatePeriod , 'EXPENSE', iif(ubw.strGLAccount IS NULL, '',ubw.strGLAccount ) as strGLAccount
--	from tblCompanyWithholdings cw left outer join 
--	(SELECT strWithHoldingsName, strGLAccount, sum(decWithholdingsAmount) as decWithholdingsAmount FROM viewPay_CompanyBatchWithholdings where strBatchID = @BATCHID GROUP BY strWithHoldingsName, strGLAccount) as ubw ON cw.strWithHoldingsName = ubw.strWithHoldingsName
--	where cw.strCompanyName = (select strCompanyName from tblBatch where strBatchID = @BATCHID) 
--	and intComputationType >= 0
--	ORDER by intReportOrder

--	-- Company Contributions per GL Account Payable (FOAM PACK GLs)
--	insert into @tblBatchGLPayrollEntry
--	select @BATCHID as strBatchID, cw.strContributionsName as strAccountName, 0 as decDebits, iif(cbw.decWithholdingsAmount is null, 0, -cbw.decWithholdingsAmount)   as decCredits  ,200 + ROW_NUMBER() OVER (ORDER BY intReportOrder)
--	, @strBatchDescription , @strCompanyName,@dtPayDate ,@dtStartDatePeriod , @dtEndDatePeriod , 'PAYABLE', iif(cbw.strGLAccount IS NULL, '',cbw.strGLAccount ) as strGLAccount
--	from tblCompanyWithholdings cw left outer join 
--	(SELECT cbw.strWithHoldingsName, uwi.strGLAccount , sum(cbw.decWithholdingsAmount) as decWithholdingsAmount FROM viewPay_CompanyBatchWithholdings cbw inner join tblUserWithholdingsItems uwi 
--	ON cbw.intuserid = uwi.intUserID and cbw.strWithHoldingsName = uwi.strWithHoldingsName 
--	where cbw.strBatchID = @BATCHID 
--	GROUP BY cbw.strWithHoldingsName, uwi.strGLAccount ) as cbw ON cw.strWithHoldingsName = cbw.strWithHoldingsName
--	where strCompanyName = (select strCompanyName from tblBatch where strBatchID = @BATCHID) AND cbw.decWithholdingsAmount <> 0
--	ORDER by intReportOrder

--	-- User Withholdings per GL Account Payable
--	insert into @tblBatchGLPayrollEntry
--	select @BATCHID as strBatchID, cw.strContributionsName as strAccountName, 0 as decDebits, iif(ubw.decWithholdingsAmount is null, 0, -ubw.decWithholdingsAmount)  as decCredits  ,200 + ROW_NUMBER() OVER (ORDER BY intReportOrder)
--	, @strBatchDescription , @strCompanyName,@dtPayDate ,@dtStartDatePeriod , @dtEndDatePeriod , 'PAYABLE', iif(ubw.strGLAccount IS NULL, '',ubw.strGLAccount ) as strGLAccount
--	from tblCompanyWithholdings cw left outer join 
--	(SELECT strWithHoldingsName, strGLAccount, sum(decWithholdingsAmount) as decWithholdingsAmount FROM viewPay_UserBatchWithholdings where strBatchID = @BATCHID GROUP BY strWithHoldingsName, strGLAccount) as ubw ON cw.strWithHoldingsName = ubw.strWithHoldingsName
--	where strCompanyName = (select strCompanyName from tblBatch where strBatchID = @BATCHID) AND ubw.decWithholdingsAmount <> 0
--	ORDER by intReportOrder
	
--	--PAYROLL ACCOUNT
--	DECLARE @PAYROLL_GL nvarchar(50)
--	SELECT @PAYROLL_GL = strAccountID from tblGLAccounts WHERE strCompanyName IN (select strCompanyName from tblBatch where strBatchID = @BATCHID) AND intAccountType = 2	
--	if @PAYROLL_GL IS NULL SET @PAYROLL_GL = ''

--	--CHECKS
--	insert into @tblBatchGLPayrollEntry
--	select @BATCHID as strBatchID, strPayMethodType as strAccountName, 0 as decDebits, sum (decCheckAmount) as decCredits, 300 
--	, @strBatchDescription , @strCompanyName,@dtPayDate ,@dtStartDatePeriod , @dtEndDatePeriod , 'PAYABLE',@PAYROLL_GL
--	from viewPay_UserPayCheck where strBatchID = @BATCHID and intPayMethodType = 1
--	group by strBatchID, strPayMethodType
--	--DIRECT DEPOSIT
--	insert into @tblBatchGLPayrollEntry
--	select @BATCHID as strBatchID, strPayMethodType as strAccountName, 0 as decDebits, sum (decCheckAmount) as decCredits , 2000 
--	, @strBatchDescription , @strCompanyName,@dtPayDate ,@dtStartDatePeriod , @dtEndDatePeriod , 'PAYABLE',@PAYROLL_GL
--	from viewPay_UserPayCheck where strBatchID = @BATCHID and intPayMethodType = 2
--	group by strBatchID, strPayMethodType
--	RETURN
--END



--GO

--VARIES BY COMPANY
CREATE FUNCTION [dbo].[fnPay_GLEntryContributionPayable]
(
@PayrollCompany nvarchar(50),
@strWithholdingName nvarchar(50),
@strGLAccount nvarchar(50)
)
RETURNS nvarchar(50)
AS
BEGIN
DECLARE @Return nvarchar(50)

SET @Return = @strGLAccount 
	
	IF @PayrollCompany = 'Lanco Manufacturing Corp.'
	BEGIN
	select @Return =  case @strWithholdingName
						WHEN 'CHOFERIL' THEN '2045'
						WHEN 'DISABILITY' THEN '2040'
						WHEN 'FUTA' THEN '2055'
						WHEN 'SUTA' THEN '2050'
						WHEN 'FICA SS' THEN '2035'
						WHEN 'FICA MED' THEN '2035'
						WHEN 'FICA MED PLUS' THEN '2035'
						WHEN '401K 1' THEN '2058'
						WHEN '401K 2' THEN '2058'
						WHEN '401K 3' THEN '2058'
						WHEN 'CFSE' THEN '1058'
						ELSE @strGLAccount
						END
	END

	-- Return the result of the function
	RETURN @Return

END

GO
