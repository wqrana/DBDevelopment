USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_BatchNetPay]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Net Batch Pay from tblBatchCompensations - Pretax wothholdings (from tblBatchEmployeeWithholdings)
-- =============================================

CREATE FUNCTION [dbo].[fnPay_BatchNetPay]
(
	@BatchID nvarchar(50), 
	@UserID int
)
RETURNS decimal (18,2) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Declare the return variable here
	DECLARE @GrossPay decimal(18,2)
	DECLARE @Withholdings decimal(18,2)

	-- Get Gross Pay
	select @GrossPay= [dbo].[fnPay_BatchGrossPay](@BatchID,@UserID)
	-- Withholdings
	select  @Withholdings  = dbo.[fnPay_BatchWithholdingsTotal](@BatchID,@UserID)
	RETURN ROUND( @GrossPay + @Withholdings,2)
END


GO
