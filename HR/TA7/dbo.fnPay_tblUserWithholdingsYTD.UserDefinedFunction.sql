USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblUserWithholdingsYTD]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		11-05-2018
-- Description:		Gets the viewPay_UserBatchWithholdings with the YTD
--	Note:			The rate is either the assigned rate in tuserTransactionsPayRates
--					OR the the rate depends on whether the transaction is multiplier, fixed amount(offset only) or both
--					The function returns 0 if no hourlyrate or transaction is not money (nMoneyValue = 0)
--					Takes into account Payroll Company
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblUserWithholdingsYTD]
(
	@BATCHID as nvarchar(50)
)
RETURNS @tblUserWithholdingsYTD TABLE 
(
strBatchID  nvarchar(50), 
intUserID  int, 
strWithHoldingsName  nvarchar(50), 
decWithholdingsAmount  decimal(18,2), 
decBatchEffectivePay  decimal(18,2), 
strGLAccount  nvarchar(50),
decWithholdingsYTD  decimal(18,2),
intReportOrder int
)
-- WITH ENCRYPTION
AS
BEGIN
	
	--Use the Batch End Date to know YTD
	INSERT INTO @tblUserWithholdingsYTD
	SELECT ub.strBatchID, ub.intUserID, cw.strWithHoldingsName 
	,iif(ubw.decWithholdingsAmount is null, 0,decWithholdingsAmount) as decWithholdingsAmount
	, iif(ubw.decBatchEffectivePay is null, 0, decBatchEffectivePay) as decBatchEffectivePay
	, iif(ubw.strGLAccount is null, '',ubw.strGLAccount) as strGLAccount
	,[dbo].[fnPay_YearToDateUserBatchWithholdings](ub.intUserID,cw.strWithHoldingsName,ub.dtPayDate,ub.strCompanyName) as decWithholdingsYTD  , 
	iif(ubw.intReportOrder is null, 20, ubw.intReportOrder) as intReportOrder
	FROM 
	 tblCompanyWithholdings cw  
	 inner join viewPay_UserBatchStatus ub on cw.strCompanyName = ub.strCompanyName
	left outer join 
	viewPay_UserBatchWithholdings ubw  on cw.strWithHoldingsName = ubw.strWithHoldingsName and ubw.intUserID = ub.intUserID and ubw.strBatchID = ub.strBatchId
	WHERE 
	ub.strBatchID = @BATCHID 		RETURN
END

GO
