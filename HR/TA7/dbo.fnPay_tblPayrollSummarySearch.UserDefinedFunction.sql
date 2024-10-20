USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPayrollSummarySearch]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	Returns the payroll user register table.  Compensations, Withholdings and Contributions
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblPayrollSummarySearch]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50),
	@StartDate As Date,
	@EndDate As Date, 
	@PayrollCompany As nvarchar(50), 
	@UserID As Integer, 
	@CompanyID As Integer,
	@DepartmentID As Integer, 
	@SubDepartmentID As Integer, 
	@EmployeeTypeID As Integer
)
RETURNS 
@tblUserBatchSummary TABLE 
(
	intUserID  int,
	strUserName nvarchar(50),
	strDepartmentName nvarchar(50),
	strItemsName nvarchar(50),
	decItemsAmount decimal(18,5),
	decItemsHours decimal(18,5)
) 
-- WITH ENCRYPTION
AS
BEGIN
IF @BATCHID = ''
BEGIN
	--Return the Compensations
	insert into @tblUserBatchSummary
	SELECT ubc.intUserID , ubs.strUserName, ubs.strDepartment, IIF (uci.intReportOrder is null, '10', convert( nvarchar(2) ,uci.intReportOrder)) + '_' + ubc.strCompensationName as strItemsName , decPay as decItemsAmount, decHours as decItemsHours 
	FROM [dbo].[tblUserBatchCompensations] ubc inner join viewPay_UserBatchStatus ubs on ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID
	inner join [dbo].[tblCompanyCompensations] uci on ubc.strCompensationName = uci.strCompensationName and ubs.strCompanyName = uci.strCompanyName
	WHERE ubs.dtPayDate BETWEEN @StartDate and @EndDate 
	and ubs.strCompanyName = @PayrollCompany
	--and ubc.boolDeleted = 0 
	and (ubs.intUserID = @UserID OR @UserID = 0)
	and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
	and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
	and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
	and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
	ORDER BY ubc.intUserID, convert( nvarchar(2) ,uci.intReportOrder) + '_' + ubc.strCompensationName  ASC

	--Return the Withholdings
	insert into @tblUserBatchSummary
	SELECT ubw.intUserID,ubs.strUserName, ubs.strDepartment, IIF (uci.intReportOrder is null, '20', convert( nvarchar(2) ,uci.intReportOrder)) + '_' + ubw.strWithHoldingsName as strItemsName  , ubw.decWithholdingsAmount as decItemsAmount , 0 as decItemsHours 
	FROM [dbo].[tblUserBatchWithholdings] ubw inner join viewPay_UserBatchStatus ubs on ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID
	left outer join [dbo].[tblCompanyWithholdings] uci on ubw.strWithHoldingsName = uci.strWithHoldingsName and ubs.strCompanyName = uci.strCompanyName
	WHERE ubs.dtPayDate BETWEEN @StartDate and @EndDate and ubs.strCompanyName = @PayrollCompany
	--and uci.boolDeleted = 0 
	and (ubs.intUserID = @UserID OR @UserID = 0)
	and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
	and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
	and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
	and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
	ORDER BY ubw.intUserID, convert( nvarchar(2) ,uci.intReportOrder) + '_' + ubw.strWithHoldingsName  ASC

	--Return the Contributions
	insert into @tblUserBatchSummary
	SELECT ubw.intUserID,ubs.strUserName, ubs.strDepartment, left(IIF (uci.intReportOrder is null, '80', convert( nvarchar(2) ,uci.intReportOrder+25)) + '_' + ubw.strWithHoldingsName +' CC',50) as strItemsName  , ubw.decWithholdingsAmount as decItemsAmount , 0 as decItemsHours 
	FROM [dbo].[tblCompanyBatchWithholdings] ubw inner join viewPay_UserBatchStatus ubs on ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID
	left outer join [dbo].[tblCompanyWithholdings] uci on ubw.strWithHoldingsName = uci.strWithHoldingsName and ubs.strCompanyName = uci.strCompanyName
	WHERE ubs.dtPayDate BETWEEN @StartDate and @EndDate and ubs.strCompanyName = @PayrollCompany
	--and uci.boolDeleted = 0 
	and (ubs.intUserID = @UserID OR @UserID = 0)
	and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
	and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
	and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
	and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
	ORDER BY ubw.intUserID, convert( nvarchar(2) ,uci.intReportOrder) + '_' + ubw.strWithHoldingsName  ASC
END
ELSE
BEGIN
	--Return the Compensations
	insert into @tblUserBatchSummary
	SELECT ubc.intUserID , ubs.strUserName, ubs.strDepartment, IIF (uci.intReportOrder is null, '10', convert( nvarchar(2) ,uci.intReportOrder)) + '_' + ubc.strCompensationName as strItemsName , decPay as decItemsAmount, decHours as decItemsHours 
	FROM [dbo].[tblUserBatchCompensations] ubc inner join viewPay_UserBatchStatus ubs on ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID
	inner join [dbo].[tblCompanyCompensations] uci on ubc.strCompensationName = uci.strCompensationName and ubs.strCompanyName = uci.strCompanyName
	WHERE ubc.strBatchID = @BATCHID  and ubc.boolDeleted = 0
	ORDER BY ubc.intUserID, convert( nvarchar(2) ,uci.intReportOrder) + '_' + ubc.strCompensationName  ASC

	--Return the Withholdings
	insert into @tblUserBatchSummary
	SELECT ubw.intUserID,ubs.strUserName, ubs.strDepartment, IIF (uci.intReportOrder is null, '20', convert( nvarchar(2) ,uci.intReportOrder)) + '_' + ubw.strWithHoldingsName as strItemsName  , ubw.decWithholdingsAmount as decItemsAmount , 0 as decItemsHours 
	FROM [dbo].[tblUserBatchWithholdings] ubw inner join viewPay_UserBatchStatus ubs on ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID
	left outer join [dbo].[tblCompanyWithholdings] uci on ubw.strWithHoldingsName = uci.strWithHoldingsName and ubs.strCompanyName = uci.strCompanyName
	WHERE ubw.strBatchID = @BATCHID 
	ORDER BY ubw.intUserID, convert( nvarchar(2) ,uci.intReportOrder) + '_' + ubw.strWithHoldingsName  ASC

	--Return the Contributions
	insert into @tblUserBatchSummary
	SELECT ubw.intUserID,ubs.strUserName, ubs.strDepartment, left(IIF (uci.intReportOrder is null, '80', convert( nvarchar(2) ,uci.intReportOrder+25)) + '_' + ubw.strWithHoldingsName +' CC',50) as  strItemsName  , ubw.decWithholdingsAmount as decItemsAmount , 0 as decItemsHours 
	FROM [dbo].[tblCompanyBatchWithholdings] ubw inner join viewPay_UserBatchStatus ubs on ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID
	left outer join [dbo].[tblCompanyWithholdings] uci on ubw.strWithHoldingsName = uci.strWithHoldingsName and ubs.strCompanyName = uci.strCompanyName
	WHERE ubw.strBatchID = @BATCHID 
	ORDER BY ubw.intUserID, convert( nvarchar(2) ,uci.intReportOrder) + '_' + ubw.strWithHoldingsName  ASC

END
	RETURN
END


GO
