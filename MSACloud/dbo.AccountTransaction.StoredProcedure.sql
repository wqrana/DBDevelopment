USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[AccountTransaction]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AccountTransaction]
	@ClientID bigint,
	@SchoolID float,
	@AlaDebit float output,
	@AlaCredit float output,
	@MealDebit float output,
	@MealCredit float output,
	@AlaBalance float output,
	@MealBalance float output,
	@BonusCredit float output,
	@CustBBalance float output,
	@PrevBBalance float,
	@bBonus float output,
	@bPayment float output,
	@MealType int,
	@LunchType_Id int,
	@Success bit output
AS
DECLARE 
	@UseMealPlan bit,
	@UseBonus bit,
	@BonusType int,
	@BonusAmount float,
	@BonusLimit float
BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET XACT_ABORT ON
	SET NOCOUNT ON;
	BEGIN TRY
		-- Gather information from Database for calculations
		SELECT 
			@UseMealPlan = ISNULL(do.UsingMealPlan,0),
			@UseBonus = ISNULL(do.UsingBonus,0)
		FROM Schools s
			LEFT OUTER JOIN District d on d.Id = s.district_id and d.ClientID = s.ClientID
			LEFT OUTER JOIN DistrictOptions do on do.District_Id = s.District_Id and do.ClientID = s.ClientID
		WHERE s.ClientID = @ClientID
			and s.Id = @SchoolID
		IF (@@ERROR <> 0) 
			RAISERROR('Failed to get District options', 11, 1)
		
		SELECT
			@BonusType = ISNULL(l.Bonus,0),
			@BonusAmount = ISNULL(l.BonusAmount,0),
			@BonusLimit = ISNULL(l.BonusLimit,0)
		FROM LunchTypes l
		WHERE l.ClientID = @ClientID
			and l.Id = @LunchType_Id
		IF (@@ERROR <> 0) 
			RAISERROR('Failed to get Bonus settings', 11, 2)

		-- This procedure should match the code for an Account Transaction in POS Software
		IF (@MealDebit <> 0.0 OR @AlaDebit <> 0.0) BEGIN
			IF ((@UseBonus = 1) AND (@MealType = 5) AND (@LunchType_Id > 0)) BEGIN
				SET @bPayment = 0.0
				
				IF ((@AlaDebit > 0.0) AND (@AlaDebit > @AlaCredit)) BEGIN
					SET @bPayment = @bPayment + (@AlaDebit - @AlaCredit)
				END
				
				IF ((@MealDebit > 0.0) AND (@MealDebit > @MealCredit)) BEGIN
					SET @bPayment = @bPayment + (@MealDebit - @MealCredit)
				END
				
				-- Apply Bonus only when payment is made
				IF (@bPayment > 0.0) BEGIN
					-- Get Bonus Amount Here
					SELECT @bBonus = dbo.GetBonusAmount(@ClientID, @LunchType_Id, @bPayment)
				END
				
				IF (@bBonus > 0.0) BEGIN
					SET @PrevBBalance = @CustBBalance
					SET @CustBBalance = @CustBBalance + @bBonus
				END
			END
			
			IF (@MealDebit <> 0.0) BEGIN
				SET @MealBalance = @MealBalance + @MealDebit
			END
			
			IF (@AlaDebit <> 0.0) BEGIN
				IF (@AlaDebit > 0.0) BEGIN
					IF (@AlaCredit >= 0.0) BEGIN
						IF (@AlaCredit >= @AlaDebit) BEGIN
							SET @AlaBalance = @AlaBalance + @AlaDebit
						END
						ELSE BEGIN
							DECLARE @AppliedADebit float
							SET @AppliedADebit = @AlaDebit - @AlaCredit
							SET @AlaBalance = @AlaBalance + @AlaCredit
							
							IF ((@MealBalance - @MealCredit) < 0.0) BEGIN
								IF (@AppliedADebit > (-(@MealBalance - @MealCredit))) BEGIN
									DECLARE @TmpAApplied float, @TmpMApplied float
									SET @TmpAApplied = 0.0
									SET @TmpMApplied = 0.0
									
									SET @TmpMApplied = -(@MealBalance - @MealCredit)
									SET @TmpAApplied = @AppliedADebit - @TmpMApplied
									
									SET @AlaBalance = @AlaBalance + @TmpAApplied
									SET @MealBalance = @MealBalance + @TmpMApplied
								END
								ELSE BEGIN	-- Extra AlaCarte Payment goes toward meal Plan Account
									SET @MealBalance = @MealBalance + @AppliedADebit
								END
							END
							ELSE BEGIN	-- Meal Plan Account is Positive
								SET @AlaBalance = @AlaBalance + @AppliedADebit
							END
						END
					END
					ELSE BEGIN	-- Ala Carte Payment Only
						SET @AlaBalance = @AlaBalance + @AlaDebit
					END
				END
				ELSE BEGIN -- Refunds are just subtracted from the account
					SET @AlaBalance = @AlaBalance + @AlaDebit
				END
			END
		END	-- IF Payment was made
		
		-- If there are Bonus Credits put them into Ala Carte for Calculations
		IF (@BonusCredit > 0.0) BEGIN
			SET @AlaCredit = @AlaCredit + @BonusCredit
		END
		
		-- do AlaCarte Sale First
		IF ((@AlaCredit <> 0.0) OR (@MealCredit <> 0.0)) BEGIN
			-- Do AlaCarte Charges... if any Bonus money is there, pull from Bonus first
			IF (@AlaCredit > 0.0) BEGIN
				IF ((@UseBonus = 1) AND (@MealType = 5) AND (@LunchType_Id > 0)) BEGIN
					-- See if we want to take any from Bonus money
					IF ((@AlaCredit > 0.0) AND (@CustBBalance > 0.0)) BEGIN
						-- If Bonus account has enough to cover
						IF (@CustBBalance > @AlaCredit) BEGIN
							SET @BonusCredit = @AlaCredit
							SET @CustBBalance = @CustBBalance - @BonusCredit
							SET @AlaCredit = 0.0
						END
						ELSE BEGIN
							SET @BonusCredit = @CustBBalance
							SET @CustBBalance = 0.0
							SET @AlaCredit = @AlaCredit - @BonusCredit
						END
					END -- If Bonus Available
				END -- If Bonus
				
				-- Then pull from AlaCarte Account, AlaCarte Account can go negative
				IF (@AlaCredit <> 0.0) BEGIN
					SET @AlaBalance = @AlaBalance - @AlaCredit
				END
			END -- If AlaCarte Sales

			IF (@AlaCredit < 0.0) BEGIN
				SET @AlaBalance = @AlaBalance - @AlaCredit
			END
			
			-- Then do Meal Plan Sale
			IF (@MealCredit <> 0.0) BEGIN
				IF (@MealCredit > 0.0) BEGIN
					-- do meal plan sale
					IF (@MealBalance >= @MealCredit) BEGIN
						-- if there is enough money in mealplan. pull sale from meal plan balance
						SET @MealBalance = @MealBalance - @MealCredit
					END
					ELSE BEGIN
						-- if there is not enough money in meal plan to fund this sale
						DECLARE @TMealCredit float
						SET @TMealCredit = @MealCredit
						
						IF (@MealBalance > 0.0) BEGIN
							-- pull any remaining amount from meal plan balance
							SET @TMealCredit = @TMealCredit - @MealBalance
							SET @MealBalance = 0.0
						END
						
						-- if there is any money in Alacarte balance, pull from it
						IF (@AlaBalance >= @TMealCredit) BEGIN
							-- Alacarte enough to cover, then use it
							SET @AlaBalance = @AlaBalance - @TMealCredit
						END
						ELSE BEGIN	-- not enough in alacarte to cover
							IF (@AlaBalance > 0.0) BEGIN
								SET @TMealCredit = @TMealCredit - @AlaBalance
								SET @AlaBalance = 0.0	
							END
							
							-- if there is not enough money in either account, let meal plan go negative
							IF (@TMealCredit > 0.0) BEGIN
								SET @MealBalance = @MealBalance - @TMealCredit
							END
						END
					END
				END
				ELSE BEGIN
					SET @MealBalance = @MealBalance - @MealCredit
				END
			END
		END
		
		SET @Success = 1
		--SELECT 0 as Result, '' as ErrorMessage
	END TRY
	BEGIN CATCH
		SET @Success = 0
		--SELECT ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
	END CATCH
END
GO
