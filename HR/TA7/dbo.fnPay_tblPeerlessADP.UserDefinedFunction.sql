USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPeerlessADP]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnPay_tblPeerlessADP]
(
	@PayrollCompany as nvarchar(50) ,
	@BATCHID as nvarchar(50) 
)
RETURNS 
@tblPeerlessADP TABLE 
(
	USERID int,
	EMPLOYEENAME nvarchar(50),
	HOMEDEPT int,
	HRS_REG decimal(18,2),
	HRS_OT decimal(18,2),	
	HRS_D decimal(18,2),
	HRS_H decimal(18,2),
	HRS_I decimal(18,2),
	HRS_J decimal(18,2),
	HRS_M decimal(18,2),
	HRS_S decimal(18,2),
	HRS_V decimal(18,2),
	EARNS_REG decimal(18,2),
	EARNS_OT decimal(18,2),
	EARNS_D decimal(18,2),
	EARNS_F decimal(18,2),
	EARNS_H decimal(18,2),
	EARNS_I decimal(18,2),
	EARNS_J decimal(18,2),
	EARNS_M decimal(18,2),
	EARNS_N decimal(18,2),
	EARNS_R decimal(18,2),
	EARNS_S decimal(18,2),
	EARNS_V decimal(18,2),
	GROSS_PAY decimal(18,2),
	SS_TAX decimal(18,2),
	MED_TAX decimal(18,2),
	ADD_MED_TAX decimal(18,2),
	SIT decimal(18,2),
	SUI_SDI_TAX decimal(18,2),
	DED_C decimal(18,2),
	DED_D decimal(18,2),
	DED_E decimal(18,2),
	DED_F decimal(18,2),
	DED_G decimal(18,2),
	DED_I decimal(18,2),
	DED_K decimal(18,2),	
	DED_M decimal(18,2),
	DED_T decimal(18,2),
	DED_U decimal(18,2),
	V_CHECKS decimal(18,2),
	W_SAVE decimal(18,2),
	X_CHECKS decimal(18,2),
	Y_CHECKS decimal(18,2),
	Z_CHECKS decimal(18,2),
	NET_PAY  decimal(18,2),
	PAY_DATE date,
	CHECKS  decimal(18,2),
	ADJUST  decimal(18,2),
	CHECK_NUM  decimal(18,2),
	SS_ER_TAX  decimal(18,2),
	MED_ER_TAX  decimal(18,2),
	Short_Charge decimal(18,2),
Meal_penalty decimal(18,2),
Birthday decimal(18,2),
Call_In decimal(18,2),
Car_Allowance decimal(18,2),
Agreement decimal(18,2),
Severance_Pay decimal(18,2),
Meal_ticket  decimal(18,2),
Child_Support decimal(18,2),
Twic decimal(18,2),
Loan decimal(18,2),
CC_Sinot decimal(18,2),
CC_Suta decimal(18,2),
CC_Futa decimal(18,2),
CC_Choferil decimal(18,2),
CC_CFSE decimal(18,2),
	MISCELLANEOUS decimal(18,2),
	ONCALL decimal(18,2),
	COMISSION decimal(18,2),
	REFUND decimal(18,2),
	OTHERCOMPENSATION decimal(18,2),
	REFUND401K decimal(18,2),
	EFMLAE decimal(18,2),
	EPSLA decimal(18,2),
	SPECIAL_EMERGENCY decimal(18,2),
	Fleet_Card decimal(18,2),
	RefundHealthPlan decimal(18,2)
) 
	-- WITH ENCRYPTION
AS
BEGIN
	INSERT INTO @tblPeerlessADP
