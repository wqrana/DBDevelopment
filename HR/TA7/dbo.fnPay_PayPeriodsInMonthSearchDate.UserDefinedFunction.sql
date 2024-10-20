USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_PayPeriodsInMonthSearchDate]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 11/1/2017
-- Description:	Pay Periods in Month.  Searchdate determines how many periods have been processed before the date.
-- =============================================

CREATE FUNCTION [dbo].[fnPay_PayPeriodsInMonthSearchDate]
(
	@PAYROLL_COMPANY nvarchar(50),
	@SEARCH_DATE date,
	@BATCH_TYPE int,
	@USERID int
)
RETURNS int
-- WITH ENCRYPTION
AS
BEGIN
	declare @MonthStart date
	declare @PeriodCount int
	
	--FIRST DAY OF MONTH
	SELECT @MonthStart = DATEADD(mm, DATEDIFF(mm, 0,@SEARCH_DATE), 0)
	
	SELECT @PeriodCount = count(strBatchID) from viewpay_userbatchstatus where intBatchType = @BATCH_TYPE and dtPayDate BETWEEN @MonthStart and @SEARCH_DATE AND strCompanyName = @PAYROLL_COMPANY and intuserid = @USERID

	if @PeriodCount is null  SET @PeriodCount = 0
	-- Return the result of the function
	RETURN @PeriodCount
END

GO
