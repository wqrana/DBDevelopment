USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblFUTAQuarterlyReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 08/14/2019
-- Description:	Quarterly Report for FUTA Taxes
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblFUTAQuarterlyReport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbFUTAReport TABLE 
(
	strCompanyName nvarchar(50),
	dtStartDate date,
	dtEndDate date,
	FUTAUsersCovered int,
	FUTATotalWages decimal(18,5),
	FUTATaxableWages decimal(18,5),
	FUTAExcludedWages decimal(18,5),
	FUTAContributionsPercent decimal(18,5),
	FUTACompanyTaxOwed decimal(18,5),
	FUTAUserCompanyRetained decimal(18,5),
	FUTATotalTaxesOwed decimal(18,5),
	FUTAContributionTaxesOwed decimal(18,5),
	FUTAAportacionTaxesOwed decimal(18,5)

	) 
	-- WITH ENCRYPTION
AS
BEGIN
--select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName = @PAYITEM 
Declare @FUTATotalWages decimal(18,5)
Declare @FUTATaxableWages decimal(18,5)
Declare @FUTATaxPercent decimal(18,5)
Declare @FUTAAportacionEspecial decimal(18,5)
declare @UserCovered int
declare @NonFUTAWages decimal(18,5)
declare	@UserWithholdings decimal(18,5)
declare @CompanyContributedTax decimal(18,5) --Retained
declare @CompanyContributionsTax decimal(18,5) --Real Tax Number
declare @CompanyAportacionTax decimal(18,5) --Real Tax Number
DECLARE @WithholdingName nvarchar(50)
declare @FUTATotalTaxes decimal(18,5) --Real Tax Number

--Check for WH that is configured as FUTA
	SET @WithholdingName = 'FUTA'
	--Already included in percent
	SET @FUTAAportacionEspecial = 0

	select  @FUTATaxPercent = decCompanyPercent from tblCompanyWithholdings where strWithHoldingsName = @WithholdingName and strCompanyName = @PayrollCompany
	-- FUTA Aportacion is reported separately
	SET @FUTATaxPercent = @FUTATaxPercent - @FUTAAportacionEspecial
--1 Number of Employees Covered by this policy
	 select @UserCovered=  count(distinct strSSN) , @FUTATaxableWages = sum(decTaxablePay), @NonFUTAWages =  sum(decPeriodPay)- sum(decTaxablePay) 
	 FROM 	[dbo].[fnPay_tblUserTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,@WithholdingName) where bitWithholdingApplies = 1 

--2 Total Salaries for all Employees
	SELECT @FUTATotalWages =sum(decPeriodPay) FROM 	[dbo].[fnPay_tblCompanyTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,@WithholdingName) 
--  Taxable Wages
--	Non-Taxable Wages
	 select @UserCovered=  count(distinct strSSN) , @FUTATaxableWages = sum(decTaxablePay), @NonFUTAWages =  sum(decPeriodPay)- sum(decTaxablePay) 
	 FROM 	[dbo].[fnPay_tblUserTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,@WithholdingName) where bitWithholdingApplies = 1


--No FUTA User Withholding, only company contribution
	select @CompanyContributedTax =  sum(-[dbo].[fnPay_CompanyBatchWithholdings_ByDates](intuserid,@WithholdingName,@startdate,@enddate ))From viewPay_UserWithholdingItems uwi where strCompanyName = @PayrollCompany and decCompanyPercent <> 0
	and strWithHoldingsName = @WithholdingName 

	select @CompanyContributionsTax  = ROUND(@FUTATaxableWages * @FUTATaxPercent / 100,2)
	select @CompanyAportacionTax = ROUND(@FUTATaxableWages * @FUTAAportacionEspecial / 100,2)

	SET @FUTATotalTaxes = ROUND(@FUTATaxableWages* (@FUTATaxPercent + @FUTAAportacionEspecial)  / 100,2)


--5  = 2-3
	--Select employees that New law applies
	INSERT INTO @tbFUTAReport
	SELECT @PayrollCompany PayrollCompany, @STARTDATE startdate, @ENDDATE endate,  @UserCovered UserCount, 
	@FUTATotalWages FUTATotalWages, @FUTATaxableWages FUTATaxableWages,@NonFUTAWages NonTaxableWages ,@FUTATaxPercent TaxPercent , 
	@CompanyContributionstax FUTACompanyTaxOwed, @CompanyContributedTax  CompanyRetained
	,@FUTATotalTaxes, @CompanyContributionsTax,@CompanyAportacionTax


RETURN
END

GO
