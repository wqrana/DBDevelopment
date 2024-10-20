USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_WFNQuarterlyBalancesInfo]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <6/6/2024>
-- Description:	<To extract data for User WFN Quarterly Balances Info excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_WFNQuarterlyBalancesInfo]
@startDate datetime=null,
@endDate datetime=null
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @YSDate datetime = Cast(concat('01/01/',year(getdate())) as datetime)
	DECLARE @YTDate datetime = Getdate()	
	--select @startDate,@endDate
	SET @YSDate = IIF(@startDate is null,@YSDate,@startDate)
	SET @YTDate = IIF(@endDate is null,@YTDate,@endDate)
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
	  INTO ##CompensationHrsQData
	  FROM(
		SELECT *	
		FROM (
			Select intUserID,QuarterId,strCompensationName, sum(decHours) as decHours
			From(
				SELECT intUserID,Concat(DATEPART(QUARTER, dtPayDate),''-'',DATEPART(YEAR, dtPayDate)) as QuarterId,Concat(''Hours-'',[strCompensationName]) as strCompensationName,[decHours]
				FROM tblUserBatchCompensations
				WHERE dtPayDate BETWEEN  '''+ CONVERT(varchar,@YSDate,101)+''' AND '''+ CONVERT(varchar,@YTDate,101)+'''
				) UserBatchCompensations
			Group by intUserID,QuarterId,strCompensationName
		) CompensationHrData   
		 PIVOT (
			SUM([decHours])
			FOR [strCompensationName] IN (' + @pvtColSet1 + ')	
		) AS PT1	
		) tblEarnings'
	--select @query
	Drop table If Exists ##CompensationHrsQData
	Exec sp_executesql @sqlQuery
	--select * from ##CompensationHrsQData
	
	--Compensations amount
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##CompensationEarnQData
	  FROM(
		SELECT *	
		FROM (
			Select intUserID,QuarterId,strCompensationName, sum(decPay) as decPay
			From(
					SELECT intUserID,Concat(DATEPART(QUARTER, dtPayDate),''-'',DATEPART(YEAR, dtPayDate)) as QuarterId,Concat(''Earnings-'',[strCompensationName]) as strCompensationName, [decPay]
					FROM tblUserBatchCompensations
					WHERE dtPayDate BETWEEN  '''+ CONVERT(varchar,@YSDate,101)+''' AND '''+ CONVERT(varchar,@YTDate,101)+'''
				 ) UserBatchCompensations
			Group by intUserID,QuarterId,strCompensationName

		) CompensationEarnData   
		 PIVOT (
			SUM([decPay])
			FOR [strCompensationName] IN (' + @pvtColSet2 + ')	
		) AS PT1
	
		) tblEarnings'
	--select @query
	Drop table If Exists ##CompensationEarnQData
	Exec sp_executesql @sqlQuery
	--select * from ##CompensationEarnQData
	
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
	  INTO ##DeductionQData
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserID,QuarterId,strWithHoldingsName, sum(decWithholdingsAmount) as decWithholdingsAmount
			FROM(
				SELECT intUserID,Concat(DATEPART(QUARTER, dtPayDate),''-'',DATEPART(YEAR, dtPayDate)) as QuarterId,Concat(''Ded-'',[strWithHoldingsName]) as strWithHoldingsName,[decWithholdingsAmount]
				FROM tblUserBatchWithholdings
				WHERE dtPayDate BETWEEN  '''+ CONVERT(varchar,@YSDate,101)+''' AND '''+ CONVERT(varchar,@YTDate,101)+'''
				) UserBatchWithholdings
			Group by intUserID,QuarterId,strWithHoldingsName
		) WithHoldingData   
		 PIVOT (
			SUM([decWithholdingsAmount])
			FOR [strWithHoldingsName] IN (' + @pvtColSet1 + ')	
		) AS PT1	
		) tblPreTaxDeduction'
	
	Drop table If Exists ##DeductionQData
	Exec sp_executesql @sqlQuery
	--select * from ##DeductionQData

	--return
	--Memo 
	SET @pvtColSet1 = STUFF(
    (SELECT ',' + +CONCAT('[',[strWithHoldingsName],'-','Employer',']') FROM tblWithholdingsItems WHERE strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS', 'ST ITAX', 'SUTA') AND boolCompanyContribution=1 GROUP BY [strWithHoldingsName] FOR XML PATH('')),
    1, 1, ''
	);
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##MemosQData
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserID,QuarterId,strWithHoldingsName, sum(decWithholdingsAmount) as decWithholdingsAmount
			FROM(
				SELECT intUserID,Concat(DATEPART(QUARTER, dtPayDate),''-'',DATEPART(YEAR, dtPayDate)) as QuarterId,Concat([strWithHoldingsName],''-Employer'') as strWithHoldingsName,[decWithholdingsAmount]
				FROM tblCompanyBatchWithholdings
				WHERE dtPayDate BETWEEN  '''+ CONVERT(varchar,@YSDate,101)+''' AND '''+ CONVERT(varchar,@YTDate,101)+'''
				) UserBatchWithholdings
			Group by intUserID,QuarterId,strWithHoldingsName
		) WithHoldingData   
		 PIVOT (
			SUM([decWithholdingsAmount])
			FOR [strWithHoldingsName] IN (' + @pvtColSet1 + ')	
		) AS PT1	
		) tblMemos'
	
	Drop table If Exists ##MemosQData
	Exec sp_executesql @sqlQuery
	--select * from ##MemosQData

	--end
		--return;
	;with cte_UserQuerterlyBatch
	as
	(
	   SELECT intUserId,QuarterId,sum(FederalTaxBal) as FederalTaxBal,sum(SSTaxBal) as SSTaxBal, sum(MedTaxBal) as MedTaxBal,
			  sum(WorkedStateTaxBal) as WorkedStateTaxBal,sum(SUISDITaxBal) as SUISDITaxBal,sum(NetPay) as NetPay
	   FROM(
		SELECT	
			userBatch.intUserId, 	
			Concat(DATEPART(QUARTER, dtPayDate),'-',DATEPART(YEAR, dtPayDate)) as QuarterId,	
			( Select sum(decWithholdingsAmount)
			 From tblUserBatchWithholdings
			 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
			 And strWithHoldingsName in('FICA SS','FICA MED','FICA MED PLUS')
			) as [FederalTaxBal],
			( Select sum(decWithholdingsAmount)
			 From tblUserBatchWithholdings
			 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
			 And strWithHoldingsName in('FICA SS')
			) as [SSTaxBal],
	
			( Select sum(decWithholdingsAmount)
			 From tblUserBatchWithholdings
			 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
			 And strWithHoldingsName in('FICA MED')
			) as [MedTaxBal],
	
			(Select sum(decWithholdingsAmount)
			 From tblUserBatchWithholdings
			 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
			 And strWithHoldingsName in('ST ITAX')	
			) as [WorkedStateTaxBal],
	
			(Select sum(decWithholdingsAmount)
			 From tblUserBatchWithholdings
			 Where intUserID=userBatch.intUserID and strBatchID=userBatch.strBatchID
			 And strWithHoldingsName in('SUTA') 
			 ) as [SUISDITaxBal],
			 userBatch.decBatchNetPay as [NetPay]
		FROM viewPay_UserBatchStatus userBatch
		Where userBatch.dtPayDate Between @YSDate And @YTDate
		) UserBatchData
	  Group By intUserID, QuarterId
	  )

	  SELECT 
		  userInfo.strCompanyName as [Company Code],
		  userInfo.name as [Employee Name],
		  userInfo.intUserID as [Position ID],
		  CONVERT(varchar,@YSDate,101)+' - '+ CONVERT(varchar,@YTDate,101) as [Balance Date Range],
		  userQuerterlyBatch.QuarterId as [Quarter #],
		  CompensationHrsQData.*,
		  CompensationEarnQData.*,
		  FederalTaxBal as [Federal Tax Bal],
		  SSTaxBal as [SS Tax Bal],
		  MedTaxBal as [Med Tax Bal],
		  WorkedStateTaxBal as [Worked State Tax Bal],
		  SUISDITaxBal as [SUI/SDI Tax Bal],
		  DeductionQData.*,
		  MemosQData.*,
		  NetPay as [Net Pay]

	  FROM viewPay_UserRecord userInfo
	  INNER JOIN cte_UserQuerterlyBatch userQuerterlyBatch On userInfo.intUserID = userQuerterlyBatch.intUserID
	  LEFT JOIN  ##CompensationHrsQData CompensationHrsQData On CompensationHrsQData.intUserID = userQuerterlyBatch.intUserID And CompensationHrsQData.QuarterId = userQuerterlyBatch.QuarterId
	  LEFT JOIN  ##CompensationEarnQData CompensationEarnQData On CompensationEarnQData.intUserID = userQuerterlyBatch.intUserID And CompensationEarnQData.QuarterId = userQuerterlyBatch.QuarterId
	  LEFT JOIN  ##DeductionQData DeductionQData On DeductionQData.intUserID = userQuerterlyBatch.intUserID And DeductionQData.QuarterId = userQuerterlyBatch.QuarterId
	  LEFT JOIN  ##MemosQData MemosQData On MemosQData.intUserID = userQuerterlyBatch.intUserID And MemosQData.QuarterId = userQuerterlyBatch.QuarterId

	  Order by userInfo.strCompanyName,userQuerterlyBatch.QuarterId,userQuerterlyBatch.intUserID

 
END
GO
