USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_UserCompensationsRecord]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewPay_UserCompensationsRecord]
AS
SELECT        dbo.tblUserCompensationItems.strCompensationName, dbo.tblUserCompensationItems.strDescription, dbo.tblUserCompensationItems.intCompensationType, dbo.tblCompensationTypes.strCompensationTypeName, 
                         dbo.tblUserCompensationItems.intComputationType, dbo.tblCompensationComputationTypes.strComputationTypeName, dbo.tblUserCompensationItems.boolEnabled, dbo.tblUserCompensationItems.decHourlyRate, 
                         dbo.tblUserCompensationItems.decMoneyAmount, dbo.tblUserCompensationItems.strGLAccount, dbo.tblUserCompensationItems.intPeriodEntryID, dbo.tblCompensationPeriodEntry.strPeriodEntryName, 
                         dbo.viewPay_UserRecord.intUserID, dbo.viewPay_UserRecord.strCompanyName, dbo.viewPay_UserRecord.intPayrollUserStatus, dbo.viewPay_UserRecord.strStatusName, dbo.viewPay_UserRecord.id, 
                         dbo.viewPay_UserRecord.name, dbo.viewPay_UserRecord.idno, dbo.viewPay_UserRecord.nStatus, dbo.viewPay_UserRecord.sCompanyName, dbo.viewPay_UserRecord.sDeptName, 
                         dbo.viewPay_UserRecord.sEmployeeTypeName, dbo.viewPay_UserRecord.sJobTitleName, dbo.viewPay_UserRecord.nDeptID, dbo.viewPay_UserRecord.nEmployeeType, dbo.viewPay_UserRecord.nCompanyID, 
                         dbo.viewPay_UserRecord.nJobTitleID
FROM            dbo.tblUserCompensationItems INNER JOIN
                         dbo.viewPay_UserRecord ON dbo.tblUserCompensationItems.intUserID = dbo.viewPay_UserRecord.intUserID INNER JOIN
                         dbo.tblCompensationTypes ON dbo.tblUserCompensationItems.intCompensationType = dbo.tblCompensationTypes.intCompensationType INNER JOIN
                         dbo.tblCompensationComputationTypes ON dbo.tblUserCompensationItems.intComputationType = dbo.tblCompensationComputationTypes.intComputationType INNER JOIN
                         dbo.tblCompensationPeriodEntry ON dbo.tblUserCompensationItems.intPeriodEntryID = dbo.tblCompensationPeriodEntry.intPeriodEntryID
GO
