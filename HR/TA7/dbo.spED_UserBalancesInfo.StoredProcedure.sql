USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_UserBalancesInfo]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <6/6/2024>
-- Description:	<To extract data for User Balances excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_UserBalancesInfo]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @YSDate datetime = Cast(concat('01/01/',year(getdate())) as datetime)
	DECLARE @YTDate datetime = Getdate()	
	DECLARE @pvtColSet1 AS NVARCHAR(MAX),@pvtColSet2 AS NVARCHAR(MAX),@earningsColSet AS NVARCHAR(MAX)
	DECLARE @earningsDataColSet AS NVARCHAR(MAX), @sqlQuery AS NVARCHAR(MAX);
	
	--Earning pair data 
	SET @pvtColSet1 = STUFF(
		(SELECT ',' +CONCAT('[',[strCompensationName],'-','Hours',']') FROM tblCompensationItems GROUP BY strCompensationName FOR XML PATH('')),
		1, 1, '');

	SET @pvtColSet2 = STUFF(
    (SELECT ',' +CONCAT('[',[strCompensationName],'-','Earnings',']') FROM tblCompensationItems GROUP BY strCompensationName FOR XML PATH('')),
    1, 1, '');	

	SET @earningsDataColSet = STUFF(
    (SELECT ',' +CONCAT('[',[strCompensationName],'-','Hours',']')+','+CONCAT('[',[strCompensationName],'-','Earnings',']') FROM tblCompensationItems GROUP BY strCompensationName FOR XML PATH('')),
    1, 1, '');

	SET @earningsColSet = CONCAT('intUserID,strBatchID,',@earningsDataColSet);

	--select @earningsColSet

	-- earning dynamic query
	-- Compensations hours
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##CompensationHrsYTD
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserID,strBatchID,Concat([strCompensationName],''-Hours'') as strCompensationName,[decHours]
			FROM tblUserBatchCompensations
			WHERE dtPayDate BETWEEN '''+ CONVERT(varchar,@YSDate,101)+''' AND '''+ CONVERT(varchar,@YTDate,101)+'''
		) CompensationHrData   
		 PIVOT (
			SUM([decHours])
			FOR [strCompensationName] IN (' + @pvtColSet1 + ')	
		) AS PT1	
		) tblEarnings'
	--select @query
	Drop table If Exists ##CompensationHrsYTD
	Exec sp_executesql @sqlQuery
