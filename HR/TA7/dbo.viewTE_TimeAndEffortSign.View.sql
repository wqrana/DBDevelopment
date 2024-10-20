USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewTE_TimeAndEffortSign]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewTE_TimeAndEffortSign]
AS
SELECT        s.intTAEMonthlySignatureID, s.intUserID, s.strUserName, s.intMonth, s.intYear, s.SignHash, s.SignEntry, s.SignDateTime, t.strBatchID, t.strBatchDescription, t.strCompensationName, t.decPayRate, t.decHours, t.intEditType, 
                         t.dtPunchDate, t.decPay, t.strCompanyName, t.strCompany, t.strDepartment, t.strSubdepartment, t.strEmployeeType
FROM            dbo.tblTimeAndEffortMonthlySign AS s FULL OUTER JOIN
                         dbo.tblTimeAndEffortMonthly AS t ON s.intTAEMonthlySignatureID = t.intTAEMonthlySignatureID
GO
