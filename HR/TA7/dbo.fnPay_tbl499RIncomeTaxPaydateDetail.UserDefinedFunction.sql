USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tbl499RIncomeTaxPaydateDetail]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 05/08/2016
-- Description:	Data for 499R Income Tax Report
--				The detail includes all the retentions per pay date
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tbl499RIncomeTaxPaydateDetail]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbl499ReportDetail TABLE 
(
	dtStartDate		date,
	decDailyRetainedStTax decimal(18,5)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
--select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName = @PAYITEM 
----------------------------------
-- COMPUTOS 499R INCOME TAX
----------------------------------

--Income Tax Withholdings By Date
--	Total St ITAX retained income taxes
insert @tbl499ReportDetail
select dtPayDate, - isnull(sum(ubw.decWithholdingsAmount),0) decDailyRetainedStTax 
From viewPay_UserBatchWithholdings ubw inner join tblWithholdingsItems w on ubw.strWithHoldingsName = w.strWithHoldingsName
where strCompanyName = @PayrollCompany and dtPayDate between @StartDate and @EndDate
AND w.intComputationType = -1
group by dtPayDate
order by dtPayDate asc

RETURN
END



GO
