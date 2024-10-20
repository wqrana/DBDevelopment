USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchUserGLReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnPay_tblBatchUserGLReport]
(
@BatchID nvarchar(50),
@StartDate date,
@EndDate date,
@PayrollCompany nvarchar(50),
@Company nvarchar(50),
@Department nvarchar(50),
@SubDepartment nvarchar(50),
@EmployeeType nvarchar(50)
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
AS
BEGIN

IF @BATCHID <> '' --Single Batch
	BEGIN
		INSERT INTO @tblUserGLPayrollReport
		SELECT 	strBatchID , 	strBatchDescription , 	intUserID ,	strUserName , 	strPayItem , 	strExpenseOrPayable, strGLAccount, decHours , 	decAmount ,
		decDebits, decCredits,
		strPayrollCompany , 	strCompany , 	strDepartment , 	strSubDepartment , 	strEmployeeType FROM  [dbo].[fnPay_tblBatchUserGLReportDetail]	(@BatchID)
		WHERE (strPayrollCompany = @PayrollCompany ) AND (strCompany = @Company OR @Company = 'ALL') AND (strDepartment = @Department OR @Department = 'ALL')
		AND (strSubDepartment = @SubDepartment OR @SubDepartment = 'ALL') and (strEmployeeType = @EmployeeType OR @EmployeeType = 'ALL')
	END
ELSE
	BEGIN
		INSERT INTO @tblUserGLPayrollReport
		SELECT 	r.strBatchID , 	r.strBatchDescription , 	r.intUserID ,	r.strUserName , 	r.strPayItem , 	r.strExpenseOrPayable, r.strGLAccount, r.decHours , 	r.decAmount ,
		r.decDebits, r.decCredits,
		r.strPayrollCompany , 	r.strCompany , 	r.strDepartment , 	r.strSubDepartment , 	r.strEmployeeType 
		FROM tblBatch b 	 CROSS APPLY	 [dbo].[fnPay_tblBatchUserGLReportDetail]	(b.strbatchid) r 
		 where b.strCompanyName = @PayrollCompany	and b.dtPayDate BETWEEN @StartDate and @EndDate
		AND (r.strPayrollCompany = @PayrollCompany OR @PayrollCompany = '') AND (strCompany = @Company OR @Company = 'ALL')  AND (strDepartment = @Department OR @Department = 'ALL')
		AND (strSubDepartment = @SubDepartment OR @SubDepartment = 'ALL') and (strEmployeeType = @EmployeeType OR @EmployeeType = 'ALL')
	END
	RETURN
END
GO
