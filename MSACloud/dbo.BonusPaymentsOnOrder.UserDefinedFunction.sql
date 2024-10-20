USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[BonusPaymentsOnOrder]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[BonusPaymentsOnOrder]
(
	@ClientID bigint,
	@FMYORDERID int
)
RETURNS TABLE
AS
RETURN
(
	SELECT 
		ISNULL(SUM(BonusPaid), 0.0) AS Bonus
	FROM BonusPayments
	WHERE 
		ClientID = @ClientID AND 
		Order_Id = @FMYORDERID
)
GO
