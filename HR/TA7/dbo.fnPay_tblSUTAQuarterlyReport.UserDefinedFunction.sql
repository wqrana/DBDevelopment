USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblSUTAQuarterlyReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 05/15/2019
-- Description:	Quarterly Report for SUTA Taxes
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblSUTAQuarterlyReport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbSUTAReport TABLE 
(
	strCompanyName nvarchar(50),
	dtStartDate date,
	dtEndDate date,
	SUTAUsersCovered int,
	SUTATotalWages decimal(18,5),
	SUTATaxableWages decimal(18,5),
	SUTAExcludedWages decimal(18,5),
	SUTAContributionsPercent decimal(18,5),
	SUTACompanyTaxOwed decimal(18,5),
	SUTAUserCompanyRetained decimal(18,5),
	SUTATotalTaxesOwed decimal(18,5),
	SUTAContributionTaxesOwed decimal(18,5),
	SUTAAportacionTaxesOwed decimal(18,5)

	) 
	-- WITH ENCRYPTION
AS
BEGIN
--select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName = @PAYITEM 
Declare @SUTATotalWages decimal(18,5)
Declare @SUTATaxableWages decimal(18,5)
Declare @SUTATaxPercent decimal(18,5)
Declare @SUTAAportacionEspecial decimal(18,5)
declare @UserCovered int
declare @NonSUTAWages decimal(18,5)
declare	@UserWithholdings decimal(18,5)
declare @CompanyContributedTax decimal(18,5) --Retained
declare @CompanyContributionsTax decimal(18,5) --Real Tax Number
declare @CompanyAportacionTax decimal(18,5) --Real Tax Number
DECLARE @WithholdingName nvarchar(50)
declare @SUTATotalTaxes decimal(18,5) --Real Tax Number

--Check for WH that is configured as SUTA
	SET @WithholdingName = 'SUTA'
	--Already included in percent
	SET @SUTAAportacionEspecial = 1
	
	--SUTA Override
	Select @SUTATaxPercent = decSUTAPercent from tblSUTAHistory where strcompanyname = @PayrollCompany and dtYearStartDate = DATEADD(yy, DATEDIFF(yy, 0,@STARTDATE), 0);
	IF @SUTATaxPercent is null set @SUTATaxPercent =0
	IF @SUTATaxPercent  = 0 
		select  @SUTATaxPercent = decCompanyPercent from tblCompanyWithholdings where strWithHoldingsName = @WithholdingName and strCompanyName = @PayrollCompany
	
	-- SUTA Aportacion is reported separately
	SET @SUTATaxPercent = @SUTATaxPercent - @SUTAAportacionEspecial
--1 Number of Employees Covered by this policy
	 select @UserCovered=  count(distinct strSSN) , @SUTATaxableWages =  sum(decTaxablePay)
	 , @NonSUTAWages =  sum(decPeriodPay)- sum(decTaxablePay) 
	 FROM 	[dbo].[fnPay_tblUserTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,@WithholdingName) where bitWithholdingApplies = 1 


--2 Total Salaries for all Employees
	SELECT @SUTATotalWages =sum(decPeriodPay) FROM 	[dbo].[fnPay_tblUserTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,@WithholdingName) 
--  Taxable Wages
--	Non-Taxable Wages
	 --select @UserCovered=  count(distinct strSSN) , @SUTATaxableWages = sum(decTaxablePay), @NonSUTAWages =  sum(decPeriodPay)- sum(decTaxablePay) 
	 --FROM 	[dbo].[fnPay_tblCompanyTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,@WithholdingName) where bitWithholdingApplies = 1 


--No SUTA User Withholding, only company contribution
	select @CompanyContributedTax =  sum(-[dbo].[fnPay_CompanyBatchWithholdings_ByDates](intuserid,@WithholdingName,@startdate,@enddate ))
	From viewPay_UserWithholdingItems uwi where strCompanyName = @PayrollCompany and decCompanyPercent <> 0
	and strWithHoldingsName = @WithholdingName 

	select @CompanyContributionsTax  = ROUND(@SUTATaxableWages * @SUTATaxPercent / 100,2)
	select @CompanyAportacionTax = ROUND(@SUTATaxableWages * @SUTAAportacionEspecial / 100,2)

	SET @SUTATotalTaxes = ROUND(@SUTATaxableWages* (@SUTATaxPercent + @SUTAAportacionEspecial)  / 100,2)


--5  = 2-3
	--Select employees that New law applies\

	INSERT INTO @tbSUTAReport
	SELECT @PayrollCompany as PayrollCompany, @STARTDATE as startdate, @ENDDATE as endate,  @UserCovered as UserCount, 
	@SUTATotalWages as SUTATotalWages, @SUTATaxableWages as SUTATaxableWages,@NonSUTAWages as NonTaxableWages ,@SUTATaxPercent as TaxPercent , 
	@CompanyContributionstax as SUTACompanyTaxOwed, @CompanyContributedTax  as CompanyRetained
	,@SUTATotalTaxes, @CompanyContributionsTax,@CompanyAportacionTax


RETURN
END
GO
