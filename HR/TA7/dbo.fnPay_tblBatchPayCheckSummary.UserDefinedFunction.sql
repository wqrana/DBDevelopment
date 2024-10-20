USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblBatchPayCheckSummary]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	For Pay Check Summary.  Returns amounts and Check / Debit Type
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblBatchPayCheckSummary]
(	
	-- Add the parameters for the function here
	@BATCHID nvarchar(50)
)
RETURNS 
@tblBatchPayCheckSummary TABLE 
(
	strBatchID nvarchar(50),
	strPayMethodType nvarchar(50), 
	decPayTotals decimal(18,2)
) 
-- WITH ENCRYPTION
AS
BEGIN
		INSERT INTO @tblBatchPayCheckSummary
		select strBatchID as strBatchID, pm.strPayMethodType as strPayMethodType, sum(decCheckAmount) as decCheckAmountTotal 
		from [dbo].[tblUserPayChecks] pc inner join tblPayMethodType pm on pc.intPayMethodType = pm.intPayMethodType
		where strBatchID = @BATCHID
		group by strBatchID, pm.strPayMethodType
	RETURN
END

GO
