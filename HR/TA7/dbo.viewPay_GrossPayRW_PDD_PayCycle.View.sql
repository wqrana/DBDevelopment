USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_GrossPayRW_PDD_PayCycle]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[viewPay_GrossPayRW_PDD_PayCycle]
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
			dbo.tReportWeekPayCycle.e_id, dbo.tReportWeekPayCycle.e_idno, dbo.tReportWeekPayCycle.e_name, dbo.tReportWeekPayCycle.sPayRuleName, dbo.tReportWeekPayCycle.nPayWeekNum, 
                         dbo.tReportWeekPayCycle.nPayRuleID, dbo.tReportWeekPayCycle.DTStartDate, dbo.tReportWeekPayCycle.DTEndDate, dbo.tReportWeekPayCycle.dblREGULAR, dbo.tReportWeekPayCycle.dblONEHALF, dbo.tReportWeekPayCycle.dblDOUBLE, 
                         dbo.tReportWeekPayCycle.sHoursSummary, dbo.tReportWeekPayCycle.nDept, dbo.tReportWeekPayCycle.sDeptName, dbo.tReportWeekPayCycle.nCompID, dbo.tReportWeekPayCycle.sCompanyName, dbo.tReportWeekPayCycle.nEmployeeType, 
                         dbo.tReportWeekPayCycle.sEmployeeTypeName, dbo.tReportWeekPayCycle.nJobTitleID, dbo.tReportWeekPayCycle.sJobTitleName, dbo.tReportWeekPayCycle.nScheduleID, dbo.tReportWeekPayCycle.sScheduleName, dbo.tReportWeekPayCycle.nReviewStatus, 
                         dbo.tReportWeekPayCycle.sWeekID as nWeekID
FROM            dbo.tReportWeekPayCycle INNER JOIN
                         dbo.tuser ON dbo.tuser.id = dbo.tReportWeekPayCycle.e_id inner join tPunchDate pdt on tReportWeekPayCycle.sWeekID = pdt.sWeekID
						 LEFT OUTER JOIN 
                         dbo.tPunchDateDetailPayCycle ON pdt.DTPunchDate = dbo.tPunchDateDetailPayCycle.DTPunchDate and pdt.e_id = dbo.tPunchDateDetailPayCycle.e_id 
cross apply [dbo].[fnPay_UserTransaction_GrossPay]( tuser.id, dbo.tPunchDateDetailPayCycle.DTPunchDate, tPunchDateDetailPayCycle.sType, tPunchDateDetailPayCycle.dblHours,0) as ut

GO
