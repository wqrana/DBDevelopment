USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPayRegisterSummary_ByCompanyDates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	Full Company Summary (all user items) for Pay Register Report
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblPayRegisterSummary_ByCompanyDates]
(
	@COMPANY_NAME nvarchar(50),
	@STARTDATE DATE,
	@ENDDATE DATE
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

	DECLARE @BatchDescription nvarchar(50)
	SET @BatchDescription = 'Dates: ' + convert(nvarchar(24), @STARTDATE,101) + ' to ' + convert(nvarchar(24), @ENDDATE,101)

	-- Compensations in order stated
	insert into @tblPayRegisterCompanySummary
	select '', strCompanyName, strCompensationName as strItem,[dbo].[fnPay_EECompensations_ByCompanyDates](@COMPANY_NAME,strCompensationName, @STARTDATE, @ENDDATE ) as decPay, 
	[dbo].[fnPay_YTDCompanyUserBatchcompensations](strCompanyName,strCompensationName,@ENDDATE) as decPayYTD,0 as decContribution, 0 as decContributionTYD, intReportOrder,@BatchDescription  
	from tblCompanyCompensations cw where strCompanyName = @COMPANY_NAME 
	ORDER BY strItem, cw.intReportOrder asc

	--Withholdings in order stated
	insert into @tblPayRegisterCompanySummary
	select '', strCompanyName, strWithHoldingsName as strItem, [dbo].[fnPay_EEWithholdings_ByCompanyDates](@COMPANY_NAME,strWithHoldingsName, @STARTDATE, @ENDDATE ) as decPay,
	[dbo].[fnPay_YTDCompanyUserBatchWithholdings](strCompanyName,strWithHoldingsName,@ENDDATE) as decPayYTD,	[dbo].[fnPay_ERWithholdings_ByCompanyDates](@COMPANY_NAME,strWithHoldingsName, @STARTDATE, @ENDDATE) as decContribution,
	[dbo].[fnPay_YTDCompanyCompanyBatchWithholdings](strCompanyName,strWithHoldingsName,@ENDDATE) as decContributionYTD, intReportOrder ,@BatchDescription   
	from tblCompanyWithholdings cw where strCompanyName = @COMPANY_NAME
	ORDER BY strItem, cw.intReportOrder asc
	
	RETURN
END


GO
