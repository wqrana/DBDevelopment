USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblChoferilSummaryReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 04/01/2019
-- Description:	For Choferil Rentention/ContributionReport
-- Parameters:	Payroll Company, Start Date and End Date
--				Required for Planilla Choferl
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblChoferilSummaryReport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbChoferilReport TABLE 
(
	strNumeroPatronalChoferil nvarchar(50),
	strCompanyName nvarchar(50),
	strWithHoldingsName nvarchar(50),
	dtStartDate date,
	dtEndDate date,
	strSSN nvarchar(9),
	strFirstName nvarchar(30),
	strMiddleInital nvarchar(1),
	strLastName1 nvarchar(30),
	strLastName2 nvarchar(30),
	strDriversLicense nvarchar(7),
	decChauffeurWeeks int,
	strQuarter nvarchar(1),
	strYear nvarchar(4),
	decAportacionEmpleado decimal(18,2),
	decAportacionSemanas decimal(18,2),
	decContribucionPatronal decimal(18,2),
	decContribucionSemanas decimal(18,2)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
insert into @tbChoferilReport
	SELECT 
	(select isnull(strSeguroChoferilAccount,'') from tblCompanyPayrollInformation where strCompanyName = ubs.strCompanyName) strSeguroChoferilAccount
	,LEFT(ubs.strCompanyName,50) strCompanyName
	,strWithHoldingsName
	,@STARTDATE as dtStartDate
	,@ENDDATE as dtEndDate
	,LEFT(REPLACE(isnull(sSSN,''),'-',''),9) as sSSN --3

	,LEFT(FirstName,30) AS strFirstName --1 

	,LEFT(MiddleInitial,1) AS strMiddleName --1 

	,LEFT(FirstLastName,30) AS strLastFather --2 

	,LEFT(SecondLastName,30) AS strLastMother --2 
		
	,left((SELECT strDriversLicense  FROM [tblUserPRPayFields] where intUserID = ubs.intUserID),7) strDriversLicense
	
	------Check the number of weeks to see where to get them
	,isnull([dbo].[fnPay_NumberOfSundays](dtStartDatePeriod,dtEndDatePeriod ) ,0) as decChauffeurWeeks --AM

	,(SELECT DATEPART(QUARTER, @ENDDATE)) strQuarter
	,(SELECT DATEPART(YEAR, @ENDDATE)) strYear

	 ,(select isnull(sum(decWithholdingsAmount),0) from viewPay_UserBatchWithholdings  where strCompanyName = ubs.strCompanyName AND strWithHoldingsName =ubs.strWithHoldingsName 
	 and intUserID = ubs.intUserID AND dtPayDate between @STARTDATE and @ENDDATE)  decAportacionEmpleado

	 ,-(select isnull(sum(decWithholdingsAmount),0) from viewPay_UserBatchWithholdings  where strCompanyName = ubs.strCompanyName AND strWithHoldingsName =ubs.strWithHoldingsName 
	 and intUserID = ubs.intUserID AND dtPayDate between @STARTDATE and @ENDDATE)  /iif(decEmployeeAmount=0,1,decEmployeeAmount)  decSemanasEmpleado
	 
	 ,(select isnull(sum(decWithholdingsAmount),0) from viewPay_CompanyBatchWithholdings  where strCompanyName = ubs.strCompanyName AND strWithHoldingsName =ubs.strWithHoldingsName 
	 and ubs.intUserID = intUserID AND dtPayDate between @STARTDATE and @ENDDATE)  decContribucionCompania

	 	 ,-(select isnull(sum(decWithholdingsAmount),0) from viewPay_CompanyBatchWithholdings  where strCompanyName = ubs.strCompanyName AND strWithHoldingsName =ubs.strWithHoldingsName 
	 and ubs.intUserID = intUserID AND dtPayDate between @STARTDATE and @ENDDATE) / iif(decCompanyAmount =0,1,decCompanyAmount)  decSemanasCompania

	FROM 
	(select ubs.strCompanyName, ubs.intUserID, uwi.strWithHoldingsName, max(sSSN) as sSSN, max(u.name)  as strUserName
	,max(u.FirstName) FirstName,max(u.MiddleInitial) MiddleInitial,max(u.FirstLastName) FirstLastName,max(u.SecondLastName) SecondLastName,
	 max(uwi.decEmployeeAmount)as decEmployeeAmount , max(uwi.decCompanyAmount )as decCompanyAmount, min(ubs.dtStartDatePeriod)dtStartDatePeriod, max(ubs.dtEndDatePeriod)dtEndDatePeriod
	FROM

	viewPay_UserBatchStatus ubs	inner join tuser u on ubs.intUserID = u.id
	inner join tblUserPRPayFields upr on ubs.intUserID = upr.intUserID
	left outer join tblUserWithholdingsItems uwi on ubs.intUserID = uwi.intUserID 
	left outer join tblWithholdingsItems_PRPayExport prp on uwi.strWithHoldingsName = prp.strWithholdingsName  

	where ubs.dtPayDate between @STARTDATE AND @ENDDATE AND ubs.strCompanyName = @PayrollCompany
	and upr.boolChauffeur = 1
	and (prp.boolChauffeur_Insurance = 1 )
	GROUP BY ubs.strCompanyName, ubs.intUserID, uwi.strWithHoldingsName) ubs
 
 
RETURN
END

GO
