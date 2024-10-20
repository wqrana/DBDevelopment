USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_CompanyBatchWithholdings_ByDates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Gets the withholdings for the year 
--				Searches from Jan 1 to SearchDate.
-- =============================================

CREATE FUNCTION [dbo].[fnPay_CompanyBatchWithholdings_ByDates]
(
	@UserID int,
	@WithholdingsName nvarchar(50), 
	@StartDate as datetime,
	@EndDate as datetime
)
RETURNS decimal (18,2) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Declare the return variable here
	DECLARE @SumofDates decimal(18,2)

	-- Add the T-SQL statements to compute the return value here
	select @SumofDates = sum(decWithholdingsAmount) from tblCompanyBatchWithholdings
	where dtPayDate between @StartDate and @EndDate
	AND strWithHoldingsName = @WithholdingsName 
	and intUserID = @UserID
	group by intUserID,strWithHoldingsName

	if @SumofDates is null set @SumofDates = 0
	-- Return the result of the function
	RETURN @SumofDates
END





GO