SELECT 
	intuserid  USERID, --FILE
		strUserName EMPLOYEENAME , --EMPLOYEE NAME
	COALESCE((select CODE FROM tdept where ID  = intDepartmentID ),'') HOMEDEPT , --HOME DEPT
	--HOURS
	COALESCE((select sum(decHours) from tblUserBatchCompensations ubc where ubc.intuserid = ubs.intuserid AND ubc.strbatchid = ubs.strbatchid AND ubc.strCompensationName = 'Regular Wages' ),0) HRS_REG,  --REGULAR HOURS
	COALESCE((select sum(decHours) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Overtime' ),0) HRS_OT ,	--OVERTIME HOURS PTT
	COALESCE((select sum(decHours) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Overtime 2X' ),0) HRS_D ,--DOUBLE OVERTIME HOURS
	COALESCE((select sum(decHours) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Holiday' ),0) HRS_H ,--HOLIDAY HOURS
	
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Attendance Bonus Hrs' ),0)  HRS_I,  --SICKBO HOURS

	COALESCE((select sum(decHours) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Shift Differential' ),0) HRS_J ,-- SHIFT EARNINGS
	COALESCE((select sum(decHours) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Maternity' ),0) HRS_M , --MATERNITY EARNINGS
	COALESCE((select sum(decHours) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Sick' ),0)  as HRS_S , --SICK HOURS
	COALESCE((select sum(decHours) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Vacation' ),0) HRS_V , --VACATION HOURS
	--EARNINGS
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Regular Wages' ),0) EARNS_REG , --REGULAR EARNINGS
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Overtime' ),0) EARNS_OT , --OVERTIME EARNINGS PTT
	COALESCE((select sum(decpay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Overtime 2X' ),0) EARNS_D ,--DOUBLE OVERTIME EARNINGS
	COALESCE((select sum(decpay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName NOT IN ('Regular Hours','Overtime', 'Overtime 2X','Sick','Vacation','Meal Ticket') ),0) EARNS_F , --OTHER EARNINGS (all others
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Holiday' ),0) EARNS_H , --HOLIDAY EARNINGS
	
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Attendance Bonus Earnings' ),0)   EARNS_I , --SICKBO EARNINGS
	
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Shift Differential' ),0) EARNS_J ,--SHIFT EARNINGS
	COALESCE((select sum(decHours) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Maternity' ),0) EARNS_M ,--MATERNITY EARNINGS

	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Funeral' ),0)    EARNS_N ,--FUNERAL EARNINGS

	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Retroactive' ),0) EARNS_R ,--RETRO EARNINGS
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Sick' ),0) EARNS_S ,--SICK EARNINGS
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Vacation' ),0) EARNS_V , --VACATION EARNINGS
	--GROSS PAY
	ubs.decBatchUserCompensations as GROSS_PAY ,--GROSS PAY
	--EMPLOYE TAXES
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName = 'FICA SS' ),0) SS_TAX , --SOCIAL SECURITY TAX DEDUCTED
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName = 'FICA MED' ),0) MED_TAX , --MEDICARE TAX DEDUCTED
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName = 'FICA MED PLUS' ),0) ADD_MED_TAX ,--ADDITIONAL MEDICARE TAX DEDUCTED
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName = 'ST ITAX' ),0)  SIT ,--STATE INCOME TAX DEDUCTED
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('SUTA') ),0) SUI_SDI_TAX ,-- SUI/SDI TAX DEDUCTED
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('CHOFERIL') ),0) DED_C , --CHAUFFEUR
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('SINOT') ),0) DED_D ,--SDI TAX DEDUCTED
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('Generator') ),0) DED_E ,--MISCELLANEOUS DEDUCTION
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('Fuel') ),0) DED_F ,--FUEL DEDUCTION
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('ASUME','Embargo') ),0) DED_G ,-- GARISHMENT DEDUCTION
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('AFLAC','TOLIC','TRIPLE S','COSVI') ),0)  DED_I ,--INSURANCE DEDUCTION
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('401 K') ),0) DED_K ,	--401K SAVIGS DEDUCTION
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('Medical Plan') ),0) DED_M ,--MEDICAL DEDUCTION
	
	0 DED_T ,--MEALS COMPENSATION
	
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('Union Initial Fee','Union Quota') ),0) DED_U, -- UNION DEDUCTION
	--PAY CHECKS
	COALESCE((select top(1) decCheckAmount from tblUserPayChecks where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid  and intpaymethodType = 2 ORDER BY intSequenceNum ),0) V_CHECKS , --1st Direct Deposit
	COALESCE((SELECT TOP(1) decCheckAmount FROM (select decCheckAmount from tblUserPayChecks where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid  and intpaymethodType = 2 ORDER BY intSequenceNum ASC OFFSET 1 ROWS) t ),0) W_SAVE , --2nd Direct Deposit
	COALESCE((SELECT TOP(1) decCheckAmount FROM (select decCheckAmount from tblUserPayChecks where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid  and intpaymethodType = 2 ORDER BY intSequenceNum ASC OFFSET 2 ROWS) t ),0) X_CHECKS , -- 3rd Direct Deposit
	COALESCE((SELECT TOP(1) decCheckAmount FROM (select decCheckAmount from tblUserPayChecks where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid  and intpaymethodType = 2 ORDER BY intSequenceNum ASC OFFSET 3 ROWS) t ),0) Y_CHECKS,  --4th Direct Deposit
	COALESCE((SELECT TOP(1) decCheckAmount FROM (select decCheckAmount from tblUserPayChecks where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid  and intpaymethodType = 2 ORDER BY intSequenceNum ASC OFFSET 4 ROWS) t ),0) Z_CHECKS , --5th Direct Deposit
	ubs.decBatchNetPay NET_PAY  ,--NET PAY
	ubs.dtPayDate PAY_DATE , --DATE
	COALESCE((select top(1) decCheckAmount from tblUserPayChecks where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid  and intpaymethodType = 1 ORDER BY intSequenceNum ),0) CHECKS ,--CHECK AMOUNT
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Adjustment' ),0)  ADJUST  , --ADJUSTMENTS
	COALESCE((select top(1) intCheckNumber from tblUserPayChecks where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid  and intpaymethodType = 1 ORDER BY intSequenceNum ),0) CHECK_NUM  ,--CHECK #S
	COALESCE((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName = 'FICA SS' ),0) SS_ER_TAX  ,--SOCIAL SECURITY TAX EMPLOYER
	COALESCE((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName = 'FICA MED' ),0) MED_ER_TAX , 

	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName IN ('Short Charge') ),0)   Short_Charge,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName IN ('Meal') ),0)   Meal_penalty,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName IN ('Birthday') ),0)   Birthday ,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName IN ('Call In') ),0)   Call_In ,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName IN ('Car Allowance') ),0)   Car_Allowance,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName IN ('Agreement') ),0)   Agreement ,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName IN ('Severance Pay') ),0)   Severance_Pay ,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName IN ('Meal Ticket') ),0)   Meal_ticket  ,

	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('CHILD SUPPORT') ),0)  Child_Support ,
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('Twic') ),0)  Twic ,
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('Loan') ),0)  Loan,

	COALESCE((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName = 'SINOT' ),0) CC_Sinot ,
	COALESCE((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName = 'SUTA' ),0) CC_Suta ,
	COALESCE((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName = 'FUTA' ),0) CC_Futa ,
	COALESCE((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName = 'Choferil' ),0) CC_Choferil ,
	COALESCE((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName = 'CFSE' ),0) CC_CFSE ,
		
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('Miscellaneous', 'Miscellaneous 2') ),0)  MISCELLANEOUS ,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'On Call $$' ),0)  ONCALL$$ ,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Commission' ),0) COMISSION ,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Refund' ),0) REFUND ,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Other Compensation' ),0) OTHERCOMPENSATION, 
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = '401K Refund' ),0) REFUND401K ,
	
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'EFMLEA' ),0) EFMLEA ,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'EPSLA' ),0) AS EPSLA,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Special Emergency' ),0)  as 	SPECIAL_EMERGENCY ,
	COALESCE((select sum(decWithholdingsAmount) from tblUserBatchWithholdings where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strWithHoldingsName IN ('Fleet Card') ),0)    as 	Fleet_Card ,
	COALESCE((select sum(decPay) from tblUserBatchCompensations where intuserid = ubs.intuserid AND strbatchid = ubs.strbatchid AND strCompensationName = 'Refund Health Plan' ),0)  as 	RefundHealthPlan 
	FROM viewPay_UserBatchStatus ubs where strBatchID = @BATCHID
	
	ORDER BY intuserid, dtPayDate asc

RETURN
END

GO
