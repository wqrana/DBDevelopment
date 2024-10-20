USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_UserBatchWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_UserBatchWithholdings]
-- WITH ENCRYPTION
AS
SELECT        TOP (100) PERCENT ubc.strBatchID, ubc.intUserID, ubc.strWithHoldingsName, ubc.decBatchEffectivePay, ubc.decWithholdingsAmount, ubc.strGLAccount, ci.intReportOrder, ub.strCompanyName, ub.strBatchDescription, 
                         ub.dtPayDate, ub.intPayWeekNum, ub.strUserName, ub.intDepartmentID, ub.intSubdepartmentID, ub.intEmployeeTypeID, ub.strCompany, ub.strDepartment, ub.strSubdepartment, ub.strEmployeeType, ub.sSSN, 
                         ubc.intPrePostTaxDeduction, ubc.intSequenceNumber, ubc.boolDeleted, ubc.intEditType, ub.intCompanyID, dbo.tblEditMode.strEditDescription, ubc.intUBMESequence, ubc.dtTimeStamp
FROM            dbo.tblUserBatchWithholdings AS ubc INNER JOIN
                         dbo.viewPay_UserBatchStatus AS ub ON ub.strBatchID = ubc.strBatchID AND ub.intUserID = ubc.intUserID LEFT OUTER JOIN
                         dbo.tblEditMode ON ubc.intEditType = dbo.tblEditMode.intEditMode LEFT OUTER JOIN
                         dbo.tblCompanyWithholdings AS ci ON ubc.strWithHoldingsName = ci.strWithHoldingsName AND ub.strCompanyName = ci.strCompanyName
WHERE        (ubc.boolDeleted = 0)

GO
