USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_EECompensations_UseridBatchid]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 02/17/2023
-- Description:	UserBatchCompensations for BatchID, UserID,Compensantion Name
-- =============================================
CREATE FUNCTION [dbo].[fnPay_EECompensations_UseridBatchid]
(
	@USERID nvarchar(50),
	@BATCHID nvarchar(50),
	@COMPENSATION nvarchar(50)
)
RETURNS decimal (18,2) 
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @EECompensation decimal(18,2)	 

	select @EECompensation= round( sum(decPay),2) from viewPay_UserBatchCompensations ubc 
	where strBatchID = @BATCHID and intUserID = @USERID AND strCompensationName = @COMPENSATION group by strCompensationName
	
	return ISNULL(@EECompensation ,0)
 
END

GO
