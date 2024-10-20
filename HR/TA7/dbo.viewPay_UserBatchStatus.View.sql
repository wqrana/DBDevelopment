USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_UserBatchStatus]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_UserBatchStatus]
AS
SELECT        dbo.viewPay_Batch.strBatchID, dbo.viewPay_Batch.strCompanyName, dbo.viewPay_Batch.strBatchDescription, dbo.viewPay_Batch.dtBatchCreated, dbo.viewPay_Batch.intCreatedByID, dbo.viewPay_Batch.strCreateByName, 
                         dbo.viewPay_Batch.dtBatchUpdates, dbo.viewPay_Batch.intBatchStatus, dbo.viewPay_Batch.dtPayDate, dbo.viewPay_Batch.decBatchCompensationAmount, dbo.viewPay_Batch.decBatchDeductionAmount, 
                         dbo.viewPay_Batch.strStatusDescription, dbo.viewPay_Batch.decBatchTransactionHoursAmount, dbo.tblUserBatch.intPayWeekNum, dbo.tblUserBatchStatus.strUserBatchStatus, dbo.tblUserBatch.intUserID, 
                         dbo.tUserExtended.sEmployeeName AS strUserName, dbo.tUserExtended.sHomeAddressLine1, dbo.tUserExtended.sHomeAddressLine2, dbo.tUserExtended.sHomeCity AS strCity, dbo.tUserExtended.sHomeState AS strState, 
                         dbo.tUserExtended.sHomeZipCode AS strZipCode, dbo.fnPay_BatchUserCompensations(dbo.viewPay_Batch.strBatchID, dbo.tblUserBatch.intUserID) AS decBatchUserCompensations, 
                         dbo.fnPay_BatchUserWithholdings(dbo.viewPay_Batch.strBatchID, dbo.tblUserBatch.intUserID) AS decBatchUserWithholdings, dbo.fnPay_BatchUserCompensations(dbo.viewPay_Batch.strBatchID, dbo.tblUserBatch.intUserID) 
                         + dbo.fnPay_BatchUserWithholdings(dbo.viewPay_Batch.strBatchID, dbo.tblUserBatch.intUserID) AS decBatchNetPay, dbo.tblUserBatch.dtStartDatePeriod, dbo.tblUserBatch.dtEndDatePeriod, dbo.tblUserBatch.intCompanyID, 
                         dbo.tblUserBatch.intDepartmentID, dbo.tblUserBatch.intSubdepartmentID, dbo.tblUserBatch.intEmployeeTypeID, dbo.tCompany.Name AS strCompany, dbo.tDept.Name AS strDepartment, 
                         dbo.tJobTitle.Name AS strSubdepartment, dbo.tEmployeeType.Name AS strEmployeeType, dbo.tUserExtended.sSSN, dbo.viewPay_Batch.strBatchTypeName, dbo.tblUserBatch.intPayMethodType, 
                         dbo.tblPayMethodType.strPayMethodType, dbo.viewPay_Batch.intBatchType, dbo.viewPay_Batch.intTemplateID, dbo.tblUserBatch.intUserBatchStatus,
                             (SELECT        COUNT(intUserID) AS Expr1
                               FROM            dbo.tblUserPayChecks
                               WHERE        (strBatchID = dbo.tblUserBatch.strBatchID) AND (intUserID = dbo.tblUserBatch.intUserID) AND (intPayMethodType = 2)) AS intDirectDepositCount,
                             (SELECT        COUNT(intUserID) AS Expr1
                               FROM            dbo.tblUserPayChecks AS tblUserPayChecks_1
                               WHERE        (strBatchID = dbo.tblUserBatch.strBatchID) AND (intUserID = dbo.tblUserBatch.intUserID) AND (intPayMethodType = 1)) AS intCheckCount, dbo.viewPay_Batch.ClosedByUserID, 
                         dbo.viewPay_Batch.ClosedDateTime
FROM            dbo.tblUserBatch INNER JOIN
                         dbo.viewPay_Batch ON dbo.tblUserBatch.strBatchID = dbo.viewPay_Batch.strBatchID INNER JOIN
                         dbo.tUserExtended ON dbo.tblUserBatch.intUserID = dbo.tUserExtended.nUserID LEFT OUTER JOIN
                         dbo.tblPayMethodType ON dbo.tblUserBatch.intPayMethodType = dbo.tblPayMethodType.intPayMethodType LEFT OUTER JOIN
                         dbo.tblUserBatchStatus ON dbo.tblUserBatch.intUserBatchStatus = dbo.tblUserBatchStatus.intUserBatchStatus LEFT OUTER JOIN
                         dbo.tEmployeeType ON dbo.tblUserBatch.intEmployeeTypeID = dbo.tEmployeeType.ID LEFT OUTER JOIN
                         dbo.tJobTitle ON dbo.tblUserBatch.intSubdepartmentID = dbo.tJobTitle.ID LEFT OUTER JOIN
                         dbo.tDept ON dbo.tblUserBatch.intDepartmentID = dbo.tDept.ID LEFT OUTER JOIN
                         dbo.tCompany ON dbo.tblUserBatch.intCompanyID = dbo.tCompany.ID
GO