--	select * from ##CompensationHrsYTD
	--Compensations amount
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##CompensationEarnYTD
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserID as intEUserID,strBatchID as strEBatchID,Concat([strCompensationName],''-Earnings'') as strCompensationName, [decPay]
			FROM tblUserBatchCompensations
			WHERE dtPayDate BETWEEN '''+ CONVERT(varchar,@YSDate,101)+''' AND '''+ CONVERT(varchar,@YTDate,101)+'''
		) CompensationEarnData   
		 PIVOT (
			SUM([decPay])
			FOR [strCompensationName] IN (' + @pvtColSet2 + ')	
		) AS PT1
	
		) tblEarnings'
	--select @query
	Drop table If Exists ##CompensationEarnYTD
	Exec sp_executesql @sqlQuery
	--select * from ##CompensationEarnYTD
	
	Set @sqlQuery=N'
	Select '+@earningsColSet+'
	Into ##tempEarningYTD	
	From ##CompensationHrsYTD  p1
	Inner Join ##CompensationEarnYTD p2 on p1.intUserId= p2.intEUserID And p1.strBatchID=p2.strEBatchID' 
	Drop table If Exists ##tempEarningYTD
	Exec sp_executesql @sqlQuery
	--select @sqlQuery
	--Select * from ##tempEarningYTD	
    --end earning pair
	--PreTax & PostTax Deductions  data YTDate
	SET @pvtColSet1 = STUFF(
		(SELECT ',' +CONCAT('[','PreTax-',[strWithHoldingsName],'-','Deduction',']') FROM tblWithholdingsItems WHERE intPrePostTaxDeduction=0 And strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS', 'ST ITAX', 'SUTA') GROUP BY [strWithHoldingsName] FOR XML PATH('')),
		1, 1, '');
	SET @pvtColSet2 = STUFF(
		(SELECT ',' +CONCAT('[','PostTax-',[strWithHoldingsName],'-','Deduction',']') FROM tblWithholdingsItems WHERE intPrePostTaxDeduction=1  And strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS', 'ST ITAX', 'SUTA') GROUP BY [strWithHoldingsName] FOR XML PATH('')),
		1, 1, '');
	--PreTax deduction
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##PreTaxDeductionYTD
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserID,strBatchID,Concat(''PreTax-'',[strWithHoldingsName],''-Deduction'') as strWithHoldingsName,[decWithholdingsAmount]
			FROM tblUserBatchWithholdings
			WHERE dtPayDate BETWEEN '''+ CONVERT(varchar,@YSDate,101)+''' AND '''+ CONVERT(varchar,@YTDate,101)+'''
		) WithHoldingData   
		 PIVOT (
			SUM([decWithholdingsAmount])
			FOR [strWithHoldingsName] IN (' + @pvtColSet1 + ')	
		) AS PT1	
		) tblPreTaxDeduction'
	
	Drop table If Exists ##PreTaxDeductionYTD
	Exec sp_executesql @sqlQuery
	--select * from ##PreTaxDeductionYTD
	--PostTax Deduction
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##PostTaxDeductionYTD
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserID,strBatchID,Concat(''PostTax-'',[strWithHoldingsName],''-Deduction'') as strWithHoldingsName,[decWithholdingsAmount]
			FROM tblUserBatchWithholdings
			WHERE dtPayDate BETWEEN '''+ CONVERT(varchar,@YSDate,101)+''' AND '''+ CONVERT(varchar,@YTDate,101)+'''
		) WithHoldingData   
		 PIVOT (
			SUM([decWithholdingsAmount])
			FOR [strWithHoldingsName] IN (' + @pvtColSet2 + ')	
		) AS PT1	
		) tblPreTaxDeduction'
	
	Drop table If Exists ##PostTaxDeductionYTD
	Exec sp_executesql @sqlQuery
	--select * from ##PostTaxDeductionYTD
	-- Memos list
	SET @pvtColSet1 = STUFF(
    (SELECT ',' + +CONCAT('[','NonTaxable-',[strWithHoldingsName],'-','Memo',']') FROM tblWithholdingsItems WHERE strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS', 'ST ITAX', 'SUTA') AND boolCompanyContribution=1 GROUP BY [strWithHoldingsName] FOR XML PATH('')),
    1, 1, ''
	);
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##NonTaxableMemosYTD
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserID,strBatchID,Concat(''NonTaxable-'',[strWithHoldingsName],''-Memo'') as strWithHoldingsName,[decWithholdingsAmount]
			FROM tblCompanyBatchWithholdings
			WHERE dtPayDate BETWEEN '''+ CONVERT(varchar,@YSDate,101)+''' AND '''+ CONVERT(varchar,@YTDate,101)+'''
		) WithHoldingData   
		 PIVOT (
			SUM([decWithholdingsAmount])
			FOR [strWithHoldingsName] IN (' + @pvtColSet1 + ')	
		) AS PT1	
		) tblMemos'
	
	Drop table If Exists ##NonTaxableMemosYTD
	Exec sp_executesql @sqlQuery
	--select * from ##NonTaxableMemosYTD
	--end
