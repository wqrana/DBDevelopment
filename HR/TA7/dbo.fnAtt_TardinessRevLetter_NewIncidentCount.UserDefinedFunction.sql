USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnAtt_TardinessRevLetter_NewIncidentCount]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnAtt_TardinessRevLetter_NewIncidentCount] 
(	
@STARTDATE AS smalldatetime,
@ENDDATE as smalldatetime,
@USERID AS int,
@POLICYCOUNT AS INT
)
RETURNS TABLE 
AS
RETURN 
(
SELECT Tdd.e_id AS nUserID , @STARTDATE as dStartDate, @ENDDATE as dEndDate, COUNT(Tdd.e_id) AS nIncidentCount FROM tTardinessTransactions  AS tdd INNER JOIN tuser AS u 
ON tdd.e_id = U.id INNER JOIN tUserAttendanceRules ON U.id = tUserAttendanceRules.nUserID 
WHERE        (Tdd.nTardinessRevLetter = 1) AND (tdd.nWarningLetterID = 0) AND (Tdd.DTPunchDate BETWEEN @STARTDATE AND @ENDDATE) 
GROUP BY Tdd.e_id, tUserAttendanceRules.nTardinessRulesID 
HAVING      (Tdd.e_id= @USERID OR @USERID = 0 ) AND (COUNT(Tdd.e_id) >= @POLICYCOUNT ) 

)
GO
