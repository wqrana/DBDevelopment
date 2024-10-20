USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_UserWithholdingsRecord]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewPay_UserWithholdingsRecord]
AS
SELECT        dbo.tblUserWithholdingsItems.intUserID, dbo.tblUserWithholdingsItems.strWithHoldingsName, dbo.tblUserWithholdingsItems.strDescription, dbo.tblUserWithholdingsItems.decEmployeePercent, 
                         dbo.tblUserWithholdingsItems.decEmployeeAmount, dbo.tblUserWithholdingsItems.decCompanyPercent, dbo.tblUserWithholdingsItems.decCompanyAmount, dbo.tblUserWithholdingsItems.decMaximumSalaryLimit, 
                         dbo.tblUserWithholdingsItems.decMinimumSalaryLimit, dbo.tblUserWithholdingsItems.boolDeleted, dbo.tblUserWithholdingsItems.strGLAccount, dbo.tblUserWithholdingsItems.strClassIdentifier, 
                         dbo.tblUserWithholdingsItems.intGLLookupField, dbo.tblUserWithholdingsItems.strContributionsName, dbo.tblUserWithholdingsItems.strGLAccount_Contributions, dbo.tblUserWithholdingsItems.intPeriodEntryID, 
                         dbo.tblUserWithholdingsItems.boolApply401kPlan, dbo.tblUserWithholdingsItems.strGLContributionPayable, dbo.viewPay_UserRecord.strCompanyName, dbo.viewPay_UserRecord.intPayrollUserStatus, 
                         dbo.viewPay_UserRecord.strStatusName, dbo.viewPay_UserRecord.id, dbo.viewPay_UserRecord.name, dbo.viewPay_UserRecord.nStatus, dbo.viewPay_UserRecord.sCompanyName, dbo.viewPay_UserRecord.sDeptName, 
                         dbo.viewPay_UserRecord.sEmployeeTypeName, dbo.viewPay_UserRecord.sJobTitleName, dbo.viewPay_UserRecord.nDeptID, dbo.viewPay_UserRecord.nEmployeeType, dbo.viewPay_UserRecord.nCompanyID, 
                         dbo.viewPay_UserRecord.nJobTitleID, dbo.tblWitholdingsPeriodEntry.strPeriodEntryName
FROM            dbo.tblUserWithholdingsItems INNER JOIN
                         dbo.viewPay_UserRecord ON dbo.tblUserWithholdingsItems.intUserID = dbo.viewPay_UserRecord.intUserID INNER JOIN
                         dbo.tblWitholdingsPeriodEntry ON dbo.tblUserWithholdingsItems.intPeriodEntryID = dbo.tblWitholdingsPeriodEntry.intPeriodEntryID

GO
