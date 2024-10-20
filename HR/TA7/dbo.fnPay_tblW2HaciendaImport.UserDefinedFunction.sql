USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblW2HaciendaImport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnPay_tblW2HaciendaImport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tblW2FormExport TABLE 
(
	intUserID int,
	strFirstName nvarchar(30),  
	strMiddleName nvarchar(1), --ADD
	strLastFather nvarchar(50), --2 --FIX
	strLastMother nvarchar(50), --2 --FIX
	strSocialSecurityNo  nvarchar(50),--3
	strAddressLine1 nvarchar(50),
	strAddressLine2 nvarchar(50),
	strCity nvarchar(22),
	strState nvarchar(2),
	strZipCode nvarchar(9),
	strDateOfBirth nvarchar(10), 
	decHealth decimal(18,2), --5
	decCharitable  decimal(18,2), --6
	decWages decimal(18,2), --7
	decComissions decimal(18,2), --8
	decAllowances decimal(18,2), --9
	decTips decimal(18,2), --10
	decTotal decimal(18,2), --11
	decReimbursedExpenses decimal(18,2), --12
	decTaxWithheld decimal(18,2), --TAX WITHHELD 13
	decRetirementFund decimal(18,2), --14 Retirement Fund
	decCodaPlan decimal(18,2), --CODA PLANS 15
	decExemptSalaries decimal(18,2), -- Exempt Salary 16 (Line 16)
	strExemptSalariesCode nvarchar(3), -- Exempt Salary Code (Line 16)
	decExemptSalaries2 decimal(18,2), --16a Exempt (Line 16a)
	strExemptSalariesCode2 nvarchar(3), -- Exempt Salary Code (Line 16a)
	decSaveDoubleMoney decimal(18,2), --SaveDoubleMoney - (Line 16B)
	decSociaslSecurityNWages decimal(18,2), --19
	decSocialSecurityWithheld decimal(18,2), --SS Retention 18
	decMedicareWagesAndTips decimal(18,2), --19
	decMedicareWithheld decimal(18,2), --Medicare Retention 18
	decSocSecTips decimal(18,2),
	decUncollectedSocSecTips decimal(18,2), --LINE(22)
	decUncollectedMedicareTips decimal(18,2) --(LINE 23)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
	--Select employees that New law applies
	INSERT INTO @tblW2FormExport

	SELECT 
	ubs.intUserID as intUserID,
	 ubs.name as strFirstName,
	 '' as strMiddleName,
	 '' as strLastFather,
	 '' as strLastMother,
	--LEFT(iif( Charindex(' ',LTRIM(SUBSTRING(ubs.name,(SELECT PATINDEX('%,%', ubs.name))+1,100))) >0,
	--left(LTRIM(SUBSTRING(ubs.name,(SELECT PATINDEX('%,%', ubs.name))+1,100)),Charindex(' ',LTRIM(SUBSTRING(ubs.name,(SELECT PATINDEX('%,%', ubs.name))+1,100)))),
	--LTRIM(SUBSTRING(ubs.name,(SELECT PATINDEX('%,%', ubs.name))+1,100))),30) AS strFirstName, --1 

	--LEFT(iif(CHARINDEX(' ', REVERSE(SUBSTRING(ubs.name,(SELECT PATINDEX('%,%', ubs.name))+1,100)))< LEN(REVERSE(SUBSTRING(ubs.name,(SELECT PATINDEX('%,%', ubs.name))+1,100))),	
	--substring(RIGHT(SUBSTRING(ubs.name,(SELECT PATINDEX('%,%', ubs.name))+1,100), 
	--CHARINDEX(' ', REVERSE(SUBSTRING(ubs.name,(SELECT PATINDEX('%,%', ubs.name))+1,100))) - 1),1,1),''),1) AS strMiddleName, --1 

	--LEFT(left(SUBSTRING(ubs.name,1, iif( (SELECT PATINDEX('%,%', ubs.name))-1 <0, 0,(SELECT PATINDEX('%,%', ubs.name))-1)),charindex(' ', SUBSTRING(ubs.name,1, iif( (SELECT PATINDEX('%,%', ubs.name))-1 <0, 0,(SELECT PATINDEX('%,%', ubs.name))-1)))),50) AS strLastFather, --2 

	--LEFT(Right(SUBSTRING(ubs.name,1, iif( (SELECT PATINDEX('%,%', ubs.name))-1 <0, 0,(SELECT PATINDEX('%,%', ubs.name))-1)),
	--charindex(' ', REVERSE(SUBSTRING(ubs.name,1, iif( (SELECT PATINDEX('%,%', ubs.name))-1 <0, 0,(SELECT PATINDEX('%,%', ubs.name))-1))) )),50) AS strLastMother, --2

	LEFT(REPLACE([sSSN],'-',''),9) as sSSN ,--3
	LEFT(isnull(ubs.[sHomeAddressLine1],''),50),
	LEFT(isnull(ubs.[sHomeAddressLine2],''),50),
	LEFT(isnull(ubs.[strCity],''),22),
	LEFT( iif( charindex('P',isnull(ubs.[strState],''))>=1, 'PR',iif( charindex('U',isnull(ubs.[strState],'')) >0,'US','')),2) as strState,
	LEFT(isnull(ubs.[strZipCode],''),9),
	
	iif( (SELECT CAST(count(nuserid) AS INT) as Count  FROM tUserExtended WHERE dBirthDate > DATEADD(year, -26, @ENDDATE) AND dBirthDate < DATEADD(year, -16, @ENDDATE ) and nuserid = ubs.intuserid) > 0, isnull((select top(1) convert(varchar(10), dBirthDate,101) from tUserExtended  where nUserID = ubs.intUserID and dBirthDate IS NOT NULL),'') , '' ) as strDateOfBirth, --FIX MM/DD/YYYY

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
	
	 iif (COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_W2Export prp on ubc.strCompensationName = prp.strCompensationName  
	 where prp.boolWages = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) > 40000.00 
	 ,40000.00,	
	 COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_W2Export prp on ubc.strCompensationName = prp.strCompensationName  
	 where prp.boolWages = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) ) as decExempt, -- Exempt Salary 16
	 
	iif( (SELECT CAST(count(nuserid) AS INT) as Count  FROM tUserExtended WHERE dBirthDate > DATEADD(year, -26, @ENDDATE) AND dBirthDate < DATEADD(year, -16, @ENDDATE ) and nuserid = ubs.intuserid) > 0, 'E', '' ) as strExemptSalariesCode, --FIX

	0 as decExempt2, --16a Exempt --FIX

	'' as strExemptSalariesCode2, --FIX

	-COALESCE((select sum(ubc.decWithholdingsAmount) from viewpay_userbatchwithholdings ubc inner join tblWithholdingsItems_W2Export prp on ubc.strWithHoldingsName = prp.strWithholdingsName  
	where prp.[boolSaveAndDouble] = 1 and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) as decSaveDoubleMoney, 

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
	COALESCE((select -round((sum(decWithholdingsAmount) / .062),0) decComputedWithholdings  from viewPay_UserBatchWithholdings where strWithHoldingsName 
	IN  ( SELECT strWithHoldingsName FROM tblWithholdingsItems_W2Export where [boolSocialSecurity] = 1) and dtpaydate between @startdate and @enddate
	group by intuserid having intUserID = ubs.intUserID ),0) ) decMedicareWagesAndTips, --19

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
