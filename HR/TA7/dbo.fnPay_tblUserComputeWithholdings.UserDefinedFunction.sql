USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblUserComputeWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera
-- Create date: 11/5/2016
-- Description:	Computes the a withholding rule for a complete batch
-- Modified: 10/2/2018
--			Fixed so that it takes into account the maximum for 401K and others.
--			Uses functions that take into account Payroll Company
-- 8/6/2020:	Added FICA SS Covid Exemption
--01/17/2022:	Added to handle FICA SS overage on duplicate Pay Date.  The payrolls CANNOT be re-opened or must all be recomputed.
-- =============================================

CREATE  FUNCTION [dbo].[fnPay_tblUserComputeWithholdings]
(	
	@BatchID nvarchar(50),
	@IntUserID int,
	@strWithHoldingsName nvarchar(50)
)
RETURNS  @tblUserWithholdingsItems TABLE
(
	strBatchID nvarchar(50),
	IntUserID int,
	strWithHoldingsName nvarchar(50),
	decBatchEffectivePay decimal(18,2),
	decBatchEmployeeWithholding decimal(18,2),
	decBatchCompanyWithholding decimal(18,2),
	decFICASSEffectivePay decimal(18,2)
)
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE	@intPrePostTaxDeduction int
	DECLARE	@intComputationType int
	DECLARE	@decEmployeePercent decimal(18,5)
	DECLARE	@decEmployeeAmount decimal(18,5)
	DECLARE	@decCompanyPercent decimal(18,5)
	DECLARE	@decCompanyAmount decimal(18,5)
	DECLARE	@decMaximumSalaryLimit decimal(18,5)
	DECLARE	@decMinimumSalaryLimit as decimal(18,5)
	DECLARE @CompanyName nvarchar(50)

	--For limits processing
	DECLARE @PayDate as datetime
	DECLARE @PeriodStartDate as datetime
	DECLARE @YTDStartOfPeriodSalary decimal(18,5)
	DECLARE @PeriodEndDate as datetime
	DECLARE @YTDEndOfPeriodSalary decimal(18,5)
	DECLARE @401KPlan bit

	--Return Values
	DECLARE @BatchComputationPay as decimal(18,5)
	DECLARE @FICASSContributionPay as decimal(18,5) --Excludes all COVID transactions
	DECLARE @BatchEmployeeWithholding as decimal(18,5)
	DECLARE @BatchCompanyWithholding as decimal(18,5)
	DECLARE @COMPUTE_VALUE int
	--Initialize values
	SET @BatchComputationPay = 0
	SET @BatchEmployeeWithholding = 0
	SET @BatchCompanyWithholding = 0
	SET @COMPUTE_VALUE = 1

	--Get the parameters for processing
	select @intPrePostTaxDeduction =intPrePostTaxDeduction, @intComputationType = intComputationType, @decEmployeePercent =decEmployeePercent, 
	@decEmployeeAmount =decEmployeeAmount, @decCompanyPercent =decCompanyPercent, @decCompanyAmount = decCompanyAmount, @decMaximumSalaryLimit = decMaximumSalaryLimit, 
	@decMinimumSalaryLimit =decMinimumSalaryLimit, @401KPlan = boolApply401kPlan, @CompanyName = strCompanyName
	from viewPay_UserWithholdingItems
	where intUserID = @IntUserID and strWithHoldingsName = @strWithHoldingsName and boolDeleted = 0

	--Get the batch end date for computation purposes
	SELECT @PeriodStartDate = dtStartDatePeriod, @PeriodEndDate = dtEndDatePeriod from tblUserBatch where strBatchID = @BatchID and intUserID = @IntUserID
	SELECT @PayDate  = dtPayDate from tblBatch where strBatchID = @BatchID

	IF (not @intComputationType is null) AND (not @PeriodEndDate IS NULL)
		--computation type enables non-configurable settings
		BEGIN
		if @intComputationType >= 0 --Standard Computation

		if @intPrePostTaxDeduction = 0 -- Gross pay computation
			select @BatchComputationPay = [dbo].[fnPay_BatchTaxablePay](@batchid,@IntUserID)
		else --Net Pay computation.  MUST happen after all gross pay computations!
			select @BatchComputationPay = [dbo].[fnPay_BatchNetPay](@batchid,@IntUserID)
		
		if @BatchComputationPay is null set	@BatchComputationPay = 0

		set @FICASSContributionPay = 0
		--Covid Pay
		IF @strWithHoldingsName = 'FICA SS' 
		BEGIN
			select @FICASSContributionPay= isnull(sum(decPay),0) from tblUserBatchCompensations ubc
			inner join tblUserCompensationItems uc on ubc.intUserID = uc.intUserID and ubc.strCompensationName = uc.strCompensationName
			inner join tblCompensationItems ci on uc.strCompensationName = ci.strCompensationName
			where ubc.strBatchID = @BatchID and ubc.intUserID = @IntUserID and uc.intCompensationType = 1   and ubc.boolDeleted = 0
			and ci.[boolFICASSCCExempt] = 0
			group by strBatchID, ubc.intUserID

			IF @FICASSContributionPay is null set @FICASSContributionPay = 0
		END
		--Check for any excluded compensations income for this withholding
		DECLARE @ExcludedIncome as decimal(18,2)
		SELECT @ExcludedIncome = sum(decPay) FROM tblUserBatchCompensations where strCompensationName IN (select strCompensationNameExcluded FROM [tblWithholdingsCompensationExclusions] where strWithHoldingsName = @strWithHoldingsName)
		AND intUserID = @IntUserID AND boolDeleted = 0 AND strBatchID =  @BatchID  GROUP BY intUserID 
		if @ExcludedIncome is null SET @ExcludedIncome = 0
		
		--Excluded Incomes		
		SET @BatchComputationPay = @BatchComputationPay - @ExcludedIncome	
		SET @FICASSContributionPay = @FICASSContributionPay - @ExcludedIncome	
		--Eliminate negatives
		IF @BatchComputationPay < 0 SET @BatchComputationPay = 0
		IF @FICASSContributionPay < 0 SET @FICASSContributionPay = 0

		--Something to Compute
		if @BatchComputationPay > 0
			BEGIN
			--!!!!!!!!!!!!!!  COMPLETE  !!!!!!!!!!!!!
			--Check yearly maximum limit
			if @decMaximumSalaryLimit > 0
				BEGIN
				--Process only the amount below the limit,  Use Pay Dates since payperiods overlap PayDates
				SET @YTDEndOfPeriodSalary  = [dbo].[fnPay_YearToDateUserSalaryEarnings](@IntUserID, @PayDate,@CompanyName )
					--If the salary, including the period, exceeds the maximum, then check if there is a partial amount that applies
					if @YTDEndOfPeriodSalary  > @decMaximumSalaryLimit
					BEGIN
					IF @strWithHoldingsName = 'FICA SS' 
						SET @YTDStartOfPeriodSalary  = @YTDEndOfPeriodSalary - @FICASSContributionPay
					ELSE
						SET @YTDStartOfPeriodSalary  = @YTDEndOfPeriodSalary - @BatchComputationPay
					--[dbo].[fnPay_YearToDateUserSalaryEarnings](@IntUserID,DATEADD( d,-1,@PayDate),@CompanyName)
					
					IF  @YTDStartOfPeriodSalary  < @decMaximumSalaryLimit
						BEGIN
						DECLARE @LimitPay as  decimal(18,5)

							--Do only the portion until the limit is reached since sometimes more than one payroll open and affects computation
							SET @LimitPay = @decMaximumSalaryLimit - @YTDStartOfPeriodSalary
								if @LimitPay < @BatchComputationPay
								BEGIN
									SET @BatchComputationPay = @LimitPay
									SET @FICASSContributionPay = @LimitPay
								END
							  
						END
					ELSE
						BEGIN
							--Do not compute, the maximum has been passed
							SET @COMPUTE_VALUE = 0
						END			
					END
				END

			--!!!!!!!!!!!!!!  COMPLETE  !!!!!!!!!!!!!
			--Check yearly minimum limit
			if @decMinimumSalaryLimit > 0
				BEGIN
					--Process only the amount abovew the limit
					SET @YTDEndOfPeriodSalary  = [dbo].[fnPay_YearToDateUserSalaryEarnings](@IntUserID,@PayDate,@CompanyName)
					if @YTDEndOfPeriodSalary  > @decMinimumSalaryLimit
					BEGIN
					
						SET @YTDStartOfPeriodSalary  = [dbo].[fnPay_YearToDateUserSalaryEarnings](@IntUserID,dateadd(DAY,-1, @PayDate),@CompanyName)		
						IF  @YTDStartOfPeriodSalary  < @decMinimumSalaryLimit 
							--ONLY Part of this period applies for withholding
							BEGIN
							--Do only the portion after the limit is reached
							SET @BatchComputationPay = @YTDEndOfPeriodSalary - @decMinimumSalaryLimit  
							END
						END					
					ELSE
					BEGIN
						--Do not compute, the minimum has not been reached
						SET @COMPUTE_VALUE = 0
					END
				END
			if @COMPUTE_VALUE = 1
				BEGIN
				--Employee Percent Computation
				if @decEmployeePercent > 0
					set @BatchEmployeeWithholding = @BatchComputationPay * @decEmployeePercent / 100
				--Company Percent Computation
				if @decCompanyPercent > 0
					set @BatchCompanyWithholding = @BatchComputationPay * @decCompanyPercent / 100
					IF @strWithHoldingsName = 'FICA SS' 
						set @BatchCompanyWithholding = @FICASSContributionPay * @decCompanyPercent / 100
				--Employee Amount Computation
				if @decEmployeeAmount > 0
					set @BatchEmployeeWithholding = @BatchEmployeeWithholding + @decEmployeeAmount
				--Company Money Amount
				if @decCompanyAmount > 0
					set @BatchCompanyWithholding = @BatchCompanyWithholding + @decCompanyAmount
				END

				--If this is a 401k Plan, check that the Employee limit has not ben passed.
				BEGIN
					DECLARE @EE401KYTD decimal(18,5)
					DECLARE @EEMaxYearlyAmount decimal(18,5)
					DECLARE @ER401KYTD decimal(18,5)
					DECLARE @ERMaxYearlyAmount decimal(18,5)

					select @EE401KYTD = -[dbo].[fnPay_YearToDateUserBatchWithholdings]( @IntUserID, @strWithHoldingsName,@PayDate,@CompanyName ),
						@ER401KYTD =-[dbo].[fnPay_YearToDateCompanyBatchWithholdings]( @IntUserID, @strWithHoldingsName,@PayDate,@CompanyName ),
					 @EEMaxYearlyAmount= decEEMaxYearlyAmount, @ERMaxYearlyAmount = decERMaxYearlyAmount FROM tblWithholdings401K where strWithholdingName = @strWithHoldingsName
					
					--Check for nulls (not in table)					
					if @EEMaxYearlyAmount is null set @EEMaxYearlyAmount = 0
					if @ERMaxYearlyAmount is null set @ERMaxYearlyAmount = 0

					--Check Employee Yearly Amount					
					if @EEMaxYearlyAmount <> 0 
					BEGIN
						if  @EE401KYTD < @EEMaxYearlyAmount --Has not reached limit yet
							BEGIN
								if @EE401KYTD + @BatchEmployeeWithholding > @EEMaxYearlyAmount 
									SET @BatchEmployeeWithholding = (@EEMaxYearlyAmount - @EE401KYTD)  --Last Entry!
							END
						ELSE
							BEGIN
								SET @BatchEmployeeWithholding = 0
							END
						END
					END
					
					--Check Employer Yearly Amount					
					if @ERMaxYearlyAmount <> 0 
					BEGIN
						if  @ER401KYTD < @ERMaxYearlyAmount --Has not reached limit yet
							BEGIN
								if @ER401KYTD + @BatchCompanyWithholding > @ERMaxYearlyAmount 
									SET @BatchCompanyWithholding= (@ERMaxYearlyAmount - @ER401KYTD)  --Last Entry!
							END
						ELSE
							BEGIN
								SET @BatchCompanyWithholding= 0
							END
						END
					END

				END
			
		

	--  WHAT HAPPENS IF THERE IS NO ENABLED RULE
	if @BatchEmployeeWithholding is null SET @BatchEmployeeWithholding = 0
	if @BatchCompanyWithholding is null set @BatchCompanyWithholding = 0

	insert  @tblUserWithholdingsItems
	SELECT @BatchID, @IntUserID,@strWithHoldingsName,@BatchComputationPay SALARY,-@BatchEmployeeWithholding WH,-@BatchCompanyWithholding CC, @FICASSContributionPay FICASS
	RETURN
END

GO
