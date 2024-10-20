USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_Recalculation_BonusPayments]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Main_Recalculation_BonusPayments]
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@CustID int,
	@BonusBal float OUTPUT,
	@BeginDate datetime = '1/1/1900',
	@EndDate datetime = '1/1/1900',
	@OrderID int = -1
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE 
		@CUSTBONUSPYMTS CURSOR,
		@Bonus float,
		@BonusPaymentID int
	SET @Bonus = 0.0
	SET @BonusPaymentID = -1

	BEGIN TRY
		-- Insert statements for procedure here
		IF (@OrderID = -1) BEGIN
			-- Lookup Bonus Payments between date range
			SET @CUSTBONUSPYMTS = CURSOR LOCAL FOR 
				SELECT b.Id, b.BonusPaid
				FROM BonusPayments b 
				WHERE b.BonusDate between @BeginDate AND @EndDate 
					AND b.Customer_Id = @CustID
					AND b.ClientID = @ClientID
		END
		ELSE BEGIN
			-- Lookup Bonus Payment on an Order
			SET @CUSTBONUSPYMTS = CURSOR LOCAL FOR 
				SELECT b.Id, b.BonusPaid
				FROM BonusPayments b
				WHERE b.Order_Id = @OrderID
					AND b.Customer_Id = @CustID
					AND b.ClientID = @ClientID
		END
		
		OPEN @CUSTBONUSPYMTS
		
		FETCH NEXT FROM @CUSTBONUSPYMTS INTO @BonusPaymentID, @Bonus
		WHILE (@@FETCH_STATUS = 0) BEGIN
			UPDATE BonusPayments SET PriorBal = @BonusBal WHERE Id = @BonusPaymentID
			IF (@@ERROR <> 0) RAISERROR('Failed to Update Prior Balance on Bonus Payment ID: %d for Customer ID: %d.', 11, 1, @BonusPaymentID, @CustID)
			SET @BonusBal = ROUND(@BonusBal + @Bonus,2)
			
			FETCH NEXT FROM @CUSTBONUSPYMTS INTO @BonusPaymentID, @Bonus	
		END
		
		CLOSE @CUSTBONUSPYMTS
		DEALLOCATE @CUSTBONUSPYMTS
		
	END TRY
	BEGIN CATCH
		IF (CURSOR_STATUS('variable', '@CUSTORDCUR') >= 0) BEGIN
			CLOSE @CUSTBONUSPYMTS
			DEALLOCATE @CUSTBONUSPYMTS
		END
		RETURN(ERROR_STATE())
	END CATCH
END
GO
