USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblW2FormExport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Returns the fields to file a W2 Form
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblW2FormExport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tblW2FormExport TABLE 
(
	intUserID int,
	strFirstName nvarchar(50),
	strLastName nvarchar(50), --2
	sreHomeAddressLine1 nvarchar(50),
	strHomeAddressLine2 nvarchar(50),
	strtrCity nvarchar(50),
	strState nvarchar(50),
	strZipCode nvarchar(50),
	strSSN  nvarchar(50),--3
	strEIN  nvarchar(50), --4
	decHealth decimal(18,2), --5
	decCharitable  decimal(18,2), --6
	decWages decimal(18,2), --7
	decComissions decimal(18,2), --8
	decAllowances decimal(18,2), --9
	decTips decimal(18,2), --10
	decTotal decimal(18,2), --11
	decReimbursements decimal(18,2), --12
	decTaxWithheld decimal(18,2), --TAX WITHHELD 13
	decRetirementFund decimal(18,2), --14 Retirement Fund
	decCodaPlan decimal(18,2), --CODA PLANS 15
	decExempt decimal(18,2), -- Exempt Salary 16
	decExempt2 decimal(18,2), --16a Exempt
	decSSNWages decimal(18,2), --19
	decSocialSecurity decimal(18,2), --SS Retention 18
	decMedicareWages decimal(18,2), --19
	decMedicare decimal(18,2), --SS Retention 18
	decPropinasSS decimal(18,2),
	decPropinasNoRetenidasSS decimal(18,2),
	decPropinasNoRetenidasMedicare decimal(18,2)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
	--Select employees that New law applies
	INSERT INTO @tblW2FormExport

	SELECT 
	ubs.id,
	LTRIM(SUBSTRING(ubs.name,(SELECT PATINDEX('%,%', ubs.name))+1,100)) AS FirstName, --1
	SUBSTRING(ubs.name,1, iif( (SELECT PATINDEX('%,%', ubs.name))-1 <0, 0,(SELECT PATINDEX('%,%', ubs.name))-1)) AS LastName, --2
	ubs.[sHomeAddressLine1],
	ubs.[sHomeAddressLine2],
	ubs.[strCity],
	ubs.[strState],
	ubs.[strZipCode],
	REPLACE([sSSN],'-','') as sSSN ,--3
	REPLACE((Select strEIN FROm tblCompanyPayrollInformation where strCompanyName = ubs.strCompanyName),'-','') as EIN, --4

	-COALESCE((select sum(ubc.decWithholdingsAmount) from viewpay_userbatchwithholdings ubc inner join tblWithholdingsItems_W2Export prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
	where prp.boolHealth_CoverageContribution = 1 and ubc.intUserID = ubs.intUserID and ubc.dtpaydate between @startdate and @enddate   group by intUserID  ),0) as decHealth, --5

	-COALESCE((select sum(ubc.decWithholdingsAmount) from viewpay_userbatchwithholdings ubc inner join tblWithholdingsItems_W2Export prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
	where prp.[boolCharitable_Contribution] = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decCharitable , --6

	COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_W2Export prp on ubc.strCompensationName = prp.strCompensationName  
	where prp.boolWages = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decWages, --7

	COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_W2Export prp on ubc.strCompensationName = prp.strCompensationName  
	where prp.boolCommissions = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decComissions, --8

	COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_W2Export prp on ubc.strCompensationName = prp.strCompensationName  
	where prp.boolAllowances = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decAllowances, --9

	COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_W2Export prp on ubc.strCompensationName = prp.strCompensationName  
	where prp.[boolTips] = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decTips, --10

	COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_W2Export prp on ubc.strCompensationName = prp.strCompensationName  
	where (prp.[boolTips] = 1 OR prp.boolWages = 1 OR prp.boolCommissions = 1 OR prp.boolAllowances = 1) and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decTotal, --11

	COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_W2Export prp on ubc.strCompensationName = prp.strCompensationName  
	where prp.boolReimbursements = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decReimbursements, --12

	-COALESCE((select sum(ubc.decWithholdingsAmount) from viewpay_userbatchwithholdings ubc inner join tblWithholdingsItems_W2Export prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
	where prp.[boolTaxWithheld] = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decTaxWithheld, --TAX WITHHELD 13

	-COALESCE((select sum(ubc.decWithholdingsAmount) from viewpay_userbatchwithholdings ubc inner join tblWithholdingsItems_W2Export prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
	where prp.[boolGovtRetirementFund] = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decRetirementFund, --14 Retirement Fund

	-COALESCE((select sum(ubc.decWithholdingsAmount) from viewpay_userbatchwithholdings ubc inner join tblWithholdingsItems_W2Export prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
	where prp.[boolCODA_401k] = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decCodaPlan, --CODA PLANS 15

	COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_W2Export prp on ubc.strCompensationName = prp.strCompensationName  
	where prp.[boolExempt_Salaries] = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decExempt, -- Exempt Salary 16

	0 as decExempt2, --16a Exempt
	--decSSNWages
	COALESCE((select -round((sum(decWithholdingsAmount) / .062),0) decComputedWithholdings  from viewPay_UserBatchWithholdings where strWithHoldingsName 
	IN  ( SELECT strWithHoldingsName FROM tblWithholdingsItems_W2Export where [boolSocialSecurity] = 1) and dtpaydate between @startdate and @enddate
	group by intuserid having intUserID = ubs.intUserID ),0) decSSNWages, --19

	-COALESCE((select sum(ubc.decWithholdingsAmount) from viewpay_userbatchwithholdings ubc inner join tblWithholdingsItems_W2Export prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
	where prp.[boolSocialSecurity] = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decSocialSecurity, --SS Retention 18

	--decMedicareWages
	iif (COALESCE((select sum(ubc.decWithholdingsAmount) from viewpay_userbatchwithholdings ubc inner join tblWithholdingsItems_W2Export prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
	where (prp.[boolMedicarePlus] = 1 ) and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID    ),0) <> 0 ,
	COALESCE((select (200000 + -round((sum(decWithholdingsAmount) / .009),0))   from viewPay_UserBatchWithholdings where strWithHoldingsName 
	IN  ( SELECT strWithHoldingsName FROM tblWithholdingsItems_W2Export where [boolMedicarePlus] = 1) and dtpaydate between @startdate and @enddate
	group by intuserid having intUserID = ubs.intUserID ),0),
	COALESCE((select -round((sum(decWithholdingsAmount) / .0145),0) decComputedWithholdings  from viewPay_UserBatchWithholdings where strWithHoldingsName 
	IN  ( SELECT strWithHoldingsName FROM tblWithholdingsItems_W2Export where [boolMedicare] = 1) and dtpaydate between @startdate and @enddate
	group by intuserid having intUserID = ubs.intUserID ),0)) decMedicareWages, --19

	-COALESCE((select sum(ubc.decWithholdingsAmount) from viewpay_userbatchwithholdings ubc inner join tblWithholdingsItems_W2Export prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
	where (prp.[boolMedicare] = 1 OR prp.[boolMedicarePlus]=1) and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID    ),0) as decMedicare, --SS Retention 18
	0 as PropinasSS,
	0 as PropinasNoRetenidasSS,
	0 as PropinasNoRetenidasMedicare

	FROM (SELECT DISTINCT 
	ubs.intUserID, u.id,
	u.name,
	ubs.[sHomeAddressLine1],
	ubs.[sHomeAddressLine2],
	ubs.[strCity],
	ubs.[strState],
	ubs.[strZipCode],
	[sSSN],--3
	ubs.strCompanyName --4
	 FROM  viewPay_UserBatchStatus as ubs inner join tuser u on ubs.intUserID = u.id where ubs.strCompanyName = @PAYROLLCOMPANY AND ubs.dtPayDate between @STARTDATE and @ENDDATE 
	 ) ubs
	 ORDER BY id ASC
RETURN
END



GO
