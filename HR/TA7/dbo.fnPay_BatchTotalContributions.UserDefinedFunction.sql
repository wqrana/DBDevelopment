USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_BatchTotalContributions]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 05/17/2019
-- Description:	Computes the Total Company Contributions of a Payroll
--				Returns 0
-- =============================================
CREATE FUNCTION [dbo].[fnPay_BatchTotalContributions]
(
	@BATCHID as nvarchar(50)
	)
RETURNS decimal(18,2)
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @PayAmount as decimal(18,2)

	select @PayAmount= isnull(round( sum(decWithholdingsAmount),2),0)  from tblCompanyBatchWithholdings
	where strBatchID = @BATCHID
	group by strBatchID

return round( @PayAmount,2)
END

GO
