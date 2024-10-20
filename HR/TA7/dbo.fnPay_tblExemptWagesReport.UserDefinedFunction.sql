USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblExemptWagesReport]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date:1/15/20216
-- Description: Exempt Wages Report
-- Returns the wages, age and if the employee is ecempt.
-- Expect full year parameters
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblExemptWagesReport]
(	
	-- Add the parameters for the function here
	@PAYROLLCOMPANY nvarchar(50),
	@STARTDATE date,
	@ENDDATE date
)
RETURNS TABLE 

-- WITH ENCRYPTION
AS
RETURN
select 
 ubs.strCompanyName Company
, ubs.intUserID UserID
,max(ur.name) UserName
,max(ubs.sSSN) SSN
,@STARTDATE StartDate
,@ENDDATE as EndDate
,(select isnull(sum(decPay),0) from viewPay_UserBatchCompensations ubc inner join tblCompensationItems ci on ubc.strCompensationName = ci.strCompensationName 
WHERE ci.intCompensationType = 1 AND  ubc.strCompanyName = ubs.strCompanyName and ubc.intUserID = ubs.intUserID and dtPayDate BETWEEN @STARTDATE and @ENDDATE 
) as Wages
,ISNULL((select SUM(dbo.fnPay_BatchTaxablePay(strBatchID,intUserID)) from viewPay_UserBatchStatus ubc inner join tUserExtended ue on ubc.intUserID = ue.nUserID 
		where (ubs.strCompanyName = @PayrollCompany OR @PayrollCompany = '') and   dtPayDate BETWEEN @STARTDATE and @ENDDATE  AND ubc.intUserID = ubs.intUserID
		and (cast(format(@ENDDATE,'yyyy') as int) - cast(format((dBirthDate),'yyyy') as int))  < 27),0) 
		 as ExemptWages
,(select isnull(sum(decPay),0) from viewPay_UserBatchCompensations ubc 
where ubc.strCompanyName = ubs.strCompanyName and ubc.intUserID = ubs.intUserID and dtPayDate BETWEEN @STARTDATE and @ENDDATE 
) as TotalCompensations,
(select isnull(sum(decWithholdingsAmount),0) from viewPay_UserBatchWithholdings ubc inner join tblWithholdingsQualifierItems qi on ubc.strWithHoldingsName = qi.strWithHoldingsName 
where ubc.strCompanyName = ubs.strCompanyName and ubc.intUserID = ubs.intUserID and dtPayDate BETWEEN @STARTDATE and @ENDDATE  and intWithHoldingsQualifierID = 0 and intQualifierValue = 1
) as wh401K
,isnull(max(ur.dBirthDate),'') BirthDate
,isnull((CONVERT(int,CONVERT(char(8),DATEADD(yy, DATEDIFF(yy, 0, @ENDDATE) + 1, -1) ,112))-CONVERT(char(8),max(dBirthDate),112))/10000.0,0) AS AgeIntYears
,cast(format(@ENDDATE,'yyyy') as int) - cast(format(max(dBirthDate),'yyyy') as int) AS AgeIntYears2
,IIF(cast(format(@ENDDATE,'yyyy') as int) - cast(format(max(dBirthDate),'yyyy') as int) < 27.0,'Y','N') AS Exempt
from viewPay_UserBatchStatus ubs inner join viewPay_UserRecord ur on ubs.intUserID = ur.intUserID
WHERE (ubs.strCompanyName = @PayrollCompany OR @PayrollCompany = '') and   dtPayDate BETWEEN @STARTDATE and @ENDDATE
group by ubs.strCompanyName, ubs.intUserID


GO
