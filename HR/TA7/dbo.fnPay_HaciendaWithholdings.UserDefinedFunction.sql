USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_HaciendaWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  UserDefinedFunction [dbo].[fnPay_HaciendaWithholdings]    Script Date: 4/5/2017 10:41:55 AM ******/

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 8/22/2016
-- Description:	Computes the Hacienda Withholdings Based 
--				on the user's tblUserHaciendaParameters
--				Returns 0 if negative OR record does not exist
-- =============================================

CREATE FUNCTION [dbo].[fnPay_HaciendaWithholdings]
(
	@BATCHID as nvarchar(50),
	@UserID as int,
	@SearchDate as date
	)
RETURNS decimal(18,2)
-- WITH ENCRYPTION
AS
BEGIN
	--General Non-taxable income
	DECLARE @TaxableIncome decimal(18,2)
	SET @TaxableIncome = [dbo].[fnPay_BatchTaxablePay] (@BATCHID, @USERID)

	--HACIENDA TAX DEDUCTIONS
	DECLARE @401kDeduction as decimal(18,2)
	SET @401kDeduction = [dbo].[fnPay_BatchStTaxExemptions](@BATCHID, @UserID)

	if @401kDeduction is null SET @401kDeduction = 0
	DECLARE @Withholding as decimal(18,2)
		
	DECLARE @ExcludedIncome as decimal(18,2)
	SELECT @ExcludedIncome = sum(decPay) FROM tblUserBatchCompensations where strCompensationName IN (select strCompensationNameExcluded FROM [tblWithholdingsCompensationExclusions]
	where strWithHoldingsName = dbo.fnPay_GetHaciendaStateTaxName(@UserID))
	AND intUserID = @UserID AND boolDeleted = 0 AND strBatchID =  @BatchID  GROUP BY intUserID 
	if @ExcludedIncome is null SET @ExcludedIncome = 0
	
	select top(1) @Withholding = (((@TaxableIncome + @401kDeduction - @ExcludedIncome -  decClaimedExemption - decClaimedAllowance) *   (decHaciendaWithholdingPercent + decClaimedAdditionalWithholdingPercent)/100) -decHaciendaWithholdingSubtractAmount+   decClaimedAdditionalWithholdingAmount )
	from [dbo].[tblUserHaciendaParameters] 
	where intUserID = @UserID and dtEntryDate <=  @SearchDate
	ORDER BY dtEntryDate DESC

	if @Withholding is null		set @Withholding = 0
	if @Withholding < 0 set @Withholding =	 0

return - ROUND(@Withholding,2)
END

GO
