USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCompanyDatePeriodSummary]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	Fopr cross tab reports, Batch Company totals for the time period
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblCompanyDatePeriodSummary]
(	
	-- Add the parameters for the function here
	@COMPANYNAME AS NVARCHAR(50),
	@STARTDATE AS DATETIME,
	@ENDDATE AS DATETIME
)
RETURNS 
@tblCompanyBatchSummary TABLE 
(
	intUserID  int,
	strUserName nvarchar(50),
	strItemsName nvarchar(50),
	decItemsAmount decimal(18,5)
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Add the SELECT statement with parameter references here
	insert into @tblCompanyBatchSummary
	SELECT intUserID,ue.sEmployeeName, strWithHoldingsName, decWithholdingsAmount FROM [dbo].[tblCompanyBatchWithholdings] ubw inner join tUserExtended ue on ubw.intUserID = ue.nUserID
	inner join tblBatch b on ubw.strBatchID = b.strBatchID
	WHERE UBW.dtPayDate between @STARTDATE and @ENDDATE and b.strCompanyName = @COMPANYNAME

	RETURN
END

GO
