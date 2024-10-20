USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spAtt_CreateAttendanceLetters]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAtt_CreateAttendanceLetters]
	-- Add the parameters for the stored procedure here
	      @nUserID as  int
           ,@dStartDate as datetime
           ,@dEndDate as datetime
           ,@nAttendanceRulesID as int
		   ,@nResetTransactions as int
		   	,@TRANSACTION_COUNT int OUTPUT
		   	,@LETTER_COUNT int OUTPUT
AS
BEGIN

DECLARE @ERROR1 as int   


BEGIN TRY
BEGIN TRANSACTION 

--Get the WarningLetterID
declare @nWarningLetterID as bigint
set @nWarningLetterID =  dbo.fnAtt_GetAttendanceLetterID(@dStartDate,@dEndDate) 

--Import the data to tAttendanceTransactions
EXEC	[dbo].[spAtt_ResetandImportAttendanceTrans_RulesID]
		@STARTDATE = @dStartDate,
		@ENDDATE = @dEndDate,
		@RULEID = @nAttendanceRulesID,
		@USERID = @nUserID,
		@LETTERCODE = @nWarningLetterID,
		@RESET = @nResetTransactions,
		@RECORD_COUNT = @TRANSACTION_COUNT OUTPUT

--Get attendance Rule Parameters
DECLARE @nPolicyHours_Incidences as int
DECLARE @nPolicyType as int
SELECT @nPolicyHours_Incidences = dblPolicyHours_Incidences, @nPolicyType = nPolicyType from tAttendanceRules where id = @nAttendanceRulesID

if @nPolicyType = 0
BEGIN
--Insert New Incident_Count letters into tAttendanceLetters
insert into tAttendanceLetters (nUserID, sName, nCompanyID, sCompanyName, nDeptID, sDeptName, nJobTitleID, sJobTitleName, nEmployeeTypeID, sEmployeeTypeName, nEvaluationLevel, sEvaluationLevelDesc, sActionTaken, dStartDateEvaluation, dEndDateEvaluation, dEmploymentDate, nSupervisorID, sSupervisorName, sEmployeeComments, sSupervisorComments, dWarningIssueDate, dWarningReviewedDate, nWarningStatus, nWarningType, sWarningType, dblWarningTime, nWarningLetterID, dStartDateSuspension, dEndDateSuspension, dTerminationDate, nAttendanceRulesID)
SELECT * FROM [dbo].[fnAtt_Compute_AttendanceRule_IncidenceCount] ( @dStartDate,@dEndDate,@nUserID, @nAttendanceRulesID,@nPolicyHours_Incidences )
set @LETTER_COUNT = @@ROWCOUNT

END

if @nPolicyType = 1
BEGIN 
--Insert New Hours Sum letters into tAttendanceLetters
insert into tAttendanceLetters (nUserID, sName, nCompanyID, sCompanyName, nDeptID, sDeptName, nJobTitleID, sJobTitleName, nEmployeeTypeID, sEmployeeTypeName, nEvaluationLevel, sEvaluationLevelDesc, sActionTaken, dStartDateEvaluation, dEndDateEvaluation, dEmploymentDate, nSupervisorID, sSupervisorName, sEmployeeComments, sSupervisorComments, dWarningIssueDate, dWarningReviewedDate, nWarningStatus, nWarningType, sWarningType, dblWarningTime, nWarningLetterID, dStartDateSuspension, dEndDateSuspension, dTerminationDate, nAttendanceRulesID)
SELECT * FROM [dbo].[fnAtt_Compute_AttendanceRule_NewHoursSum]( @dStartDate,@dEndDate,@nUserID, @nAttendanceRulesID,@nPolicyHours_Incidences )
set @LETTER_COUNT = @@ROWCOUNT
END


--Mark the tAttendancetransactions that are in the new letters
update AT set at.nWarningLetterID =   al.nWarningLetterID
from tAttendanceTransactions AT cross apply 
(SELECT nWarningLetterID, nUserID,dStartDateEvaluation,dEndDateEvaluation FROM [dbo].[fnAtt_Compute_AttendanceRule_IncidenceCount] ( @dStartDate,@dEndDate,0, @nAttendanceRulesID,@nPolicyHours_Incidences)) as AL
where AT.e_id = al.nUserID and DTPunchDate between AL.dStartDateEvaluation and AL.dEndDateEvaluation and at.nWarningLetterID = 0 

COMMIT 
END TRY

BEGIN CATCH
ROLLBACK 
END CATCH

RETURN @LETTER_COUNT
END
GO
