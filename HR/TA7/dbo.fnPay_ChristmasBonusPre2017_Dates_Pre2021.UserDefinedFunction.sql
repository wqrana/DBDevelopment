USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_ChristmasBonusPre2017_Dates_Pre2021]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnPay_ChristmasBonusPre2017_Dates_Pre2021]
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
			DECLARE		@decHoursWorked decimal(18,2)
			DECLARE		@decGrossPay decimal(18,2)
			DECLARE		@decBonusPercent decimal(18,2)
			DECLARE		@decBonusAmount decimal(18,2)
			--Hours Worked
			--ART CHANGED FOR MULTICOMPANY 
			select @decHoursWorked = sum(dblHours) from tblPunchDateDetail pdd inner join viewPay_UserBatchStatus ubs ON pdd.strBatchID = ubs.strBatchID  AND pdd.e_id = ubs.intUserID
			inner join [dbo].[tblChristmasBonusTransactions] cb ON pdd.sType = cb.strTransName and cb.strCompanyName = ubs.strCompanyName
			inner join tTransDef td on cb.strTransName = td.Name
			where e_id = @UserID
			-- START OF CODE ADDED BY YMB 17-oct-2017
			and pdd.DTPunchDate between @StartDate and @EndDate 
			--ART Multicompany
			and ubs.strCompanyName = @CompanyName
			and td.nIsMoneyTrans = 0
			-- END OF CODE ADDED BY YMB 17-oct-2017
			GROUP by e_id
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
