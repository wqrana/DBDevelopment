USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblTaxQuarterlyReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 04/01/2019
-- Description:	For Taxes Verification Report
-- Parameters:	Payroll Company, Start Date and End Date
--				Required for Verifying Trimester and W2 Taxes
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblTaxQuarterlyReport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tblTaxesReport TABLE 
(
	strCompanyName nvarchar(50),
	intUseriD int,
	strUserName nvarchar(50),
	strSSN nvarchar(9),
	dtStartDate date,
	dtEndDate date,
	decQuarterWages decimal(18,2),
	decYearToWages decimal(18,2),
	decFICA_SS_Computed decimal(18,2),
	decFICA_SS_Withheld decimal(18,2),
	decFICA_SS_Diff decimal(18,2),
	decFICA_Med_Computed decimal(18,2),
	decFICA_Med_Withheld decimal(18,2),
	decFICA_Med_Diff decimal(18,2),
	decFUTA_Quarter decimal(18,2),
	decFUTA_YearTo decimal(18,2),
	decFUTA_Computed decimal(18,2),
	decFUTA_Diff decimal(18,2),
	decSUTA_Quarter decimal(18,2),
	decSUTA_YearTo decimal(18,2),
	decSUTA_Computed decimal(18,2),
	decSUTA_Diff decimal(18,2)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @YearStart date =  DATEADD(yy, DATEDIFF(yy, 0, @startdate), 0)
	DECLARE @YearEnd date = @ENDDATE
	DECLARE @SUTATrans nvarchar(50)
	DECLARE @SUTA as decimal(18,5) =0
	DECLARE @FUTATrans nvarchar(50)
	DECLARE @FUTA as decimal(18,5)= 0
	DECLARE @SINOTTrans nvarchar(50)
	DECLARE @SINOT as decimal(18,5)= 0
	DECLARE @FICASSLimit as decimal(18,5)= 0
	
	SELECT @SUTATrans = strWithHoldingsName  ,@SUTA  =decCompanyPercent from tblCompanyWithholdings where strWithHoldingsName = 'SUTA' AND strCompanyName = @PayrollCompany 
	SELECT @FUTATrans = strWithHoldingsName, @FUTA  =decCompanyPercent from tblCompanyWithholdings where strWithHoldingsName = 'FUTA' AND strCompanyName = @PayrollCompany 
	SELECT TOP(1)  @SINOTTrans = strWithHoldingsName ,@SINOT =decCompanyPercent from tblCompanyWithholdings where strWithHoldingsName IN ('SINOT','DISABILITY') AND strCompanyName = @PayrollCompany 
	--Get FICA Limit From Company 
	SELECT @FICASSLimit =decMaximumSalaryLimit from tblCompanyWithholdings where strWithHoldingsName = 'FICA SS' AND strCompanyName = @PayrollCompany 

insert into @tblTaxesReport 
select  strCompanyName Company
, intUserID UserID
, max(strUserName) UserName
,max(replace(sSSN,'-','')) strSSN
,@STARTDATE dtStartDate
,@ENDDATE  dtEndDate
, sum(decPay) as QPay,
(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1)) YearPay,

iif((select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1)) > @FICASSLimit, @FICASSLimit,
(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))) * .0620 'FICA SS Comp',

coalesce((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = 'FICA SS'),0) 'FICA SS PAID',

iif((select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1)) > @FICASSLimit, @FICASSLimit,
(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))) * .0620  +
coalesce((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = 'FICA SS'),0) 'FICA SS DIFF',

(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))*.0145 'FICA MED Comp',

coalesce((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = 'FICA MED'),0) 'FICA MED PAID',

(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))*.0145 +
coalesce((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = 'FICA MED'),0) 'FICA MED DIFF',

coalesce((select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings ubw where dtPayDate between @STARTDATE and @ENDDATE and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = @FUTATrans),0) 'QFUTA',
coalesce((select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = @FUTATrans),0) 'YFUTA',

-ROUND(iif((select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))< 7000,(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))*@FUTA/100, (7000.00 * @FUTA / 100)),2) 'FUTA_Calc',

-ROUND(iif((select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))< 7000,(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))*@FUTA/100, (7000.00 * @FUTA / 100)),2) 
-
coalesce((select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName =@FUTATrans),0)  'FUTAAdjust',


coalesce((select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings ubw where dtPayDate between @STARTDATE and @ENDDATE and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = @SUTATrans),0) QSUTA,
coalesce((select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = @SUTATrans),0) YSUTA,

-ROUND(iif((select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))< 7000,(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))*@SUTA/100, (7000.00 * @SUTA / 100)),2) SUTA_Calc,

-ROUND(iif((select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))< 7000,(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))*@SUTA/100, (7000.00 * @SUTA / 100)),2) 
-
coalesce((select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = @SUTATrans),0) SUTAAdjust

--coalesce((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where dtPayDate between @STARTDATE and @ENDDATE and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = 'SINOT'),0) EQSinot,
--coalesce((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = 'SINOT'),0) EYSinot,

--coalesce((select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings ubw where dtPayDate between @STARTDATE and @ENDDATE and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = 'SINOT'),0) PQSinot,
--coalesce((select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = 'SINOT'),0) PYSinot,
 
--ROUND(iif((select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
--and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))< 9000,(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
--and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))*@SINOT/100, (9000.00 * @SINOT / 100)),2) SINOT_Calc,

--coalesce((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = 'SINOT'),0)
--+ROUND(iif((select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
--and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))< 9000,(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
--and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))*@SINOT/100, (9000.00 * @SINOT / 100)),2)  ESinotAdjust,

--coalesce((select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings ubw where dtPayDate between @YearStart and @YearEnd and ubw.strCompanyName = ubc.strCompanyName and ubw.intuserid =ubc.intuserid and strWithHoldingsName = 'SINOT'),0)
--+ROUND(iif((select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
--and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))< 9000,(select sum(decPay)  FROM viewPay_UserBatchCompensations  yc  where yc.dtPayDate between @YearStart and @YearEnd and yc.strCompanyName = ubc.strCompanyName and yc.intuserid =ubc.intuserid
--and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1))*@SINOT/100, (9000.00 * @SINOT / 100)),2)   PSinotAdjust

from viewPay_UserBatchCompensations ubc where dtPayDate between @STARTDATE and @ENDDATE
and strCompensationName in (select strCompensationName from tblCompensationItems where intCompensationType = 1)
and (ubc.strCompanyName = @PayrollCompany )
group by strCompanyName, intUserID
order by strCompanyName, intUserID
RETURN
END

GO
