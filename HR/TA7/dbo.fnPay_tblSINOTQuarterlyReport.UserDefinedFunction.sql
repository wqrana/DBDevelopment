USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblSINOTQuarterlyReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 05/15/2019
-- Description:	Quarterly Report for SINOT/DISABILITY Taxes
-- =============================================


Create FUNCTION [dbo].[fnPay_tblSINOTQuarterlyReport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbSINOTReport TABLE 
(
	strCompanyName nvarchar(50),
	dtStartDate date,
	dtEndDate date,
	SinotUsersCovered int,
	SinotTotalWages decimal(18,5),
	SinotTaxableWages decimal(18,5),
	SinotExcludedWages decimal(18,5),
	ChauffeurWages decimal(18,5),
	SinotContributionsPercent decimal(18,5),
	SinotUserTaxOwed decimal(18,5),
	SinotUserTaxRetained decimal(18,5),
	SinotCompanyTaxOwed decimal(18,5),
	SinotUserCompanyRetained decimal(18,5),
	SinotTotalTaxesOwed decimal(18,5)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
--select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName = @PAYITEM 
Declare @SinotTotalWages decimal(18,5)
Declare @SinotTaxableWages decimal(18,5)
Declare @SinotTaxPercent decimal(18,5)
Declare @SinotCompanyTaxPercent decimal(18,5)
declare @UserCovered int
declare @NonSinotWages decimal(18,5)
declare	@UserWithholdings decimal(18,5)
declare	@UserWithholdingsTax decimal(18,5) --Real Number
declare @CompanyContributions decimal(18,5)
declare @CompanyContributionsTax decimal(18,5) --Real Tax Number
declare @ChauffeurWages decimal(18,5)
DECLARE @WithholdingName nvarchar(50)
DECLARE @ChauffeurWithholding nvarchar(50)
declare @SinotTotalTaxes decimal(18,5) --Real Tax Number

--Check for WH that is configured as disability/SINOT
	select top(1) @WithholdingName = ISNULL( wi.strWithholdingsName,''),  @SinotTaxPercent =isnull(decEmployeePercent,0) , @SinotCompanyTaxPercent =isnull(decCompanyPercent,0) from tblCompanyWithholdings wi inner join tblWithholdingsItems_PRPayExport prp on wi.strWithHoldingsName = prp.strWithholdingsName
	where prp.boolDisability = 1 and strCompanyName = @PayrollCompany
	--If none is configured, try the defaults
	iF @WithholdingName = ''
		select top(1) @WithholdingName = ISNULL( wi.strWithholdingsName,'') ,  @SinotTaxPercent =isnull(decEmployeePercent,0) , @SinotCompanyTaxPercent =isnull(decCompanyPercent,0)  from tblWithholdingsItems wi where strWithHoldingsName = 'SINOT'
	iF @WithholdingName = ''
		select top(1) @WithholdingName = ISNULL( wi.strWithholdingsName,'') ,  @SinotTaxPercent =isnull(decEmployeePercent,0) , @SinotCompanyTaxPercent =isnull(decCompanyPercent,0)  from tblWithholdingsItems wi where strWithHoldingsName = 'DISABILITY'

	--Chauffeur Wages
	select top(1) @ChauffeurWithholding = ISNULL( wi.strWithholdingsName,'') from tblWithholdingsItems wi inner join tblWithholdingsItems_PRPayExport prp on wi.strWithHoldingsName = prp.strWithholdingsName
	where prp.boolChauffeur_Insurance = 1
	

--1 Number of Employees Covered by this policy
	 select @UserCovered=  count(distinct intuserid) , @SinotTaxableWages = sum(decTaxablePay), @NonSinotWages =  sum(decPeriodPay)- sum(decTaxablePay) FROM 	[dbo].[fnPay_tblSINOTUserTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,@WithholdingName) where bitWithholdingApplies = 1

--2 Total Salaries for all Employees
	SELECT @SinotTotalWages =sum(decPeriodPay) FROM 	[dbo].[fnPay_tblSINOTUserTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,@WithholdingName) 
--  Taxable Wages
--	Non-Taxable Wages
	 select @UserCovered=  count(distinct intuserid) , @SinotTaxableWages = sum(decTaxablePay), @NonSinotWages =  sum(decPeriodPay)- sum(decTaxablePay) FROM 	[dbo].[fnPay_tblSINOTUserTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,@WithholdingName) where bitWithholdingApplies = 1

--4 Salaries Paid to Chauffeurs
--	 select  @ChauffeurWages =sum(decPeriodPay) FROM 	[dbo].[fnPay_tblSINOTUserTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,@ChauffeurWithholding) WHERE bitWithholdingApplies = 1
	SELECT @ChauffeurWages= isnull(sum(decPay),0) from viewPay_UserBatchCompensations	ubc 
				inner join tblCompensationItems ci on ubc.strCompensationName = ci.strCompensationName
					inner join tblUserPRPayFields upr on ubc.intUserID = upr.intUserID
					where ubc.boolDeleted = 0 and dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany 
					and boolChauffeur = 1 and ci.intCompensationType =1
	 

--8. Amount Due
select @UserWithholdings =  sum(-dbo.fnPay_UserBatchWithholdings_ByDates(intuserid,@WithholdingName,@startdate,@enddate ))From viewPay_UserWithholdingItems uwi where strCompanyName = @PayrollCompany and decCompanyPercent <> 0
	and strWithHoldingsName = @WithholdingName 


SET @UserWithholdingsTax = ROUND(@SinotTaxableWages * @SinotTaxPercent / 100,2)

select @CompanyContributions =  sum(-[dbo].[fnPay_CompanyBatchWithholdings_ByDates](intuserid,@WithholdingName,@startdate,@enddate ))From viewPay_UserWithholdingItems uwi where strCompanyName = @PayrollCompany and decCompanyPercent <> 0
	and strWithHoldingsName = @WithholdingName 

select @CompanyContributionsTax  = ROUND(@SinotTaxableWages * @SinotCompanyTaxPercent / 100,2)

SET @SinotTotalTaxes = ROUND(@SinotTaxableWages* ( @SinotTaxPercent +@SinotCompanyTaxPercent) / 100,2)
--5  = 2-3

	--Select employees that New law applies
	INSERT INTO @tbSINOTReport
	SELECT @PayrollCompany PayrollCompany, @STARTDATE startdate, @ENDDATE endate,  @UserCovered UserCount, 
	@SinotTotalWages SinotTotalWages, @SinotTaxableWages SinotTaxableWages,@NonSinotWages NonTaxableWages ,@ChauffeurWages Chauffeur, @SinotTaxPercent TaxPercent , 
	@UserWithholdingsTax UserExpected, @UserWithholdings UserRetained, 
	@CompanyContributionstax CompanyExpected, @CompanyContributions  CompanyRetained
	,@SinotTotalTaxes


RETURN
END


GO
