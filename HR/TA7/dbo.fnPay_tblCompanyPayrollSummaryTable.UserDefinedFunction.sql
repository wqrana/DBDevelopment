USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCompanyPayrollSummaryTable]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 03/23/2021
-- Description: Company Payroll Summary Last Page Summary
-- Takes into consideration the Payroll Company
-- Uses Expected Values of FICA and ST-ITax
-- =============================================
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 03/23/2021
-- Description: Company Payroll Summary Last Page Summary
-- Takes into consideration the Payroll Company
-- Uses Expected Values of FICA and ST-ITax
-- 06/30/2023: Fixed 01 Total Employees
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblCompanyPayrollSummaryTable]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50),
	@USERID int = 0,
	@PAYROLLCOMPANY nvarchar(50) ,
	@STARTDATE date ,
	@ENDDATE date ,
	@CompanyID int ,
	@DepartmentID int ,
	@SubDepartmentID int ,
	@EmployeeTypeID int 
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
		select '01 Total Employees', 
		0,
		(select distinct count(distinct intuserid) from viewPay_UserBatchStatus ubs 		
		where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE		
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)
		and decBatchNetPay <> 0) as decUserRecords,
		0,0,0

		insert into @tblCompanyContributionsSalary
		select '02 Total Hours', 
		0,
		(select  sum(decHours) FROM tblUserBatchCompensations ubc inner join viewPay_UserBatchStatus ubs ON ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID
		where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)) as decEffectiveWages,
		0,0,0

		insert into @tblCompanyContributionsSalary
		select '03 Total Net Pay', 
		(select sum(decBatchNetPay) FROM viewPay_UserBatchStatus ubs 
		where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)) as decEffectiveWages,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '04 Total Gross Pay', 
		(select sum(decBatchUserCompensations) FROM viewPay_UserBatchStatus ubs 
		where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)) as decEffectiveWages,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '05 Total Employee Withholdings', 
		-(select sum(decBatchUserWithholdings) FROM viewPay_UserBatchStatus ubs 
		where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)) as decEE,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '06 Total Employer Contributions', 
		-(select round( sum(decWithholdingsAmount),2) from viewPay_CompanyBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) ) as decTotalCompanyContributions,
		0,0,0,0
		
		insert into @tblCompanyContributionsSalary
		select '07 Total Payroll Expenses', 
		ISNULL((select sum(decBatchUserCompensations) FROM viewPay_UserBatchStatus ubs 
		where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)) 
		+ 
		-(select round( sum(decWithholdingsAmount),2) from viewPay_CompanyBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) ) ,0) as decTotalCompanyContributions,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '08 Total Checks', 
		isnull((select sum(decCheckAmount) FROM tblUserPayChecks upc inner join viewPay_UserBatchStatus ubs on upc.strBatchID = ubs.strBatchID and upc.intUserID = ubs.intUserID
		where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) and upc.intPayMethodType = 1),0) as decCheckAmount,
		isnull((select count(intSequenceNum) FROM tblUserPayChecks upc inner join viewPay_UserBatchStatus ubs on upc.strBatchID = ubs.strBatchID and upc.intUserID = ubs.intUserID
		where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) and upc.intPayMethodType = 1 and decCheckAmount <> 0),0) as decCheckCount,
		0,0,0

		insert into @tblCompanyContributionsSalary
		select '09 Total Direct Deposit', 
		(select sum(decCheckAmount) FROM tblUserPayChecks upc inner join viewPay_UserBatchStatus ubs on upc.strBatchID = ubs.strBatchID and upc.intUserID = ubs.intUserID
		where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) and upc.intPayMethodType = 2)  as decDirectDepositAmount,
		(select count(intSequenceNum) FROM tblUserPayChecks upc inner join viewPay_UserBatchStatus ubs on upc.strBatchID = ubs.strBatchID and upc.intUserID = ubs.intUserID
		where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) and upc.intPayMethodType = 1 and decCheckAmount <> 0) as decDirectDepositCount,
		0,0,0

		--FICA MED. FICA SS
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
		from viewpay_UserBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) cbw 
		ON cw.strContributionsName = cbw.strWithHoldingsName and ubw.strBatchID = cbw.strBatchID and ubw.intUserID = cbw.intUserID
		where boolFICA = 1 
		group by cw.strWithHoldingsName
		
		--SINOT, SUTA, FUTA
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
		left outer join 
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) ubw 
		ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName 
		left outer join 
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) cbw 
		ON cw.strContributionsName = cbw.strWithHoldingsName and cw.strCompanyName = cbw.strCompanyName 
		where cw.strWithHoldingsName IN ('DISABILITY','SINOT','SUTA','FUTA') 
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
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) ubw 
		ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName 
		left outer join 
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) cbw 
		ON cw.strContributionsName = cbw.strWithHoldingsName and cw.strCompanyName = cbw.strCompanyName 
		where boolCoda_401K = 1 
		group by cw.strWithHoldingsName

		--ST ITAX
		insert into @tblCompanyContributionsSalary
		select 
		'   ' + cw.strWithholdingsName,
		isnull((	select sum(decPay) from tblUserBatchCompensations ubc inner join viewPay_UserBatchStatus ubs on ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID
			inner join tblUserCompensationItems uc on ubc.intUserID = uc.intUserID and ubc.strCompensationName = uc.strCompensationName
			where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) and uc.intCompensationType = 1   and ubc.boolDeleted = 0),0)
		 + 
		 isnull((	SELECT  SUM(decWithholdingsAmount) FROM viewPay_UserBatchWithholdings ubs inner join tblWithholdingsQualifierItems wqi on ubs.strWithHoldingsName = wqi.strWithHoldingsName
			WHERE ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
			and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
			and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		and intWithHoldingsQualifierID = 0 and intQualifierValue = 1 ),0) as decEffectiveWages,
		0,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		3
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join 
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) ubw 
		ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName 
		left outer join 
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) cbw 
		ON cw.strContributionsName = cbw.strWithHoldingsName and cw.strCompanyName = cbw.strCompanyName 
		where cw.strWithHoldingsName = 'ST ITAX' 
		group by cw.strWithHoldingsName		


		insert into @tblCompanyContributionsSalary
		SELECT 
		'   ' + cw.strWithholdingsName,
		0 as decEffectiveWages,
		(SELECT top(1) [dbo].[fnPay_NumberOfSundays](dtStartDatePeriod, dtEndDatePeriod) FROM viewPay_UserBatchStatus ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE) as decWeeks,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		4
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE group by strBatchID , intUserID, strCompanyName, strWithHoldingsName)  cbw ON cw.strContributionsName = cbw.strWithHoldingsName and cw.strCompanyName= cbw.strCompanyName 
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings ubs where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName and ubw.intUserID = cbw.intUserID and ubw.strBatchID = cbw.strBatchID
		where cw.strWithHoldingsName IN ('CHOFERIL','DRIVERS') and cbw.strBatchID = @BATCHID 
		group by cw.strWithHoldingsName

	END
