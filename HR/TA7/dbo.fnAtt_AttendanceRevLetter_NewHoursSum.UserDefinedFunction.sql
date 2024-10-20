USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnAtt_AttendanceRevLetter_NewHoursSum]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnAtt_AttendanceRevLetter_NewHoursSum] 
(	
@STARTDATE AS smalldatetime,
@ENDDATE as smalldatetime,
@USERID AS int,
@POLICYHOURS AS float
)
RETURNS TABLE 
AS
RETURN 
(
SELECT Tdd.e_id AS nUserID , @STARTDATE as dStartDate, @ENDDATE as dEndDate, sum(Tdd.HoursWorked) AS dblHours FROM tAttendanceTransactions  AS tdd INNER JOIN tuser AS u 
ON tdd.e_id = U.id INNER JOIN tUserAttendanceRules ON U.id = tUserAttendanceRules.nUserID 
WHERE        (Tdd.nAttendanceRevLetter = 1) AND (tdd.nWarningLetterID = 0) AND (Tdd.DTPunchDate BETWEEN @STARTDATE AND @ENDDATE) 
GROUP BY Tdd.e_id, tUserAttendanceRules.nAttendanceRulesID 
HAVING      (Tdd.e_id= @USERID OR @USERID = 0 ) AND (sum(Tdd.HoursWorked) >= @POLICYHOURS ) 
)
GO
