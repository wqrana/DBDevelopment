USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_BatchUserWithholdingNameAmount]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 8/22/2016
-- Description:	Returns the Withholding Amount of a Withholding
-- =============================================

CREATE FUNCTION [dbo].[fnPay_BatchUserWithholdingNameAmount]
(
	@BATCHID as nvarchar(50),
	@USERID as int,
	@WITHHOLDINGNAME as nvarchar(50)
	)
RETURNS decimal(18,2)
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @PayAmount as decimal(18,2)

	select @PayAmount= sum(decWithholdingsAmount)  from tblUserBatchWithholdings
	where intUserID = @USERID and strBatchID = @BATCHID and strWithHoldingsName = @WITHHOLDINGNAME
	group by intUserID, strBatchID

	if @PayAmount is null SET @PayAmount = 0
return  ROUND(@PayAmount,2)
END

GO
