USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[SALESTAXTOTAL]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SALESTAXTOTAL] 
(
	@ClientID bigint,
	@FORDERID int
)
RETURNS float
AS
BEGIN
	DECLARE @SALESTAX float
	
	SELECT 
		@SALESTAX = SUM(SalesTax) 
	FROM SalesTax 
	WHERE ClientID = @ClientID
		AND Order_Id = @FORDERID
	
	RETURN ROUND(ISNULL(@SALESTAX,0.0),2)
END
GO
