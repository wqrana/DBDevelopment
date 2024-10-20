USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchWithholdingsSummary]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	For Company Summary.  Returns all withholdings and their types for report
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblBatchWithholdingsSummary]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50)
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
		INSERT INTO @tblBatchWithholdingsSummary
		SELECT strBatchID, strWithHoldingsName,  wtt.strWithholdingsTaxTypeDescription,		
		dbo.fnPay_EEWithholdings(@BATCHID,strWithHoldingsName) as EEWithhodings, 
		dbo.fnPay_ERWithholdings(@BATCHID,strWithHoldingsName) as ERWithhodings 
		FROM tblCompanyWithholdings cw inner join viewPay_Batch b ON cw.strCompanyName = b.strCompanyName
		AND b.strBatchID = @BATCHID
		inner join tblWithholdingsTaxTypes wtt ON cw.intWithholdingsTaxType = wtt.intWithholdingsTaxType

	RETURN
END

GO
