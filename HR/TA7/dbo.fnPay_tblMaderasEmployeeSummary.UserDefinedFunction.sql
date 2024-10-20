USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblMaderasEmployeeSummary]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--Employee Summary Report for Maderas and general use
--The report uses the table tblReportRegularHours to determine regular hours
CREATE FUNCTION [dbo].[fnPay_tblMaderasEmployeeSummary]
(
	@PayrollCompany as nvarchar(50) ,
	@BATCHID as nvarchar(50) 
)
RETURNS TABLE 
AS
RETURN 
(
SELECT 
	ubs.strCompanyName ,
	ubs.strBatchDescription Payroll,
	intuserid  USERID, --FILE
	strUserName EMPLOYEENAME , --EMPLOYEE NAME
	COALESCE((select CODE FROM tdept where ID  = intDepartmentID ),'') HOMEDEPT , --HOME DEPT
	--HOURS
	COALESCE((select sum(dblhours) from tblPunchDateDetail pdd where (sType IN (select [strTransactionName] from [dbo].[tblMaderasRegTransHours]) OR sType = 'HR') and pdd.e_id = ubs.intuserid AND pdd.strbatchid = ubs.strbatchid ),0) HRS_REG,  --TOTAL HR AND TABLE HOURS (table)
	COALESCE((select sum(decHours) from tblUserBatchCompensations ubc where ubc.intuserid = ubs.intuserid AND ubc.strbatchid = ubs.strbatchid AND ubc.strCompensationName = 'Regular Wages' ),0) HRS_RegWages,  --REGULAR WAGES HOURS
	--EARNINGS
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Regular Wages' ),0) EARNS_REG , --REGULAR EARNINGS
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName IN ('Overtime' ,'Overtime 2X' )),0) EARNS_OT , --OVERTIME EARNINGS 
	--GROSS PAY
	ubs.decBatchUserCompensations as GROSS_PAY ,--GROSS PAY
	--EMPLOYE TAXES
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('FICA SS','FICA MED','FICA MED PLUS','ST ITAX','SUTA','CHOFERIL','SINOT') ),0) TOTAL_TAXES , --TAXES
	--TOTAL DEDUCTIONS	
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName NOT IN ('FICA SS','FICA MED','FICA MED PLUS','ST ITAX','SUTA','CHOFERIL','SINOT') ),0) TOTAL_DEDUCTIONS , --OTHER DEDUCTIONS
	--NET PAY
	ubs.decBatchNetPay NET_PAY  --NET PAY

	FROM viewPay_UserBatchStatus ubs where strBatchID = @BATCHID

)
GO
