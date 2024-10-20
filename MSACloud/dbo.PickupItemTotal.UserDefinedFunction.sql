USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[PickupItemTotal]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PickupItemTotal] 
(
	@ClientID bigint,
	@FORDERID int
)
RETURNS float
AS
BEGIN
	DECLARE @ITEMSTOTAL FLOAT
	
	SELECT @ITEMSTOTAL = SUM(poi.PaidPrice * it.Qty) 
	FROM Items it
		LEFT OUTER JOIN PreOrderItems poi ON (poi.Id = it.PreOrderItem_Id AND poi.ClientID = it.ClientID)
	WHERE it.ClientID = @ClientID
		AND it.Order_Id = @FORDERID 
		AND it.isVoid = 0 
		AND poi.isVoid = 0 
		AND it.PreOrderItem_Id IS NOT NULL
	
	RETURN ISNULL(@ITEMSTOTAL,0.0)
END
GO
