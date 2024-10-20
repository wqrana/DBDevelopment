USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_BatchTotalNetPay]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Batch Net Pay for BatchID
-- =============================================

CREATE FUNCTION [dbo].[fnPay_BatchTotalNetPay]
(
	@BatchID nvarchar(50)
)
RETURNS decimal (18,2) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Return the result of the function
	RETURN ROUND( [dbo].[fnPay_BatchTotalCompensations](@BatchID) + [dbo].[fnPay_BatchTotalWithholdings](@BatchID) ,2)

END


GO
