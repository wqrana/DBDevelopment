USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tbl941RFicaTaxPaydateDetail]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 05/22/2019
-- Description:	Data for 941R FICA Tax Report
--				The detail includes all the obligation per pay date
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tbl941RFicaTaxPaydateDetail]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbl941ReportDetail TABLE 
(
	dtStartDate		date,
	decDailyRetainedFicaTax decimal(18,5)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
--select distinct wi.intUserID FROM tblUserWithholdingsItems wi inner join tblUserCompanyPayroll ucp ON wi.intUserID = ucp.intUserID AND strCompanyName = @PayrollCompany and strWithHoldingsName = @PAYITEM 
----------------------------------
-- COMPUTOS 941R TOTAL FICA TAX
----------------------------------
	----------------------------------
	
--Income Tax Withholdings By Date
--	Total St ITAX retained income taxes
insert @tbl941ReportDetail

select dtPayDate, sum(decDailyRetainedFicaTax) decDailyRetainedFicaTax from
(select dtPayDate, 
(select isnull(-sum(decWithholdingsAmount),0) from tblUserBatchWithholdings ubw where ubw.strBatchID = ubs.strBatchID and ubw.intUserID = ubs.intUserID and ubw.strWithHoldingsName IN ('FICA SS','FICA MED','FICA MED PLUS'))
+
(select isnull(-sum(decWithholdingsAmount),0) from tblcompanyBatchWithholdings cbw where cbw.strBatchID = ubs.strBatchID and cbw.intUserID = ubs.intUserID and cbw.strWithHoldingsName IN ('FICA SS','FICA MED','FICA MED PLUS')) 
decDailyRetainedFicaTax
from viewPay_UserBatchStatus ubs where strCompanyName = @PayrollCompany and dtPayDate between @StartDate and @EndDate) Batch
GROUP BY Batch.dtPayDate
RETURN
END

GO
