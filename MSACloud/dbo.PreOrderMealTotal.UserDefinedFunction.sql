USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[PreOrderMealTotal]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PreOrderMealTotal]
(
	@ClientID bigint,
	@PREORDERID int
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @MEALTOTAL float

	-- Add the T-SQL statements to compute the return value here
	SELECT 
		@MEALTOTAL = SUM(Qty * PaidPrice)
	FROM Items 
	WHERE 
		ClientID = @ClientID AND
		Order_Id = @PREORDERID AND 
		(
			(SoldType IS NULL AND FullPrice < 0.0) OR 
			(SoldType = 10)
		)

	-- Return the result of the function
	RETURN ISNULL(@MEALTOTAL,0.0)
END
GO
