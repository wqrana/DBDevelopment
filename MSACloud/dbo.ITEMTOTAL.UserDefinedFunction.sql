USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[ITEMTOTAL]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ITEMTOTAL]
(
	@ClientID bigint,
	@FORDERID bigint
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @ITEMSTOTAL float
	
	SELECT 
		@ITEMSTOTAL = SUM(PaidPrice * Qty) 
	FROM Items 
	WHERE ClientID = @ClientID AND 
		Order_Id = @FORDERID AND 
		isVoid = 0
	
	RETURN ISNULL(@ITEMSTOTAL,0.0)
END
GO
