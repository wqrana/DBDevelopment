USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblTrimesterReports]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/03/2020
-- Description:	Reporte de trimestre PRPay
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblTrimesterReports]
(
	-- Add the parameters for the function here
	@PayrollCompany as nvarchar(50),
	@StartDate as date,
	@EndDate as date
)
RETURNS TABLE 
AS
RETURN 
(
	-- Fill the table variable with the rows for your result set
select 
strCompanyName,
intUserID,
strUserName,
sSSN ,
strbatchid, 
--'Month:' + cast(dc.TheMonth as varchar(2)) + '/' + cast(dc.TheYear as varchar(4)) TheMonth,
--cast(dc.TheMonth as varchar(2)) + '/' + cast(dc.TheYear as varchar(4)) TheMonth,
'Month:' + format(dc.TheMonth,'00') + '/' + cast(dc.TheYear as varchar(4)) TheMonth,
'Qtr:'+ cast(dc.TheQuarter as varchar(1))  + '/' + cast(dc.TheYear as varchar(4)) TheQuarter,
isnull(strSubdepartment,'') as strDepartment,
(dtPayDate)as dtPayDate,
(decBatchUserCompensations) Gross,
(decBatchNetPay) NetPay,
(select isnull(sum(ubc.decPay),0) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName
where prp.boolCommissions = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID) as Commissions ,
(select isnull(sum(ubc.decPay),0) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName
where prp.boolAllowances = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID) as Allowances ,
(select isnull(sum(ubc.decPay),0) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName
where prp.boolTips = 1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID) as Tips ,
(select isnull(sum(ubc.decPay),0) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName
where (prp.boolTips <> 1 AND prp.boolTips <> 1 and prp.boolAllowances <> 1) and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID) as Others ,
(select isnull(sum(ubc.decPay),0) from tblUserBatchCompensations ubc inner join tblCompensationItems ci on ubc. strCompensationName = ci.strCompensationName
where ci.intCompensationType =1 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID) as Wages ,
(select isnull(sum(ubc.decPay),0) from tblUserBatchCompensations ubc inner join tblCompensationItems ci on ubc. strCompensationName = ci.strCompensationName
where ci.intCompensationType =2 and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID) as Reimbursements ,
(select isnull(sum(ubc.decPay),0) from tblUserBatchCompensations ubc inner join tblCompensationsItems_PRPayExport prp on ubc.strCompensationName = prp.strCompensationName
where (prp.boolCODA_401K = 1) and ubc.strBatchID = ubs.strBatchID and ubc.intUserID = ubs.intUserID) as CODA ,
0 as SalaryExempt,
'' as Codigo,
0 as RETDA,
-isnull((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID  and strWithHoldingsName IN ('FICA SS')),0) FICASS,
-isnull((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID  and strWithHoldingsName IN ('FICA MED')),0) FICAMED,
-isnull((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID  and strWithHoldingsName IN ('FICA MED PLUS')),0) FICAMEDPLUS,
-isnull((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID  and strWithHoldingsName IN ('ST ITAX')),0) STITAX,
-isnull((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID and strWithHoldingsName IN ('SINOT','DISABILITY')),0) SINOT,
-isnull((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID and strWithHoldingsName IN ('CHOFERIL')),0) CHOFERIL,

0 as Semanas,

-isnull((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID  and strWithHoldingsName 
NOT IN ('FICA SS','FICA MED','FICA MED PLUS','ST ITAX','SINOT','DISABILITY','CHOFERIL')),0) OtherDeductions,
-isnull((select sum(decWithholdingsAmount) from viewPay_UserBatchWithholdings ubw where ubw.strBatchID = ubs.strBatchID  and ubw.intUserID = ubs.intUserID  ),0) TotalDeductions


from viewPay_UserBatchStatus  ubs inner join DateCalendar dc on ubs.dtPayDate = dc.TheDate
where strCompanyName = @PAYROLLCOMPANY
AND dtPayDate between @STARTDATE and @ENDDATE


)
GO
