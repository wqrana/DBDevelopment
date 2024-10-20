USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_YTDUserTaxablePay_SSN]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 02/02/2020
-- Description:	Returns the Year To Date Taxable Earinings of an employee.
--				 Gets the earnings that are ComensationType = Salary
--				Used to determine the income for the year for computations
--				Searches from Jan 1 to SearchDate.  Takes into account Payroll Company
-- =============================================
CREATE FUNCTION [dbo].[fnPay_YTDUserTaxablePay_SSN]
(
	@CompanyName nvarchar(50),
	@SSN nvarchar(15),
	@SearchDate as datetime
)
RETURNS decimal (18,5) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Declare the return variable here
	DECLARE @YearToDate decimal(18,5)

	-- Add the T-SQL statements to compute the return value here
	select  @YearToDate = sum(ubc.decPay) 	
	from viewPay_UserBatchCompensations ubc inner join tblUserCompensationItems cc on ubc.strCompensationName = cc.strCompensationName and ubc.intUserID = cc.intUserID
	where ubc.dtPayDate between DATEADD(yy, DATEDIFF(yy,0,@SearchDate), 0) AND @SearchDate and ubc.boolDeleted = 0
	and cc.intCompensationType = 1
	AND ubc.sSSN = @SSN
	and ubc.strCompanyName =@CompanyName
	group by ubc.sSSN

	if @YearToDate is null set @YearToDate = 0
	-- Return the result of the function
	RETURN @YearToDate
END

GO
