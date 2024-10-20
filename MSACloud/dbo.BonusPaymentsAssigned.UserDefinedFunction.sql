USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[BonusPaymentsAssigned]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[BonusPaymentsAssigned]
(
	@ClientID bigint,
	@CUSTID int,
	@BEGINDATE datetime,
	@ENDDATE datetime,
	@LocalDate bit = 0
)
RETURNS @BonusAmt TABLE (Bonus float) 
AS
BEGIN
	IF (@LocalDate = 0) BEGIN
		INSERT INTO @BonusAmt
		SELECT 
			ISNULL(SUM(BonusPaid),0.0) AS BONUS 
		FROM BonusPayments
		WHERE ClientID = @ClientID 
			AND BonusDateLocal >= @BEGINDATE
			AND BonusDateLocal < @ENDDATE
			AND Order_Id IS NULL
			AND Customer_Id = @CUSTID
	END
	ELSE BEGIN
		INSERT INTO @BonusAmt
		SELECT 
			ISNULL(SUM(BonusPaid),0.0) AS BONUS 
		FROM BonusPayments
		WHERE ClientID = @ClientID 
			AND BonusDate >= @BEGINDATE
			AND BonusDate < @ENDDATE
			AND Order_Id IS NULL
			AND Customer_Id = @CUSTID
	END

	RETURN
END
GO
