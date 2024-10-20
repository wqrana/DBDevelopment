USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_ComputeHaciendaTable]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 9/28/2018
-- Description:	Computes the Employees retention values using the Hacienda Withholdings Table 
-- =============================================
CREATE PROCEDURE [dbo].[spPay_ComputeHaciendaTable]
	-- Add the parameters for the stored procedure here
	@BatchID nvarchar(50),
	@IntUserID int
AS
BEGIN
	DECLARE @intComputePerPayroll int
	select @intComputePerPayroll= coalesce(intComputePerPayroll,0)  FROM [dbo].[tblUserHaciendaOptions] where intUserID = @IntUserID

IF @intComputePerPayroll <> 0
BEGIN
	DECLARE @BatchComputationPay as decimal(18,5)
	DECLARE @ClaimedExceptionAndAllowances decimal(18,5)
	DECLARE @TablePay decimal(18,5)
	DECLARE @PAYPERIOD as int
	DECLARE @TaxWithholdingPercent decimal(18,5)
	DECLARE @TaxSubtractAmount decimal(18,5)
	DECLARE @PayDate as date
	DECLARE @PayrollCompany as nvarchar(50)
	--Birthday Computation
	DECLARE @as_of datetime
	DECLARE @bday datetime
	DECLARE @AgeAtEndOfyear as int
	
	--Allowances Computation
	DECLARE @decDeductionsAllowance decimal(18,5) = 0
	DECLARE @decAllowancesClaimed decimal(18,5) = 0
	--Initialize values
	SET @BatchComputationPay = 0

	--Get Paydate
	select @PayDate = dtPayDate,@PayrollCompany = strCompanyName from tblBatch where strBatchID = @BatchID

	--Get Age at the end of the year for 26 computation purposes
	SELECT  @as_of =  DATEADD (dd, -1, DATEADD(yy, DATEDIFF(yy, 0, @PayDate ) +1, 0)), @bday = dBirthDate from tUserExtended where nUserID = @IntUserID
	SET @AgeAtEndOfyear  = (0 + Convert(Char(8),@as_of,112) - Convert(Char(8),@bday,112)) / 10000 
	
	if @AgeAtEndOfyear is null
		SET @AgeAtEndOfyear = 27

	if @AgeAtEndOfyear > 26
		BEGIN
		--Get the batch end date for computation purposes
		select @BatchComputationPay = [dbo].[fnPay_BatchTaxablePay](@batchid,@IntUserID)

		if @BatchComputationPay is null set	@BatchComputationPay = 0
			if @BatchComputationPay>0
			BEGIN
				--Pay Period
				select top(1) @PAYPERIOD= intPayPeriod from tblUserPayRates where intUserID = @IntUserID order by dtStartDate desc


				--Get decAllowancesClaimed from 499R4 
				select top(1) @decAllowancesClaimed= decAllowancesClaimed  from tblUser499R4 u4  where u4.intUserID = @IntUserID and dtEntryDate <= @PayDate order by dtEntryDate desc
				--Get decDuctionsAllowances from tblAppendix1Exemptions based on payperiod
				select @decDeductionsAllowance = decDeductionsAllowance from tblAppendix1Exemptions where intPayPeriod = 1

				--Configured Exemptions and Allowances
				SELECT top(1) @ClaimedExceptionAndAllowances  =decClaimedExemption + decClaimedAllowance +ISNULL(@decAllowancesClaimed,0) * ISNULL(@decDeductionsAllowance,0)
				FROM tblUserHaciendaParameters where intUserID = @IntUserID ORDER BY dtEntryDate desc
			
				SET @TablePay = @BatchComputationPay- @ClaimedExceptionAndAllowances   
				--Find the values from the table
				SELECT TOP (1) @TaxWithholdingPercent =[decWithholdingPercent], @TaxSubtractAmount =[decWitholdingsSubtract]
				FROM [dbo].[tblAppendix3Tax]  where [intPayPeriod] = @PAYPERIOD   
				AND [decWagesFrom] <= @TablePay  AND @TablePay  <=[decWagesTo] 
				ORDER BY [dtTableStartDate] DESC

			END
		
			IF @BatchComputationPay < 0 SET @BatchComputationPay = 0

		SELECT @BatchID as BatchID, @IntUserID as UserID,
		@PAYPERIOD as PayPeriod,
		@BatchComputationPay as TaxablePay 
		,-@ClaimedExceptionAndAllowances as Exceptions,
		@BatchComputationPay - @ClaimedExceptionAndAllowances as TablePay,
		@TaxWithholdingPercent as HaciendaPercent,@TaxSubtractAmount SubtractAmount


		END
	
	ELSE
		--26 YEARS OR LESS
		BEGIN
			DECLARE @BatchGrossIncome as decimal(18,5)
			DECLARE @GrossIncome as decimal(18,5)
	
			SELECT @BatchGrossIncome = dbo.fnPay_BatchGrossPay(@BatchID,@IntUserID)
			SELECT @GrossIncome = [dbo].[fnPay_YTDUserGrossPay](@IntUserID, @PayDate,@PayrollCompany)

			if @GrossIncome <= 40000 --EXEMPT
				BEGIN
					SET @TablePay = 0
					SET @TaxWithholdingPercent = 0
					SET @TaxSubtractAmount = 0
				END
			ELSE --Over 40000, check if full or partial amount pays taxes
				BEGIN
				if (@GrossIncome - @BatchGrossIncome) < 40000
					BEGIN
						--Amount that will pay Hacienda tax
						SET @TablePay = @GrossIncome - 40000
				
						--Should not happen !!!
						if @TablePay < @BatchGrossIncome 
								SET @TablePay = 0
				
						--Find the values from the table
						SELECT TOP (1) @TaxWithholdingPercent =[decWithholdingPercent], @TaxSubtractAmount =[decWitholdingsSubtract]
						FROM [dbo].[tblAppendix3Tax]  where [intPayPeriod] = @PAYPERIOD   
						AND [decWagesFrom] <= @TablePay  AND @TablePay  <=[decWagesTo] 
						ORDER BY [dtTableStartDate] DESC
					END
				ELSE
					BEGIN
						--Amount that will pay Hacienda tax
						SET @TablePay = @BatchGrossIncome
						--Find the values from the table
						SELECT TOP (1) @TaxWithholdingPercent =[decWithholdingPercent], @TaxSubtractAmount =[decWitholdingsSubtract]
						FROM [dbo].[tblAppendix3Tax]  where [intPayPeriod] = @PAYPERIOD   
						AND [decWagesFrom] <= @TablePay  AND @TablePay  <=[decWagesTo] 
						ORDER BY [dtTableStartDate] DESC

					END
			END		 
		END
		if @TaxWithholdingPercent is null SET @TaxWithholdingPercent =0
		if @TaxSubtractAmount is null SET @TaxSubtractAmount = 0

			IF EXISTS(SELECT * FROM [dbo].[tblUserHaciendaParameters] WHERE intUserID = @intUserID and  dtEntryDate= @PayDate)
				 UPDATE [dbo].[tblUserHaciendaParameters] WITH (SERIALIZABLE)
					SET [decTablesWithholdingPercent] = @TaxWithholdingPercent
				   ,[decTablesWithholdingSubtractAmount] = @TaxSubtractAmount
				   ,[decHaciendaWithholdingPercent]= @TaxWithholdingPercent
				   ,[decHaciendaWithholdingSubtractAmount]= @TaxSubtractAmount
					WHERE intUserID = @intUserID and  dtEntryDate= @PayDate
			ELSE
				IF EXISTS(SELECT * FROM [dbo].[tblUserHaciendaParameters] WHERE intUserID = @intUserID )
					BEGIN -- There are other entries in the table, so copy the last one and change the percentages
					INSERT INTO [dbo].[tblUserHaciendaParameters]
					   ([intUserID]
					   ,[dtEntryDate]
					   ,[decComputedExemption]
					   ,[decClaimedExemption]
					   ,[decComputedAllowance]
					   ,[decClaimedAllowance]
					   ,[decAdditionalWithholdingPercent]
					   ,[decAdditionalWithholdingAmount]
					   ,[decClaimedAdditionalWithholdingPercent]
					   ,[decClaimedAdditionalWithholdingAmount]
					   ,[decTablesWithholdingPercent]
					   ,[decTablesWithholdingSubtractAmount]
					   ,[decHaciendaWithholdingPercent]
					   ,[decHaciendaWithholdingSubtractAmount])
     				SELECT TOP (1) [intUserID]
					  ,@PayDate
					  ,[decComputedExemption]
					  ,[decClaimedExemption]
					  ,[decComputedAllowance]
					  ,[decClaimedAllowance]
					  ,[decAdditionalWithholdingPercent]
					  ,[decAdditionalWithholdingAmount]
					  ,[decClaimedAdditionalWithholdingPercent]
					  ,[decClaimedAdditionalWithholdingAmount]
					  ,@TaxWithholdingPercent
					  ,@TaxSubtractAmount
					  ,@TaxWithholdingPercent
					  ,@TaxSubtractAmount
				FROM [dbo].[tblUserHaciendaParameters] where intUserID = @intUserID and  dtEntryDate <= @PayDate ORDER BY dtEntryDate DESC
  			END
				ELSE
					BEGIN --There are no entries in the table
					--Not configured
					select 'No Configuration Found'
					END

END -- USE Payroll Hacienda Computation	
END

GO
