USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_GrossPayRW_PP]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_GrossPayRW_PP]
-- WITH ENCRYPTION
AS
SELECT        ut.intUserID AS UserID, dbo.tuser.idno AS IDNumber, dbo.tuser.name AS UserName, ISNULL(ut.strTransName, '') AS TransName, ISNULL(ut.decHours, 0) AS TransHours, ISNULL(ut.dtPunchDate, '') AS PunchDate, 
                         ut.decHourlyRate AS HourlyRate, ut.decGrossPay AS GrossPay, ISNULL(ut.intJobCodeID,0) AS JobCodeID, ISNULL(dbo.tPunchPair.DTimeIn, dbo.tReportWeek.DTStartDate) AS TimeIn, ISNULL(dbo.tPunchPair.DTimeOut, 
                         dbo.tReportWeek.DTStartDate) AS TimeOut, ISNULL(dbo.tPunchPair.pCode, '') AS TransCode, ISNULL(dbo.tPunchPair.sTDesc, '') AS TransNote, ISNULL(dbo.tJobCode.sJobCodeName, '') AS JobCodeName, 
                         ISNULL(dbo.tPunchPair.sTimeIn, '') AS sTimeIn, ISNULL(dbo.tPunchPair.sTimeOut, '') AS sTimeOut, dbo.tReportWeek.e_id, dbo.tReportWeek.e_idno, dbo.tReportWeek.e_name, dbo.tReportWeek.sPayRuleName, 
                         dbo.tReportWeek.nPayWeekNum, dbo.tReportWeek.nPayRuleID, dbo.tReportWeek.DTStartDate, dbo.tReportWeek.DTEndDate, dbo.tReportWeek.dblREGULAR, dbo.tReportWeek.dblONEHALF, 
                         dbo.tReportWeek.dblDOUBLE, dbo.tReportWeek.sHoursSummary, dbo.tReportWeek.nDept, dbo.tReportWeek.sDeptName, dbo.tReportWeek.nCompID, dbo.tReportWeek.sCompanyName, 
                         dbo.tReportWeek.nEmployeeType, dbo.tReportWeek.sEmployeeTypeName, dbo.tReportWeek.nJobTitleID, dbo.tReportWeek.sJobTitleName, dbo.tReportWeek.nScheduleID, dbo.tReportWeek.sScheduleName, 
                         dbo.tReportWeek.nReviewStatus, dbo.tReportWeek.nReviewSupervisorID, dbo.tReportWeek.sSupervisorName, dbo.tReportWeek.nWeekID, dbo.tReportWeek.dblMEAL, dbo.tReportWeek.dblOTHERS
FROM            dbo.tJobCode LEFT OUTER JOIN
                         dbo.tPunchPair ON dbo.tJobCode.nJobCodeID = dbo.tPunchPair.nJobCodeID RIGHT OUTER JOIN
                         dbo.tReportWeek INNER JOIN
                         dbo.tuser ON dbo.tuser.id = dbo.tReportWeek.e_id ON dbo.tPunchPair.nWeekID = dbo.tReportWeek.nWeekID CROSS apply[dbo].[fnPay_UserTransaction_GrossPay](tuser.id, dbo.tPunchPair.DTPunchDate, 
                         tPunchPair.sType, tPunchPair.HoursWorked, tPunchPair.nJobCodeID) AS ut

GO
