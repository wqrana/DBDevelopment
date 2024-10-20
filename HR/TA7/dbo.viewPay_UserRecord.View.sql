USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_UserRecord]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_UserRecord]
AS
SELECT        ucp.intUserID, ucp.strCompanyName, ucp.intPayrollUserStatus, us.strStatusName, ur.id, ur.name, ur.idno, ur.nStatus, ur.sNotes, ur.sCompanyName, ur.sDeptName, ur.sJobTitleName, ur.sEmployeeTypeName, 
                         ur.sPayrollRuleName, ur.sScheduleName, ur.nDeptID, ur.nJobTitleID, ur.nGroupID, ur.nEmployeeType, ur.nCompanyID, ur.nPayrollRuleID, ur.nScheduleID, ur.dCompanySeniorityDate, ur.sSSN, ur.sHomeAddressLine1, 
                         ur.sHomeAddressLine2, ur.sHomeCity, ur.sHomeState, ur.sHomeZipCode, ur.sHomePhoneHum, ur.sSex, ur.sMaritalStatus, ur.dBirthDate, ur.dOriginalHiredDate, ur.dblHourlyRate, ur.sRegTempCode, ur.sFullPartTimeCode, 
                         ur.dblBaseCompensationRate, ur.email, dbo.tblCompanyPayrollInformation.strEIN, ur.intPositionID, ur.strPositionName, ur.dTerminationDate
						 ,ur.FirstName, ur.MiddleInitial, ur.FirstLastName, ur.SecondLastName
FROM            dbo.tblUserCompanyPayroll AS ucp INNER JOIN
                         dbo.tblUserStatus AS us ON ucp.intPayrollUserStatus = us.intStatus INNER JOIN
                         dbo.viewUser_Reports AS ur ON ucp.intUserID = ur.id INNER JOIN
                         dbo.tblCompanyPayrollInformation ON ucp.strCompanyName = dbo.tblCompanyPayrollInformation.strCompanyName

GO
