USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblSINOTReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnPay_tblSINOTReport]
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
	SinotUsersCovered int,
	SinotTotalWages decimal(18,5),
	SinotTaxableWages decimal(18,5),
	SinotExcludedWages decimal(18,5),
	ChauffeurWages decimal(18,5),
	SinotUserWithholdings decimal(18,5),
	SinotCompanyContributions decimal(18,5),
	SinotTotalWithholdings decimal(18,5)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
--select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName = @PAYITEM 
Declare @SinotTotalWages decimal(18,5)
Declare @SinotTaxableWages decimal(18,5)
declare @UserCovered int
declare @ChauffeurWages decimal(18,5)
declare	@UserWithholdings decimal(18,5)
declare @CompanyContributions decimal(18,5)

DECLARE @SINOT nvarchar(100)
SET @SINOT = 'SINOT'

SELECT @SinotTotalWages =	( select coalesce(sum(decPay),0) from viewPay_UserBatchCompensations	
		where boolDeleted = 0 and dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany 
				and intUserID IN 
				(select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName IN (@SINOT) ))
	
--1 Number of Employees Covered by this policy
	SELECT @UserCovered = count( distinct wi.intUserID) FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp 
	ON wi.intUserID = ucp.intUserID where strCompanyName = @PayrollCompany and strWithHoldingsName IN (@SINOT) and ucp.intPayrollUserStatus > 0
 
--2 Total Salaries Paid to the Covered Employees
	SELECT @SinotTaxableWages=	( select coalesce(sum(decBatchEffectivePay),0) from viewPay_CompanyBatchWithholdings
		where boolDeleted = 0 and dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany and strWithHoldingsName IN (@SINOT)) 

--4 Salaries Paid to Chauffeurs
		SELECT @ChauffeurWages =	( select coalesce(sum(decPay),0) from viewPay_UserBatchCompensations	
		where boolDeleted = 0 and dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany 
				and intUserID IN  
				(select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and wi.strWithHoldingsName = 'Choferil' where (decCompanyPercent <> 0 OR decEmployeePercent <> 0 OR decEmployeeAmount <> 0 or decCompanyAmount <> 0) )) 

--5. User Withholdings
	SELECT @UserWithholdings =coalesce(sum(decWithholdingsAmount),0) from viewPay_UserBatchWithholdings
		where boolDeleted = 0 and strCompanyName = @PayrollCompany and strWithHoldingsName IN (@SINOT) and dtPayDate between @STARTDATE AND @ENDDATE

--6. User Withholdings
	SELECT @CompanyContributions = coalesce(sum(decWithholdingsAmount),0) from viewPay_CompanyBatchWithholdings
				where boolDeleted = 0 and strCompanyName = @PayrollCompany and strWithHoldingsName IN (@SINOT) and dtPayDate between @STARTDATE AND @ENDDATE

--5  = 2-3
	--Select employees that New law applies
	INSERT INTO @tbSINOTReport
	SELECT @PayrollCompany, @STARTDATE, @ENDDATE,  @UserCovered, @SinotTotalWages, @SinotTaxableWages,(@SinotTotalWages - @SinotTaxableWages),@ChauffeurWages,@UserWithholdings, @CompanyContributions, (@UserWithholdings +@CompanyContributions)

RETURN
END

GO
