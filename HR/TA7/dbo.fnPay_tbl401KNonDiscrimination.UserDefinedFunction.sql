USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tbl401KNonDiscrimination]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Returns the fields to file a 401K Non discrimination file
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tbl401KNonDiscrimination]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbl401K TABLE 
(
	strSSN nvarchar(9),
	decTotalCompensation decimal(18,2), --Compensation paid For Determined Year
	decEmployeePreTaxContribution decimal(18,2), --Employee Pre-Tax Contribution
	strDivisionCode nvarchar(6), --Optional Division Code
	strLastName nvarchar(30), -- Last Name          
	strFirstName nvarchar(20), -- Last Name
	strParticipant nvarchar(1), -- A=Currently Participating T=Terminated N=Not Participating S=Hardship Suspension
	strOfficerStakeholder nvarchar(1), -- O= Officer S= 5% Shareholder
	decCompensationPaidLookBackYear decimal(18,2) -- compensation paid during the Look-back Period 
	) 
	-- WITH ENCRYPTION
AS
BEGIN

	DECLARE @401KDEDUCTION nvarchar(50)
	DECLARE @DELIMITER1 varchar(1), @DELIMITER2 varchar(1), @MAX_LENGTH int
	SET @DELIMITER1 = ','
	SET @DELIMITER2 = ' '
	SET @MAX_LENGTH = 50

	SELECT @401KDEDUCTION = cw.strWithHoldingsName FROM tblCompanyWithholdings cw inner join tblWithholdingsQualifierItems wqi on cw.strWithHoldingsName = wqi.strWithHoldingsName
	where  intWithHoldingsQualifierID = 0 and intQualifierValue = 1 and cw.strCompanyName = @PayrollCompany

	--Select employees that New law applies
	INSERT INTO @tbl401K



		select 
		LEFT(REPLACE(ur.sSSN,'-',''),9)  strSSN, 


		iif( DATEADD(d, 1,EOMONTH(dateadd(month, +9, ur.dOriginalHiredDate))) <= @startdate ,
		coalesce((select sum(decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport ppr on ubc.strCompensationName = ppr.strCompensationName  
		where strcompanyname =@payrollcompany  AND intuserid = ur.id and dtPayDate between @StartDate and @EndDate and  ubc.strcompensationname NOT IN ('Christmas Bonus')),0) ,
		coalesce((select sum(decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport ppr on ubc.strCompensationName = ppr.strCompensationName  
		where strcompanyname =@payrollcompany  AND intuserid = ur.id and dtPayDate between DATEADD(d, 1,EOMONTH(dateadd(month, +9, ur.dOriginalHiredDate))) and @EndDate and  ubc.strcompensationname NOT IN ('Christmas Bonus')),0) ) as decTotalCompensation,

		coalesce( -(select sum(decWithholdingsAmount) from viewpay_UserBatchWithholdings ubc inner join tblWithholdingsQualifierItems wqi on ubc.strWithHoldingsName = wqi.strWithHoldingsName
			where  intWithHoldingsQualifierID = 0 and intQualifierValue = 1 and ubc.strCompanyName = @PayrollCompany AND intuserid = ur.id and dtpaydate between @StartDate and @EndDate
			AND  UPPER( ubc.strWithHoldingsName) NOT LIKE '%CATCH%'
			AND  UPPER( ubc.strWithHoldingsName) NOT LIKE '%LOAN%')
			- (select isnull(sum(decPay),0) from viewPay_UserBatchCompensations 
			where  strCompanyName = @PayrollCompany and dtpaydate between @StartDate and @EndDate
			AND strCompensationName like '%Refund 401K%' AND intUserID = ur.id)	,0) as decEmployeePreTaxContribution,

		'' strDivisionCode,

		left(iif(charindex(',',ur.name)>0,left(ur.name,charindex(',',ur.name)-1), ur.name),30) as strLastName ,

		 CASE 
				-- Count the number of @DELIMITER2. Choose the string between the @DELIMITER1 and the final @DELIMITER2. 
				WHEN LEN(SUBSTRING(NAME, CHARINDEX(@DELIMITER1,Name)+ 2,@MAX_LENGTH)) - LEN(REPLACE(SUBSTRING(NAME, CHARINDEX(@DELIMITER1,Name)+ 2,@MAX_LENGTH), @DELIMITER2, '')) > 0
					Then SUBSTRING(Name, CHARINDEX(@DELIMITER1,Name)+ 2, 
						 (LEN(SUBSTRING(NAME, CHARINDEX(@DELIMITER1,Name)+ 2,@MAX_LENGTH))
						 - LEN(SUBSTRING(Name, LEN(Name) - CHARINDEX(@DELIMITER2, REVERSE(Name))+2, @MAX_LENGTH))))
				ELSE SUBSTRING(Name,CHARINDEX(@DELIMITER1,Name)+ 2,@MAX_LENGTH)
			END AS strFirstName,

		iif( ur.dTerminationDate IS NUll,
		iif(coalesce( -(select sum(decWithholdingsAmount) from viewpay_UserBatchWithholdings ubc inner join tblWithholdingsQualifierItems wqi on ubc.strWithHoldingsName = wqi.strWithHoldingsName
			where  intWithHoldingsQualifierID = 0 and intQualifierValue = 1 and ubc.strCompanyName = @PayrollCompany AND intuserid = ur.id and dtpaydate between @StartDate and @EndDate
			AND  UPPER( ubc.strWithHoldingsName) NOT LIKE '%CATCH%'
			AND  UPPER( ubc.strWithHoldingsName) NOT LIKE '%LOAN%')
			- (select isnull(sum(decPay),0) from viewPay_UserBatchCompensations 
			where  strCompanyName = @PayrollCompany and dtpaydate between @StartDate and @EndDate
			AND strCompensationName like '%Refund 401K%' AND intUserID = ur.id)	,0)> 0,'A','N'),
		'T') as strParticipant,

		'' strOfficerStakeholder,

		coalesce((select sum(decPay) from viewpay_UserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport ppr on ubc.strCompensationName = ppr.strCompensationName  
		where strcompanyname =@payrollcompany  AND intuserid = ur.id and dtPayDate between  DATEADD(yy,-1,DATEADD(yy,DATEDIFF(yy,0,@startdate),0)) and DATEADD(ms,-3,DATEADD(yy,0,DATEADD(yy,DATEDIFF(yy,0,@ENDDATE),0))) ),0)  decCompensationPaidLookBackYear
	
		from viewPay_UserRecord  ur inner join tUserExtended ue on ur.id = ue.nUserID 
		where strCompanyName = @PAYROLLCOMPANY 
		and (ur.dTerminationDate >= @StartDate  OR ur.dTerminationDate is null) 
		AND (DATEADD(d, 1,EOMONTH(dateadd(month, +9, ur.dOriginalHiredDate))) < @ENDDATE) 
		AND (ur.dTerminationDate is null OR ur.dTerminationDate > DATEADD(d, 1,EOMONTH(dateadd(month, +9, ur.dOriginalHiredDate)))) 
	
 
 RETURN
 END
GO
