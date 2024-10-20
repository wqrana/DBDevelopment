USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_ChristmasBonusPre2017]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Hours
-- =============================================

CREATE FUNCTION [dbo].[fnPay_ChristmasBonusPre2017]
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

IF @decHoursWorked >= 700 --Bonus applies
	BEGIN
		if @CompanySize <= 15
			SET @decBonusPercent = .03
		else
			SET @decBonusPercent = .06
		--Get bonus pay 
		IF @decGrossPay >= 10000 --Max Amount
			SET @decBonusAmount = @decBonusPercent * 10000  --300 or 600 depending on company size
		ELSE
			SET @decBonusAmount = @decGrossPay * @decBonusPercent
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
