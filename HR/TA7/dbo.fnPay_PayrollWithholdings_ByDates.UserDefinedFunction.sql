USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_PayrollWithholdings_ByDates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 5/22/2019
-- Description:	Gets the withholdings for the payroll company for the time period
-- =============================================
CREATE FUNCTION [dbo].[fnPay_PayrollWithholdings_ByDates]
(
	@PayrollCompany nvarchar(50),
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
	select @SumofDates = ISNULL(sum(decWithholdingsAmount),0) from viewPay_UserBatchWithholdings 
	where strCompanyName = @PayrollCompany AND dtPayDate between @StartDate and @EndDate
	AND strWithHoldingsName = @WithholdingsName 
	-- Return the result of the function
	RETURN @SumofDates
END

GO
