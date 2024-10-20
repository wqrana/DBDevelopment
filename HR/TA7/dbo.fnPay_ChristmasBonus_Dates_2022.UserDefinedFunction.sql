USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_ChristmasBonus_Dates_2022]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_ChristmasBonus2017_Dates]    Script Date: 10/13/2022 3:41:57 PM ******/

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 10/13/2022
-- Description:	Employees AFTER 2017.  Uses PUNCHDATE HOURS
-- =============================================

CREATE FUNCTION [dbo].[fnPay_ChristmasBonus_Dates_2022]
(
	@PayrollCompany nvarchar(50),
	@UserID int,
	@StartDate date,
	@EndDate  date,
	@Pymes int,
	@Over20Employees bit 
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
		DECLARE		@decHoursHistory decimal(18,2) = 0
		DECLARE		@decHoursWorked decimal(18,2) = 0
		DECLARE		@decGrossPay decimal(18,2) = 0

		DECLARE		@decBonusPercent decimal(18,2) = 0
		DECLARE		@decBonusMax decimal(18,2) = 0
		DECLARE		@decBonusAmount decimal(18,2) = 0
	
		DECLARE		@decBonusMinHours decimal(18,2)
		--The number of hours minimum varies if company qualifies as PYMES
		IF @Pymes = 0
			SET @decBonusMinHours = 700
		else
			SET @decBonusMinHours = 900

		-- Get Gross Pay, Hourws from Transactions
		SELECT @decHoursWorked = sum(dblHours) 
		FROM 
		(select  rw.e_id, pdd.DTPunchDate, pdd.sType
		, pdd.dblHours,[dbo].[fnPay_UserTransaction_MoneyAmount](pdd.e_id, pdd.DTPunchDate,pdd.sType,pdd.dblHours) Pay
		from tPunchDateDetail PDD inner join tReportWeek RW on pdd.nWeekID = rw.nWeekID
		inner join tblCompanyPayrollRules cpr on rw.nPayRuleID = cpr.intPayrollRule
		where 
		pdd.e_id = @UserID AND
		pdd.DTPunchDate BETWEEN @StartDate AND @EndDate  
		and cpr.strPayrollCompany = @PayrollCompany
		and pdd.sType IN (select strTransName FROM tblChristmasBonusTransactions where strPayrollCompany = @PayrollCompany) 
		and pdd.e_id IN (select intUserID from viewPay_UserBatchStatus where dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany)
		) GrossPay
		GROUP BY e_id

			-- Get Gross Pay
			-- Get Gross Pay
			select @decGrossPay= round( sum(decPay),2) from tblUserBatchCompensations ub inner join tblBatch b on ub.strBatchID = b.strBatchID
			inner join tblCompensationItems ci on ub.strCompensationName = ci.strCompensationName
			where intUserID = @UserID and b.dtPayDate BETWEEN @StartDate AND @EndDate  
			and ci.intCompensationType =1
			AND b.strCompanyName = @PayrollCompany
			if @decGrossPay is null  set	@decGrossPay = 0



		IF exists (select * from sys.tables where name = 'tblChristmasBonusHistory')
		BEGIN
			--Bonus Hours Adjustment
			if @decHoursWorked is null  set	@decHoursWorked = 0
			if @decGrossPay is null  set	@decGrossPay = 0
			--Get Adjustment
			select @decHoursWorked  = @decHoursWorked   + isnull(SUM(decAdjustHours),0), @decGrossPay =  @decGrossPay + isnull(SUM([decAdjustSalary]),0) 
			FROM [dbo].[tblChristmasBonusHistory] 
			where  [dtAdjustDate] between @StartDate and @EndDate and [strCompanyName] = @PayrollCompany
			and intUserID = @UserID 
		END
		if @decHoursWorked is null  set	@decHoursWorked = 0
		

	IF @decHoursWorked >= @decBonusMinHours --Bonus applies
	BEGIN
		if @Over20Employees =1
			BEGIN
				SET @decBonusPercent = .03
				SET @decBonusMax = 600
			END
		else
			BEGIN
				SET @decBonusPercent = .03
				SET @decBonusMax = 300
			END
		--Get bonus pay 
			SET @decBonusAmount = @decBonusPercent * @decGrossPay --300 or 600 depending on company size
		
			IF @decBonusAmount > @decBonusMax
				SET @decBonusAmount = @decBonusMax
	END
	ELSE
		BEGIN
		--Does not meet the requirements
				SET @decBonusPercent = 0
				SET @decBonusAmount = 0
		END

	INSERT INTO @tblUserChristmasBonusSummary
	SELECT @UserID intUserID, @decHoursWorked HoursWorked, @decGrossPay GrossPay, @decBonusPercent BonusPercent, @decBonusAmount BonusAmount


RETURN
END

GO
