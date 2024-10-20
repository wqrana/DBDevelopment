USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_GetNextDirectDeposit]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Gets the next Direct Deposit Number
-- =============================================

CREATE FUNCTION [dbo].[fnPay_GetNextDirectDeposit]
(
	@PAYROLL_COMPANY nvarchar(50)
)
RETURNS integer
-- WITH ENCRYPTION
AS
BEGIN
	-- Declare the return variable here
	DECLARE @CheckSeed as integer
	DECLARE @LastCheck as integer

	select top(1) @CheckSeed = intDirectDepositSeedNumber from tblCompanyBankAccounts WHERE strCompanyName = @PAYROLL_COMPANY
	DECLARE @CheckBook int
	SELECT top(1) @CheckBook =  isnull([intCheckingAccountID],0) from tblCompanyBankAccounts where strCompanyName  =@PAYROLL_COMPANY

	if @CheckBook = 0
		SELECT @LastCheck = max(intchecknumber) from viewPay_UserPayCheck where strCompanyName = @PAYROLL_COMPANY and intPayMethodType = 2
	ELSE
		SELECT @LastCheck = max(intchecknumber) from viewPay_UserPayCheck where strCompanyName IN (select strCompanyName from tblCompanyBankAccounts where intCheckingAccountID =@CheckBook) and intPayMethodType = 2

		if @LastCheck is null SET @LastCheck = 0
		if @CheckSeed  is null SET @CheckSeed = 0

	if @CheckSeed > @LastCheck
		SET @CheckSeed = @CheckSeed + 1
	else
		SET @CheckSeed = @LastCheck + 1


	RETURN @CheckSeed
END


GO
