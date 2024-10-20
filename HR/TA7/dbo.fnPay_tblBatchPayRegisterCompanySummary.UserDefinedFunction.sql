USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchPayRegisterCompanySummary]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	Full Company Summary (all user items) for Pay Register Report
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblBatchPayRegisterCompanySummary]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50)
)
RETURNS 
@tblPayRegisterCompanySummary TABLE 
(
	strBatchID nvarchar(50),
	strCompanyName nvarchar(50),
	strPayItem nvarchar(50),
	decPay decimal(18,2),
	decPayYTD  decimal(18,2),
	decContribution decimal(18,2),
	decContributionYTD  decimal(18,2),
	intReportOrder  int,
	strBatchDescription nvarchar(50)
) 
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @StrCompanyName nvarchar(50)
	DECLARE @PayDate date
	DECLARE @BatchDescription nvarchar(50)
	SELECT @StrCompanyName= strCompanyName, @PayDate = dtPayDate, @BatchDescription = strBatchDescription from tblBatch where strBatchID = @BATCHID

	-- Compensations in order stated
	insert into @tblPayRegisterCompanySummary
	select @BATCHID, strCompanyName, strCompensationName as strItem,[dbo].[fnPay_EECompensations](@BATCHID,strCompensationName) as decPay, 
	[dbo].[fnPay_YTDCompanyUserBatchcompensations](strCompanyName,strCompensationName,@PayDate) as decPayYTD,0 as decContribution, 0 as decContributionTYD, intReportOrder,@BatchDescription  
	from tblCompanyCompensations cw where strCompanyName = @StrCompanyName 
	ORDER BY strItem, cw.intReportOrder asc

	--Withholdings in order stated
	insert into @tblPayRegisterCompanySummary
	select @BATCHID, strCompanyName, strWithHoldingsName as strItem, [dbo].[fnPay_EEWithholdings](@BATCHID,strWithHoldingsName) as decPay,
	[dbo].[fnPay_YTDCompanyUserBatchWithholdings](strCompanyName,strWithHoldingsName,@PayDate) as decPayYTD,	[dbo].[fnPay_ERWithholdings](@BATCHID,strWithHoldingsName) as decContribution,
	[dbo].[fnPay_YTDCompanyCompanyBatchWithholdings](strCompanyName,strWithHoldingsName,@PayDate) as decContributionYTD, intReportOrder ,@BatchDescription   
	from tblCompanyWithholdings cw where strCompanyName = @StrCompanyName
	ORDER BY strItem, cw.intReportOrder asc
	
	RETURN
END



GO
