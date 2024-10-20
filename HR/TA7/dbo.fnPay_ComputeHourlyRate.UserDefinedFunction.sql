USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_ComputeHourlyRate]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		2016-03-17
-- Description:		Gets the equivalent hourly rate from the Hourly/Salary,Rate,Hours settings
--	Note:			The rate depends on whether the entryn is Hourly or Salary and HoursPerPeriod in record
--					Returns 0 if not error
-- =============================================
CREATE FUNCTION [dbo].[fnPay_ComputeHourlyRate]
(
	@UserID as int,
	@intHourlyOrSalary  as int,
	@decPayRate as  decimal(18,5),
	@decHoursPerPeriod as decimal(18,5)
)
RETURNS decimal (18,5) 
-- WITH ENCRYPTION
AS
BEGIN
	declare @HourlyPayRate as decimal(18,5)
	IF @intHourlyOrSalary = 0 -- Hourly
		BEGIN 
			set @HourlyPayRate = @decPayRate
		END
	ELSE
		BEGIN --Hours per Period says how many hours should be expected in the period
			set @HourlyPayRate = @decPayRate / iif(@decHoursPerPeriod=0,1,@decHoursPerPeriod)
	END
	if @HourlyPayRate 	is null
		SET @HourlyPayRate = 0

	RETURN @HourlyPayRate 
END

GO
