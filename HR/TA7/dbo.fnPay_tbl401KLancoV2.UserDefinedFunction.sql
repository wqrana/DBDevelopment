USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tbl401KLancoV2]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 07/01/2020
-- Description:	401K export format for Lanco Version2
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tbl401KLancoV2]
(
	@BATCHID as nvarchar(50),
	@401KTrans as nvarchar(50)
)
RETURNS @tbl401KCoopOriental TABLE 
(
strPayrollDate nvarchar(50), --A
strPlanNumber nvarchar(50), --B
strSecSocNum nvarchar(50), --C
strFirstName nvarchar(50), --D
strName nvarchar(50), --E
strStatus nvarchar(50),--F
decEmployeeContribution decimal(18,2),--G
decEmployerMatch decimal(18,2),--H
strParticipationDate nvarchar(50), --I
strEligibilityIndicator nvarchar(50), --J
decLoanPayments decimal(18,2),--K
decYTDSalary decimal(18,2),--L
decYTDHours decimal(18,2),--M
strBlank nvarchar(50),--N
strBirthDate nvarchar(50), --O
strHireDate nvarchar(50),--P
strTermDate nvarchar(50),--Q
strBlank2 nvarchar(50),--R
strSex nvarchar(50),--S
strAddress1 nvarchar(50),--T
strAddress2 nvarchar(50),--U
strCity nvarchar(50),--V
strState nvarchar(50),--W
strZip nvarchar(50),--X
strATK1 nvarchar(50),--Y
strEmail nvarchar(50),--Z

strMaritalStatus nvarchar(1),
strHomePhoneNumber nvarchar(50),
strWorkPhoneNumber nvarchar(50),
decEmployeeAfterTax decimal(18,2),
decEmployerProfitSharing decimal(18,2),
strSalaryAmountQualifier nvarchar(1)

) 
AS
BEGIN

DECLARE @PayrollCompany nvarchar(50)
DECLARE @PayDate date
-----------
SELECT @PayrollCompany = strCompanyName, @PayDate = dtPayDate  from viewPay_Batch where strBatchID = @BATCHID

INSERT INTO @tbl401KCoopOriental 

SELECT  
	format(ubw.dtPayDate,'M/dd/yyyy') PayrollDate,
	w4.str401KDescription PlanNumber,

	 case len(ur.sssn)
		when 9 then (Substring(ur.sssn,1,3)+'-'+Substring(ur.sssn,4,2)+'-'+Substring(ur.sssn,6,4))
		when 8 then	('0'+Substring(ur.sssn,1,2)+'-'+Substring(ur.sssn,3,2)+'-'+Substring(ur.sssn,5,4))
		when 7 then ('00'+Substring(ur.sssn,1,1)+'-'+Substring(ur.sssn,2,2)+'-'+Substring(ur.sssn,4,4))
		when 6 then	('000-'+Substring(ur.sssn,1,2)+'-'+Substring(ur.sssn,3,4)) 
		ELSE ur.sssn END
 SecSoc,

	LTRIM(SUBSTRING(ur.name,(SELECT PATINDEX('%,%', ur.name))+1,100)) AS FirstName, --1
	
	SUBSTRING(ur.name,1, iif( (SELECT PATINDEX('%,%', ur.name))-1 <0, 0,(SELECT PATINDEX('%,%', ur.name))-1)) AS LastName, --2
	iif(ur.nstatus = 1,'A','T') Status,
	
	-[dbo].[fnPay_BatchUserWithholdingNameAmount](@BATCHID, ur.intUserID,@401KTRANS) as EmployeeContribution,
	
	-[dbo].[fnPay_BatchCompanyWithholdingNameAmount](@BATCHID, ur.intUserID,@401KTRANS) as EmployerMatch,
	
	DATEADD(d, 1,EOMONTH(dateadd(month, +6, ur.dOriginalHiredDate))) as ParticipationDate,
	
	iif(isnull(DATEADD(d, 1,EOMONTH(dateadd(month, +6, ur.dOriginalHiredDate))),@paydate)< @PayDate,'Y','N') Eligibility,
	
	-[dbo].[fnPay_BatchUserWithholdingNameAmount](@BATCHID, ur.intUserID,'401K LOAN') as 'LoanPayments',
	dbo.fnPay_YearToDateUserSalaryEarnings(ur.intuserid,@PayDate,ur.strcompanyname) YTDSalary,

	ISNULL((select sum(pp.dblHours) decHours from tPunchDateDetail pp where stype 
	IN (Select Name from tTransDef td where td.nIsMoneyTrans = 0)  AND pp.DTPunchDate BETWEEN DATEADD(yy, DATEDIFF(yy,0,@PayDate), 0) AND @PayDate AND pp.e_id = ur.intUserID ),0) YearHours,

	'' Blank,
	isnull(convert(varchar(10),convert(date,ue.dBirthDate),101),'') BirthDate,

	isnull(convert(varchar(10),convert(date,ue.dOriginalHiredDate),101),'') HireDate,

	isnull(convert(varchar(10),convert(date,ue.dTerminationDate),101),'') TerminationDate,
	'' Blank2,
	isnull(left(ue.sSex,1),'') as Sex,
	isnull(ur.sHomeAddressLine1,'') as Address1,
	isnull(ur.sHomeAddressLine2,'') as  Address2,
	isnull(ur.sHomeCity,'') as City,
	'PR' State,
	isnull(Left(ur.sHomeZipCode,5),'') Zip,
	 -[dbo].[fnPay_BatchUserWithholdingNameAmount](@BATCHID, ur.intUserID,'401K AFTER TAX') strATK1 ,
	isnull(ue.sJobTitle,'') as strEmail ,
	isnull(left(ur.sSex,1),'') as	strMaritalStatus ,
	'' as strHomePhoneNumber ,
	'' as strWorkPhoneNumber ,
	-[dbo].[fnPay_BatchUserWithholdingNameAmount](@BATCHID, ur.intUserID,'401K AFTER TAX')  as decEmployeeAfterTax ,
0 as decEmployerProfitSharing ,
'A' as strSalaryAmountQualifier 

	from 
	viewPay_UserBatchWithholdings ubw inner join	viewPay_UserRecord  ur on ubw.intUserID = ur.intUserID
	inner join tUserExtended ue on ur.id = ue.nUserID 
	inner join tblWithholdings401K w4 on ubw.strWithHoldingsName = w4.strWithholdingName
	WHERE 
	ubw.strBatchID = @BATCHID and ubw.strWithHoldingsName = @401KTrans
	AND (ur.dTerminationDate is null OR ur.dTerminationDate >  DATEADD(yy, DATEDIFF(yy, 0, @PayDate), 0)) 
	and dbo.fnPay_YearToDateUserSalaryEarnings(ur.intuserid,@PayDate,ur.strcompanyname) > 0
	and 
	([dbo].[fnPay_BatchUserWithholdingNameAmount](@BATCHID, ur.intUserID,@401KTRANS) <> 0 
	OR [dbo].[fnPay_BatchCompanyWithholdingNameAmount](@BATCHID, ur.intUserID,@401KTRANS) <> 0
	OR [dbo].[fnPay_BatchUserWithholdingNameAmount](@BATCHID, ur.intUserID,'401K LOAN') <>0)
	ORDER BY ur.name
RETURN
END
GO
