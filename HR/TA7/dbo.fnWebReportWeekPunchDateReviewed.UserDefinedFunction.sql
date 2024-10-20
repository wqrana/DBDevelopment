USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnWebReportWeekPunchDateReviewed]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 1/16/2015
-- Description:	Table function that unites tReportweek and tPunchDate- mostly for timesheet reports
-- RW indicates tReportWeek fields, PDT indicates PunchDate fields
-- =============================================
CREATE FUNCTION [dbo].[fnWebReportWeekPunchDateReviewed]
(
	-- Add the parameters for the function here

)
RETURNS TABLE 
AS
RETURN 
(

/* Fill the table variable with the rows for your result set*/
SELECT        tReportWeek.e_id AS RW_e_id, tReportWeek.e_idno AS RW_e_idno, tReportWeek.e_name AS RW_e_name, tReportWeek.nPayRuleID AS RW_nPayRuleID, tReportWeek.sPayRuleName AS RW_sPayRuleName, 
                         tReportWeek.nPayWeekNum AS RW_nPayWeekNum, tReportWeek.DTStartDate AS RW_DTStartDate, tReportWeek.DTEndDate AS RW_DTEndDate, tReportWeek.dblREGULAR AS RW_dblREGULAR, 
                         tReportWeek.dblONEHALF AS RW_dblONEHALF, tReportWeek.dblDOUBLE AS RW_dblDOUBLE, tReportWeek.sHoursSummary AS RW_sHoursSummary, tReportWeek.nDept AS RW_nDept, 
                         tReportWeek.sDeptName AS RW_sDeptName, tReportWeek.nCompID AS RW_nCompID, tReportWeek.sCompanyName AS RW_sCompanyName, tReportWeek.nEmployeeType AS RW_nEmployeeType, 
                         tReportWeek.sEmployeeTypeName AS RW_sEmployeeTypeName, tReportWeek.nJobTitleID AS RW_nJobTitleID, tReportWeek.sJobTitleName AS RW_sJobTitleName, 
                         tReportWeek.nScheduleID AS RW_nScheduleID, tReportWeek.sScheduleName AS RW_sScheduleName, tReportWeek.nPayPeriod AS RW_nPayPeriod, tReportWeek.nReviewStatus AS RW_nReviewStatus, 
                         tReportWeek.nReviewSupervisorID AS RW_nReviewSupervisorID, tReportWeek.sSupervisorName AS RW_sSupervisorName, tReportWeek.nWeekID AS RW_nWeekID, tReportWeek.dblMEAL AS RW_dblMEAL, 
                         tReportWeek.dblOTHERS AS RW_dblOTHERS, tReportWeek.nLocked AS RW_nLocked, tPunchDate.DTPunchDate AS PDT_DTPunchDate, tPunchDate.DayID AS PDT_DayID, 
                         tPunchDate.dblPunchHrs AS PDT_dblPunchHrs, tPunchDate.sType AS PDT_sType, tPunchDate.sPunchSummary AS PDT_sPunchSummary, tPunchDate.sExceptions AS PDT_sExceptions, 
                         tPunchDate.sDaySchedule AS PDT_sDaySchedule, tPunchDate.sHoursSummary AS PDT_sHoursSummary, tPunchDate.bLocked AS PDT_bLocked, tPunchDate.dblREGULAR AS PDT_dblREGULAR, 
                         tPunchDate.dblONEHALF AS PDT_dblONEHALF, tPunchDate.dblDOUBLE AS PDT_dblDOUBLE, tPunchDate.sWeekID AS PDT_sWeekID, tPunchDate.dblMEAL AS PDT_dblMEAL, 
                         tPunchDate.dblOTHERS AS PDT_dblOTHERS, tPunchDate.nAbsentStatus AS PDT_nAbsentStatus, tPunchDate.nWeekID AS PDT_nWeekID, tReportWeekReview.intReviewedID, 
                         tReportWeekReview.strReviewedName, tReportWeekReview.strReviewedDateTime, tReportWeekReview.intApprovedID, tReportWeekReview.strApprovedName, tReportWeekReview.strApprovedDateTime
FROM            tReportWeek INNER JOIN
                         tPunchDate ON tReportWeek.nWeekID = tPunchDate.nWeekID LEFT OUTER JOIN
                         tReportWeekReview ON tReportWeek.nWeekID = tReportWeekReview.intReportWeekID
						 
)





GO
