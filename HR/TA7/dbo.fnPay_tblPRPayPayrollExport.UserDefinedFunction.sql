USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPRPayPayrollExport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Computes PR Pay Export File for PRPay Tax Reporting
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblPRPayPayrollExport]
(
	@PayrollCompany as nvarchar(50) ,
	@FROMDATE as date,
	@ENDDATE as date
)
RETURNS 
@tblPRPayPayrollExport TABLE 
(
strPayDate nvarchar(50), --A
sSSN  nvarchar(50),--B
EIN nvarchar(50), --C COMPLETE
decCustomDed1 decimal(18,2), --D
decCustomDed2 decimal(18,2), --E
decCustomDed3 decimal(18,2), --F
decCustomDed4 decimal(18,2), --G
decCustomDed5 decimal(18,2), --H
decCustomInc1 decimal(18,2),
decCustomInc2 decimal(18,2),
decCustomInc3 decimal(18,2),
decCustomInc4 decimal(18,2),
decCustomInc5 decimal(18,2), --M
decTaxable1 decimal(18,2),
decTaxable2 decimal(18,2),
decTaxable3 decimal(18,2),
decTaxable4 decimal(18,2),
decTaxable5 decimal(18,2), --R
TotalTaxableIncome nvarchar(50), --s
TotalNonTaxable nvarchar(50), --T
TotalIncome nvarchar(50), --U
TotalDeductions nvarchar(50), --V
NetIncome nvarchar(50), --W
decWages decimal(18,2), --X
decComissions decimal(18,2), --Y
decAllowances decimal(18,2), --Z
decTips decimal(18,2), --AA
dec401Income decimal(18,2), --AB
decOtherRet decimal(18,2), --AC
decCafeteria decimal(18,2), --AD
decReimbursements decimal(18,2), --AE
dec401k decimal(18,2), --AF
decWitholdings decimal(18,2), --AG
decFICA decimal(18,2), --AH
decSocialSecurity decimal(18,2), --AI
decMedicare decimal(18,2), --AJ
decDisabilty decimal(18,2), --AK
decChauffeurInsurance decimal(18,2), --AL
decChauffeurWeeks decimal(18,2), --AM
decOtherDeductions decimal(18,2), --AN
strBlank1 nvarchar(50),
decExemptSalary decimal(18,2), --AP
strBlank2 nvarchar(50), --AO
strHireAct nvarchar(50), --AR
intReference int ,--Reference Number
decHealthCoverageContribution decimal(18,2), --AT
decCharitable_Contribution decimal(18,2), --AN
decMoney_Savings decimal(18,2), --AV
decMedicare_Plus decimal(18,2), --AW
strBlank3 nvarchar(50), --AX
strEndMark  nvarchar(50)--AY END MARK
) 
-- WITH ENCRYPTION
AS
BEGIN
--Select employees that New law applies
INSERT INTO @tblPRPayPayrollExport

SELECT 
 convert(varchar(8),dtpaydate,112) as PayDate, --A
REPLACE([sSSN],'-','') as sSSN ,--B
REPLACE((Select strEIN FROm tblCompanyPayrollInformation where strCompanyName = ubs.strCompanyName),'-','') as EIN, --C COMPLETE

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolCustom_deduction_1 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decCustomDed1, --D

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolCustom_deduction_2 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decCustomDed2, --E

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolCustom_deduction_3 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID ),0)  as decCustomDed3, --F

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolCustom_deduction_4 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID),0) as decCustomDed4, --G

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolCustom_deduction_5 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID),0) as decCustomDed5, --H

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolCustom_income_1 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decCustomInc1,

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolCustom_income_2 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ) ,0)as decCustomInc2,

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolCustom_income_3 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decCustomInc3,

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolCustom_income_4 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decCustomInc4,

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolCustom_income_5 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decCustomInc5, --M

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolNon_taxable_1 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decTaxable1,

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolNon_taxable_2 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decTaxable2,

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolNon_taxable_3 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decTaxable3,

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolNon_taxable_4 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decTaxable4,

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolNon_taxable_5 = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decTaxable5, --R
'' TotalTaxableIncome, --s
'' TotalNonTaxable, --T
'' TotalIncome, --U
'' TotalDeductions, --V
'' NetIncome, --W

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolWages = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decWages, --X

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolCommissions = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decComissions, --Y

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolAllowances = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decAllowances, --Z

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolTips = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decTips, --AA

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.bool401K_Income = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as dec401Income, --AB

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolOther_Retirement = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decOtherRet, --AC

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolCafeteria = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decCafeteria, --AD

COALESCE((select sum(ubc.decPay) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName  
where prp.boolReimbursements = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decReimbursements, --AE

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolCoda_401K = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as dec401k, --AF

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolWithholding = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decWitholdings, --AG

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolFICA = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decFICA, --AH

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolSocialSecurity = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decSocialSecurity, --AI

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolMedicare = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decMedicare, --AJ

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolDisability = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decDisabilty, --AK

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolChauffeur_Insurance = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decChauffeurInsurance, --AL

--CHeck the number of weeks to see where to get them
iif( (select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolChauffeur_Insurance = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID and ubc.decWithholdingsAmount <> 0   group by strbatchid, intUserID  ) IS NOT NULL , COALESCE((SELECT [dbo].[fnPay_NumberOfSundays](ubs.dtstartdateperiod,ubs.dtenddateperiod ) ),0),0) as decChauffeurWeeks, --AM

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolOther_Deductions = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decOtherDeductions, --AN

0,

--Check Exempt Salaries
-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.[boolCoda_ExemptSalary] = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decExemptSalary, --AP

0, --AO

--HIRE ACT
'F', --AR

--Reference Number
ROW_NUMBER() OVER  (ORDER BY ubs.intUserID), --AS

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblCompanyBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolHealth_CoverageContribution = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decHealthCoverageContribution, --AT

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolCharitable_Contribution = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decCharitable_Contribution, --AN

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolMoney_Savings = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decMoney_Savings, --AV

-COALESCE((select sum(ubc.decWithholdingsAmount) from tblUserBatchWithholdings ubc inner join tblWithholdingsItems_PRPayExport prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
where prp.boolMedicare_Plus = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID  group by strbatchid, intUserID  ),0) as decMedicare_Plus, --AW

0, --AX

0 --AY END MARK

FROM viewPay_UserBatchStatus ubs where dtPayDate between @FROMDATE AND @ENDDATE AND strCompanyName = @PayrollCompany
--and intuserid = 4484
ORDER BY intuserid, dtPayDate asc

RETURN
END

GO
