USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_EECompensations]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	Total UserBatchCompensations for BatchID, Compensantion Name
-- =============================================
CREATE FUNCTION [dbo].[fnPay_EECompensations]
(
	@BATCHID nvarchar(50),
	@COMPENSATION nvarchar(50)
)
RETURNS decimal (18,2) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Return the result of the function
	DECLARE @EECompensation decimal(18,2)	 
	
	select @EECompensation= round( sum(decPay),2) from viewPay_UserBatchCompensations ubc where strBatchID = @BATCHID and strCompensationName = @COMPENSATION group by strCompensationName
	
	if @EECompensation is null 
		set	@EECompensation = 0

	return @EECompensation 
 
END

GO
