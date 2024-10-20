USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblFUTAReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnPay_tblFUTAReport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbSINOTReport TABLE 
(
	strCompanyName nvarchar(50),
	dtStartDate date,
	dtEndDate date,
	FutaUsersCovered int,
	FutaTotalWages decimal(18,5),
	FutaTaxableWages decimal(18,5),
	FutaExcludedWages decimal(18,5),
	FUTACompanyContributions decimal(18,5)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
--select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName = @PAYITEM 
Declare @FutaTotalWages decimal(18,5)
Declare @FutaTaxableWages decimal(18,5)
declare @UserCovered int
declare @CompanyContributions decimal(18,5)

DECLARE @FUTA nvarchar(100)
SET @FUTA = 'FUTA'

SELECT @FutaTotalWages =	( select coalesce(sum(decPay),0) from viewPay_UserBatchCompensations	
		where boolDeleted = 0 and dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany 
				and intUserID IN 
				(select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName IN (@FUTA) ))
	
--1 Number of Employees Covered by this policy
	SELECT @UserCovered = count( distinct wi.intUserID) FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp 
	ON wi.intUserID = ucp.intUserID where strCompanyName = @PayrollCompany and strWithHoldingsName IN (@FUTA) and ucp.intPayrollUserStatus > 0


--2 Total Salaries Paid to the Covered Employees
	SELECT @FutaTaxableWages=	( select coalesce(sum(decBatchEffectivePay),0) from viewPay_CompanyBatchWithholdings
		where boolDeleted = 0 and dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany and strWithHoldingsName IN (@FUTA)) 
		
--6. CompanyContributions
	SELECT @CompanyContributions = coalesce(sum(decWithholdingsAmount),0) from viewPay_CompanyBatchWithholdings
				where boolDeleted = 0 and strCompanyName = @PayrollCompany and strWithHoldingsName IN (@FUTA) and dtPayDate between @STARTDATE AND @ENDDATE
--5  = 2-3
	--Select employees that New law applies
	INSERT INTO @tbSINOTReport
	SELECT @PayrollCompany,@STARTDATE, @ENDDATE,  @UserCovered, @FutaTotalWages, @FutaTaxableWages,(@FutaTotalWages - @FutaTaxableWages),@CompanyContributions

RETURN
END

GO
