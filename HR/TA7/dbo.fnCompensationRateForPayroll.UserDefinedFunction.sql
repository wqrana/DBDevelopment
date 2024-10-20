USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCompensationRateForPayroll]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnCompensationRateForPayroll](@UserID int, @AccrualType varchar(50),@SearchDate date )
RETURNS decimal(18,5)
AS
BEGIN
	DECLARE @PayRate decimal(18,5) = 0;

IF @AccrualType = 'VA'
BEGIN
	--Vacation
	SELECT @PayRate = [dbo].[fnPay_UserTransaction_PayRate](@UserID,@SearchDate,'VAC REG')

END
ELSE IF @AccrualType = 'SA'
BEGIN
	--Sick
	SELECT @PayRate = [dbo].[fnPay_UserTransaction_PayRate](@UserID,@SearchDate,'SICK')
END
ELSE
	BEGIN
	--Standard Rate
	SELECT @PayRate = [dbo].[fnPay_UserTransaction_PayRate](@UserID,@SearchDate,'HR')
	END


IF @PayRate IS NULL SET @PayRate = 0
	RETURN @PayRate ;
END;
GO
