USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_YearToDateUserBatchcompensations]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 11/05/2018
-- Description:	Gets the withholdings for the year 
--				Searches from Jan 1 to SearchDate.  Takes into accoun t Payroll Company
-- =============================================
CREATE FUNCTION [dbo].[fnPay_YearToDateUserBatchcompensations]
(
	@UserID int,
	@CompensationName nvarchar(50), 
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
	select @YearToDate = sum(decPay) 	from viewPay_UserBatchCompensations 
	where dtPayDate between DATEADD(yy, DATEDIFF(yy,0,@SearchDate), 0) AND @SearchDate AND intUserID = @UserID and boolDeleted = 0
	AND strCompensationName = @CompensationName 
	and strCompanyName = @CompanyName
	group by intUserID,strCompensationName

	if @YearToDate is null set @YearToDate = 0
	-- Return the result of the function
	RETURN ROUND(@YearToDate,2)

END

GO
