USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[LockPRDates]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LockPRDates]
@nPayrollRuleID as int,
@StartDate as datetime,
@EndDate as datetime,
@bLock as bit
AS
DECLARE @ERROR1 as int
DECLARE @ERROR2 as int

BEGIN TRAN 

UPDATE tPunchDate SET tPunchDate.bLocked = @bLock 
WHERE (nEmployeeTypeID = @nPayrollRuleID) AND (tPunchDate.DTPunchDate BETWEEN @StartDate and @EndDate)

SET @ERROR2 =@@ERROR

IF @ERROR2 !=0
BEGIN
	ROLLBACK TRAN 
END
ELSE
BEGIN
	COMMIT TRAN 
END
GO
