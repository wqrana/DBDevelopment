USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[GetCustomerActivityCount]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Farrukh M.
-- Create date: 04/07/2016
-- Description:	Get Customer Activity Count
-- =============================================
CREATE FUNCTION [dbo].[GetCustomerActivityCount]
(
	-- Add the parameters for the function here
	@ClientID BIGINT,
	@Customer_ID BIGINT
)
RETURNS INT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ActivityCount INT  = 0

	-- Add the T-SQL statements to compute the return value here
	SELECT   @ActivityCount=COUNT(*) FROM CustomerActivity WHERE  Customer_Id = @Customer_ID AND ClientID = @ClientID

	-- Return the result of the function
	RETURN @ActivityCount

END
GO
