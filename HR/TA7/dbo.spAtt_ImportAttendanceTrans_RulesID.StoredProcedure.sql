USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spAtt_ImportAttendanceTrans_RulesID]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAtt_ImportAttendanceTrans_RulesID]
	-- Add the parameters for the stored procedure here
	@STARTDATE AS smalldatetime,
	@ENDDATE as smalldatetime,
	@RULEID AS int,
	@LETTERCODE as int,
	@RECORD_COUNT int OUTPUT
AS
BEGIN
DECLARE @ERROR1 as int   

BEGIN TRY
BEGIN TRANSACTION 

-- Import current transactions
INSERT INTO tAttendanceTransactions (e_id, e_name, DTPunchDate, sType, pCode, HoursWorked, nWeekID, nProcessedCode, nAttendanceRevLetter, nWarningLetterID)
SELECT     pdd.e_id, vu.name AS e_name, pdd.DTPunchDate as DTPunchDate, pdd.sType as sType, pdd.sExportCode AS pCode, pdd.dblHours AS HoursWorked, pdd.nWeekID as nWeekID,  
			@LETTERCODE AS nProcessedCode,  tTransDef.nAttendanceRevLetter as nAttendanceRevLetter ,0 as  nWarningLetterID
             FROM tPunchDateDetail AS pdd INNER JOIN viewAtt_UserAttendance AS vu ON pdd.e_id = vu.id INNER JOIN
             tPunchDate AS pdt ON pdd.e_id = pdt.e_id AND pdd.DTPunchDate = pdt.DTPunchDate INNER JOIN
             tTransDef ON pdd.sType = tTransDef.Name 
             WHERE vu.nAttendanceRulesID = @RULEID AND pdd.dtPunchDate between @STARTDATE AND @ENDDATE
			AND tTransDef.nAttendanceRevLetter = 1 AND PDD.nHRProcessedCode = 0

--	Mark the previous transactions as Processed
update tPunchDateDetail set nHRProcessedCode  = @LETTERCODE 
		FROM tPunchDateDetail AS pdd INNER JOIN viewAtt_UserAttendance AS vu ON pdd.e_id = vu.id 
		INNER JOIN tTransDef td ON pdd.sType = td.Name 
        WHERE vu.nAttendanceRulesID = @RULEID AND pdd.dtPunchDate between @STARTDATE AND @ENDDATE
		AND td.nAttendanceRevLetter= 1 AND PDD.nHRProcessedCode = 0

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
