USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_UserTransaction_DefaultMoneyAmount]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		2016-03-17
-- Description:		Gets the money amount for a transaction.
--	Note:			The rate depends on whether the transaction is multiplier, fixed amount(offset only) or both
--					The function returns 0 if no hourlyrate or transaction is not money (nMoneyValue = 0)
-- =============================================
CREATE FUNCTION [dbo].[fnPay_UserTransaction_DefaultMoneyAmount]
(
	@UserID as int,
	@TransName as nvarchar(50),
	@dblHour as float
)
RETURNS decimal(14,2)  
-- WITH ENCRYPTION
AS
BEGIN
declare @MoneyAmount as int
declare @PayTrans as int
declare @HourlyRate as  decimal(16,2)
declare @RateMultiplier as decimal(16,2)
declare @Offset as decimal(16,2)
declare @Value as decimal(14,2)

select @MoneyAmount= nIsMoneyTrans, @PayTrans= nPayRateTransaction, @RateMultiplier = decPayRateMultiplier, @Offset = decPayRateOffset from tTransDef where name = @TransName
--If Rate Transaction, use formular Multiplier * PayRate + Offset
if @PayTrans > 0
	BEGIN
		select @HourlyRate = dblhourlyrate from tUserExtended where nuserid = @UserID
		if @HourlyRate is null	set @HourlyRate = 0
		
		select @Value = @RateMultiplier * @HourlyRate * @dblHour + @Offset
	END
--If Money Transaction, the amount is already a money amount
if @MoneyAmount >0 	SET @Value = @dblHour  

if @Value is null set @value = 0

RETURN @value
END

GO
