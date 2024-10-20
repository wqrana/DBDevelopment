USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spAtt_DeleteTardinessPeriod]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAtt_DeleteTardinessPeriod]
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
	--Delete the period from tTardinessLetterComputation
	delete from tTardinessLetterComputation  where nWarningLetterID = @LETTERCODE and nTardinessRuleID = @RULEID
	END

	--Delete the letter or letters
	delete from tTardinessLetters where nWarningLetterID = @LETTERCODE and nTardinessRulesID = @RULEID AND (nUserID = @USERID OR @USERID = 0)

	-- Delete all the Tardiness transactions that imported with the Tardiness letter (nProcessedCode)
	delete from tTardinessTransactions from tTardinessTransactions AL inner join viewAtt_UserTardiness VU ON AL.e_id = VU.id
	and vu.nTardinessRulesID = @RULEID AND AL.nProcessedCode = @LETTERCODE AND (e_id= @USERID OR @USERID=0)
            
	-- Mark the previous transactions as unprocessed (nTardinessLetterCode)
	update tPunchDateDetail set  [nTardinessLetterCode] = 0   
		FROM tPunchDateDetail AS pdd INNER JOIN viewAtt_UserTardiness AS vu ON pdd.e_id = vu.id 
		INNER JOIN tTransDef td ON pdd.sType = td.Name 
		WHERE vu.nTardinessRulesID = @RULEID AND nTardinessLetterCode = @LETTERCODE
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
GO
