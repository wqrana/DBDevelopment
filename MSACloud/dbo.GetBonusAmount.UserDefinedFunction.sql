USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[GetBonusAmount]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetBonusAmount]
(
	@ClientID bigint,
	@MealPlanID int,
	@cPayment int
)
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE 
		@BonusToApply float,
		@BonusAmount float,
		@BonusLimit float,
		@BonusType int
	SET @BonusToApply = 0.0
	
	IF (@MealPlanID <= 0)
		RETURN @BonusToApply

	SELECT 
		@BonusAmount = l.BonusAmount,
		@BonusLimit = l.BonusLimit,
		@BonusType = l.Bonus
	FROM LunchTypes l 
	WHERE l.ClientID = @ClientID and l.Id = @MealPlanID

	IF (@BonusType = 1) BEGIN	-- Flat Amount when assigned
		SET @BonusToApply = 0.0
	END
	ELSE IF (@BonusType = 2) BEGIN -- Bonus Amount for each payment of Limit
		SET @BonusToApply = ROUND((@BonusAmount * (ABS(@cPayment / @BonusLimit))), 2)
	END
	ELSE IF (@BonusType = 3) BEGIN -- Bonus Percent of payment up to Limit
		IF (@cPayment > @BonusLimit)
			SET @BonusToApply = ROUND((@BonusAmount * @BonusLimit) / 100, 2)
		ELSE
			SET @BonusToApply = ROUND((@BonusAmount * @cPayment) / 100, 2)
	END 
	ELSE IF (@BonusType = 4) BEGIN -- One Time Bonus + Bonus Amount for each payment of Limit
		SET @BonusToApply = ROUND((@BonusAmount * (ABS(@cPayment / @BonusLimit))), 2)
	END
	ELSE IF (@BonusType = 5) BEGIN -- One Time Bonus + Bonus Percent of Payment up to Limit
		IF (@cPayment > @BonusLimit)
			SET @BonusToApply = ROUND( ((@BonusAmount * @BonusLimit) / 100), 2)
		ELSE
			SET @BonusToApply = ROUND( ((@BonusAmount * @cPayment) / 100), 2)
	END
	ELSE BEGIN
		SET @BonusToApply = 0.0
	END
			
	-- Return the result of the function
	RETURN @BonusToApply
END
GO
