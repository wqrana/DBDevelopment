USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_EEWithholdings_UseridDates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 02/17/2022
-- Description:	Employee Withholdings for company, date
--				The withholdings are per payroll company when selecting by dates
-- =============================================
CREATE FUNCTION [dbo].[fnPay_EEWithholdings_UseridDates]
(
	@USERID int,
	@COMPANY_NAME nvarchar(50),
	@WITHHOLDINGSNAME nvarchar(50),
	@STARTDATE DATE,
	@ENDDATE DATE
)
RETURNS decimal (18,2) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Return the result of the function
	DECLARE @EEWithholdings decimal(18,2)	 
	
	select @EEWithholdings= round( sum(decWithholdingsAmount),2) from viewPay_UserBatchWithholdings 
	where intUserID = @USERID AND strCompanyName = @COMPANY_NAME and strWithHoldingsName = @WITHHOLDINGSNAME 
	and dtPayDate BETWEEN @STARTDATE and @ENDDATE
	group by strWithHoldingsName
	
	return ISNULL(@EEWithholdings ,0)
 
END
GO
