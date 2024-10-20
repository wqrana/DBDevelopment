USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[BalanceAfterOrder]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[BalanceAfterOrder]
(
	@MDebit float,
	@MCredit float,
	@ADebit float,
	@ACredit float,
	@BCredit float,
	@FUseBonus bit,
	@LunchType int,
	@MBalance float OUTPUT,
	@ABalance float OUTPUT,
	@BonusBalance float OUTPUT
)
AS
BEGIN
	DECLARE 
		@AppliedADebit float,
		@TempMApplied float,
		@TempAApplied float
	
	IF (@MDebit <> 0.0) BEGIN
		SET @MBalance = ROUND(@MBalance + @MDebit,2)
	END -- If Meal Plan Payment 
	
	IF (@ADebit <> 0.0) BEGIN
		IF (@ADebit > 0.0) BEGIN
			IF (@ACredit >= @ADebit) BEGIN
				SET @ABalance = ROUND(@ABalance + @ADebit,2)	
			END
			ELSE BEGIN
				SET @AppliedADebit = @ADebit - @ACredit	
				SET @ABalance = ROUND(@ABalance + @ACredit,2)
				
				IF ((@MBalance - @MCredit) < 0.0) BEGIN
					IF (@AppliedADebit > (-(@MBalance - @MCredit))) BEGIN
						SET @TempMApplied = -(@MBalance - @MCredit)
						SET @TempAApplied = @AppliedADebit - @TempMApplied	
						SET @ABalance = ROUND(@ABalance + @TempAApplied,2)
						SET @MBalance = ROUND(@MBalance + @TempMApplied,2)
					END
					ELSE BEGIN
						SET @MBalance = ROUND(@MBalance + @AppliedADebit,2)
					END
				END
				ELSE BEGIN
					SET @ABalance = ROUND(@ABalance + @AppliedADebit,2)
				END
			END
		END
		ELSE BEGIN
			SET @ABalance = ROUND(@ABalance + @ADebit,2)	
		END	
	END -- If AlaCarte Payment
	
	IF (@FUseBonus = 1) BEGIN
		SET @ACredit = @ACredit + @BCredit
		SET @BCredit = 0.0	
	END
	
	IF (@ACredit <> 0.0) BEGIN
		IF ((@FUseBonus = 1) AND (@LunchType = 5)) BEGIN
			IF (@BonusBalance > 0.0) BEGIN
				IF (@BonusBalance > @ACredit) BEGIN
					SET @BonusBalance = ROUND(@BonusBalance - @ACredit,2)
					SET @BCredit = @ACredit
					SET @ACredit = 0.0
				END
				ELSE BEGIN
					SET @BCredit = @BonusBalance
					SET @BonusBalance = 0.0
					SET @ACredit = @ACredit - @BCredit
				END
			END
		END
		
		SET @ABalance = ROUND(@ABalance - @ACredit,2)
	END
	
	IF (@MCredit <> 0.0) BEGIN
		IF (@MCredit > 0.0) BEGIN
			IF (@MBalance >= @MCredit) BEGIN
				SET @MBalance = ROUND(@MBalance - @MCredit,2)
			END
			ELSE BEGIN
				DECLARE @TempMCredit float
				SET @TempMCredit = @MCredit
				IF (@MBalance > 0.0) BEGIN
					SET @TempMCredit = @TempMCredit - @MBalance
					SET @MBalance = 0.0	
				END
				
				IF (@ABalance >= @TempMCredit) BEGIN
					SET @ABalance = ROUND(@ABalance - @TempMCredit,2)	
				END
				ELSE BEGIN
					IF (@ABalance > 0.0) BEGIn
						SET @TempMCredit = @TempMCredit - @ABalance
						SET @ABalance = 0.0
					END	
					
					IF (@TempMCredit > 0.0) BEGIN
						SET @MBalance = ROUND(@MBalance - @TempMCredit,2)
					END
				END
			END	
		END
		ELSE BEGIN
			SET @MBalance = ROUND(@MBalance - @MCredit,2)
		END	
	END
END
GO
