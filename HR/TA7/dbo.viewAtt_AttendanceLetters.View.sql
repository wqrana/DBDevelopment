USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewAtt_AttendanceLetters]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewAtt_AttendanceLetters]
AS
SELECT        tAttendanceLetters.nUserID, tAttendanceLetters.sName, tAttendanceLetters.nCompanyID, tAttendanceLetters.sCompanyName, tAttendanceLetters.nDeptID, tAttendanceLetters.sDeptName, 
                         tAttendanceLetters.nJobTitleID, tAttendanceLetters.sJobTitleName, tAttendanceLetters.nEmployeeTypeID, tAttendanceLetters.sEmployeeTypeName, tAttendanceLetters.nEvaluationLevel, 
                         tAttendanceLetters.sEvaluationLevelDesc, tAttendanceLetters.sActionTaken, tAttendanceLetters.dStartDateEvaluation, tAttendanceLetters.dEndDateEvaluation, tAttendanceLetters.dEmploymentDate, 
                         tAttendanceLetters.nSupervisorID, tAttendanceLetters.sSupervisorName, tAttendanceLetters.sEmployeeComments, tAttendanceLetters.sSupervisorComments, tAttendanceLetters.dWarningIssueDate, 
                         tAttendanceLetters.dWarningReviewedDate, tAttendanceLetters.nWarningStatus, tAttendanceLetters.nWarningType, tAttendanceLetters.sWarningType, tAttendanceLetters.dblWarningTime, 
                         tAttendanceLetters.nWarningLetterID, tAttendanceLetters.dStartDateSuspension, tAttendanceLetters.dEndDateSuspension, tAttendanceLetters.dTerminationDate, tAttendanceLetters.nAttendanceRulesID, 
                         tAttendanceTransactions.DTPunchDate, tAttendanceTransactions.sType, tAttendanceTransactions.pCode, tAttendanceTransactions.HoursWorked, tAttendanceTransactions.nAttendanceRevLetter, 
                          tAttendanceTransactions.nProcessedCode
FROM            tAttendanceLetters left outer JOIN
                         tAttendanceTransactions ON tAttendanceLetters.nWarningLetterID = tAttendanceTransactions.nWarningLetterID AND tAttendanceLetters.nUserID = tAttendanceTransactions.e_id
GO
