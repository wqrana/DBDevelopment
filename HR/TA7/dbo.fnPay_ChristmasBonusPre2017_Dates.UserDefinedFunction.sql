USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_ChristmasBonusPre2017_Dates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
--DROP FUNCTION [dbo].[fnPay_ChristmasBonusPre2017_Dates]
--GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Employees before 2017.  Uses PUNCHDATE HOURS
-- =============================================

CREATE FUNCTION [dbo].[fnPay_ChristmasBonusPre2017_Dates]
(
	@UserID int,
	@CompanySize int,
	@StartDate date,
	@EndDate  date,
	@CompanyName nvarchar(50)
)
RETURNS 
@tblUserChristmasBonusSummary TABLE 
(
	intUserID  int,
	decHoursWorked decimal(18,2),
	decGrossPay decimal(18,2),
	decBonusPercent decimal(18,5),
	decBonusAmount decimal(18,2)
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Declare the return variable here
	DECLARE		@decHoursHistory decimal(18,2)
	DECLARE		@decHoursWorked decimal(18,2)
	DECLARE		@decGrossPay decimal(18,2)
	DECLARE		@decBonusPercent decimal(18,2)
	DECLARE		@decBonusAmount decimal(18,2)
	--Hours between both dates
	select @decHoursWorked =  isnull(sum(dblhours),0)  from tPunchDateDetail  pdd
	inner join [dbo].[tblChristmasBonusTransactions] cb ON pdd.sType = cb.strTransName AND cb.strCompanyName = @CompanyName
	where e_id = @UserID
	and pdd.DTPunchDate between @StartDate and @EndDate 


	if @decHoursWorked is null  set	@decHoursWorked = 0
			-- Get Gross Pay
			select @decGrossPay= round( sum(decPay),2) from viewPay_UserBatchCompensations ubc 
			inner join tblCompensationItems ci on ubc.strCompensationName = ci.strCompensationName
			where intUserID = @UserID and dtPayDate BETWEEN @StartDate AND @EndDate  
			and ci.intCompensationType =1
			AND ubc.strCompanyName = @CompanyName
			if @decGrossPay is null  set	@decGrossPay = 0

IF @decHoursWorked >= 700 --Bonus applies
	BEGIN
		if @CompanySize <= 15
			BEGIN
				SET @decBonusPercent = .03
			END
		else
			BEGIN
				SET @decBonusPercent = .06
			END
		--Get bonus pay 
		IF @decGrossPay >= 10000 --Max Amount
			BEGIN
				SET @decBonusAmount = @decBonusPercent * 10000  --300 or 600 depending on company size
			END
		ELSE
			BEGIN
				SET @decBonusAmount = @decGrossPay * @decBonusPercent
			END
	END
ELSE
	BEGIN
	--Does not meet the requirements
			SET @decBonusPercent = 0
			SET @decBonusAmount = 0
	END

INSERT INTO @tblUserChristmasBonusSummary
SELECT @UserID, @decHoursWorked, @decGrossPay, @decBonusPercent, @decBonusAmount

RETURN
END

GO
