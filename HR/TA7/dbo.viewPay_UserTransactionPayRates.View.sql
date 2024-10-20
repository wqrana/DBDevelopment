USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_UserTransactionPayRates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewPay_UserTransactionPayRates]
-- WITH ENCRYPTION
AS
SELECT        ut.dStartDate, ut.sTransName, ut.intPayPeriod, ut.intHourlyOrSalary, ut.decPayRate, ut.decHoursPerPeriod, ut.nInactivate, ut.decPeriodWages, ut.decPeriodComissions, ut.decPeriodHours, ut.dtPeriodStartDate, 
                         ut.dtPeriodEndDate, ur.intUserID, ur.strCompanyName, ur.intPayrollUserStatus, ur.strStatusName, ur.id, ur.name, ur.idno, ur.nStatus, ur.sNotes, ur.sCompanyName, ur.sDeptName, ur.sJobTitleName, ur.sEmployeeTypeName, 
                         ur.sPayrollRuleName, ur.sScheduleName, ur.nDeptID, ur.nJobTitleID, ur.nGroupID, ur.nEmployeeType, ur.nCompanyID, ur.nPayrollRuleID, ur.nScheduleID, ur.dCompanySeniorityDate, ur.sSSN, ur.sHomeAddressLine1, 
                         ur.sHomeAddressLine2, ur.sHomeCity, ur.sHomeState, ur.sHomeZipCode, ur.sHomePhoneHum, ur.sSex, ur.sMaritalStatus, ur.dBirthDate, ur.dOriginalHiredDate, ur.dblHourlyRate, ur.sRegTempCode, ur.sFullPartTimeCode, 
                         ur.dblBaseCompensationRate, ur.email, ur.strEIN
FROM            dbo.tblUserTransactionPayRates AS ut INNER JOIN
                         dbo.viewPay_UserRecord AS ur ON ut.nUserID = ur.intUserID


GO
