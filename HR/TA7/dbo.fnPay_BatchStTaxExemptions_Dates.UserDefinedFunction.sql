USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_BatchStTaxExemptions_Dates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Taxable Batch Pay from tblBatchCompensations
--				Excludes all compensations except salary
-- =============================================
CREATE FUNCTION [dbo].[fnPay_BatchStTaxExemptions_Dates]
(
	@PayrollCompany nvarchar(50), 
	@StartDate date,
	@EndDate date
)
RETURNS decimal (18,2) -- WITH ENCRYPTION
AS
BEGIN
	--HACIENDA TAX DEDUCTIONS
	DECLARE @401kDeduction as decimal(18,2)
	SELECT  @401kDeduction = SUM(decWithholdingsAmount) FROM viewPay_UserBatchWithholdings uw inner join tblWithholdingsQualifierItems wqi on uw.strWithHoldingsName = wqi.strWithHoldingsName
	where strCompanyName = @PayrollCompany and dtPayDate BETWEEN @StartDate AND @EndDate
	and intWithHoldingsQualifierID = 0 and intQualifierValue = 1 

	if @401kDeduction is null SET @401kDeduction = 0
	
	-- Return the result of the function
	RETURN ROUND(@401kDeduction,2)

END


GO
