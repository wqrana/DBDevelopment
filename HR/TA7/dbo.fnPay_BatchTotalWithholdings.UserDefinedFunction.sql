USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_BatchTotalWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 8/22/2016
-- Description:	Computes the Total Withholdings
--				on the user's tblUserHaciendaParameters
--				Returns 0 if negative OR record does not exist
-- =============================================

CREATE FUNCTION [dbo].[fnPay_BatchTotalWithholdings]
(
	@BATCHID as nvarchar(50)
	)
RETURNS decimal(18,2)
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @PayAmount as decimal(18,2)

	select @PayAmount= round( sum(decWithholdingsAmount),2)  from tblUserBatchWithholdings
	where strBatchID = @BATCHID
	group by strBatchID

	if @PayAmount is null SET @PayAmount = 0
return round( @PayAmount,2)
END

GO
