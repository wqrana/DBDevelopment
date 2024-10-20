USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchUserGLReportDetail]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  -- =============================================
-- Author:		Alexander Rivera	
-- Create date: 03/16/2020
-- Description:	Function for UserGLReport (Users detail)
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblBatchUserGLReportDetail]
(
@BATCHID nvarchar(50)
)
RETURNS 
@tblUserGLPayrollReport TABLE 
(
	strBatchID nvarchar(50),
	strBatchDescription nvarchar(50),
	intUserID int,
	strUserName nvarchar(50), 
	strPayItem nvarchar(50), 
	strExpenseOrPayable nvarchar(50), 
	strGLAccount nvarchar(50), 
	decHours decimal(18,2),
	decAmount decimal(18,2),
	decDebits decimal(18,2),
	decCredits decimal(18,2),
	strPayrollCompany nvarchar(50), 
	strCompany nvarchar(50), 
	strDepartment nvarchar(50), 
	strSubDepartment nvarchar(50), 
	strEmployeeType nvarchar(50)
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- User Compensations per GL Account Expense
INSERT INTO @tblUserGLPayrollReport
select @batchid as strBatchID, max(strBatchDescription), intUserID,max(strUserName),strCompensationName as strPayItem, 'EXPENSE' as strExpenseOrPayable,strGLAccount, isnull(sum(ubc.decHours),0) as decHours , isnull(sum(ubc.decPay),0) as Amount, 
isnull(sum(ubc.decPay),0)  as decDebits , 0 as decCredits,
isnull(max(strCompanyName),'') as PayrollCompany, isnull(max(strCompany ),'') as Company, isnull(max(strDepartment),'') as Department, isnull(max(strSubdepartment),'') as strSubdepartment , isnull(max(strEmployeeType),'') as EmployeeType 
from viewPay_UserBatchCompensations ubc where strBatchID = @BATCHID group by intuserid, strCompensationName, strGLAccount

	-- Company Contributions per GL Account Expense
INSERT INTO @tblUserGLPayrollReport
select @batchid as strBatchID, max(strBatchDescription), intUserID,max(strUserName),strWithHoldingsName as PayItem, 'EXPENSE' as strExpenseOrPayable, strGLAccount ,  0 as decHours, isnull(sum(decWithholdingsAmount),0) as Amount ,
-ISNULL(sum(decWithholdingsAmount) , 0) as decDebits , 0 as decCredits, 
isnull(max(strCompanyName),'') as PayrollCompany, isnull(max(strCompany ),'') as Company, isnull(max(strDepartment),'') as Department, isnull(max(strSubdepartment),'') as strSubdepartment , isnull(max(strEmployeeType),'') as EmployeeType 
from viewPay_CompanyBatchWithholdings ubw where strBatchID = @BATCHID group by intuserid, strWithHoldingsName, strGLAccount,strGLContributionPayable

-- Company Contributions per GL Account Payable
INSERT INTO @tblUserGLPayrollReport
select @batchid as strBatchID, max(strBatchDescription), intUserID,max(strUserName),strWithHoldingsName as PayItem, 'PAYABLE' as strExpenseOrPayable,strGLContributionPayable as Payable,  0 as decHours, isnull(sum(decWithholdingsAmount),0) as Amount , 
0 as decDebits, -ISNULL(sum(ubw.decWithholdingsAmount) , 0)   as decCredits  ,
isnull(max(strCompanyName),'') as PayrollCompany, isnull(max(strCompany ),'') as Company, isnull(max(strDepartment),'') as Department, isnull(max(strSubdepartment),'') as strSubdepartment , isnull(max(strEmployeeType),'') as EmployeeType 
from viewPay_CompanyBatchWithholdings ubw where strBatchID = @BATCHID group by intuserid, strWithHoldingsName, strGLAccount,strGLContributionPayable
	
	-- User Withholdings per GL Account Payable
INSERT INTO @tblUserGLPayrollReport
select @batchid as strBatch1ID, max(strBatchDescription),intUserID,max(strUserName),strWithHoldingsName as PayItem, 'PAYABLE' as strExpenseOrPayable, strGLAccount ,  0 as decHours, isnull(sum(decWithholdingsAmount),0)  as Amount, 
0 as decDebits, -isnull(sum(decWithholdingsAmount),0)  as decCredits,
isnull(max(strCompanyName),'') as PayrollCompany, isnull(max(strCompany ),'') as Company, isnull(max(strDepartment),'') as Department, isnull(max(strSubdepartment),'') as strSubdepartment , isnull(max(strEmployeeType),'') as EmployeeType 
from viewPay_UserBatchWithholdings ubw where strBatchID = @BATCHID group by intuserid, strWithHoldingsName, strGLAccount

--PAYROLL ACCOUNT
	DECLARE @PAYROLL_GL nvarchar(50)
	SELECT @PAYROLL_GL = strAccountID from tblGLAccounts WHERE strCompanyName IN (select strCompanyName from tblBatch where strBatchID = @BATCHID) AND intAccountType = 2	
	if @PAYROLL_GL IS NULL SET @PAYROLL_GL = ''

	--CHECKS
INSERT INTO @tblUserGLPayrollReport
	select @batchid as strBatchID, max(strBatchDescription), intUserID,max(strUserName),strPayMethodType as PayItem, 'PAYABLE' as strExpenseOrPayable,@PAYROLL_GL as strGLAccount,  0 as decHours, isnull(sum(decCheckAmount),0) as Amount , 
	0 as decDebits, ISNULL(sum(decCheckAmount) , 0)   as decCredits  ,
	isnull(max(strCompanyName),'') as PayrollCompany, isnull(max(strCompany ),'') as Company, isnull(max(strDepartment),'') as Department, isnull(max(strSubdepartment),'') as strSubdepartment , isnull(max(strEmployeeType),'') as EmployeeType 
	from viewPay_UserPayCheck where strBatchID = @BATCHID and intPayMethodType = 1
	group by strBatchID, intUserID, strPayMethodType

	--DIRECT DEPOSIT
INSERT INTO @tblUserGLPayrollReport
	select @batchid as strBatchID, max(strBatchDescription), intUserID,max(strUserName),strPayMethodType as PayItem, 'PAYABLE' as strExpenseOrPayable,@PAYROLL_GL as strGLAccount,  0 as decHours, isnull(sum(decCheckAmount),0) as Amount , 
	0 as decDebits, ISNULL(sum(decCheckAmount) , 0)   as decCredits  ,
	isnull(max(strCompanyName),'') as PayrollCompany, isnull(max(strCompany ),'') as Company, isnull(max(strDepartment),'') as Department, isnull(max(strSubdepartment),'') as strSubdepartment , isnull(max(strEmployeeType),'') as EmployeeType 
	from viewPay_UserPayCheck where strBatchID = @BATCHID and intPayMethodType = 2
	group by strBatchID, intUserID, strPayMethodType

RETURN
END
GO
