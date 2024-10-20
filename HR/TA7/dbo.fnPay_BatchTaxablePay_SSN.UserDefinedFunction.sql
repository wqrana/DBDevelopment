USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_BatchTaxablePay_SSN]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 02/02/2020
-- Description:	Taxable Batch Pay from tblBatchCompensations
--				Excludes all compensations except salary
-- =============================================

CREATE FUNCTION [dbo].[fnPay_BatchTaxablePay_SSN]
(
	@BatchID nvarchar(50), 
	@SSN nvarchar(15)
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
	where ubc.strBatchID = @BatchID and ubc.sSSN = @SSN and uc.intCompensationType = 1   
	group by strBatchID, ubc.sSSN
	
	if @GrossPay is null set @GrossPay = 0
	-- Return the result of the function
	RETURN ROUND(@GrossPay,2)

END

GO
