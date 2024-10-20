USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_GrossPayRW_PDD]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_GrossPayRW_PDD]
-- WITH ENCRYPTION
AS
SELECT       
 ut.intUserID AS UserID, 
			dbo.tuser.idno AS IDNumber, 
			dbo.tuser.name AS UserName, 
			ISNULL(ut.strTransName, '') AS TransName, 
			ISNULL(ut.decHours , 0) AS TransHours, 
			ISNULL(ut.dtPunchDate, '') AS PunchDate, 
			ut.decHourlyRate as HourlyRate,
			ut.decGrossPay AS GrossPay,
			ut.intJobCodeID as JobCode,
			dbo.tReportWeek.e_id, dbo.tReportWeek.e_idno, dbo.tReportWeek.e_name, dbo.tReportWeek.sPayRuleName, dbo.tReportWeek.nPayWeekNum, 
                         dbo.tReportWeek.nPayRuleID, dbo.tReportWeek.DTStartDate, dbo.tReportWeek.DTEndDate, dbo.tReportWeek.dblREGULAR, dbo.tReportWeek.dblONEHALF, dbo.tReportWeek.dblDOUBLE, 
                         dbo.tReportWeek.sHoursSummary, dbo.tReportWeek.nDept, dbo.tReportWeek.sDeptName, dbo.tReportWeek.nCompID, dbo.tReportWeek.sCompanyName, dbo.tReportWeek.nEmployeeType, 
                         dbo.tReportWeek.sEmployeeTypeName, dbo.tReportWeek.nJobTitleID, dbo.tReportWeek.sJobTitleName, dbo.tReportWeek.nScheduleID, dbo.tReportWeek.sScheduleName, dbo.tReportWeek.nReviewStatus, 
                         dbo.tReportWeek.nReviewSupervisorID, dbo.tReportWeek.sSupervisorName, dbo.tReportWeek.nWeekID, dbo.tReportWeek.dblMEAL, dbo.tReportWeek.dblOTHERS
FROM            dbo.tReportWeek INNER JOIN
                         dbo.tuser ON dbo.tuser.id = dbo.tReportWeek.e_id LEFT OUTER JOIN
                         dbo.tPunchDateDetail ON dbo.tReportWeek.nWeekID = dbo.tPunchDateDetail.nWeekID
cross apply [dbo].[fnPay_UserTransaction_GrossPay]( tuser.id, dbo.tPunchDateDetail.DTPunchDate, tPunchDateDetail.sType, tPunchDateDetail.dblHours,0) as ut

GO
