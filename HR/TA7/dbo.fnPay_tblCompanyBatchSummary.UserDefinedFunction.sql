USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCompanyBatchSummary]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	Fopr cross tab reports, Batch Company totals
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblCompanyBatchSummary]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50)
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
	WHERE strBatchID = @BATCHID 

	RETURN
END

GO
