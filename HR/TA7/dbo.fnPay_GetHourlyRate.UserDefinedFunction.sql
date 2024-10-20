USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_GetHourlyRate]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		2016-03-17
-- Description:		Gets the equivalent hourly rate from the Hourly/Salary,Rate,Hours settings
--	Note:			The rate depends on whether the entryn is Hourly or Salary
--					Returns 0 if not error
-- =============================================
CREATE FUNCTION [dbo].[fnPay_GetHourlyRate]
(
	@UserID as int,
	@dtEffectiveDate as datetime
)
RETURNS decimal (18,5) 
-- WITH ENCRYPTION
AS
BEGIN
	
	DECLARE @HourlyPayRate AS DECIMAL(18,5)
	SELECT 
		@HourlyPayRate = 
			CASE tblUPR.intHourlyOrSalary
				WHEN 0 THEN 
					tblUPR.decPayRate
				ELSE
					tblUPR.decPayRate / tblUPR.decHoursPerPeriod
			END
	FROM 
		(
			SELECT 
				tUPR.intUserID, 
				tUPR.dtStartDate, 
				tUPR.intHourlyOrSalary,
				tupr.decHoursPerPeriod,
				tUPR.decPayRate, 
				ROW_NUMBER() OVER(PARTITION BY tUPR.intUserID 
									ORDER BY tUPR.dtStartDate DESC) AS rk
			FROM 
				tblUserPayRates AS tUPR
			WHERE 
				dtStartDate <= @dtEffectiveDate
				AND tUPR.intUserID = @UserID
		)  AS tblUPR
	WHERE 
		tblUPR.rk = 1

	IF @HourlyPayRate is null
		SET @HourlyPayRate = 0

	RETURN @HourlyPayRate 
END


GO
