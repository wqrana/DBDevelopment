USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_WFNBalancesInfo]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <6/6/2024>
-- Description:	<To extract data for User WFN Balances Info excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_WFNBalancesInfo]
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
		(SELECT ',' +CONCAT('[','Hours','-',[strCompensationName],']') FROM tblCompensationItems GROUP BY strCompensationName FOR XML PATH('')),
		1, 1, '');

	SET @pvtColSet2 = STUFF(
    (SELECT ',' +CONCAT('[','Earnings','-',[strCompensationName],']') FROM tblCompensationItems GROUP BY strCompensationName FOR XML PATH('')),
    1, 1, '');	

	-- earning dynamic query
	-- Compensations hours
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##CompensationHrsYTD
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserID,strBatchID,Concat(''Hours-'',[strCompensationName]) as strCompensationName,[decHours]
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
			SELECT intUserID,strBatchID as strBatchID,Concat(''Earnings-'',[strCompensationName]) as strCompensationName, [decPay]
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
	--Deduction
	SET @pvtColSet1 = STUFF(
		(SELECT ',' +CONCAT('[','Ded-',[strWithHoldingsName],']') 
		 FROM tblWithholdingsItems 
		 WHERE strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS', 'ST ITAX', 'SUTA')		
		 GROUP BY [strWithHoldingsName] FOR XML PATH('')),
		 1, 1, '');
	--PreTax deduction
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##DeductionYTD
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserID,strBatchID,Concat(''Ded-'',[strWithHoldingsName]) as strWithHoldingsName,[decWithholdingsAmount]
			FROM tblUserBatchWithholdings
			WHERE dtPayDate BETWEEN '''+ CONVERT(varchar,@YSDate,101)+''' AND '''+ CONVERT(varchar,@YTDate,101)+'''
		) WithHoldingData   
		 PIVOT (
			SUM([decWithholdingsAmount])
			FOR [strWithHoldingsName] IN (' + @pvtColSet1 + ')	
		) AS PT1	
		) tblPreTaxDeduction'
	
	Drop table If Exists ##DeductionYTD
	Exec sp_executesql @sqlQuery
	--select * from ##DeductionYTD
	--Memo 
	SET @pvtColSet1 = STUFF(
    (SELECT ',' + +CONCAT('[',[strWithHoldingsName],'-','Employer',']') FROM tblWithholdingsItems WHERE strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS', 'ST ITAX', 'SUTA') AND boolCompanyContribution=1 GROUP BY [strWithHoldingsName] FOR XML PATH('')),
    1, 1, ''
	);
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##MemosYTD
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserID,strBatchID,Concat([strWithHoldingsName],''-Employer'') as strWithHoldingsName,[decWithholdingsAmount]
			FROM tblCompanyBatchWithholdings
			WHERE dtPayDate BETWEEN '''+ CONVERT(varchar,@YSDate,101)+''' AND '''+ CONVERT(varchar,@YTDate,101)+'''
		) WithHoldingData   
		 PIVOT (
			SUM([decWithholdingsAmount])
			FOR [strWithHoldingsName] IN (' + @pvtColSet1 + ')	
		) AS PT1	
		) tblMemos'
	
	Drop table If Exists ##MemosYTD
	Exec sp_executesql @sqlQuery
	--select * from ##NonTaxableMemosYTD

	--end
--	return;
SELECT 
	userBatch.strCompanyName as [Company Code],	
	userBatch.strUserName as [Employee Name],	
	userBatch.intUserId as [Position ID],	
	DATEPART(QUARTER, userBatch.dtPayDate) as [Quarter #],	
	CompensationHrs.*,
	CompensationEarnings.*,
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
	
	( Select sum(decWithholdingsAmount)
	 From tblUserBatchWithholdings
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	 And strWithHoldingsName in('FICA MED')
	) as [Med Tax Bal],
	
	(Select sum(decWithholdingsAmount)
	 From tblUserBatchWithholdings
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	 And strWithHoldingsName in('ST ITAX')	
	) as [Worked State Tax Bal],
	
	(Select sum(decWithholdingsAmount)
	 From tblUserBatchWithholdings
	 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
	 And strWithHoldingsName in('SUTA') 
	 ) as [SUI/SDI Tax Bal],
	 --deductions
	Deductions.*,
	--memos
	Memos.*

FROM viewPay_UserBatchStatus userBatch
INNER JOIN tblCompanyPayrollInformation payrollCMP on payrollCMP.strCompanyName = userBatch.strCompanyName
LEFT JOIN ##CompensationHrsYTD CompensationHrs on CompensationHrs.intUserID=userBatch.intUserID and CompensationHrs.strBatchID = userBatch.strBatchID
LEFT JOIN ##CompensationEarnYTD CompensationEarnings on CompensationEarnings.intUserID=userBatch.intUserID and CompensationEarnings.strBatchID = userBatch.strBatchID
LEFT JOIN ##DeductionYTD Deductions on Deductions.intUserID=userBatch.intUserID and Deductions.strBatchID = userBatch.strBatchID
LEFT JOIN ##MemosYTD Memos on Memos.intUserID=userBatch.intUserID and Memos.strBatchID = userBatch.strBatchID

Where userBatch.dtPayDate Between @YSDate And @YTDate
Order by userBatch.strCompanyName,userBatch.dtPayDate,userBatch.strBatchID, userBatch.intUserID
 
END
GO
