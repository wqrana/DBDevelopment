USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_UserWithholdingItems]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_UserWithholdingItems]
-- WITH ENCRYPTION
AS
SELECT        dbo.tblUserWithholdingsItems.intUserID, dbo.tblUserWithholdingsItems.strWithHoldingsName, dbo.tblUserWithholdingsItems.strDescription, dbo.tblUserWithholdingsItems.decEmployeePercent, 
                         dbo.tblUserWithholdingsItems.decEmployeeAmount, dbo.tblUserWithholdingsItems.decCompanyPercent, dbo.tblUserWithholdingsItems.decCompanyAmount, dbo.tblUserWithholdingsItems.decMaximumSalaryLimit, 
                         dbo.tblUserWithholdingsItems.decMinimumSalaryLimit, dbo.tblUserWithholdingsItems.strGLAccount, dbo.tblUserWithholdingsItems.strClassIdentifier, dbo.tblUserWithholdingsItems.boolDeleted, 
                         dbo.tblCompanyWithholdings.intPrePostTaxDeduction, dbo.tblCompanyWithholdings.intComputationType, dbo.tblCompanyWithholdings.intWithholdingsTaxType, dbo.tblUserCompanyPayroll.strCompanyName, 
                         dbo.tblUserWithholdingsItems.strContributionsName, dbo.tblUserWithholdingsItems.strGLAccount_Contributions, dbo.tblUserWithholdingsItems.intPeriodEntryID, dbo.tblUserWithholdingsItems.intGLLookupField, 
                         dbo.tblUserWithholdingsItems.boolApply401kPlan, dbo.tblUserWithholdingsItems.strGLContributionPayable
FROM            dbo.tblUserWithholdingsItems INNER JOIN
                         dbo.tblCompanyWithholdings ON dbo.tblUserWithholdingsItems.strWithHoldingsName = dbo.tblCompanyWithholdings.strWithHoldingsName INNER JOIN
                         dbo.tblUserCompanyPayroll ON dbo.tblUserWithholdingsItems.intUserID = dbo.tblUserCompanyPayroll.intUserID AND dbo.tblCompanyWithholdings.strCompanyName = dbo.tblUserCompanyPayroll.strCompanyName

GO
