USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCompanyContributionsSalary]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description: Pay Register Company Summary
-- Takes into consideration the Payroll Company
-- Uses Expected Values of FICA and ST-ITax
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblCompanyContributionsSalary]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50),
	@PAYROLLCOMPANY nvarchar(50),
	@STARTDATE date,
	@ENDDATE date
)
RETURNS 
@tblCompanyContributionsSalary TABLE 
(
	strWithholdingsName nvarchar(50),
	decEffectiveWages decimal(18,2),
	decWeeks decimal(18,2),
	decWithholdingsAmount decimal(18,2),
	decContributionsAmount decimal(18,2),
	intOrderSequence int
) 
-- WITH ENCRYPTION
AS
BEGIN
if @BATCHID = ''
	BEGIN
			insert into @tblCompanyContributionsSalary
	select '01 Total Records', 
		0,
		(select  count(distinct intuserid) from viewPay_UserBatchStatus where strCompanyName = @PAYROLLCOMPANY AND dtPayDate between @STARTDATE AND @ENDDATE) as decUserRecords,
		0,0,0

		 		insert into @tblCompanyContributionsSalary
		select '02 Total Hours', 
		0,
		(select  sum(decHours) FROM viewPay_UserBatchCompensations where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE AND @ENDDATE ) as decEffectiveWages,
		0,0,0

		 		insert into @tblCompanyContributionsSalary
		select '03 Total Net Pay', 
		(select SUM(decBatchNetPay) from viewPay_UserBatchStatus where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE AND @ENDDATE) as decEffectiveWages,
		0,0,0,0

		 		insert into @tblCompanyContributionsSalary
		select '04 Total Gross Pay', 
		(select SUM(decBatchUserCompensations) from viewPay_UserBatchStatus where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE AND @ENDDATE) as decEffectiveWages,
		0,0,0,0

		 		insert into @tblCompanyContributionsSalary
		select '05 Total Employee Withholdings', 
		-(select SUM(decBatchUserWithholdings) from viewPay_UserBatchStatus where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE AND @ENDDATE) as decEE,
		0,0,0,0

		 		insert into @tblCompanyContributionsSalary
		select '06 Total Employer Contributions', 
	-(select  sum(decWithholdingsAmount) from  viewPay_CompanyBatchWithholdings where  strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE AND @ENDDATE )  as decTotalCompanyContributions,
	0,0,0,0
		
		 		insert into @tblCompanyContributionsSalary
		select '07 Total Payroll Expenses', 
		(select SUM(decBatchUserCompensations) from viewPay_UserBatchStatus where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE AND @ENDDATE) +
		-(select  sum(decWithholdingsAmount) from  viewPay_CompanyBatchWithholdings where  strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE AND @ENDDATE ) as decTotalCompanyContributions,
		0,0,0,0	

		 		insert into @tblCompanyContributionsSalary
		select '08 Total Checks', 
		coaleSce((select sum(decCheckAmount) FROM viewpay_UserPayCheck where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE AND @ENDDATE and intPayMethodType = 1),0) as decCheckAmount,
		(select count(intSequenceNum) FROM viewpay_UserPayCheck where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE AND @ENDDATE  and intPayMethodType = 1 and decCheckAmount <> 0) as decCheckCount,
		0,0,0

		 		insert into @tblCompanyContributionsSalary
		select '09 Total Direct Deposit', 
		(select sum(decCheckAmount) FROM viewPay_UserPayCheck where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE AND @ENDDATE  and intPayMethodType = 2) as decCheckAmount,
		(select count(intSequenceNum) FROM viewPay_UserPayCheck where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE AND @ENDDATE  and intPayMethodType = 2) as decCheckCount,
		0,0,0


		--FICA
		 		insert into @tblCompanyContributionsSalary
		select 
		'   ' + cw.strWithholdingsName,
