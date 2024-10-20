USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnAtt_Compute_AttendanceRule_IncidenceCount]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnAtt_Compute_AttendanceRule_IncidenceCount] 
(	
@STARTDATE AS smalldatetime,
@ENDDATE as smalldatetime,
@USERID AS int,
@RULEID AS int,
@INCIDENCE_COUNT AS INT
)
RETURNS TABLE 
AS
RETURN 
(
 select arl.nUserID, sName, nCompanyID, sCompanyName, nDeptID, sDeptName, nJobTitleID, sJobTitleName, nEmployeeTypeID, sEmployeeTypeName, nEvaluationLevel, sEvaluationLevelDesc, sActionTaken, dStartDateEvaluation, dEndDateEvaluation, dEmploymentDate, nSupervisorID, sSupervisorName, sEmployeeComments, sSupervisorComments, dWarningIssueDate, dWarningReviewedDate, nWarningStatus, nWarningType, sWarningType, dblWarningTime, nWarningLetterID, dStartDateSuspension, dEndDateSuspension, dTerminationDate, nAttendanceRulesID 
 FROM [dbo].[fnAtt_AttendanceRevLetter_NewIncidentCount] (@STARTDATE,@ENDDATE,@USERID,@INCIDENCE_COUNT)as arl 
 cross apply dbo.fnAtt_CreateAttendanceRevLetter(arl.nUserId,arl.dStartDate, arl.dEndDate, arl.nIncidentCount,[dbo].[fnAtt_GetAttendanceLetterID](arl.dstartdate, arl.denddate) ) 
 where nAttendanceRulesID = @RULEID
)
GO
