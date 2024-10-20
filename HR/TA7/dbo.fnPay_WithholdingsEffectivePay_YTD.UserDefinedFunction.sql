USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_WithholdingsEffectivePay_YTD]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 5/23/2010
-- Description:	WithholdingEffectivePay takes into account salary limits for compensations
-- =============================================
CREATE FUNCTION [dbo].[fnPay_WithholdingsEffectivePay_YTD]
(
	@PayrollCompany nvarchar(50), 
	@PayDate date,
	@WithholdingName nvarchar(50),
	@UserID int

)
RETURNS decimal (18,2) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Declare the return variable here
	DECLARE @GrossPay decimal(18,2)


	-- Add the T-SQL statements to compute the return value here
	  	select  @GrossPay = ISNULL(	SUM(
	case 
		when uwi.decMinimumSalaryLimit = 0 THEN
			case 
				when uwi.decMaximumSalaryLimit = 0  then decPay
				when uwi.decMaximumSalaryLimit < decPay then uwi.decMaximumSalaryLimit
				else decPay
			end 
		when uwi.decMinimumSalaryLimit < decPay THEN
			decPay - uwi.decMinimumSalaryLimit 
		when uwi.decMinimumSalaryLimit > decPay THEN
			0

	END
		),0) 


	from
	(
	select ubc.intuserid, sum(decPay) as decPay from viewPay_UserBatchCompensations ubc
	inner join tblUserCompensationItems uc on ubc.intUserID = uc.intUserID and ubc.strCompensationName = uc.strCompensationName
	where ubc.strCompanyName = @PayrollCompany and ubc.dtPayDate BETWEEN  DATEADD(yy, DATEDIFF(yy, 0, @PayDate), 0) and @PayDate and uc.intCompensationType = 1   and ubc.boolDeleted = 0
	GROUP BY ubc.intUserID) C
	inner join tblUserWithholdingsItems uwi on c.intUserID = uwi.intUserID
	where uwi.strWithHoldingsName = @WithholdingName
	AND (uwi.intUserID = @UserID OR @UserID = 0)
	-- Return the result of the function
	RETURN ROUND(@GrossPay,2)

END

GO
