USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[PreorderItemTotal]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PreorderItemTotal] 
(
	@ClientID bigint,
	@FPREORDERID int
)
RETURNS float
AS
BEGIN
	DECLARE @ITEMSTOTAL float

	SELECT 
		@ITEMSTOTAL = SUM(PaidPrice * Qty) 
	FROM PreOrderItems 
	WHERE ClientID = @ClientID
		AND PreOrder_Id = @FPREORDERID 
		AND isVoid = 0

	RETURN ISNULL(@ITEMSTOTAL,0.0)
END
GO
