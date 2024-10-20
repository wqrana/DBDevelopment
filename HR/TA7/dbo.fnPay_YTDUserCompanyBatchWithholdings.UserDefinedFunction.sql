USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_YTDUserCompanyBatchWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 11/5/2016
-- Description:	Gets the Company Contributions for an employee for the year.
--				Takes into account Payroll Company.  Searches from Jan 1 to SearchDate.
-- =============================================
CREATE FUNCTION [dbo].[fnPay_YTDUserCompanyBatchWithholdings]
(
	@WithholdingsName nvarchar(50), 
	@UserID as int,
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
	select @YearToDate = sum(decWithholdingsAmount) 	from viewPay_CompanyBatchWithholdings
	where dtPayDate between DATEADD(yy, DATEDIFF(yy,0,@SearchDate), 0) 
	AND @SearchDate 
	AND strWithHoldingsName = @WithholdingsName 
	AND intUserID = @UserID
	AND strCompanyName = @CompanyName
	group by strWithHoldingsName, intUserID

	if @YearToDate is null set @YearToDate = 0
	-- Return the result of the function
	RETURN ROUND(@YearToDate,2)

END



GO
