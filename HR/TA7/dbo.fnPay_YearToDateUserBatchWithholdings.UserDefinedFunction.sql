USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_YearToDateUserBatchWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
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

CREATE FUNCTION [dbo].[fnPay_YearToDateUserBatchWithholdings]
(
	@UserID int,
	@WithholdingsName nvarchar(50), 
	@SearchDate as datetime,
	@CompanyName nvarchar(50)
)
RETURNS decimal (18,2) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Declare the return variable here
	DECLARE @YearToDate decimal(18,2)

	-- Add the T-SQL statements to compute the return value here
	select @YearToDate = sum(decWithholdingsAmount) 	from viewPay_UserBatchWithholdings 
	where dtPayDate between DATEADD(yy, DATEDIFF(yy,0,@SearchDate), 0) AND @SearchDate AND intUserID = @UserID
	AND strWithHoldingsName = @WithholdingsName 
	and strCompanyName = @CompanyName
	group by intUserID,strWithHoldingsName

	if @YearToDate is null set @YearToDate = 0
	-- Return the result of the function
	RETURN ROUND(@YearToDate,2)

END

GO
