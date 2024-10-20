USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCompanyPayrollSummary_Checks]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 03/23/2021
-- Description:	For Cmpany Payroll Summary Check Summary.  
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblCompanyPayrollSummary_Checks]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50),
	@USERID int = 0,
	@PAYROLLCOMPANY nvarchar(50) ,
	@STARTDATE date ,
	@ENDDATE date ,
	@CompanyID int ,
	@DepartmentID int ,
	@SubDepartmentID int ,
	@EmployeeTypeID int 
)
RETURNS 
@tblBatchPayCheckSummary TABLE 
(
	strBatchID nvarchar(50),
	strPayMethodType nvarchar(50), 
	decPayTotals decimal(18,2)
) 
-- WITH ENCRYPTION
AS
BEGIN
IF @BATCHID <> '' --Select by Payrollcompany
BEGIN
		insert into @tblBatchPayCheckSummary
		select pc.strBatchID as strBatchID, pm.strPayMethodType as strPayMethodType, sum(decCheckAmount) as decCheckAmountTotal 
		from [dbo].[tblUserPayChecks] pc inner join tblPayMethodType pm on pc.intPayMethodType = pm.intPayMethodType
		inner join viewPay_UserBatchStatus ubs on pc.strBatchID = ubs.strBatchID and pc.intUserID = ubs.intUserID
		where pc.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (pc.intUserID = @USERID OR @USERID = 0)
		group by pc.strBatchID, pm.strPayMethodType
END
ELSE
BEGIN
		insert into @tblBatchPayCheckSummary
		select pc.strBatchID as strBatchID, pm.strPayMethodType as strPayMethodType, sum(decCheckAmount) as decCheckAmountTotal 
		from [dbo].[tblUserPayChecks] pc inner join tblPayMethodType pm on pc.intPayMethodType = pm.intPayMethodType
		inner join viewPay_UserBatchStatus ubs on pc.strBatchID = ubs.strBatchID and pc.intUserID = ubs.intUserID
		where UBS.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (pc.intUserID = @USERID OR @USERID = 0)
		group by pc.strBatchID, pm.strPayMethodType
END


	RETURN
END

GO
