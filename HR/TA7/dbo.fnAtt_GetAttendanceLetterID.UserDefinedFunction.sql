USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnAtt_GetAttendanceLetterID]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnAtt_GetAttendanceLetterID]
(
	-- Add the parameters for the function here
@StartDate as smalldatetime,
@EndDate as smalldatetime
)
RETURNS bigint
AS
BEGIN
--return computed value
	DECLARE @LetterID int
	SELECT @LetterID= CONVERT(VARCHAR(6), @EndDate, 12) 
	return @letterID
END
GO
