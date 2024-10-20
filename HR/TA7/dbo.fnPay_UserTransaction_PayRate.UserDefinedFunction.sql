USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_UserTransaction_PayRate]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		2016-03-17
-- Description:		Gets the Pay Rate for the given Transaction
--	Note:			The rate is either the assigned rate in tuserTransactionsPayRates
--					OR the the rate depends on whether the transaction is multiplier, fixed amount(offset only) or both
--					The function returns 0 if no hourlyrate or transaction is not money (nMoneyValue = 0)
-- =============================================
CREATE FUNCTION [dbo].[fnPay_UserTransaction_PayRate]
(
	@UserID as int,
	@PunchDate as datetime,
	@TransName as nvarchar(50)
)
RETURNS decimal (18,5) 
-- WITH ENCRYPTION
AS
BEGIN
declare @MoneyAmount as int
declare @PayTrans as int
declare @HourlyRate as  decimal(18,5)
declare @RateMultiplier as decimal(18,5)
declare @Offset as decimal(18,5)
declare @Value as decimal(18,5)

select @MoneyAmount= nIsMoneyTrans, @PayTrans= nPayRateTransaction, @RateMultiplier = decPayRateMultiplier, @Offset = decPayRateOffset from tTransDef where name = @TransName
--If Rate Transaction, use formular Multiplier * PayRate + Offset
if @PayTrans > 0
	BEGIN
		--Get the employee's rate:
	--	Look first at tUserTransactionPayRates
	select top(1) @HourlyRate =	[dbo].[fnPay_ComputeHourlyRate] (nUserID, intHourlyOrSalary, decPayRate, decHoursPerPeriod) 
	from  [dbo].[tblUserTransactionPayRates] where nuserid = @UserID and sTransName = @TransName and @PunchDate <= @PunchDate ORDER by dstartdate desc
	if @HourlyRate is null
		BEGIN
		--If not found, look at regular rate
			select top(1) @HourlyRate =		[dbo].[fnPay_ComputeHourlyRate] (intUserID, intHourlyOrSalary, decPayRate, decHoursPerPeriod) from [dbo].[tblUserPayRates]
			where intuserid = @UserID and dtStartDate <= @PunchDate ORDER by dtStartDate desc
	END
END
--If Money Transaction, the amount is already a money amount
if @HourlyRate is NULL 	SET @HourlyRate = 0  
--Add Multiplier
SET @HourlyRate = @RateMultiplier * @HourlyRate

RETURN @HourlyRate
END


GO
