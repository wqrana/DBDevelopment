USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_UserBatchCompensations]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_UserBatchCompensations]
-- WITH ENCRYPTION
AS
SELECT        TOP (100) PERCENT ubc.strBatchID, ubc.intUserID, ubc.strCompensationName, ubc.decPayRate, ubc.decHours, ubc.decPay, ubc.dtTimeStamp, ubc.strGLAccount, ci.intReportOrder, ub.strCompanyName, ub.strBatchDescription, 
                         ub.dtPayDate, ub.intPayWeekNum, ub.strUserName, ub.intDepartmentID, ub.intSubdepartmentID, ub.intEmployeeTypeID, ub.strCompany, ub.strDepartment, ub.strSubdepartment, ub.strEmployeeType, ub.sSSN, 
                         ubc.intSequenceNumber, ubc.intEditType, ubc.boolDeleted, dbo.tblEditMode.strEditDescription, ubc.intUBMESequence
FROM            dbo.tblUserBatchCompensations AS ubc INNER JOIN
                         dbo.viewPay_UserBatchStatus AS ub ON ub.strBatchID = ubc.strBatchID AND ub.intUserID = ubc.intUserID INNER JOIN
                         dbo.tblCompanyCompensations AS ci ON ubc.strCompensationName = ci.strCompensationName AND ub.strCompanyName = ci.strCompanyName AND ubc.boolDeleted = 0 LEFT OUTER JOIN
                         dbo.tblEditMode ON ubc.intEditType = dbo.tblEditMode.intEditMode

GO
