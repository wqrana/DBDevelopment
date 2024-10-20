USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tbl941RFICATaxReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 05/22/2019
-- Description:	Data for 941R FICA Tax Report
-- =============================================


CREATE FUNCTION [dbo].[fnPay_tbl941RFICATaxReport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbl941RReport TABLE 
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
	intUsersCovered int,
	decFICASSSalary decimal(18,2),
	decFICASSTips decimal(18,2),
	decFICASSTax decimal(18,2),
	decFICASSTipsTax decimal(18,2),
	decFICASSPercent decimal(18,5),
	decFICAMEDSalaryAndTips decimal(18,2),
	decFICAMEDTax decimal(18,2),
	decFICAMEDPercent decimal(18,5),
	decFICAMEDPlusSalaryAndTips decimal(18,2),
	decFICAMEDPlusTax decimal(18,2),
	decFICAMEDPlusPercent decimal(18,5),
	decFICATotalTax decimal(18,2),
	decFICARetention decimal(18,2),
	decFICAAdjust decimal(18,2)

	) 
	-- WITH ENCRYPTION
AS
BEGIN
--select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName = @PAYITEM 
	DECLARE @intUsersCovered int
	DECLARE @decFICASSSalary decimal(18,2)
	DECLARE @decFICASSTips decimal(18,2)
	DECLARE @decFICASSTax decimal(18,2)
	DECLARE @decFICASSTipsTax decimal(18,2)
	DECLARE @decFICASSPercent decimal(18,5)

	DECLARE @decFICAMEDSalaryAndTips decimal(18,2)
	DECLARE @decFICAMEDTax decimal(18,2)
	DECLARE @decFICAMEDTaxPercent decimal(18,5)

	DECLARE @decFICAMEDPlusSalaryAndTips decimal(18,2)
	DECLARE @decFICAMEDPlusTax decimal(18,2)
	DECLARE @decFICAMEDPlusPercent decimal(18,5)

	DECLARE @decFICATotalTax decimal(18,2)
	DECLARE @decFICARetention decimal(18,2)
	DECLARE @decFICAAdjust decimal(18,2)

----------------------------------
-- COMPUTOS 941R INCOME TAX
----------------------------------

--	Get the total number of distinct employees in all the payrolls of the period
select @intUsersCovered  = count(distinct intuserid) From viewPay_UserBatchStatus where strCompanyName = @PayrollCompany and dtPayDate between @StartDate and @EndDate and decBatchUserCompensations <> 0

--FICA SS

SELECT @decFICASSSalary  =sum(decTaxablePay) FROM 	[dbo].[fnPay_tblCompanyTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,'FICA SS') 

--	Total FICA SS Tips in the Period
SET @decFICASSTips = 0		--Not implemented yet.

--	FICA SS Tax Percent
SET @decFICASSPercent = .124
--	Total FICA SS Taxes
SET @decFICASSTax = (@decFICASSSalary + @decFICASSTips) * @decFICASSPercent

--	Total FICA Tips SS Taxes
SET @decFICASSTipsTax = (@decFICASSTips) * @decFICASSPercent


--FICA MED

SELECT @decFICAMEDSalaryAndTips  =sum(decTaxablePay) FROM 	[dbo].[fnPay_tblCompanyTaxablePayPerPeriod](@PayrollCompany,@STARTDATE,@ENDDATE,'FICA MED') 

--	FICA MED Tax Percent
SET @decFICAMEDTaxPercent = .029
--	Total FICA MED Taxes
SET @decFICAMEDTax = @decFICAMEDSalaryAndTips *  @decFICAMEDTaxPercent


--FICA MED PLUS
--	Total FICA MED PLUS Salary in the Period
SELECT  @decFICAMEDPlusSalaryAndTips = iif(YEAR(@StartDate) = YEAR(@EndDate),	[dbo].[fnPay_WithholdingsEffectivePay_YTD] (   @PayrollCompany  ,@EndDate  ,cw.strWithHoldingsName,0)  
		-   [dbo].[fnPay_WithholdingsEffectivePay_YTD] (   @PayrollCompany  ,@StartDate  ,cw.strWithHoldingsName,0),0) FROM tblCompanyWithholdings cw 
		where  strCompanyName = @PayrollCompany  AND strWithHoldingsName IN ('FICA MED PLUS')


--	FICA MED Plus Tax Percent
SET @decFICAMEDPlusPercent = 0.009

--	Total FICA MED PLUS Taxes
SET @decFICAMEDPlusTax = @decFICAMEDPlusSalaryAndTips *  @decFICAMEDPlusPercent


-- Total FICA Tax
SET  @decFICATotalTax = @decFICASSTax + @decFICAMEDTax + @decFICAMEDPlusTax


--Total Employee Retention and Contribution
declare @FICAWithholdings decimal(18,2)
declare @FICAContributions decimal(18,2)
SELECT @FICAWithholdings  = -sum(cbw.decWithholdingsAmount)   FROM viewPay_UserBatchWithholdings cbw   
		where  strCompanyName = @PayrollCompany  AND strWithHoldingsName IN ('FICA SS','FICA MED','FICA MED PLUS') and dtPayDate between @STARTDATE and @ENDDATE

SELECT @FICAContributions = -sum(cbw.decWithholdingsAmount)   FROM viewPay_CompanyBatchWithholdings cbw   
		where  strCompanyName = @PayrollCompany  AND strWithHoldingsName IN ('FICA SS','FICA MED','FICA MED PLUS') and dtPayDate between @STARTDATE and @ENDDATE

SET @decFICARetention = @FICAWithholdings + @FICAContributions

--FICA ADJUST AMOUNT : EXPEVTED - PAID
SET @decFICAAdjust = @decFICATotalTax - @decFICARetention

insert @tbl941RReport
select strCompanyName, @STARTDATE, @ENDDATE,strEIN, strAddress1,strAddress2,strCity,strState,strZipCode
	,@intUsersCovered,@decFICASSSalary,@decFICASSTips,@decFICASSTax,@decFICASSTipsTax,@decFICASSPercent 
	,@decFICAMEDSalaryAndTips,@decFICAMEDTax,@decFICAMEDTaxPercent, @decFICAMEDPlusSalaryAndTips,@decFICAMEDPlusTax,@decFICAMEDPlusPercent,
	 @decFICATotalTax,@decFICARetention,@decFICAAdjust
	from tblCompanyPayrollInformation where strCompanyName = @PayrollCompany

RETURN
END

GO
