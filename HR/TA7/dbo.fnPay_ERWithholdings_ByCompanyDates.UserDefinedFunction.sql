USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_ERWithholdings_ByCompanyDates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Total UserCompanyWithholdings for BatchID
-- =============================================

CREATE FUNCTION [dbo].[fnPay_ERWithholdings_ByCompanyDates]
(
	@COMPANY_NAME nvarchar(50),
	@COMPENSATION nvarchar(50),
	@STARTDATE DATE,
	@ENDDATE DATE
)
RETURNS decimal (18,2) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Return the result of the function
	DECLARE @EEWithholdings decimal(18,2)	 
	
	select @EEWithholdings= round( sum(decWithholdingsAmount),2) from viewPay_CompanyBatchWithholdings 
	where strCompanyName = @COMPANY_NAME and strWithHoldingsName = @COMPENSATION 
	and dtPayDate BETWEEN @STARTDATE and @ENDDATE
	group by strWithHoldingsName
		
	if @EEWithholdings is null 
		set	@EEWithholdings = 0

	return @EEWithholdings 
 
END



GO
