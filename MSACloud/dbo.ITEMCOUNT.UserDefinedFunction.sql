USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[ITEMCOUNT]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ITEMCOUNT] 
(
	-- Add the parameters for the function here
	@ClientID bigint,
	@OrderID int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ItemCount int

	-- Add the T-SQL statements to compute the return value here
	SELECT 
		@ItemCount = SUM(Qty) 
	FROM Items 
	WHERE 
		ClientID = @ClientID and 
		Order_Id = @OrderID and 
		isVoid = 0
	
	-- Return the result of the function
	RETURN ISNULL(@ItemCount,0)
END
GO
