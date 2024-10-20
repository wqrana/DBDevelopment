USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_EETaxablePay]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 10/20/2016
-- Description:	Total Wages for employee in company between date period
-- =============================================
CREATE FUNCTION [dbo].[fnPay_EETaxablePay]
(
	@PayrollCompany nvarchar(50), 
	@StartDate date,
	@EndDate date,
	@Userid int
)
RETURNS decimal (18,2) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Declare the return variable here
	DECLARE @GrossPay decimal(18,2)

	-- Add the T-SQL statements to compute the return value here

	select @GrossPay= sum(decPay) from viewPay_UserBatchCompensations ubc
	inner join tblUserCompensationItems uc on ubc.intUserID = uc.intUserID and ubc.strCompensationName = uc.strCompensationName
	where ubc.strCompanyName = @PayrollCompany and ubc.dtPayDate BETWEEN @StartDate and @EndDate and uc.intCompensationType = 1   and ubc.boolDeleted = 0
	and ubc.intUserID = @Userid

	if @GrossPay is null set @GrossPay = 0
	-- Return the result of the function
	RETURN ROUND(@GrossPay,2)
 
END

GO
