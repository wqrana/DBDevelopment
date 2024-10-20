USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_CompanySetupInfo]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <5/23/2024>
-- Description:	<To extract data for CompanySetupInfo excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_CompanySetupInfo]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   Declare @companyCount as int = 0
   Select @companyCount = count(*)
   From tCompany

   Declare @workedHourTiers table(WorkedHoursTierDetail nvarchar(1000),nCompRulesID int, nCompRulesTiersID int) 
	
	Insert Into @workedHourTiers
	Select '<' + format(dblTierWorkedHoursMin,'00.00') +','+ format(IIF(dblTierWorkedHoursMax=0,'999.00',dblTierWorkedHoursMax),'00.00') + ',' + format(dblAccrualHours,'00.00') +'>' as WorkedHoursTierDetail,
			nCompRulesID, nCompRulesTiersID
	From tCompensationWorkedHoursTiers
	Where nTierNum =1
   --cte temp table records for PTO detail
	 ;with cte_accrualTypeTrans as
	(
	 Select [Name], 'VA' as AccrualType from tTransDef where nCountsForVacationAccrual = 1  --VA
	 Union
	 select [Name], 'SA' from tTransDef where nCountsForSickAccrual = 1 --SA
	 )
	 , 
	-- cte_workHourTiers as
	--(
	--Select '<' + format(dblTierWorkedHoursMin,'00.00') +','+ format(IIF(dblTierWorkedHoursMax=0,'999.00',dblTierWorkedHoursMax),'00.00') + ',' + format(dblAccrualHours,'00.00') +'>' as WorkedHoursTierDetail,
	--nCompRulesID,nCompRulesTiersID
	--From tCompensationWorkedHoursTiers
	--Where nTierNum =1
	--),
	cte_PTO as
	(
	SELECT
	sCompensationRuleName as policyName -- 'Time Off Policy Name'-- (Sick, Vacation, Jury Duty, etc.):
	,'Y' as balTracking -- 'Is a balance tracked for this policy' --: Y (Yes) or N (No)
	,'ALL' as  eligibleEmp --'Which employees are eligible for this policy' -- (Full time, Part time, Salary, etc.):
	,sAccrualTypeID as accrualType -- 'What is the accrual type' --- (fixed, calculated, hours-worked):
	--,'Monthly' as awardedFrequency --'What is the award frequency' -- (Weekly, Bi-Weekly, Monthly, Yearly, etc. ):
	,IIF(crt.nResetAccruedHoursType=1,'Yearly', 'Monthly') as awardedFrequency --'What is the award frequency' -- (Weekly, Bi-Weekly, Monthly, Yearly, etc. ):
	--,'First of the Month' as whenAwarded -- 'Within the award frequency' -- when does the award distribute (Fridays, First of the Month, January 1st):
	,IIF(crt.nResetAccruedHoursType=1,'1st Jan', 'First of the Month') as whenAwarded -- 'Within the award frequency' -- when does the award distribute (Fridays, First of the Month, January 1st):

	,IIF(cr.nUseYearsWorked = 0,'N','Y') as isTenureBased  -- 'Is the award based on tenure' --: Y (Yes) or N (No)
	,'calendar year' as isTenureBasedOn -- Is tenure based on calendar year or anniversary date:
	,'N' as useCustomTenure --'Do any employees use custom tenure dates different from their hire dates' --: Y (Yes) or N (No)
	--,'<' + IIF(crt.nWaitingPeriodType = 0,'N','Y') + ',' +  cast(crt.nWaitingPeriodLength as varchar(2))  + '>' as isPolForNewHire -- 'Is the policy prorated for new hires' -- and if so how: 
	,IIF(IsNull(WorkedHoursTiersCount,0) > 1,'Y','N')  as isPolForNewHire -- 'Is the policy prorated for new hires' -- and if so how:
	, IIF((select isnull(TimeAideWebDatabase,'') from ClientInfo)='' ,'N','Y') as submitTimeOffReq --'Will employees submit their own time off requests' 
	,'Hours' as timeOffTracked -- 'Is time off tracked in hours or days' --?
	,'N' as waitingPeriod --'Do you have any waiting periods on earning or using time off' 
	,'' as BalCarryover --'Do balances carryover year to year and if so, on what date' 
	,'N' as timeOffRestriction -- 'Are there any restrictions to days when this time off can be taken'
	,'N' as timeOffRules -- 'Are there any rules for increments of how much time off must be requested at once'
	,'Y' as balOnPayStub -- 'Do balances print on pay stubs' 
	,'N' as accrualOnPayStub -- 'Do accruals each period print on pay stubs'
	,IIF((select isnull(TimeAideWebDatabase,'') from ClientInfo)='' ,'N','Y') as isTimeOffApprovedBy -- 'Is time off approved by each person’s supervisor or some other user' 
	,'<'+  STUFF (
			(SELECT ','+[Name]  FROM cte_accrualTypeTrans Where AccrualType=cr.sAccrualTypeID FOR XML PATH (''),type
			).value('(./text())[1]','varchar(max)'),1,1,'') +'>'
	as hoursTypeContribution --   'For hours-based accruals only, which hours types contribute towards accruing time off' 
	,'Hours Tiers' as accrualCalcBase -- 'For hours-based accruals only, how are accruals calculated based on hours worked' 
	,STUFF (
			(SELECT ','+WorkedHoursTierDetail  FROM @workedHourTiers Where nCompRulesID=crt.nCompRulesID And nCompRulesTiersID=crt.ID FOR XML PATH (''),type
			).value('(./text())[1]','varchar(max)'),1,1,'') as accrueHoursEligibility -- ' For hours-based accruals only, is there a maximum number of hours eligible to accrue per period' 
	,'Discard' as hoursNotUsed -- 'For hours-based accruals only, what should happen to hours that did not contribute to an accrual '

	FROM tCompensationRules cr 
	INNER JOIN tCompensationRulesTiers crt on cr.ID = crt.nCompRulesID and crt.nTierNum = 1
	LEFT JOIN(Select nCompRulesTiersID, count(*) WorkedHoursTiersCount 
				From tCompensationWorkedHoursTiers  
				group by nCompRulesTiersID) WorkedHoursTiers on WorkedHoursTiers.nCompRulesTiersID = crt.ID
	WHERE cr.ID in (Select Distinct ncomprulesid From tusercompensationrules)
	),
	cte_PTOAccrualAward as
	(
	SELECT  
	cr.sCompensationRuleName as policyName --Time Off Policy Name (Sick, Vacation, Jury Duty, etc.):      
	,format(crt.dblYearsWorkedFrom *12.0,'0.00')  +'-' + format(crt.dblYearsWorkedTo*12.0,'0.00') as TierMonths --Tier months:  0-12, 13-24 etc. 
	--,crt.dblAccrualHours  --Accrual/Award Amount: 1.00, 3.06 etc.
	,STUFF (
			(SELECT ','+WorkedHoursTierDetail  FROM @workedHourTiers Where nCompRulesID=crt.nCompRulesID And nCompRulesTiersID=crt.ID FOR XML PATH (''),type
			).value('(./text())[1]','varchar(max)'),1,1,'') as accrualAward
	,crt.dblAllowedMaxHours --Max Total Accrual Hours  
	,nCarryOverMaxType  --Max Carry Over Hours
	,dblCarryOverMaxHours --Max Balance Hours
	FROM tCompensationRules cr 
	INNER JOIN tCompensationRulesTiers crt ON cr.ID = crt.nCompRulesID and crt.nTierNum = 1	
	WHERE cr.ID in (Select Distinct ncomprulesid From tusercompensationrules)
	)
 --end cte section

   SELECT 
	'' AS [Seller's Client ID],
	CMPpayrollInfo.strCompanyName as [Legal Name],
	CMPpayrollInfo.strPayrollName as [DBA Name],
	CMPpayrollInfo.strAddress1 as [Legal Address],
	CMPpayrollInfo.strCity as [City],
	CMPpayrollInfo.strState as [State],	
	CONCAT('''',CMPpayrollInfo.strZipCode) as [Zip],
	CMPpayrollInfo.strPayrollAddress1 as [Delivery Address Line1],
	CMPpayrollInfo.strPayrollAddress2 as [Delivery Address Line2],
	CMPpayrollInfo.strPayrollCity as [Delivery City],
	CMPpayrollInfo.strPayrollState as [Delivery State],	
	CONCAT('''',CMPpayrollInfo.strPayrollZipCode) as [Delivery Zip],
	CMPpayrollInfo.strContactName as [Primary Contact Person],
	CMPpayrollInfo.strPhone as [Primary Contact Phone Number],
	CMPpayrollInfo.strEmail as [Primary Contact Email],
	CMPpayrollInfo.strPayrollContactName as [Secondary Contact Person],
	CMPpayrollInfo.strPayrollContactPhone as [Secondary Contact Phone Number],
	CMPpayrollInfo.strPayrollEmail as [Secondary Contact Email],
	STUFF (
		(Select distinct ','+ case nPayPeriod when 0 then 'Weekly' when 1 then 'Biweekly' when 2 then 'Semimonthly' end 
		From tPayrollRule PR 
		Inner Join [dbo].[tblCompanyPayrollRules] cpr on pr.ID = cpr.intPayrollRule
		Where cpr.strPayrollCompany = CMPpayrollInfo.strCompanyName		
		FOR XML PATH (''),type
		).value('(./text())[1]','varchar(max)'),1,1,'') as [Payroll Frequency],
	--CONCAT('<','','|','','|','','|','','|','','>') as [Payroll Group Calendar],
	STUFF (
	(Select  distinct ','+
	CONCAT('<',case nPayPeriod when 0 then 'Weekly' when 1 then 'Biweekly' when 2 then 'Semimonthly' end,'|', b.strBatchDescription,'|',replace(convert(varchar, b.dtPayDate,101),'/',''),'|',replace(convert(varchar,  rw.DTStartDate,101),'/',''),'|',replace(convert(varchar,  rw.DTEndDate,101),'/',''),'>')
	From tblBatch B inner join tblCompanySchedulesProcessed csp on b.strBatchID = csp.strBatchID
	Inner Join (Select nPayRuleID, nPayWeekNum, DTStartDate, DTEndDate From tReportWeek rw ) rw  on csp.intPayWeekNumber = rw.nPayWeekNum
	Inner Join tPayrollRule pr on rw.nPayRuleID = pr.id
	Where dtPayDate in (Select max(dtPayDate) From tblBatch Where intBatchType = 0 and strCompanyName=CMPpayrollInfo.strCompanyName)
	And B.strCompanyName = CMPpayrollInfo.strCompanyName 
	FOR XML PATH (''),type
	).value('(./text())[1]','varchar(max)'),1,1,'') as [Payroll Group Calendar],
	'N' as [Seasonal Client],
	--'N' as [Additional Control],
	IIF(@companyCount>1,'Y','N') as  [Additional Control],
	--'<'+ISNULL(accTypes.strBankAccountDescription,'')+'|'+ISNULL(CMPBankAcc.strBankName,'')+'|'+ISNULL(CMPBankAcc.strBankRoutingNumber,'')+'|'+ISNULL(CMPBankAcc.strBankAccountNumber,'')+'>' as [Bank Info],
	CONCAT('<','All','|',ISNULL(CMPBankAcc.strBankName,''),'|',ISNULL(CMPBankAcc.strBankRoutingNumber,''),'|',ISNULL(CMPBankAcc.strBankAccountNumber,''),'>') as [Bank Info],
	'' as [Client Banking Tier],
	'' as [DBA Name ON CHECKS],
	'' as [Payroll Only],
	CMPpayrollInfo.strEIN as [FEIN],
	IIF( exists(select * from tblCompanyWithholdings where strCompanyName=CMPpayrollInfo.strCompanyName and strWithHoldingsName = 'FUTA') , 'N','Y') as [FUTA Exempt],
	--CONCAT('<','','|','','|','','|','','|','','>') as [State Income Tax IDs],
	CONCAT('<','PR','|',CMPpayrollInfo.strEIN,'|',0,'|',StateTaxDepFrequency,'|','A','>') as [State Income Tax IDs],
	--CONCAT('<','','|','','|','','|','','|','','|','','>') as [State Unemployment Tax IDs],
	CONCAT('<','PR','|',CMPpayrollInfo.strEIN,'|',decDepartamentoDelTrabajoRate,'|','0','|','N','|','A','>') as [State Unemployment Tax IDs],
	--CONCAT('<','','|','','|','','|','','|','','|','','|','','|','','|','','|','','|','','>') as [Local Income Tax IDs],
	'' as [Local Income Tax IDs],
	--CONCAT('<','','|','','>') as [Nevada Modified Business Tax],
	'' as [Nevada Modified Business Tax],
	--CONCAT('<','','|','','>') as [Washington Unified Business Identifier (UBI)],
	'' as [Washington Unified Business Identifier (UBI)],
	--CONCAT('<','','|','','>') as [Washington Labor & Industries (L&I)],
	''  as [Washington Labor & Industries (L&I)],
	--CONCAT('<','','|','','|','','>') as [Washington Worker's Compensation Class Code/Description],
	'' as [Washington Worker's Compensation Class Code/Description],
	--CONCAT('<','','|','','|','','>') as [Washington Worker's Compensation],
	'' as [Washington Worker's Compensation],
	--CONCAT('<',CMPpayrollInfo.strNAICSCode,' - ','','>') as [Maryland NAICS Code],
	'' as [Maryland NAICS Code],
	--CONCAT('<','','|','','>') as [Maryland County Code],
	 '' as [Maryland County Code],
	--CONCAT('<','','|','','>') as [Oregon Worker's Benefit Fund],
	'' as [Oregon Worker's Benefit Fund],
	'' as [Sales Tax Exempt],
	'' as [Client Signature on Pay Statement],
	'' as [Company Logo on Pay Statement],
	'' as [Pay Statement Custom Layout],
	--CONCAT('<','','|','','|','','|','','|','','>') as [Deductions],
	STUFF (
		(SELECT ','+ CONCAT('<',strWithholdingsName,'|',strWithholdingsName,'|',Case intPrePostTaxDeduction When  0 then 'Pretax' else 'Posttax' end,'|','Every Payroll','|','N','>') FROM tblCompanyWithholdings WHERE strCompanyName=CMPpayrollInfo.strCompanyName AND strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS') FOR XML PATH (''),type
		).value('(./text())[1]','varchar(max)'),1,1,'') as [Deductions],
	--CONCAT('<','','|','','|','','|','','>')  as [Earnings],
	--STUFF (
	--	(SELECT ','+ CONCAT('<',strCompensationName,'|',strCompensationName,'|','1.0','|','','>') FROM tblCompanyCompensations WHERE strCompanyName=CMPpayrollInfo.strCompanyName FOR XML PATH (''),type
	--	).value('(./text())[1]','varchar(max)'),1,1,'') as [Earnings],
	STUFF (
		(
		SELECT distinct ','+ CONCAT('<',cc.strCompensationName,'|',ct.strTransName,'|',decPayRateMultiplier,'|',IIF(cc.intCompensationType=1,'','N'),'>') 
		FROM tblCompanyCompensations cc
		INNER JOIN  tblCompensationItems ci on cc.strCompensationName = ci.strCompensationName
		INNER JOIN tblCompensationTransactions ct on ci.strCompensationName = ct.strCompensationName
		INNER JOIN  tTransDef td on ct.strTransName = td.Name
		WHERE cc.strCompanyName=CMPpayrollInfo.strCompanyName		
		FOR XML PATH (''),type
		).value('(./text())[1]','varchar(max)'),1,1,'') as [Earnings],
	--CONCAT('<','','|','','|','','|','','|','','>') as [Memos],
	STUFF (
		(SELECT ','+ CONCAT('<',strWithholdingsName,'|',strWithholdingsName,'|','|','>') FROM tblWithholdingsItems WHERE strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS') AND boolCompanyContribution=1 FOR XML PATH (''),type
		).value('(./text())[1]','varchar(max)'),1,1,'') as [Memos],
	--CONCAT('<','','|','','>') as [Departments],
	STUFF (
		(SELECT ','+ CONCAT('<',ID,'|',Name,'>') FROM tDept  FOR XML PATH (''),type
		).value('(./text())[1]','varchar(max)'),1,1,'') as [Departments],
	--CONCAT('<','','|','','>') as [Home Cost Center],
	'' as [Home Cost Center],
	--CONCAT('<','','|','','>') as [Location Code],
	''  as [Location Code],
	--CONCAT('<','','|','','>') as [Job Class],
	''  as [Job Class],
	--CONCAT('<','','|','','>') as [Job Title],
	STUFF (
		(SELECT ','+ CONCAT('<',ID,'|',Name,'>') FROM tJobTitle WHERE Len([name])>0  FOR XML PATH (''),type
		).value('(./text())[1]','varchar(max)'),1,1,'')  as [Job Title],
	--CONCAT('<','','|','','>') as [Termination Reasons],
	'' as [Termination Reasons],
	--CONCAT('<','','|','','>') as [Hire Reason Code],
	'' as [Hire Reason Code],
	--CONCAT('<','','|','','>') as [Rehire Reason Code],
	'' as [Rehire Reason Code],
	--CONCAT('<','','|','','>') as [Leave of Absence Reason Code],
	''  as [Leave of Absence Reason Code],
	'' as [FLSA OT],
	'' as [Group Term Life],
	'' as [3rd Party Sick Pay],
	--CONCAT('<','','|','','>') as [Calculated Earnings],
	''  as [Calculated Earnings],
	--CONCAT('<','','|','','>') as [Calculated Deductions],
	''  as [Calculated Deductions],
	--CONCAT('<','','|','','>') as [0],
	'' as [0],
	--CONCAT('<','','|','','>') as [Union Calculation],
	'' as [Union Calculation],
	--CONCAT('<','','|','','|','','|','','|','','|','','|','','|','','|','','|','','|','','|','','|','','|','','|','','|','','|','','|','','|','','>') as [PTO],
	STUFF (
		(SELECT ','+CONCAT('<',policyName,'|',balTracking,'|',eligibleEmp,'|',accrualType,'|',awardedFrequency,'|',whenAwarded,'|',isTenureBased,'|',isTenureBasedOn,'|',useCustomTenure,'|',isPolForNewHire,'|',submitTimeOffReq,'|',timeOffTracked,'|',waitingPeriod,'|',BalCarryover,'|',timeOffRestriction,'|',timeOffRules,'|',balOnPayStub,'|',accrualOnPayStub,'|',isTimeOffApprovedBy,'|',hoursTypeContribution,'|',accrualCalcBase,'|',accrueHoursEligibility,'|',hoursNotUsed,'>')  FROM cte_PTO FOR XML PATH (''),type
		).value('(./text())[1]','varchar(max)'),1,1,'')  as [PTO],
	--CONCAT('<','','|','','|','','|','','|','','|','','>')as [PTO Accrual Tiers],
	STUFF (
		(SELECT ','+CONCAT('<',policyName,'|',TierMonths,'|',accrualAward,'|',nCarryOverMaxType,'|',dblAllowedMaxHours,'|',dblCarryOverMaxHours,'>')  FROM cte_PTOAccrualAward FOR XML PATH (''),type
		).value('(./text())[1]','varchar(max)'),1,1,'')  as [PTO Accrual Tiers],
	--CONCAT('<','','|','','>') as [Company Property],
	''  as [Company Property],
	--CONCAT('<','','|','','>') as [Custom Fields],
	''  as [Custom Fields],
	'' as [Time & Labor Pay Policies],
	'' as [Custom Reports],
	'' as [Certified Reports],
	'' as [Custom GL],
	STUFF (
		(SELECT ','+ CONCAT('<',ID,'|',Name,'>') FROM tEmployeeType  FOR XML PATH (''),type
		).value('(./text())[1]','varchar(max)'),1,1,'') as [Employee Types]

	FROM  tblCompanyPayrollInformation CMPpayrollInfo
	INNER JOIN tblCompanyBankAccounts CMPBankAcc on CMPpayrollInfo.strCompanyName = CMPBankAcc.strCompanyName
	LEFT JOIN tblBankAccountTypes accTypes on accTypes.intBankAccountType = CMPBankAcc.intBankAccountType
	LEFT JOIN (Select distinct FederalTaxDepositScheduleName as StateTaxDepFrequency, strCompanyName
				From tblCompanyOptions cOp 
				Inner Join FederalTaxDepositSchedule fds on cOp.FederalTaxDepositScheduleId = fds.FederalTaxDepositScheduleId
				) as StateTaxDepositFreqency on StateTaxDepositFreqency.strCompanyName = CMPpayrollInfo.strCompanyName 
	LEFT JOIN (Select distinct HaciendaTaxDepositScheduleName as HaciendaTaxDepFrequency, strCompanyName
				From tblCompanyOptions cOp 
				Inner Join HaciendaTaxDepositSchedule hds on cOp.HaciendaTaxDepositScheduleId = hds.HaciendaTaxDepositScheduleId
				) as HaciendaTaxDepositFreqency on HaciendaTaxDepositFreqency.strCompanyName = CMPpayrollInfo.strCompanyName 
END
GO
