USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_GetNextPayCheck]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Gets the next Pay Check Number
-- =============================================

CREATE FUNCTION [dbo].[fnPay_GetNextPayCheck]
(
	@PAYROLL_COMPANY nvarchar(50),
	@BATCHID nvarchar(50)
)
RETURNS integer
-- WITH ENCRYPTION
AS
BEGIN
	-- Declare the return variable here
	DECLARE @CheckSeed as integer
	DECLARE @LastCheck as integer
	DECLARE @MissingCheck as integer
	
	DECLARE @CheckBook int
	SELECT top(1) @CheckBook =  isnull([intCheckingAccountID],0) from tblCompanyBankAccounts where strCompanyName  =@PAYROLL_COMPANY

	select top(1) @CheckSeed = intCheckSeedNumber from tblCompanyBankAccounts WHERE strCompanyName = @PAYROLL_COMPANY
	
	--IF a checkbook is used, check all companies in the checkbook, otherwise use the next check number for the company
	if @CheckBook = 0
		SELECT @LastCheck = max(intchecknumber) from viewPay_UserPayCheck where strCompanyName = @PAYROLL_COMPANY and intPayMethodType = 1
	ELSE
		SELECT @LastCheck = max(intchecknumber) from viewPay_UserPayCheck where strCompanyName IN (select strCompanyName from tblCompanyBankAccounts where intCheckingAccountID =@CheckBook) and intPayMethodType = 1
	
	if @LastCheck is null SET @LastCheck = 0
	if @CheckSeed  is null SET @CheckSeed = 0

	DECLARE @StartChecknumber int
	DECLARE @LastChecknumber int
	SELECT  @StartChecknumber = min(intCheckNumber) from tblUserPayChecks where intPayMethodType = 1 and strBatchID = @BATCHID and intCheckNumber > 0
	SELECT  @LastChecknumber= max(intCheckNumber) from tblUserPayChecks where intPayMethodType = 1 and strBatchID = @BATCHID

	;WITH Missing (missnum, maxid)
	AS
	(
	SELECT @StartChecknumber AS missnum, @LastCheck as maxid
	UNION ALL
	SELECT missnum + 1, maxid FROM Missing
	WHERE missnum < maxid
	)
	SELECT @MissingCheck = min(missnum)
	FROM Missing
	LEFT OUTER JOIN tblUserPayChecks tt on tt.intCheckNumber = Missing.missnum
	WHERE tt.intCheckNumber is NULL AND missnum not in (Select [intVoidedCheckNumber] FROM tblCompanyVoidedChecks WHERE strCompanyName = @PAYROLL_COMPANY)
	OPTION (MAXRECURSION 0);
	
	if @MissingCheck is null SET @MissingCheck = 0
		
	if @CheckSeed > @LastCheck
		SET @CheckSeed = @CheckSeed + 1
	else
		SET @CheckSeed = @LastCheck + 1

	if @MissingCheck <> 0 		
		BEGIN
		SET @CheckSeed = @MissingCheck 
		END
	ELSE
		BEGIN
		DECLARE @VoidedCheckCount as integer
		SET @LastCheck = @CheckSeed
		SET @VoidedCheckCount = @LastCheck + 100
		WHILE @LastCheck < @VoidedCheckCount
		BEGIN
			DECLARE @Count as integer
			SELECT @Count = count([intVoidedCheckNumber]) FROM tblCompanyVoidedChecks WHERE  strCompanyName = @PAYROLL_COMPANY AND intVoidedCheckNumber = @LastCheck
			IF @Count = 0 BREAK;
			SET @LastCheck = @LastCheck + 1;
		END;
		SET @CheckSeed = @LastCheck
	END

	RETURN @CheckSeed
END

GO