--	return;
SELECT 
	userBatch.strCompanyName as [Company Name],	
	strEIN as [Company Federal ID],
	userBatch.intUserId as [File #/Employee ID],
	userBatch.strUserName as [Employee Full Name],
	Case Len(userBatch.sSSN) When 9 Then format(CAST(sSSN as int),'###-##-####') Else sSSN End as [Social Security Number],
	Convert(varchar,userBatch.dtEndDatePeriod,101) as [Period End Date],
	Convert(varchar,userBatch.dtPayDate,101) as [Check Date],
	(STUFF(
		(SELECT '|' + Cast(intCheckNumber as varchar)
		 FROM tblUserPayChecks 
		 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
		 FOR XML PATH('')),
		1, 1, '')
	) as [Check #],	
	DATEPART(QUARTER, userBatch.dtPayDate) as [Quarter #],
	(Select sum(decHours)
	 From tblUserBatchCompensations
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	) as [Reg Hours Bal],
	userBatch.decBatchUserCompensations as [Reg Earnings Bal],
	'' as [Salaried hours],
	'' as [Salaried Earnings],
	( Select sum(decHours)
	 From tblUserBatchCompensations
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	 And strCompensationName='Overtime'
	)  as [Ovt Hours Bal],
	( Select sum(decPay)
	 From tblUserBatchCompensations
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	 And strCompensationName='Overtime'
	) as [Ovt Earnings Bal],
	--Client Hours Code or Description and amount fields(multiple) Earnings
	tblYTDEarnings.*,
	userBatch.decBatchUserCompensations as [Gross Pay],
	( Select sum(decWithholdingsAmount)
	 From tblUserBatchWithholdings
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	 And strWithHoldingsName in('FICA SS','FICA MED','FICA MED PLUS')
	) as [Federal Tax Bal],
	( Select sum(decWithholdingsAmount)
	 From tblUserBatchWithholdings
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	 And strWithHoldingsName in('FICA SS')
	) as [SS Tax Bal],
	'' as [SS Tips Bal],
	'' as [Uncollected SS Tax Balance],
	'' as [Uncollected Med Tax Balance],
	( Select sum(decWithholdingsAmount)
	 From tblUserBatchWithholdings
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	 And strWithHoldingsName in('FICA MED')
	) as [Med Tax Bal],
	( Select sum(decWithholdingsAmount)
	 From tblUserBatchWithholdings
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	 And strWithHoldingsName in('FICA MED PLUS')
	) as [Med2 Tax Bal],
	'PR' as [Worked State Code],
	(
	 select [dbo].[fnPay_BatchTaxablePay](userBatch.strBatchID,userBatch.intUserID)

	) as [Worked State Taxable Balances],
	(Select sum(decWithholdingsAmount)
	 From tblUserBatchWithholdings
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	 And strWithHoldingsName in('ST ITAX')	
	) as [Worked State Tax Bal],
	'' as [Lived State Code],
	'' as [Lived State Taxable Balances],
	'' as [Lived State Tax Bal],
	'PR' as [SUI/SDI Tax Jurisdiction Code],
	(Select sum(decWithholdingsAmount)
	 From tblUserBatchWithholdings
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	 And strWithHoldingsName in('SUTA') 
	 ) as [SUI/SDI Tax Bal],
	'' as [WA L&I Hrs],
	'' as [WA L&I Tax Bal],
	'' as [Worked Local Code],
	'' as [Worked Local Taxable Balances],
	'' as [Worked Local Tax Bal],
	'' as [Lived Local Code],
	'' as [Lived  Local Taxable Balances],
	'' as [Lived Local Tax Bal],
	'' as [Local Services Tax Code],
	'' as [Local Services Tax],
	'' as [Ohio Local School District Tax Code],
	'' as [Ohio School District Tax Withheld],
	'' as [Family Leave Insurance Tax Bal],
	'' as [Medical Leave Insurance Tax Bal],
	'' as [WA EE PFML Tax Bal],
	'' as [3PSP Non-Taxable Bal],
	'' as [3PSP Taxable Bal],
	'' as [3PSP Fed Tax Bal],
	'' as [3PSP Med Tax Bal],
	'' as [3PSP SS Tax Bal],
	'' as [3PSP STATE TAX BAL],
	'' as [3PSP SUI/SDI Tax Bal],
	--Client Deduction Code/Description and amount (multiple)
	-- pre-tax/post-tax deduction
	preTaxDeductions.*,
	postTaxDeductions.*,
	-- Client Taxable Memo Code/Description and amount (multiple)
	'' as [Taxable-Memo],
	--Client Non-Taxable Memo Code/Description and amount (multiple)
	nonTaxableMemo.*,
	userBatch.decBatchNetPay as [Net Pay]	

FROM viewPay_UserBatchStatus userBatch
INNER JOIN tblCompanyPayrollInformation payrollCMP on payrollCMP.strCompanyName = userBatch.strCompanyName
INNER JOIN ##tempEarningYTD tblYTDEarnings on tblYTDEarnings.intUserId= userBatch.intUserID and tblYTDEarnings.strBatchId=userBatch.strBatchID
LEFT JOIN ##PreTaxDeductionYTD preTaxDeductions on preTaxDeductions.intUserId= userBatch.intUserID and preTaxDeductions.strBatchId=userBatch.strBatchID
LEFT JOIN ##PostTaxDeductionYTD postTaxDeductions on postTaxDeductions.intUserId= userBatch.intUserID and postTaxDeductions.strBatchId=userBatch.strBatchID
LEFT JOIN ##NonTaxableMemosYTD nonTaxableMemo on nonTaxableMemo.intUserId= userBatch.intUserID and nonTaxableMemo.strBatchId=userBatch.strBatchID

Where userBatch.dtPayDate Between @YSDate And @YTDate
Order by userBatch.strCompanyName,userBatch.dtPayDate,userBatch.strBatchID, userBatch.intUserID
 
END
GO