--		sum(ubw.decBatchEffectivePay) as decEffectiveWages,
		[dbo].[fnPay_BatchTaxablePay_Dates](@PAYROLLCOMPANY, @STARTDATE, @ENDDATE )	as decEffectiveWages,
		0,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		1
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join viewpay_UserBatchWithholdings ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName
		left outer join tblCompanyBatchWithholdings cbw ON cw.strContributionsName = cbw.strWithHoldingsName and ubw.strBatchID = cbw.strBatchID and ubw.intUserID = cbw.intUserID
		where boolFICA = 1 and ubw.strCompanyName = @PAYROLLCOMPANY AND ubw.dtPayDate BETWEEN @STARTDATE AND @ENDDATE 
		group by cw.strWithHoldingsName
		
		insert into @tblCompanyContributionsSalary
		select 
		'   ' + cw.strWithholdingsName,
		--sum(cbw.decBatchEffectivePay) as decEffectiveWages,
		(select sum(decTaxablePay) FROM 	[dbo].[fnPay_tblCompanyTaxablePayPerPeriod](@PAYROLLCOMPANY,@STARTDATE,@ENDDATE,cw.strWithHoldingsName) where bitWithholdingApplies = 1) as decEffectiveWages,
		0,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		2
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join viewPay_CompanyBatchWithholdings cbw ON cw.strContributionsName = cbw.strWithHoldingsName and cw.strCompanyName= cbw.strCompanyName 
		left outer join viewpay_UserBatchWithholdings ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName and ubw.intUserID = cbw.intUserID and ubw.strBatchID = cbw.strBatchID
		where cw.strWithHoldingsName IN ('DISABILITY','SINOT','SUTA','FUTA') and cbw.strCompanyName = @PAYROLLCOMPANY AND cbw.dtPayDate BETWEEN @STARTDATE AND @ENDDATE 
		group by cw.strWithHoldingsName
		
		 		insert into @tblCompanyContributionsSalary
		select 
		'   ' + cw.strWithholdingsName,
		sum(ubw.decBatchEffectivePay) as decEffectiveWages,
		0,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		3
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join viewpay_UserBatchWithholdings ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName
		left outer join tblCompanyBatchWithholdings cbw ON cw.strContributionsName = cbw.strWithHoldingsName and ubw.strBatchID = cbw.strBatchID and ubw.intUserID = cbw.intUserID
		where boolCoda_401K = 1 and ubw.strCompanyName = @PAYROLLCOMPANY AND ubw.dtPayDate BETWEEN @STARTDATE AND @ENDDATE 
		group by cw.strWithHoldingsName

		--ST ITAX
		insert into @tblCompanyContributionsSalary 
		select 
		'   ' + cw.strWithholdingsName,
		--sum(ubw.decBatchEffectivePay) as decEffectiveWages,
		[dbo].[fnPay_BatchTaxablePay_Dates](@PAYROLLCOMPANY, @STARTDATE, @ENDDATE )	+ [dbo].[fnPay_BatchStTaxExemptions_Dates](@PAYROLLCOMPANY,@STARTDATE, @ENDDATE)  as decEffectiveWages,
		0,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		3
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join viewpay_UserBatchWithholdings ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName
		left outer join tblCompanyBatchWithholdings cbw ON cw.strContributionsName = cbw.strWithHoldingsName and ubw.strBatchID = cbw.strBatchID and ubw.intUserID = cbw.intUserID
		where cw.strWithHoldingsName = 'ST ITAX' and ubw.strCompanyName = @PAYROLLCOMPANY AND ubw.dtPayDate BETWEEN @STARTDATE AND @ENDDATE 
		group by cw.strWithHoldingsName		

		insert into @tblCompanyContributionsSalary
		SELECT 
		'   ' + cw.strWithholdingsName,
		0 as decEffectiveWages,
		(SELECT top(1) [dbo].[fnPay_NumberOfSundays](dtStartDatePeriod, dtEndDatePeriod) FROM viewPay_UserBatchStatus ubs where ubs.strCompanyName = @PAYROLLCOMPANY AND ubs.dtPayDate BETWEEN @STARTDATE AND @ENDDATE ) as decWeeks,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		4
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join viewPay_CompanyBatchWithholdings cbw ON cw.strContributionsName = cbw.strWithHoldingsName and cw.strCompanyName= cbw.strCompanyName 
		left outer join viewpay_UserBatchWithholdings ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName and ubw.intUserID = cbw.intUserID and ubw.strBatchID = cbw.strBatchID
		where cw.strWithHoldingsName IN ('CHOFERIL','DRIVERS') and cbw.strCompanyName = @PAYROLLCOMPANY AND cbw.dtPayDate BETWEEN @STARTDATE AND @ENDDATE  
		group by cw.strWithHoldingsName
	END
