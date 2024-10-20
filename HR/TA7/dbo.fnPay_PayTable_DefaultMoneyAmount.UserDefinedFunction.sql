USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_PayTable_DefaultMoneyAmount]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE FUNCTION [dbo].[fnPay_PayTable_DefaultMoneyAmount]
(
	@UserID as int,
	@TransName as nvarchar(50),
	@dblHour as float
)
RETURNS
@PayTable TABLE 
(
	nUserID  int,
	sTransName  nvarchar(50),
	dblHour  float,
	decHourlyRate   decimal(16,2),
	decMoneyValue  decimal(16,2)
)
-- WITH ENCRYPTION
AS
BEGIN
declare @MoneyAmount as int
declare @PayTrans as int
declare @HourlyRate as  decimal(16,2)
declare @RateMultiplier as decimal(16,2)
declare @Offset as decimal(16,2)
declare @Value as decimal(16,2)

select @MoneyAmount= nIsMoneyTrans, @PayTrans= nPayRateTransaction, @RateMultiplier = decPayRateMultiplier, @Offset = decPayRateOffset from tTransDef where name = @TransName
--If Rate Transaction, use formular Multiplier * PayRate + Offset
if @PayTrans > 0
	BEGIN
		select @HourlyRate = dblhourlyrate from tUserExtended where nuserid = @UserID

		if @HourlyRate is null	set @HourlyRate = 0
		set @HourlyRate = @RateMultiplier * @HourlyRate 
--Note: Normally the value will be either the multiplier OR the Offset, but we can do both
		select @Value = @HourlyRate * @dblHour + @Offset
	END

--If Money Transaction, the amount is already a money amount
if @MoneyAmount >0 	
BEGIN
	SET @HourlyRate = 0
	SET @Value = @dblHour  
END
if @Value is null set @value = 0

insert into @PayTable
	select @UserID, @TransName,@dblHour,isnull(@HourlyRate,0), isnull(@Value,0)
RETURN
END

GO
