USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewAtt_TardinessLetters]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewAtt_TardinessLetters]
AS
SELECT        tTardinessLetters.nUserID, tTardinessLetters.sName, tTardinessLetters.nCompanyID, tTardinessLetters.sCompanyName, tTardinessLetters.nDeptID, tTardinessLetters.sDeptName, 
                         tTardinessLetters.nJobTitleID, tTardinessLetters.sJobTitleName, tTardinessLetters.nEmployeeTypeID, tTardinessLetters.sEmployeeTypeName, tTardinessLetters.nEvaluationLevel, 
                         tTardinessLetters.sEvaluationLevelDesc, tTardinessLetters.sActionTaken, tTardinessLetters.dStartDateEvaluation, tTardinessLetters.dEndDateEvaluation, tTardinessLetters.dEmploymentDate, 
                         tTardinessLetters.nSupervisorID, tTardinessLetters.sSupervisorName, tTardinessLetters.sEmployeeComments, tTardinessLetters.sSupervisorComments, tTardinessLetters.dWarningIssueDate, 
                         tTardinessLetters.dWarningReviewedDate, tTardinessLetters.nWarningStatus, tTardinessLetters.nWarningType, tTardinessLetters.sWarningType, tTardinessLetters.dblWarningTime, 
                         tTardinessLetters.nWarningLetterID, tTardinessLetters.dStartDateSuspension, tTardinessLetters.dEndDateSuspension, tTardinessLetters.dTerminationDate, tTardinessLetters.nTardinessRulesID, 
                         tTardinessTransactions.DTPunchDate, tTardinessTransactions.sType, tTardinessTransactions.pCode, tTardinessTransactions.HoursWorked, tTardinessTransactions.nTardinessRevLetter, 
                          tTardinessTransactions.nProcessedCode
FROM            tTardinessLetters left outer JOIN
                         tTardinessTransactions ON tTardinessLetters.nWarningLetterID = tTardinessTransactions.nWarningLetterID AND tTardinessLetters.nUserID = tTardinessTransactions.e_id
GO
