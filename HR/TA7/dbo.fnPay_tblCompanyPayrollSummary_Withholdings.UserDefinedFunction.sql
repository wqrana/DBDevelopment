USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCompanyPayrollSummary_Withholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 03/23/2021
-- Description:	For Company  Payroll Summary.  Returns all withholdings and their types for report
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblCompanyPayrollSummary_Withholdings]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50),
	@USERID int = 0,
	@PAYROLLCOMPANY nvarchar(50) ,
	@STARTDATE date ,
	@ENDDATE date ,
	@CompanyID int ,
	@DepartmentID int ,
	@SubDepartmentID int ,
	@EmployeeTypeID int 
)
RETURNS 
@tblBatchWithholdingsSummary TABLE 
(
	strBatchID nvarchar(50),
	strWithHoldingsName nvarchar(50), 
	strWithholdingsTaxTypeDescription nvarchar(50),
	EEWithhodings decimal(18,2),
	ERWithhodings decimal(18,2)
) 
-- WITH ENCRYPTION
AS
BEGIN
IF @BATCHID <> ''
BEGIN
	INSERT INTO @tblBatchWithholdingsSummary
	--fnPay_tblBatchWithholdingsSummary
	select max(strBatchID) as strBatchID, bws.strWithHoldingsName, max(bws.strWithholdingsTaxTypeDescription),sum(EEWithholdings)as EEWithholdings, sum(ERWithholdings) as ERWithholdings
	FROM
	(	SELECT strBatchID as strBatchID, cw.strWithHoldingsName,  wtt.strWithholdingsTaxTypeDescription
		,isnull((select round( sum(decWithholdingsAmount),2) from viewPay_UserBatchWithholdings ubw where ubw.strBatchID = @BATCHID and ubw.strWithHoldingsName = cw.strWithHoldingsName and ubw.intUserID = ubs.intUserID group by strWithHoldingsName),0)  as EEWithholdings
		,ISNULL((select round( sum(decWithholdingsAmount),2) from viewPay_CompanyBatchWithholdings cbw where cbw.strBatchID = @BATCHID and cbw.strWithHoldingsName = cw.strWithHoldingsName and cbw.intUserID = ubs.intUserID group by strWithHoldingsName),0)  as ERWithholdings
		FROM tblCompanyWithholdings cw 	inner join tblWithholdingsTaxTypes wtt ON cw.intWithholdingsTaxType = wtt.intWithholdingsTaxType
		inner join viewPay_UserBatchStatus ubs on cw.strCompanyName = ubs.strCompanyName
		where ubs.strBatchID = @BATCHID
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) ) bws
		GROUP BY bws.strWithHoldingsName
END
ELSE
BEGIN
	INSERT INTO @tblBatchWithholdingsSummary
	--fnPay_tblBatchWithholdingsSummary
	select max(strBatchID) as strBatchID, bws.strWithHoldingsName, max(bws.strWithholdingsTaxTypeDescription),sum(EEWithholdings)as EEWithholdings, sum(ERWithholdings) as ERWithholdings
	FROM
	(	SELECT strBatchID as strBatchID, cw.strWithHoldingsName,  wtt.strWithholdingsTaxTypeDescription
		,isnull((select round( sum(decWithholdingsAmount),2) from viewPay_UserBatchWithholdings ubw where ubw.strBatchID =ubs.strBatchID and ubw.strWithHoldingsName = cw.strWithHoldingsName and ubw.intUserID = ubs.intUserID group by strWithHoldingsName),0)  as EEWithholdings
		,ISNULL((select round( sum(decWithholdingsAmount),2) from viewPay_CompanyBatchWithholdings cbw where cbw.strBatchID =ubs.strBatchID and cbw.strWithHoldingsName = cw.strWithHoldingsName and cbw.intUserID = ubs.intUserID group by strWithHoldingsName),0)  as ERWithholdings
		FROM tblCompanyWithholdings cw 	inner join tblWithholdingsTaxTypes wtt ON cw.intWithholdingsTaxType = wtt.intWithholdingsTaxType
		inner join viewPay_UserBatchStatus ubs on cw.strCompanyName = ubs.strCompanyName
		where ubs.strCompanyName = @PAYROLLCOMPANY and ubs.dtPayDate BETWEEN @STARTDATE and @ENDDATE
		and (ubs.intCompanyID = @CompanyID OR @CompanyID = 0)
		and (ubs.intDepartmentID = @DepartmentID OR @DepartmentID = 0)
		and (ubs.intSubdepartmentID = @SubDepartmentID OR @SubDepartmentID = 0)
		and (ubs.intEmployeeTypeID = @EmployeeTypeID OR @EmployeeTypeID = 0)
		and (ubs.intUserID = @USERID OR @USERID = 0) ) bws
		GROUP BY bws.strWithHoldingsName
END
RETURN
END
GO
