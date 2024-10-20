USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[NONTAXSUBTOTAL]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[NONTAXSUBTOTAL] 
(
	-- Add the parameters for the function here
	@ClientID bigint,
	@OrderID int
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @NONTAXSUBTOTAL float
	SET @NONTAXSUBTOTAL = 0.0
	-- Add the T-SQL statements to compute the return value here
	SELECT @NONTAXSUBTOTAL = 
		SUM(
			CASE
				WHEN TaxPrice <= 0.0 THEN (Qty * PaidPrice)
				ELSE 0.0
			END
		)
	from Items
	where
		ClientID = @ClientID and
		Order_Id = @OrderID and 
		isVoid = 0
	
	-- Return the result of the function
	RETURN ISNULL(@NONTAXSUBTOTAL,0.0)
END
GO
