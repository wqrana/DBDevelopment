USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblAlplaEMISExport]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 12/7/2020
-- Description:	eMIS Export version 2.  Monthly summary
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblAlplaEMISExport]
(	
	-- Add the parameters for the function here
	@PAYROLLCOMPANY as nvarchar(50),
	@STARTDATE date,
	@ENDDATE date
)
RETURNS TABLE 
AS
RETURN 
(
select 
'201' as Plant_ID
, idno as	eMIS_Code
,1 as	FTE	
,isnull((select sum(decPay) from viewPay_UserBatchCompensations where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE and @ENDDATE and intUserID = UR.id
	and strCompensationName IN ('Regular Wages')),0) Gross_Wages	

, isnull((select sum(decPay) from viewPay_UserBatchCompensations where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE and @ENDDATE and intUserID = UR.id
	and strCompensationName  NOT IN ('Regular Wages','Christmas Bonus','Performance Bonus','Overtime','Overtime 2X','6to Dia','Sick Bonus')),0) Additional_Wages	

,isnull((select sum(decPay) from viewPay_UserBatchCompensations where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE and @ENDDATE and intUserID = UR.id
	and strCompensationName IN ('Christmas Bonus','Performance Bonus','Sick Bonus')),0) Bonus	

,isnull((select sum(decPay) from viewPay_UserBatchCompensations where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE and @ENDDATE and intUserID = UR.id
	and strCompensationName IN ('Overtime','Overtime 2X','6to Dia')),0) OverTime	
,isnull((select sum(decHours) from viewPay_UserBatchCompensations where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE and @ENDDATE and intUserID = UR.id
	and strCompensationName IN ('Overtime','Overtime 2X','6to Dia')),0) OverTime_Hours	
,-isnull((select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings  where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE and @ENDDATE and intUserID = UR.id),0) Total_Employer_Cost	
,'' as Bon_soz_ex	
,isnull((select sum(decHours) from viewPay_UserBatchCompensations where strCompanyName = @PAYROLLCOMPANY AND dtPayDate BETWEEN @STARTDATE and @ENDDATE and intUserID = UR.id
	and strCompensationName IN ('Regular Wages')),0) as Working_Hours	
,MONTH(@STARTDATE) as 'Month'
,YEAR(@STARTDATE) as 'Year'
from  viewpay_userrecord UR
where id in (select distinct intUserID from viewPay_UserBatchCompensations where strCompanyName = @PAYROLLCOMPANY and dtPayDate BETWEEN @STARTDATE and @ENDDATE)
)
GO
