USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tbl499RIncomeTaxReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 05/08/2016
-- Description:	Data for 499R Income Tax Report
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tbl499RIncomeTaxReport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbl499Report TABLE 
(
	strCompanyName	nvarchar(50),
	dtStartDate		date,
	dtEndDate		date,
	strEIN		nvarchar(50),
	strAddress1		nvarchar(50),
	strAddress2		nvarchar(50),
	strCity			nvarchar(50),
	strState		nvarchar(50),
	strZipCode		nvarchar(50),
	strNAICSCode	nvarchar(50),
	intUsersCovered int,
	decExemptSalary decimal(18,5),
	decTaxableSalary decimal(18,5),
	decTotalTips decimal(18,5),
	decTotalRetainedStTax decimal(18,5)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
--select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName = @PAYITEM 
declare @intUserCovered int
Declare @decExemptSalary decimal(18,5)
Declare @decTaxableSalary decimal(18,5)
declare @decTotalTips decimal(18,5)
declare	@decTotalRetainedStTax decimal(18,5)
declare	@CompanyContributions decimal(18,5)

----------------------------------
-- COMPUTOS 499R INCOME TAX
----------------------------------

--	Get the total number of distinct employees in all the payrolls of the period
select @intUserCovered  = count(distinct intuserid) From viewPay_UserBatchStatus where strCompanyName = @PayrollCompany and dtPayDate between @StartDate and @EndDate and decBatchUserCompensations <> 0

--	Total Exempt Salaries in the Period
select @decExemptSalary = -isnull(sum( [dbo].[fnPay_BatchStTaxExemptions](ubs.strBatchID,ubs.intUserID)),0)  From viewPay_UserBatchStatus ubs 
where strCompanyName = @PayrollCompany and dtPayDate between @StartDate and @EndDate

--	Total Taxable Salaries in the Period
select @decTaxableSalary = (isnull(sum( [dbo].[fnPay_BatchTaxablePay](ubs.strBatchID,ubs.intUserID)),0) +isnull(sum( [dbo].[fnPay_BatchStTaxExemptions](ubs.strBatchID,ubs.intUserID)),0)) From viewPay_UserBatchStatus ubs 
where strCompanyName = @PayrollCompany and dtPayDate between @StartDate and @EndDate

--	Total Tips
select @decTotalTips = 0 

--	Total St ITAX retained income taxes
select @decTotalRetainedStTax  = - isnull(sum(ubw.decWithholdingsAmount),0) From viewPay_UserBatchWithholdings ubw inner join tblWithholdingsItems w on ubw.strWithHoldingsName = w.strWithHoldingsName
where strCompanyName = @PayrollCompany and dtPayDate between @StartDate and @EndDate
AND w.intComputationType = -1

insert @tbl499Report
select strCompanyName, @STARTDATE, @ENDDATE,strEIN, strAddress1,strAddress2,strCity,strState,strZipCode,strNAICSCode,@intUserCovered,@decExemptSalary,@decTaxableSalary,@decTotalTips,@decTotalRetainedStTax
	from tblCompanyPayrollInformation where strCompanyName = @PayrollCompany

RETURN
END


GO