ELSE
	BEGIN

		insert into @tblCompanyContributionsSalary
		select '01 Total Employees', 
		0,
		(select  count( distinct intuserid) from viewPay_UserBatchStatus ubs 		
		where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)
		and decBatchNetPay <> 0) as decUserRecords,
		0,0,0

		insert into @tblCompanyContributionsSalary
		select '02 Total Hours', 
		0,
		(select  sum(decHours) FROM tblUserBatchCompensations ubc inner join viewPay_UserBatchStatus ubs ON ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID
		where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)) as decEffectiveWages,
		0,0,0

		insert into @tblCompanyContributionsSalary
		select '03 Total Net Pay', 
		(select sum(decBatchNetPay) FROM viewPay_UserBatchStatus ubs 
		where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)) as decEffectiveWages,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '04 Total Gross Pay', 
		(select sum(decBatchUserCompensations) FROM viewPay_UserBatchStatus ubs 
		where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)) as decEffectiveWages,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '05 Total Employee Withholdings', 
		-(select sum(decBatchUserWithholdings) FROM viewPay_UserBatchStatus ubs 
		where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)) as decEE,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '06 Total Employer Contributions', 
		-(select round( sum(decWithholdingsAmount),2) from viewPay_CompanyBatchWithholdings ubs where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) ) as decTotalCompanyContributions,
		0,0,0,0
		
		insert into @tblCompanyContributionsSalary
		select '07 Total Payroll Expenses', 
		ISNULL((select sum(decBatchUserCompensations) FROM viewPay_UserBatchStatus ubs 
		where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0)) 
		+ 
		-(select round( sum(decWithholdingsAmount),2) from viewPay_CompanyBatchWithholdings ubs where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) ) ,0) as decTotalCompanyContributions,
		0,0,0,0

		insert into @tblCompanyContributionsSalary
		select '08 Total Checks', 
		isnull((select sum(decCheckAmount) FROM tblUserPayChecks upc inner join viewPay_UserBatchStatus ubs on upc.strBatchID = ubs.strBatchID and upc.intUserID = ubs.intUserID
		where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) and upc.intPayMethodType = 1),0) as decCheckAmount,
		isnull((select count(intSequenceNum) FROM tblUserPayChecks upc inner join viewPay_UserBatchStatus ubs on upc.strBatchID = ubs.strBatchID and upc.intUserID = ubs.intUserID
		where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) and upc.intPayMethodType = 1 and decCheckAmount <> 0),0) as decCheckCount,
		0,0,0

		insert into @tblCompanyContributionsSalary
		select '09 Total Direct Deposit', 
		(select sum(decCheckAmount) FROM tblUserPayChecks upc inner join viewPay_UserBatchStatus ubs on upc.strBatchID = ubs.strBatchID and upc.intUserID = ubs.intUserID
		where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) and upc.intPayMethodType = 2)  as decDirectDepositAmount,
		(select count(intSequenceNum) FROM tblUserPayChecks upc inner join viewPay_UserBatchStatus ubs on upc.strBatchID = ubs.strBatchID and upc.intUserID = ubs.intUserID
		where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) and upc.intPayMethodType = 1 and decCheckAmount <> 0) as decDirectDepositCount,
		0,0,0

		--FICA MED. FICA SS
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
		from viewpay_UserBatchWithholdings ubs where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) ubw ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName
		left outer join 
		(select strBatchID , intUserID, strCompanyName, strWithHoldingsName, max(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings ubs where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) group by strBatchID , intUserID, strCompanyName, strWithHoldingsName) cbw 
		ON cw.strContributionsName = cbw.strWithHoldingsName and ubw.strBatchID = cbw.strBatchID and ubw.intUserID = cbw.intUserID
		where boolFICA = 1 and ubw.strBatchID = @BATCHID 
		group by cw.strWithHoldingsName
		
		--SINOT, SUTA, FUTA
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
		left outer join 
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings ubs where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) ubw 
		ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName 
		left outer join 
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings ubs where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) cbw 
		ON cw.strContributionsName = cbw.strWithHoldingsName and cw.strCompanyName = cbw.strCompanyName 
		where cw.strWithHoldingsName IN ('DISABILITY','SINOT','SUTA','FUTA') and 
		cbw.strBatchID = @BATCHID 
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
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings ubs where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) ubw 
		ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName 
		left outer join 
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings ubs where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) cbw 
		ON cw.strContributionsName = cbw.strWithHoldingsName and cw.strCompanyName = cbw.strCompanyName 
		where boolCoda_401K = 1 and ubw.strBatchID = @BATCHID
		group by cw.strWithHoldingsName

		--ST ITAX
		insert into @tblCompanyContributionsSalary
		select 
		'   ' + cw.strWithholdingsName,
		isnull((	select sum(decPay) from tblUserBatchCompensations ubc inner join viewPay_UserBatchStatus ubs on ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID
			inner join tblUserCompensationItems uc on ubc.intUserID = uc.intUserID and ubc.strCompensationName = uc.strCompensationName
			where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) and uc.intCompensationType = 1   and ubc.boolDeleted = 0),0)
		 + 
		 isnull((	SELECT  SUM(decWithholdingsAmount) FROM viewPay_UserBatchWithholdings ubs inner join tblWithholdingsQualifierItems wqi on ubs.strWithHoldingsName = wqi.strWithHoldingsName
			WHERE ubs.strBatchID = @BATCHID
			and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
			and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		and intWithHoldingsQualifierID = 0 and intQualifierValue = 1 ),0) as decEffectiveWages,
