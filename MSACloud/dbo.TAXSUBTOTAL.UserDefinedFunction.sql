USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[TAXSUBTOTAL]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TAXSUBTOTAL] 
(
	@ClientID bigint,
	@OrderID int
)
RETURNS float
AS
BEGIN
	DECLARE @TAXSUBTOTAL float
	SET @TAXSUBTOTAL = 0.0
	
	SELECT 
		@TAXSUBTOTAL = SUM(CASE WHEN TaxPrice > 0.0 THEN (Qty * PaidPrice) ELSE 0.0 END)
	FROM Items
	WHERE 
		ClientID = @ClientID AND
		Order_Id = @OrderID and 
		isVoid = 0
	
	RETURN ISNULL(@TAXSUBTOTAL,0.0)
END
GO
