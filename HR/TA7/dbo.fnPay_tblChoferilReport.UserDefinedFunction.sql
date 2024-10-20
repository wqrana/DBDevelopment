USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblChoferilReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 05/15/2019
-- Description:	Quarterly Report for Choferil Taxes
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblChoferilReport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbChoferilReport TABLE 
(
	strCompanyName nvarchar(50),
	dtStartDate date,
	dtEndDate date,
	ChoferilUsersCovered int,
	ChoferilTotalWages decimal(18,5),
	ChoferilTaxableWages decimal(18,5),
	ChoferilExcludedWages decimal(18,5),
	ChoferilUserWithholdings decimal(18,5),
	ChoferilCompanyContributions decimal(18,5),
	ChoferilTotalWithholdings decimal(18,5),
	ChoferilWeeks int
	) 
	-- WITH ENCRYPTION
AS
BEGIN
--select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName = @PAYITEM 
Declare @ChoferilTotalWages decimal(18,5)
Declare @ChoferilTaxableWages decimal(18,5)
declare @UserCovered int
declare @ChauffeurWages decimal(18,5)
declare	@UserWithholdings decimal(18,5)
declare	@CompanyContributions decimal(18,5)
declare @ChoferilWeeks int

--DECLARE @CHOFERIL nvarchar(100)
--SET @CHOFERIL = '''CHOFERIL'',''Choferil'''
DECLARE @CHOFERIL  TABLE (Value nvarchar(50))
INSERT INTO @CHOFERIL VALUES ('CHOFERIL')
INSERT INTO @CHOFERIL VALUES ('Choferil')

	SELECT @ChoferilTotalWages = isnull(sum(decPay),0) from viewPay_UserBatchCompensations	ubc 
							inner join tblUserPRPayFields upr on ubc.intUserID = upr.intUserID
						where boolDeleted = 0 and dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany 
						and boolChauffeur = 1
	

--1 Number of Employees Covered by this policy
	SELECT @UserCovered = count(distinct ubc.intuserid) from viewPay_UserBatchCompensations	ubc 
							inner join tblUserPRPayFields upr on ubc.intUserID = upr.intUserID
						where boolDeleted = 0 and dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany 
						and boolChauffeur = 1
 

--2 Total Salaries Paid to the Covered Employees
	SELECT @ChoferilTaxableWages = isnull(sum(decPay),0) from viewPay_UserBatchCompensations	ubc 
				inner join tblCompensationItems ci on ubc.strCompensationName = ci.strCompensationName
					inner join tblUserPRPayFields upr on ubc.intUserID = upr.intUserID
					where ubc.boolDeleted = 0 and dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany 
					and boolChauffeur = 1 and ci.intCompensationType =1

		--5. User Withholdings
	SELECT @UserWithholdings =coalesce(sum(decWithholdingsAmount),0) from viewPay_UserBatchWithholdings ubw 
			inner join tblUserPRPayFields upr ON ubw.intUserID = upr.intUserID
			where boolDeleted = 0 and strCompanyName = @PayrollCompany and strWithHoldingsName IN (select value from @CHOFERIL) and dtPayDate between @STARTDATE AND @ENDDATE
			and upr.boolChauffeur = 1

--6. User Contributions
	SELECT @CompanyContributions = coalesce(sum(decWithholdingsAmount),0) from viewPay_CompanyBatchWithholdings cbw
			inner join tblUserPRPayFields upr ON cbw.intUserID = upr.intUserID
			where boolDeleted = 0 and strCompanyName = @PayrollCompany and strWithHoldingsName IN (select value from @CHOFERIL) and dtPayDate between @STARTDATE AND @ENDDATE
			and upr.boolChauffeur = 1

	--7 Choferil Weeks
 select @ChoferilWeeks= sum(NumSundays) FROM 
					(select ubc.intuserid, dbo.fnPay_NumberOfSundays(min(dtPayDate),max(dtPayDate)) as NumSundays 
						from viewPay_UserBatchCompensations	ubc inner join tblUserPRPayFields upr on ubc.intUserID = upr.intUserID
						where boolDeleted = 0 and dtPayDate between @StartDate and @EndDate and strCompanyName = @PayrollCompany 
						and boolChauffeur = 1  group by ubc.intUserID) sun
--5  = 2-3
	--Select employees that New law applies
	INSERT INTO @tbChoferilReport
	SELECT @PayrollCompany,@STARTDATE,@ENDDATE, @UserCovered, @ChoferilTotalWages, @ChoferilTaxableWages,(@ChoferilTotalWages - @ChoferilTaxableWages),@UserWithholdings, @CompanyContributions, (@UserWithholdings +@CompanyContributions),@ChoferilWeeks

RETURN
END
GO
