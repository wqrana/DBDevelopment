USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[BonusPaymentTotal]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[BonusPaymentTotal] 
(
	@ClientID bigint,
	@STARTDATE datetime,
	@ENDDATE datetime,
	@CUSTID int = NULL
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @BonusTotal float

	-- Add the T-SQL statements to compute the return value here
	IF (@CUSTID IS NULL OR @CUSTID = -1) BEGIN
		SELECT @BonusTotal = SUM(BonusPaid) FROM BonusPayments WHERE ClientID = @ClientID AND BonusDate >= @STARTDATE AND BonusDate <= @ENDDATE
	END
	ELSE BEGIN
		SELECT @BonusTotal = SUM(BonusPaid) FROM BonusPayments WHERE ClientID = @ClientID AND BonusDate >= @STARTDATE AND BonusDate <= @ENDDATE AND Customer_Id = @CUSTID
	END

	-- Return the result of the function
	RETURN ISNULL(@BonusTotal,0.0)

END
GO
