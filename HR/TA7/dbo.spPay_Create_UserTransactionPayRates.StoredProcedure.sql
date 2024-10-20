USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_UserTransactionPayRates]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: ??
-- Description:	Creates the User Transaction Payrated for a single user
-- ======

CREATE PROCEDURE [dbo].[spPay_Create_UserTransactionPayRates]
	-- Add the parameters for the stored procedure here
	@Userid int,
	@Punchdate date
-- WITH ENCRYPTION
AS
BEGIN

DECLARE @PayRate decimal(18,2) 
DECLARE @ComputationType as integer
DECLARE @ComputationPeriod as integer

--Check if this user has comission based transactions
SELECT @ComputationType = intComputationType, @ComputationPeriod  = intComputationPeriod FROM [dbo].tblUserPayRatesRules upr inner join tblPayRatesRules pr on upr.intPayRatesRulesID = pr.intPayRatesRulesID 
where intuserid = @Userid 

if @ComputationType is null SET @ComputationType = -1
if @ComputationPeriod is null SET @ComputationPeriod = -1

IF @ComputationType = 0
	BEGIN
		DECLARE		@StartDate date
	DECLARE		@StartDateHistorical date
		DECLARE		@EndDate date
		--Select the start of the month
		SELECT @Punchdate  = DATEADD(month, DATEDIFF(month, 0, @Punchdate), 0) 

		SELECT top(1) @PayRate = decPayRate FROM [dbo].[tblUserTransactionPayRates] where nUserID = @Userid and dStartDate = @Punchdate 

		--CHECK
		SELECT @PayRate  as PayRate
	
		--If pay rate has not been computed, compute it now
		IF @PayRate IS NULL 
		BEGIN

			--Get the date of the last closed period before the date to determine the rate time frame. 
			select 
				top(1) @StartDate = DATEADD(DAY,1, dateadd(MONTH,-@ComputationPeriod, dtEndDatePeriod)), 	
				@StartDateHistorical = DATEADD(MOnth, -12, @Punchdate), 
				@EndDate = dtPayDate 
			from 
				viewPay_UserBatchStatus 
			where 
				intUserID = @Userid AND dtEndDatePeriod < @Punchdate and intBatchStatus < 0 
			ORDER BY 
				dtEndDatePeriod DESC
			
			--If there is no data in TimeAide yet, use months
			IF @StartDate IS NULL OR @EndDate IS NULL
			BEGIN
				SET @EndDate = DATEADD(DAY,-1,@Punchdate)  --End of previous month
				SET @StartDate = dateadd(MONTH,-@ComputationPeriod, @Punchdate) --12 months back
			END
			--CHECK
			SELECT @StartDate as StartDate, @EndDate as EndDate

			declare @CompensationHours decimal (18,2)
			declare @CompensationWages decimal (18,2)
			declare @CompensationCommission decimal (18,2)
	
			-- HOURS Return the result of the function
			SELECT @CompensationHours = sum(decHours)FROM tblUserBatchCompensations ubc inner join tblUserBatch ub on ubc.intUserID =ub.intUserID and ubc.strBatchID = ub.strBatchID where ubc.intUserID = @Userid AND dtPayDate BETWEEN @StartDate AND @EndDate AND ub.intUserBatchStatus = -1
			and strCompensationName IN (select [strTransHoursName] FROM [tblPayRatesRulesHoursTrans])
			IF @CompensationHours IS NULL SET @CompensationHours = 0 

			-- WAGES Return the result of the function
			SELECT @CompensationWages = sum(decPay) FROM tblUserBatchCompensations ubc inner join tblUserBatch ub on ubc.intUserID =ub.intUserID and ubc.strBatchID = ub.strBatchID where ubc.intUserID = @Userid AND dtPayDate BETWEEN @StartDate AND @EndDate AND ub.intUserBatchStatus = -1 
			and strCompensationName IN (select [strTransWagesName]FROM [dbo].[tblPayRatesRulesWagesTrans] )
			IF @CompensationWages IS NULL SET @CompensationWages = 0 

			-- COMISSIONS Return the result of the function
			SELECT @CompensationCommission =  sum(decPay)  FROM tblUserBatchCompensations ubc inner join tblUserBatch ub on ubc.intUserID =ub.intUserID and ubc.strBatchID = ub.strBatchID where ubc.intUserID = @Userid AND dtPayDate BETWEEN @StartDate AND @EndDate AND ub.intUserBatchStatus = -1 
			and strCompensationName IN (select [strTransComissionName] FROM [dbo].[tblPayRatesRulesComissionTrans] )
			IF @CompensationCommission IS NULL SET @CompensationCommission = 0 

			--History Values
			declare @HistoryHours decimal (18,2)
			declare @HistoryWages decimal (18,2)
			declare @HistoryCommission decimal (18,2)
	
			SELECT @HistoryWages = sum(decPeriodWages), @HistoryCommission= sum(decPeriodComissions), @HistoryHours = sum(decPeriodHours) FROM [dbo].[tblUserCompensationsPreviousHistory] where intUserID = @Userid AND dtPayDate BETWEEN @StartDateHistorical AND @EndDate 

			IF @HistoryHours IS NULL SET @HistoryHours = 0 
			IF @HistoryWages IS NULL SET @HistoryWages = 0 
			IF @HistoryCommission IS NULL SET @HistoryCommission = 0 

			SET @CompensationHours = @CompensationHours + @HistoryHours
			SET @CompensationWages = @CompensationWages + @HistoryWages
			SET @CompensationCommission = @CompensationCommission + @HistoryCommission

			IF @CompensationHours IS NULL SET @CompensationHours = 0
			IF  @CompensationWages IS NULL SET @CompensationWages = 0
			IF  @CompensationCommission IS NULL SET @CompensationCommission = 0

			--DEBUG
			SELECT @Userid UserID, @CompensationHours Hours, @CompensationWages Wages, @CompensationCommission Comissions

			IF @CompensationHours <> 0 
				SELECT @PayRate =  (@CompensationWages +  @CompensationCommission) / @CompensationHours 
			ELSE
				SET @PayRate = 0
				
			--DECLARE @MinPayRate decimal
			DECLARE @MinPayRate decimal(18,2)
			--CHECK
			--SELECT top(1) @MinPayRate = decPayRate FROM tblUserPayRates order by dtStartDate desc
			SELECT top(1) @MinPayRate = case intHourlyOrSalary when 1 then [decPayRate] / [decHoursPerPeriod]	else [decPayRate] end FROM tblUserPayRates WHERE intUserID = @Userid order by dtStartDate desc
			if @PayRate < @MinPayRate SET @PayRate = @MinPayRate
			
			SELECT @PayRate 'Computed Pay Rate', @MinPayRate 'Record Pay Rate'
	
			--Insert the computed rate into the table.
			INSERT INTO [dbo].[tblUserTransactionPayRates] 
			(nUserID, dStartDate, sTransName, intPayPeriod, intHourlyOrSalary, decPayRate, decHoursPerPeriod, nInactivate, decPeriodWages, decPeriodComissions, decPeriodHours, dtPeriodStartDate, dtPeriodEndDate)
			SELECT intUserID,@Punchdate, prt.strTransactionName, 0,0,@PayRate,0,0, @CompensationWages, @CompensationCommission, @CompensationHours,@StartDate,@EndDate 
			FROM tblUserPayRatesRules upr inner join	[dbo].tblPayRatesRulesTransactions prt ON upr.intPayRatesRulesID = prt.intPayRatesRulesID where intUserID = @Userid

		END
	END
END

GO
