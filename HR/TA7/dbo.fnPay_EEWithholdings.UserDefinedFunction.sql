USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_EEWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Total UserBatchWithholdings for BatchID
-- =============================================

CREATE FUNCTION [dbo].[fnPay_EEWithholdings]
(
	@BATCHID nvarchar(50),
	@WITHHOLDING nvarchar(50)
)
RETURNS decimal (18,2) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Return the result of the function
	DECLARE @EEWithholdings decimal(18,2)	 
	
	select @EEWithholdings= round( sum(decWithholdingsAmount),2) from viewPay_UserBatchWithholdings where strBatchID = @BATCHID and strWithHoldingsName = @WITHHOLDING and boolDeleted = 0 group by strWithHoldingsName
	
	if @EEWithholdings is null 
		set	@EEWithholdings = 0

	return @EEWithholdings 
 
END

GO
