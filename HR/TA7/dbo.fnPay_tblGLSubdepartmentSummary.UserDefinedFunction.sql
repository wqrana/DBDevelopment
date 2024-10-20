USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblGLSubdepartmentSummary]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 02/28/2019
-- Description:	For Machuca Subdepartment GL Summary
-- Parameters:	BatchID OR (PayrollCompanyName, StartDate, EndDate)
--				Uses SubDepartmentID 33 as coordinadores group
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblGLSubdepartmentSummary]
(	
	-- Add the parameters for the function here
	@BatchID nvarchar(50),
	@PayrollCompany nvarchar(50),
	@StartDate datetime,
	@EndDate datetime
)
RETURNS 
@tblGLSubdepartmentSummary TABLE 
(
	strPayrollCompany nvarchar(50),
	strItemType nvarchar(50),
	strSubdepartment nvarchar(50),
	strItemName nvarchar(50),
	strGLAccount nvarchar(50),
	decHours decimal(18,5),
	decAmount decimal(18,5),
	intReportOrder int
) 
-- WITH ENCRYPTION
AS
BEGIN

	-- Compensations in order stated
	insert into @tblGLSubdepartmentSummary 
	select max(strcompanyname) strPayrollCompany, 'Compensations' as ItemType, ISNULL(strSubdepartment,''), ISNULL(strCompensationName,''), ISNULL(strGLAccount,''), sum(decHours) decHours ,ROUND(sum(decPay),2) decPay, max(intReportOrder) intReportOrder 
	from viewPay_UserBatchCompensations 
	WHERE ((strCompanyName = @PayrollCompany AND dtPayDate BETWEEN @StartDate AND @EndDate) OR (cast(strBatchID as nvarchar(50)) = @BatchID))
	AND intSubdepartmentID <> 33
	group by strSubdepartment, strCompensationName,  strGLAccount

	--Add the users from the split
	insert into @tblGLSubdepartmentSummary 
	select max(strcompanyname) strPayrollCompany, 'Compensations' as ItemType
	,ISNULL((Select top(1) Name from tjobtitle where ID = M.intSubdepartmentID),'')
	, ISNULL(strCompensationName,''), ISNULL(strGLAccount,''), MAX(M.decSplitPercent)/100 * sum(decHours) decHours ,ROUND(MAX(M.decSplitPercent)/100 * sum(decPay),2) decPay, max(intReportOrder) intReportOrder 
	from viewPay_UserBatchCompensations ubc cross join tblSubdepartmentSplitMachuca M 
	WHERE ((strCompanyName = @PayrollCompany AND dtPayDate BETWEEN @StartDate AND @EndDate) OR (cast(strBatchID as nvarchar(50)) = @BatchID))
	AND ubc.intSubdepartmentID = 33
	group by M.intSubdepartmentID, strCompensationName,  strGLAccount

	--ADJUST FOR ROUNDING
	INSERT INTO @tblGLSubdepartmentSummary
	select strPayrollCompany,strItemType
	,(SELECT top (1) strSubdepartment  from @tblGLSubdepartmentSummary WHERE ItemType = summ.strItemType order by strSubdepartment,strGLAccount, decAmount DESC) strSubdepartment
	, strItemName 
	,(SELECT top (1) strGLAccount  from @tblGLSubdepartmentSummary WHERE ItemType = summ.strItemType order by strSubdepartment,strGLAccount, decAmount DESC) strGLAccount
	,0 decHours
	,(Total.decPay - summ.decPayS) decAmount
	, summ.intReportOrder
	FROM
	(select strPayrollCompany,  strItemType, strItemName, intReportOrder, sum(decAmount) decPayS	from @tblGLSubdepartmentSummary group by strPayrollCompany,  strItemType, strItemName, intReportOrder ) Summ
	Inner join
	(select  'Compensations' as ItemType, '' strSubdepartment, ISNULL(strCompensationName,'')strCompensationName, '' strGLAccount, sum(decHours) decHours ,sum(decPay) decPay, max(intReportOrder) intReportOrder 
	from viewPay_UserBatchCompensations 	WHERE ((strCompanyName = @PayrollCompany AND dtPayDate BETWEEN @StartDate AND @EndDate) OR (cast(strBatchID as nvarchar(50)) = @BatchID))	group by strCompensationName) Total
	ON Summ.strItemType = Total.ItemType AND summ.strItemName = total.strCompensationName 


	-- User Withholdigns in order stated
	insert into @tblGLSubdepartmentSummary 
	select max(strcompanyname) strPayrollCompany, 'Withholdings' as ItemType, ISNULL(strSubdepartment,''), ISNULL(strWithHoldingsName,''), ISNULL(strGLAccount,''), 0 decHours ,sum(decWithholdingsAmount) decPay, max(intReportOrder) intReportOrder 
	from viewPay_UserBatchWithholdings 
	WHERE ((strCompanyName = @PayrollCompany AND dtPayDate BETWEEN @StartDate AND @EndDate) OR (cast(strBatchID as nvarchar(50)) = @BatchID))
	AND intSubdepartmentID <> 33
	group by strSubdepartment, strWithHoldingsName, strGLAccount

	------Add the users from the split
	insert into @tblGLSubdepartmentSummary 
	select max(strcompanyname) strPayrollCompany, 'Withholdings' as ItemType,ISNULL((Select top(1) Name from tjobtitle where ID = M.intSubdepartmentID),''), ISNULL(strWithHoldingsName,''), ISNULL(strGLAccount,''), 0 decHours 
	,MAX(M.decSplitPercent)/100 * sum(decWithholdingsAmount) decPay, max(intReportOrder) intReportOrder 
	from viewPay_UserBatchWithholdings ubw cross join tblSubdepartmentSplitMachuca M 
	WHERE ((strCompanyName = @PayrollCompany AND dtPayDate BETWEEN @StartDate AND @EndDate) OR (cast(strBatchID as nvarchar(50)) = @BatchID))
	AND ubw.intSubdepartmentID = 33
	group by M.intSubdepartmentID, strWithHoldingsName, strGLAccount


	--ADJUST FOR ROUNDING
	INSERT INTO @tblGLSubdepartmentSummary
	select strPayrollCompany,strItemType
	,(SELECT top (1) strSubdepartment  from @tblGLSubdepartmentSummary WHERE ItemType = summ.strItemType order by strSubdepartment,strGLAccount, decAmount DESC) strSubdepartment
	, strItemName 
	,(SELECT top (1) strGLAccount  from @tblGLSubdepartmentSummary WHERE ItemType = summ.strItemType order by strSubdepartment,strGLAccount, decAmount DESC) strGLAccount
	,0 decHours
	,(Total.decPay - summ.decPayS) decAmount
	, summ.intReportOrder
	FROM
	(select strPayrollCompany,  strItemType, strItemName, intReportOrder, sum(decAmount) decPayS	from @tblGLSubdepartmentSummary group by strPayrollCompany,  strItemType, strItemName, intReportOrder ) Summ
	Inner join
	(select  'Withholdings' as ItemType, '' strSubdepartment, ISNULL(strWithHoldingsName,'') strWithHoldingsName, '' strGLAccount, 0 decHours ,sum(decWithholdingsAmount) decPay, max(intReportOrder) intReportOrder 
	from viewPay_UserBatchWithholdings 	WHERE ((strCompanyName = @PayrollCompany AND dtPayDate BETWEEN @StartDate AND @EndDate) OR (cast(strBatchID as nvarchar(50)) = @BatchID))	group by strWithHoldingsName) Total
	ON Summ.strItemType = Total.ItemType AND summ.strItemName = total.strWithHoldingsName 



	-- Company Contributions in order stated
	insert into @tblGLSubdepartmentSummary 
	select max(strcompanyname) strPayrollCompany, 'Contributions' as ItemType,ISNULL(strSubdepartment,''), ISNULL(strWithHoldingsName,''), ISNULL(strGLAccount,''), 0 decHours ,sum(decWithholdingsAmount) decPay, max(intReportOrder) intReportOrder 
	from viewPay_CompanyBatchWithholdings ubw 
	WHERE ((strCompanyName = @PayrollCompany AND dtPayDate BETWEEN @StartDate AND @EndDate) OR (cast(strBatchID as nvarchar(50)) = @BatchID))
	AND ubw.intSubdepartmentID <> 33
	group by strSubdepartment, strWithHoldingsName, strGLAccount
	
	----Add the users from the split
	insert into @tblGLSubdepartmentSummary 
	select max(strcompanyname) strPayrollCompany, 'Contributions' as ItemType,ISNULL((Select top(1) Name from tjobtitle where ID = M.intSubdepartmentID),''), ISNULL(strWithHoldingsName,''), ISNULL(strGLAccount,''), 0 decHours 
	,MAX(M.decSplitPercent)/100 * sum(decWithholdingsAmount) decPay, max(intReportOrder) intReportOrder 
	from viewPay_CompanyBatchWithholdings ubw cross join tblSubdepartmentSplitMachuca M 
	WHERE ((strCompanyName = @PayrollCompany AND dtPayDate BETWEEN @StartDate AND @EndDate) OR (cast(strBatchID as nvarchar(50)) = @BatchID))
	AND ubw.intSubdepartmentID = 33
	group by M.intSubdepartmentID, strWithHoldingsName, strGLAccount
	
		--ADJUST FOR ROUNDING
	INSERT INTO @tblGLSubdepartmentSummary
	select strPayrollCompany,strItemType
	,(SELECT top (1) strSubdepartment  from @tblGLSubdepartmentSummary WHERE ItemType = summ.strItemType order by strSubdepartment,strGLAccount, decAmount DESC) strSubdepartment
	, strItemName 
	,(SELECT top (1) strGLAccount  from @tblGLSubdepartmentSummary WHERE ItemType = summ.strItemType order by strSubdepartment,strGLAccount, decAmount DESC) strGLAccount
	,0 decHours
	,(Total.decPay - summ.decPayS) decAmount
	, summ.intReportOrder
	FROM
	(select strPayrollCompany,  strItemType, strItemName, intReportOrder, sum(decAmount) decPayS	from @tblGLSubdepartmentSummary group by strPayrollCompany,  strItemType, strItemName, intReportOrder ) Summ
	Inner join
	(select  'Contributions' as ItemType, '' strSubdepartment, ISNULL(strWithHoldingsName,'') strWithHoldingsName, '' strGLAccount, 0 decHours ,sum(decWithholdingsAmount) decPay, max(intReportOrder) intReportOrder 
	from viewPay_CompanyBatchWithholdings 	WHERE ((strCompanyName = @PayrollCompany AND dtPayDate BETWEEN @StartDate AND @EndDate) OR (cast(strBatchID as nvarchar(50)) = @BatchID))	group by strWithHoldingsName) Total
	ON Summ.strItemType = Total.ItemType AND summ.strItemName = total.strWithHoldingsName 

	RETURN
END



GO
