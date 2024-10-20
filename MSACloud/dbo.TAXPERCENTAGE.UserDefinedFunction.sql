USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[TAXPERCENTAGE]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TAXPERCENTAGE] 
(
	@ClientID bigint,
	@FORDERID int
)
RETURNS float
AS
BEGIN
	DECLARE @TAXRATE float

	SELECT 
		@TAXRATE = SUM(TaxRate) 
	FROM SalesTax 
	WHERE 
		ClientID = @ClientID AND
		Order_Id = @FORDERID

	RETURN ISNULL(@TAXRATE,0.0)
END
GO
