USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnAtt_CreateAttendanceRevLetter]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  FUNCTION [dbo].[fnAtt_CreateAttendanceRevLetter] 
(	
@USERID AS int,
@STARTDATE AS smalldatetime,
@ENDDATE as smalldatetime,
@Incidences AS float,
@LETTERID AS int
)
RETURNS TABLE 
AS
RETURN 
(
select id as nUserID,name as sName, nCompanyID, sCompanyName, nDeptID, sDeptName, nJobTitleID, sJobTitleName, nEmployeeType as  nEmployeeTypeID, sEmployeeTypeName, 
dbo.fnAtt_GetNextAttendanceLetterLevel(@USERID,@STARTDATE,@ENDDATE) as nEvaluationLevel, '' as sEvaluationLevelDesc,@Incidences as dblWarningTime,  '' as sActionTaken, @STARTDATE as  dStartDateEvaluation,@ENDDATE as  dEndDateEvaluation, null as dEmploymentDate, 
0 as nSupervisorID, '' as sSupervisorName, '' as sEmployeeComments, '' as sSupervisorComments, getdate() as dWarningIssueDate, null as dWarningReviewedDate, 
0 as nWarningStatus, 0 as nWarningType, '' as  sWarningType, @LETTERID as nWarningLetterID, null as dStartDateSuspension, null as dEndDateSuspension, null as dTerminationDate, nAttendanceRulesID
 FROM [dbo].[viewAtt_UserAttendance] where id = @USERID

  )
GO
