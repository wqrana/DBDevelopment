USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_YearToDateUserSalaryEarnings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Gets the earnings that are ComensationType = Salary
--				Used to determine the income for the year for computations
--				Searches from Jan 1 to SearchDate.  Takes into account Payroll Company
-- =============================================

CREATE FUNCTION [dbo].[fnPay_YearToDateUserSalaryEarnings]
(
	@UserID int,
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
	select  @YearToDate = sum(ubc.decPay) 	
	from viewPay_UserBatchCompensations ubc inner join tblUserCompensationItems cc on ubc.strCompensationName = cc.strCompensationName and ubc.intUserID = cc.intUserID
	where ubc.dtPayDate between DATEADD(yy, DATEDIFF(yy,0,@SearchDate), 0) AND @SearchDate and ubc.boolDeleted = 0
	and cc.intCompensationType = 1
	AND ubc.intUserID = @UserID
	and ubc.strCompanyName =@CompanyName
	group by ubc.intUserID

	if @YearToDate is null set @YearToDate = 0
	-- Return the result of the function
	RETURN ROUND(@YearToDate,2)

END



GO