ELSE
	BEGIN

		insert into @tblCompanyContributionsSalary
		select '01 Total Records', 
		0,
		(select distinct count(intuserid) from viewPay_UserBatchStatus where strBatchID =  @BATCHID  and decBatchNetPay <> 0) as decUserRecords,
		0,0,0

		insert into @tblCompanyContributionsSalary
		select '02 Total Hours', 
		0,
		(select  sum(decHours) FROM viewPay_UserBatchCompensations where strBatchID = @BATCHID) as decEffectiveWages,
		0,0,0

		insert into @tblCompanyContributionsSalary
		select '03 Total Net Pay', 
		(select SUM([dbo].[fnPay_BatchTotalNetPay](@BATCHID))) as decEffectiveWages,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '04 Total Gross Pay', 
		(select SUM([dbo].[fnPay_BatchTotalCompensations](@BATCHID))) as decEffectiveWages,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '05 Total Employee Withholdings', 
		-(select  sum([dbo].[fnPay_EEWithholdings](@BATCHID,  strWithHoldingsName)) as decWH FROM (select distinct strWithHoldingsName from  tblUserBatchWithholdings where strBatchID = @BATCHID) BW ) as decEE,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '06 Total Employer Contributions', 
		-(select  sum([dbo].[fnPay_ERWithholdings](@BATCHID,  strWithHoldingsName)) as decWH FROM (select distinct strWithHoldingsName from  tblCompanyBatchWithholdings where strBatchID = @BATCHID) BW) as decTotalCompanyContributions,
		0,0,0,0
		
		insert into @tblCompanyContributionsSalary
		select '07 Total Payroll Expenses', 
		(select [dbo].[fnPay_BatchTotalCompensations](@BATCHID) + -(select  sum([dbo].[fnPay_ERWithholdings](@BATCHID,  strWithHoldingsName)) as decWH FROM (select distinct strWithHoldingsName from  tblCompanyBatchWithholdings where strBatchID = @BATCHID) BW)) as decTotalCompanyContributions,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '08 Total Checks', 
		(select sum(decCheckAmount) FROM tblUserPayChecks where strBatchID = @BATCHID and intPayMethodType = 1) as decCheckAmount,
		(select count(intSequenceNum) FROM tblUserPayChecks where strBatchID = @BATCHID and intPayMethodType = 1 and decCheckAmount <> 0) as decCheckCount,
		0,0,0

		insert into @tblCompanyContributionsSalary
		select '09 Total Direct Deposit', 
		(select sum(decCheckAmount) FROM tblUserPayChecks where strBatchID = @BATCHID and intPayMethodType = 2) as decCheckAmount,
		(select count(intSequenceNum) FROM tblUserPayChecks where strBatchID = @BATCHID and intPayMethodType = 2) as decCheckCount,
		0,0,0

		--FICA
		insert into @tblCompanyContributionsSalary
		select 
		'   ' + cw.strWithholdingsName,
		sum(ubw.decBatchEffectivePay) as decEffectiveWages,
		0,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		1
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings where strBatchID = @BATCHID group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings where strBatchID = @BATCHID group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) cbw 
		ON cw.strContributionsName = cbw.strWithHoldingsName and ubw.strBatchID = cbw.strBatchID and ubw.intUserID = cbw.intUserID
		where boolFICA = 1 and ubw.strBatchID = @BATCHID 
		group by cw.strWithHoldingsName
		
		insert into @tblCompanyContributionsSalary
			select 
		'   ' + cw.strWithholdingsName,
		sum(cbw.decBatchEffectivePay) as decEffectiveWages,
		0,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		2
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join viewPay_CompanyBatchWithholdings cbw ON cw.strContributionsName = cbw.strWithHoldingsName and cw.strCompanyName= cbw.strCompanyName 
		left outer join (select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings where strBatchID = @BATCHID group by strBatchID , intUserID, strCompanyName, strWithHoldingsName)
		 ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName and ubw.intUserID = cbw.intUserID and ubw.strBatchID = cbw.strBatchID
		where cw.strWithHoldingsName IN ('DISABILITY','SINOT','SUTA','FUTA') and cbw.strBatchID = @BATCHID 
		group by cw.strWithHoldingsName
		
		insert into @tblCompanyContributionsSalary
		select 
		'   ' + cw.strWithholdingsName,
		sum(ubw.decBatchEffectivePay) as decEffectiveWages,
		0,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		3
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings where strBatchID = @BATCHID group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings where strBatchID = @BATCHID group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) cbw 
		ON cw.strContributionsName = cbw.strWithHoldingsName and ubw.strBatchID = cbw.strBatchID and ubw.intUserID = cbw.intUserID
		where boolCoda_401K = 1 and ubw.strBatchID = @BATCHID
		group by cw.strWithHoldingsName

		--ST ITAX
		insert into @tblCompanyContributionsSalary
		select 
		'   ' + cw.strWithholdingsName,
		--sum(ubw.decBatchEffectivePay) as decEffectiveWages,
		[dbo].[fnPay_BatchTaxablePay_Total](@BATCHID) + [dbo].[fnPay_BatchStTaxExemptions_Total](@BATCHID)  as decEffectiveWages,

		0,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		3
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings where strBatchID = @BATCHID group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings where strBatchID = @BATCHID group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) 
		cbw ON cw.strContributionsName = cbw.strWithHoldingsName and ubw.strBatchID = cbw.strBatchID and ubw.intUserID = cbw.intUserID
		where cw.strWithHoldingsName = 'ST ITAX' and ubw.strBatchID = @BATCHID
		group by cw.strWithHoldingsName		

		insert into @tblCompanyContributionsSalary
		SELECT 
		'   ' + cw.strWithholdingsName,
		0 as decEffectiveWages,
		(SELECT top(1) [dbo].[fnPay_NumberOfSundays](dtStartDatePeriod, dtEndDatePeriod) FROM viewPay_UserBatchStatus ubs where ubs.strBatchID = @BATCHID) as decWeeks,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		4
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings where strBatchID = @BATCHID group by strBatchID , intUserID, strCompanyName, strWithHoldingsName)  cbw ON cw.strContributionsName = cbw.strWithHoldingsName and cw.strCompanyName= cbw.strCompanyName 
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings where strBatchID = @BATCHID group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName and ubw.intUserID = cbw.intUserID and ubw.strBatchID = cbw.strBatchID
		where cw.strWithHoldingsName IN ('CHOFERIL','DRIVERS') and cbw.strBatchID = @BATCHID 
		group by cw.strWithHoldingsName

	END
RETURN
END


GO
