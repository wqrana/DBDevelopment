USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_ChristmasBonus2017_Dates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Employees AFTER 2017.  Uses PUNCHDATE HOURS
-- =============================================

CREATE FUNCTION [dbo].[fnPay_ChristmasBonus2017_Dates]
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

	--Hours Worked between both date
	select @decHoursWorked =  isnull(sum(dblhours),0)  from tPunchDateDetail  pdd
	inner join [dbo].[tblChristmasBonusTransactions] cb ON pdd.sType = cb.strTransName AND cb.strCompanyName = @CompanyName
	where e_id = @UserID
	and pdd.DTPunchDate between @StartDate and @EndDate 

			-- Get Gross Pay
			select @decGrossPay= round( sum(decPay),2) from viewPay_UserBatchCompensations ubc 
			inner join tblCompensationItems ci on ubc.strCompensationName = ci.strCompensationName
			where intUserID = @UserID and dtPayDate BETWEEN @StartDate AND @EndDate  
			and ci.intCompensationType =1
			AND ubc.strCompanyName = @CompanyName
			if @decGrossPay is null  set	@decGrossPay = 0


IF @decHoursWorked >= 1350 --Bonus applies
	BEGIN
		--Check how long the employee has worked.  If less than a year, Bonus is half
		DECLARE @DaysWorked int
		SELECT @DaysWorked =  DATEDIFF(DAY, dOriginalHiredDate, @EndDate) FROM tUserExtended where nUserID = @UserID
		if @DaysWorked IS NULL SET @DaysWorked = 0

		IF @DaysWorked < 365  --LESS THAN A YEAR
			BEGIN
				DECLARE @UserAge int --Used for limits
				SELECT @UserAge =  DATEDIFF(DAY, dBirthDate, @EndDate) FROM tUserExtended where nUserID = @UserID
				if @UserAge IS NULL SET @UserAge = 0
				--Percentage is 1/2 of 2%
				SET @decBonusPercent = .01
				SET @decBonusAmount = @decGrossPay * @decBonusPercent
				--Check Limits
				IF @UserAge <= 20 * 365 --Less than or equal to 20
					BEGIN
					if @decBonusAmount > 150 SET @decBonusAmount = 150
					END
				ELSE --Greater than 21
					BEGIN
						if @decBonusAmount > 300 SET @decBonusAmount = 300
					END
			END
		ELSE --MORE THAN ONE YEAR
			BEGIN
			--Bonus is 2% but max depends on company size
			SET @decBonusPercent  = .02
			--Get bonus pay 
			SET @decBonusAmount = @decGrossPay * @decBonusPercent
			
			--Limit bonus according to company size
			IF @CompanySize <= 20
				BEGIN
					IF @decBonusAmount > 300	SET @decBonusAmount = 300
				END
			ELSE
				BEGIN
				IF @decBonusAmount > 600	SET @decBonusAmount = 600
			END

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
