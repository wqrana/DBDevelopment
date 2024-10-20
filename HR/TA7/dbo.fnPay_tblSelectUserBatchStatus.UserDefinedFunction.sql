USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblSelectUserBatchStatus]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	For Payroll Register.  Returns the computed values for viewPay_UserBatchStatus for the parameters.
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblSelectUserBatchStatus]
(	
	-- Add the parameters for the function here
		@BATCHID nvarchar(50),
		@DESC nvarchar(50),
		@PAYROLL_COMPANY nvarchar(50),
		@STARTDATE date,
		@ENDDATE date,
		@COMPANYID int,
		@DEPTID int,
		@SUBDEPTID int,
		@EMPLOYEETYPEID int
)
RETURNS 
@viewPay_UserBatchStatus TABLE 
(
	strBatchID nvarchar(50)
      ,strCompanyName  nvarchar(50)
      ,strBatchDescription nvarchar(50)
      ,dtBatchCreated  date
      ,intCreatedByID  int
      ,strCreateByName nvarchar(50)
      ,dtBatchUpdates  date
      ,intBatchStatus  int
      ,dtPayDate  date
      ,decBatchCompensationAmount  decimal(18,2)
      ,decBatchDeductionAmount  decimal(18,2)
      ,strStatusDescription nvarchar(50)
      ,decBatchTransactionHoursAmount decimal(18,2)
      ,intPayWeekNum int
      ,intUserBatchStatus int
      ,strUserBatchStatus  nvarchar(50)
      ,intUserID int
      ,strUserName nvarchar(50)
      ,sHomeAddressLine1 nvarchar(50)
      ,sHomeAddressLine2 nvarchar(50)
      ,strCity nvarchar(50) 
      ,strState nvarchar(50)
      ,strZipCode nvarchar(50)
      ,decBatchUserCompensations  decimal(18,2)
      ,decBatchUserWithholdings  decimal(18,2)
      ,decBatchNetPay  decimal(18,2)
      ,dtStartDatePeriod date
      ,dtEndDatePeriod date
      ,intCompanyID int
      ,intDepartmentID int
      ,intSubdepartmentID int
      ,intEmployeeTypeID int
      ,strCompany nvarchar(50)
      ,strDepartment nvarchar(50)
      ,strSubdepartment nvarchar(50)
      ,strEmployeeType nvarchar(50)
      ,sSSN nvarchar(50)
) 
-- WITH ENCRYPTION
AS
BEGIN
	INSERT INTO @viewPay_UserBatchStatus 
	SELECT @BATCHID as strBatchID,[strCompanyName], @DESC as [strBatchDescription], getdate() as dtBatchCreated,0 as intCreatedByID,'' as strCreateByName,getdate() as dtBatchUpdates, -1 as intBatchStatus, max( dtPayDate), 
	sum(decBatchCompensationAmount) as decBatchCompensationAmount, sum(decBatchDeductionAmount) as decBatchDeductionAmount, 
	'' as strStatusDescription, sum(decBatchTransactionHoursAmount) as decBatchTransactionHoursAmount, 0 as intPayWeekNum, -1 as intUserBatchStatus, 
	'' as strUserBatchStatus, intUserID, max( strUserName), max(sHomeAddressLine1), max(sHomeAddressLine2), max(strCity), max(strState), max(strZipCode), 
	sum( decBatchUserCompensations) as decBatchUserCompensations, sum( decBatchUserWithholdings) as  decBatchUserWithholdings, sum(decBatchNetPay) as decBatchNetPay,
	min(dtPayDate) as  dtStartDatePeriod,max(dtpaydate) as  dtEndDatePeriod, max( intCompanyID), max(intDepartmentID), max(intSubdepartmentID), max(intEmployeeTypeID), 
	max(strCompany), max(strDepartment), max(strSubdepartment), max(strEmployeeType), max(sSSN)
	FROM [dbo].[viewPay_UserBatchStatus]
	where strCompanyName = @PAYROLL_COMPANY and dtPayDate between @STARTDATE and  @ENDDATE
	and (intCompanyID =  @COMPANYID OR @COMPANYID = 0) and (intDepartmentID = @DEPTID or @DEPTID = 0) and (intSubdepartmentID = @SUBDEPTID or @SUBDEPTID = 0) AND (intEmployeeTypeID = @EMPLOYEETYPEID or @EMPLOYEETYPEID = 0)
	GROUP BY strCompanyName, intUserID

	RETURN
END




GO
