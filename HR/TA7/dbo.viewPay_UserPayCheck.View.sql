USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_UserPayCheck]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_UserPayCheck]
-- WITH ENCRYPTION
AS
SELECT        dbo.viewPay_UserBatchStatus.strCompanyName, dbo.viewPay_UserBatchStatus.strBatchDescription, dbo.tblUserPayChecks.strBatchID, dbo.tblUserPayChecks.intUserID, dbo.tblUserPayChecks.dtPayDate, 
                         dbo.tblUserPayChecks.intSequenceNum, dbo.tblUserPayChecks.decCheckAmount, dbo.tblUserPayChecks.intPayCheckStatus, dbo.tblUserPayChecks.intCheckNumber, dbo.tblUserPayChecks.intPayMethodType, 
                         dbo.tblUserPayChecks.intAccountType, dbo.tblUserPayChecks.strBankAccountNumber, dbo.tblUserPayChecks.strBankRoutingNumber, dbo.tblUserPayChecks.strBankName, dbo.tblUserPayChecks.decDepositPercent, 
                         dbo.tblUserPayChecks.decDepositAmount, dbo.viewPay_UserBatchStatus.strUserName, dbo.viewPay_UserBatchStatus.decBatchUserCompensations, dbo.viewPay_UserBatchStatus.decBatchUserWithholdings, 
                         dbo.viewPay_UserBatchStatus.decBatchNetPay, dbo.viewPay_UserBatchStatus.dtStartDatePeriod, dbo.viewPay_UserBatchStatus.dtEndDatePeriod, dbo.viewPay_UserBatchStatus.strCompany, 
                         dbo.viewPay_UserBatchStatus.strDepartment, dbo.viewPay_UserBatchStatus.strSubdepartment, dbo.viewPay_UserBatchStatus.strEmployeeType, dbo.viewPay_UserBatchStatus.sSSN, 
                         dbo.viewPay_UserBatchStatus.intCompanyID, dbo.viewPay_UserBatchStatus.intDepartmentID, dbo.viewPay_UserBatchStatus.intSubdepartmentID, dbo.viewPay_UserBatchStatus.intEmployeeTypeID, 
                         dbo.viewPay_UserBatchStatus.intPayWeekNum, dbo.tblPayMethodType.strPayMethodType, dbo.tblBankAccountTypes.strBankAccountDescription, dbo.tUserExtended.sHomeAddressLine1, 
                         dbo.tUserExtended.sHomeAddressLine2, dbo.tUserExtended.sHomeCity, dbo.tUserExtended.sHomeState, dbo.tUserExtended.sHomeZipCode, dbo.tUserExtended.sSSN AS sSocialSecurityNum
FROM            dbo.tblUserPayChecks INNER JOIN
                         dbo.viewPay_UserBatchStatus ON dbo.tblUserPayChecks.strBatchID = dbo.viewPay_UserBatchStatus.strBatchID AND dbo.tblUserPayChecks.intUserID = dbo.viewPay_UserBatchStatus.intUserID LEFT OUTER JOIN
                         dbo.tUserExtended ON dbo.tblUserPayChecks.intUserID = dbo.tUserExtended.nUserID LEFT OUTER JOIN
                         dbo.tblBankAccountTypes ON dbo.tblUserPayChecks.intAccountType = dbo.tblBankAccountTypes.intBankAccountType LEFT OUTER JOIN
                         dbo.tblPayMethodType ON dbo.tblUserPayChecks.intPayMethodType = dbo.tblPayMethodType.intPayMethodType

GO
