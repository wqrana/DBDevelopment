USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_BatchGrossPay]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/****** Object:  UserDefinedFunction [dbo].[fnPay_BatchGrossPay]    Script Date: 1/4/2017 8:29:48 AM ******/
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Gross Batch Pay from tblBatchCompensations
-- =============================================

CREATE FUNCTION [dbo].[fnPay_BatchGrossPay]
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

	-- Add the T-SQL statements to compute the return value here
	select @GrossPay= sum(decPay) from tblUserBatchCompensations
	where strBatchID = @BatchID and intUserID = @UserID  and boolDeleted = 0
	group by strBatchID, intUserID
	
	if @GrossPay is null set @GrossPay = 0
	-- Return the result of the function
	RETURN ROUND(@GrossPay,2)

END

GO
