USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCompanyDeptSubdeptGLSummary]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnPay_tblCompanyDeptSubdeptGLSummary]
(	
	@PAYROLLCOMPANY nvarchar(50),
	@StartDate date,
	@EndDate date,
	@BATCHID nvarchar(50)
)
RETURNS  @tblCompanyDeptSubdeptGLSummary TABLE
(
	strCompany nvarchar(50), 
	strDepartment nvarchar(50), 
	strSubdepartment nvarchar(50),
	strPayrollItem nvarchar(50), 
	strGLAccount nvarchar(50),  
	decHours decimal(18,2), 
	decPay decimal(18,2),
	intReportOrder int,
	strPayrollCompany nvarchar(50)
)
-- WITH ENCRYPTION
AS
BEGIN
if @BATCHID = ''
	BEGIN
	--Compensations
	insert into @tblCompanyDeptSubdeptGLSummary 
	select strCompany, strDepartment, strSubdepartment ,strCompensationName, strGLAccount,  sum(decHours) as decHours, sum(decpay) as decPay, intReportOrder, strCompanyName from viewPay_UserBatchCompensations 
	where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @StartDate and @EndDate 
	group by strCompanyName, strCompany, strDepartment, strSubdepartment, strCompensationName, intReportOrder, strGLAccount
	--Withholdings
	insert into @tblCompanyDeptSubdeptGLSummary 
	select strCompany, strDepartment, strSubdepartment ,strWithHoldingsName, strGLAccount,  0 as decHours, sum(decWithholdingsAmount) as decPay, intReportOrder, strCompanyName from viewPay_UserBatchWithholdings 
	where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @StartDate and @EndDate 
	group by strCompanyName, strCompany, strDepartment, strSubdepartment, strWithHoldingsName, intReportOrder, strGLAccount
	END
ELSE
	BEGIN 
	--Compensations
	insert into @tblCompanyDeptSubdeptGLSummary 
	select strCompany, strDepartment, strSubdepartment ,strCompensationName, strGLAccount,  sum(decHours) as decHours, sum(decpay) as decPay, intReportOrder, strCompanyName from viewPay_UserBatchCompensations 
	where strCompanyName = @PAYROLLCOMPANY AND strBatchID = @BATCHID
	group by strCompanyName, strCompany, strDepartment, strSubdepartment, strCompensationName, intReportOrder, strGLAccount
	--Withholdings
	insert into @tblCompanyDeptSubdeptGLSummary 
	select strCompany, strDepartment, strSubdepartment ,strWithHoldingsName, strGLAccount,  0 as decHours, sum(decWithholdingsAmount) as decPay, intReportOrder, strCompanyName from viewPay_UserBatchWithholdings 
	where strCompanyName = @PAYROLLCOMPANY AND strBatchID = @BATCHID
	group by strCompanyName, strCompany, strDepartment, strSubdepartment, strWithHoldingsName, intReportOrder, strGLAccount

	END
RETURN
END


GO
