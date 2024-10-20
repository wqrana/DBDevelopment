USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spAtt_DeleteAttendanceLetter]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAtt_DeleteAttendanceLetter]
	-- Add the parameters for the stored procedure here
	@USERID AS int,
	@LETTERID as int
AS
BEGIN
DECLARE @ERROR1 as int   
DECLARE @RECORD_COUNT as int

BEGIN TRY
BEGIN TRANSACTION 

-- Set the transactions as unmarked in tAttendanceTransactions
update tAttendanceTransactions set nWarningLetterID = 0 where e_id = @USERID and nWarningLetterID = @LETTERID

delete from tAttendanceLetters where nUserID = @USERID and nWarningLetterID = @LETTERID

set @RECORD_COUNT = @@ROWCOUNT

COMMIT 

END TRY

BEGIN CATCH
SET @RECORD_COUNT = 0
ROLLBACK 
END CATCH
RETURN @RECORD_COUNT 
END
GO