--		[dbo].[fnPay_BatchTaxablePay_Total](@BATCHID) + [dbo].[fnPay_BatchStTaxExemptions_Total](@BATCHID)  as decEffectiveWages,

		0,
		-sum(isnull(ubw.decWithholdingsAmount,0)) as decWithholdingsAmount,
		-sum(isnull(cbw.decWithholdingsAmount,0)) as decContributionsAmount,
		3
		FROM tblCompanyWithholdings cw inner join tblWithholdingsItems_PRPayExport pr 
		on cw.strWithHoldingsName = pr.strWithholdingsName
		left outer join 
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewpay_UserBatchWithholdings ubs where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) ubw 
		ON CW.strWithHoldingsName = UBW.strWithHoldingsName and cw.strCompanyName = ubw.strCompanyName 
		left outer join 
		(select strBatchID ,  strCompanyName, strWithHoldingsName, sum(decBatchEffectivePay) AS decBatchEffectivePay, sum(decWithholdingsAmount) AS decWithholdingsAmount 
		from viewPay_CompanyBatchWithholdings ubs where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) 
		group by strBatchID , strCompanyName, strWithHoldingsName) cbw 
		ON cw.strContributionsName = cbw.strWithHoldingsName and cw.strCompanyName = cbw.strCompanyName 
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
