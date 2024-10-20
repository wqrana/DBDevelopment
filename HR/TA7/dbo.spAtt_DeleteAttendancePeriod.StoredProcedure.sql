USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spAtt_DeleteAttendancePeriod]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAtt_DeleteAttendancePeriod]
	-- Add the parameters for the stored procedure here
	@RULEID AS int,
	@USERID AS int,
	@LETTERCODE as int,
	@RECORD_COUNT int OUTPUT
AS
BEGIN
DECLARE @ERROR1 as int   

BEGIN TRY
BEGIN TRANSACTION 
	
	if @USERID = 0 --Delete the whole period
	BEGIN
	--Delete the period from tAttendanceLetterComputation
	delete from tAttendanceLetterComputation  where nWarningLetterID = @LETTERCODE and nAttendanceRuleID = @RULEID
	END

	--Delete the letter or letters
	delete from tAttendanceLetters where nWarningLetterID = @LETTERCODE and nAttendanceRulesID = @RULEID AND (nUserID = @USERID OR @USERID = 0)

	-- Delete all the attendance transactions that imported with the attendance letter (nProcessedCode)
	delete from tAttendanceTransactions from tAttendanceTransactions AL inner join viewAtt_UserAttendance VU ON AL.e_id = VU.id
	and vu.nAttendanceRulesID = @RULEID AND AL.nProcessedCode = @LETTERCODE AND (e_id= @USERID OR @USERID=0)
            
	-- Mark the previous transactions as unprocessed (nAttendanceLetterCode)
	update tPunchDateDetail set  [nAttendanceLetterCode] = 0   
		FROM tPunchDateDetail AS pdd INNER JOIN viewAtt_UserAttendance AS vu ON pdd.e_id = vu.id 
		INNER JOIN tTransDef td ON pdd.sType = td.Name 
		WHERE vu.nAttendanceRulesID = @RULEID AND nAttendanceLetterCode = @LETTERCODE
		AND (e_id= @USERID OR @USERID=0)


 set @RECORD_COUNT = @@ROWCOUNT

COMMIT 

END TRY

BEGIN CATCH
SET @RECORD_COUNT = 0
ROLLBACK 
END CATCH
RETURN
END


/****** Object:  StoredProcedure [dbo].[spAtt_DeleteTardinessLetter]    Script Date: 3/11/2016 4:20:20 PM ******/
SET ANSI_NULLS ON
GO
