USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_UserTransaction_GrossPay]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		2016-08-24
-- Description:		Gets the pay rate and money amount for a transaction.
--	Note:			The rate is either the assigned rate in tuserTransactionsPayRates
--					OR the the rate depends on whether the transaction is multiplier, fixed amount(offset only) or both
--					The function returns 0 if no hourlyrate or transaction is not money (nMoneyValue = 0)
-- =============================================
CREATE FUNCTION [dbo].[fnPay_UserTransaction_GrossPay]
(
	@UserID as int,
	@PunchDate as datetime,
	@TransName as nvarchar(50),
	@dblHour as float,
	@JobCodeID as int
)
RETURNS
@PayTable TABLE 
(
	intUserID  int,
	dtPunchDate  datetime,
	strTransName  nvarchar(50),
	decHours  decimal(18,5),
	decHourlyRate   decimal(18,5),
	decGrossPay  decimal(18,5),
	intJobCodeID int

)
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
	select @HourlyRate=	[dbo].[fnPay_UserTransaction_PayRate](@Userid,@PunchDate,@transName)
	if @HourlyRate is null
		BEGIN
		--If not found, look at regular rate
			select top(1) @HourlyRate =		[dbo].[fnPay_ComputeHourlyRate] (intUserID, intHourlyOrSalary, decPayRate, decHoursPerPeriod) from [dbo].[tblUserPayRates]
			where intuserid = @UserID and dtStartDate <= @PunchDate order by dtStartDate DESC
			--The payrate is the ratemultiplier X hourlyrate
			--The rate is payrate * hours.  The entered rate should be amount
			SET @HourlyRate = @RateMultiplier * @HourlyRate 
			select @Value = @HourlyRate * @dblHour + @Offset
		END
	ELSE
	BEGIN
			select @Value = @HourlyRate * @dblHour 
	END		
END
--If Money Transaction, the amount is already a money amount
if @MoneyAmount >0 	
BEGIN
	SET @Value = @dblHour  
	SET @dblHour = 0
END
if @Value is null set @value = 0

insert into @PayTable
	select @UserID, @PunchDate, @TransName,@dblHour,isnull(@HourlyRate,0), isnull(@Value,0), @JobCodeID
RETURN
END


GO
