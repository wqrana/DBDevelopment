USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_BatchTotalTransactionHours]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Total transaction hours in the batch
-- =============================================

CREATE FUNCTION [dbo].[fnPay_BatchTotalTransactionHours]
(
	@BatchID nvarchar(50)
)
RETURNS decimal (18,5)
-- WITH ENCRYPTION
AS
BEGIN
	-- Declare the return variable here
	DECLARE @TransHours decimal(18,5)

	-- Add the T-SQL statements to compute the return value here
	SELECT @TransHours  = SUM (decHours)
    FROM tblUserBatchTransactions where strBatchID = @BatchID
	group by strBatchID
  
	if @TransHours is null set @TransHours = 0
	-- Return the result of the function
	RETURN @TransHours

END

GO
