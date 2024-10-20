USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Dashboard_AccountInformation]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Farrukh M
-- Create date: 03/30/2016
-- Description:	Return Postive and Negative Account information
-- =============================================
CREATE FUNCTION [dbo].[Admin_Dashboard_AccountInformation]
(	
	-- Add the parameters for the function here

	@ClientID BIGINT
)
RETURNS TABLE 
AS
RETURN 
(
	select 
 ISNULL(sum(CASE WHEN sb.Balance > 0 THEN 1 ELSE 0 END),0) as CountOfPositiveAccounts,
 ISNULL(sum(CASE WHEN sb.Balance > 0 THEN sb.Balance ELSE 0.0 END),0) as PositiveAmount,
 ISNULL(sum(CASE WHEN sb.Balance < 0 THEN 1 ELSE 0 END),0) as CountOfNegativeAccounts,
 ISNULL(sum(CASE WHEN sb.Balance < 0 THEN sb.Balance ELSE 0.0 END),0) as NegativeAmount,
 ISNULL(sum(CASE WHEN sb.Balance = 0 THEN 1 ELSE 0 END),0) as CountOfZeroAccounts,
 ISNULL(sum(CASE WHEN sb.Balance = 0 THEN sb.Balance ELSE 0.0 END),0) as ZeroAmount
from dbo.CustomerBalances(@ClientID, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, 1, 0, 0, DEFAULT, DEFAULT, DEFAULT, GETDATE(), 1) sb

)
GO
