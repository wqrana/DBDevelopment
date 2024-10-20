USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[GetPercentage]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Farrukh M.
-- Create date: 01/04/2016
-- Description:	Get Percentage
-- =============================================
CREATE FUNCTION [dbo].[GetPercentage]
(
	-- Add the parameters for the function here
	@FirstVal float,
	@SecondVal float
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Percentage FLOAT  = 0

	-- Add the T-SQL statements to compute the return value here
	IF @FirstVal != 0 AND @SecondVal!=0
	  BEGIN
		 SELECT @Percentage = ROUND((CONVERT(float,@FirstVal) / convert(float,@SecondVal)*100),2)
	  END

	-- Return the result of the function
	RETURN @percentage

END
GO
