USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_ChristmasBonus2017]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Hours
-- =============================================

CREATE FUNCTION [dbo].[fnPay_ChristmasBonus2017]
(
	@UserID int,
	@CompanySize int,
	@BonusYear int
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
	DECLARE		@decHoursWorked decimal(18,2)
	DECLARE		@decGrossPay decimal(18,2)
	DECLARE		@decBonusPercent decimal(18,2)
	DECLARE		@decBonusAmount decimal(18,2)
	DECLARE @StartDate as date = '10/1/2016'
	DECLARE @EndDate as date = '9/30/2017'
	--Hours Worked
	select @decHoursWorked = sum(dblHours) from tPunchDateDetail pdd inner join [dbo].[tblChristmasBonusTransactions] cb ON pdd.sType = cb.strTransName 
	inner join tblUserCompanyPayroll ucp on pdd.e_id =  ucp.intUserID and cb.strCompanyName = ucp.strCompanyName
	where e_id = @UserID
	GROUP by e_id
	if @decHoursWorked is null  set	@decHoursWorked = 0

	-- Get Gross Pay
	select @decGrossPay= round( sum(decPay),2) from viewPay_UserBatchCompensations ubc where intUserID = @UserID and dtPayDate BETWEEN @StartDate AND @EndDate  
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
				IF @decBonusAmount > 300	SET @decBonusAmount = 300
			ELSE
				IF @decBonusAmount > 600	SET @decBonusAmount = 600

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
