USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[VoidOrder]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[VoidOrder]
	@ClientID int,
	@ORDERID int, 
	@ORDLOGID int,
	@ORDERTYPE int,
	@VOIDPAYMENT bit
AS
DECLARE 
	@ORDNUM int,
	@ORDID int,
	@ORDTYPE int,
	@CASHRESID int,
	@TRANSID int,
	@ABAL float,
	@MBAL float,
	@BBAL float,
	@ACredit float,
	@MCredit float,
	@BCredit float,
	@ADebit float,
	@MDebit float,
	@BDebit float,
	@ADIF float,
	@MDIF float,
	@BDIF float,
	@CUSTID int,
	@CREDDIF float,
	@DEBDIF float
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRAN
	BEGIN TRY
		SET @CREDDIF = 0.0
		SET @DEBDIF = 0.0

		-- Check for Valid Parameters
		IF (@ORDERID = -1 OR @ORDERID = 0)
			RAISERROR('Invalid Order ID %d', 11, 1, @ORDERID)

		IF (@ORDLOGID = -1 OR @ORDLOGID = 0)
			RAISERROR('Invalid Orders Log ID $d', 11, 1, @ORDLOGID)

		IF (@ORDERTYPE <= 0 AND @ORDERTYPE > 1)
			RAISERROR('Invalid Order Type %d', 11, 1, @ORDERTYPE)

		-- Gather Information on the Order for Future Use
		IF (@ORDERTYPE = 0) BEGIN
			SELECT 
				@CUSTID = Customer_Id,
				@ACredit = ACredit, 
				@MCredit = MCredit, 
				@BCredit = BCredit, 
				@ADebit = ADebit, 
				@MDebit = MDebit, 
				@BDebit = 0.0 
			FROM Orders 
			WHERE ClientID = @ClientID and
				Id = @ORDERID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Gather Order Information for Adjusting Balance', 11, 5)
		END
		ELSE IF (@ORDERTYPE = 1) BEGIN
			SELECT 
				@CUSTID = Customer_Id,
				@ACredit = ACredit, 
				@MCredit = MCredit, 
				@BCredit = BCredit, 
				@ADebit = 0.0, 
				@MDebit = 0.0, 
				@BDebit = 0.0 
			FROM PreOrders 
			WHERE ClientID = @ClientID and
				Id = @ORDERID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Gather PreOrder Information for Adjusting Balance', 11, 5)
		END

		-- Get Balance Change
		IF (@VOIDPAYMENT = 1) BEGIN
			SET @ADIF = @ACredit - @ADebit
			SET @MDIF = @MCredit - @MDebit
			SET @BDIF = @BCredit - @BDebit
			SET @DEBDIF = ROUND(@ADebit + @MDebit + @BDebit,2)
			SET @CREDDIF = ROUND(@ACredit + @MCredit + @BCredit,2)
		END
		ELSE BEGIN
			SET @ADIF = @ACredit
			SET @MDIF = @MCredit
			SET @BDIF = @BCredit
			SET @DEBDIF = 0.0
			SET @CREDDIF = ROUND(@ACredit + @MCredit + @BCredit,2)
		END

		-- Get Current Balance of Accounts Only
		IF (@CUSTID > 0) BEGIN
			SELECT 
				@ABAL = ISNULL(ABalance, 0.0), 
				@MBAL = ISNULL(MBalance, 0.0), 
				@BBAL = ISNULL(BonusBalance, 0.0) 
			FROM AccountInfo 
				WITH (UPDLOCK) 
			WHERE ClientID = @ClientID and
				Customer_Id = @CUSTID
		END
		ELSE BEGIN
			SET @ABAL = 0.0
			SET @MBAL = 0.0
			SET @BBAL = 0.0
		END
		
		IF (@@ERROR <> 0) BEGIN
			RAISERROR('Failed to Gather Customer''s Account Balance', 11, 2)
		END

		-- Void Items in the Order
		IF (@ORDERTYPE = 0) BEGIN
			UPDATE Items SET isVoid = 1 WHERE ClientID = @ClientID and Order_Id = @ORDERID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Mark Items for Order ID: %d voided', 11, 3, @ORDERID)
		END
		ELSE IF (@ORDERTYPE = 1) BEGIN
			-- Check to see if any of the items were already Picked up
			/*
			SELECT *
			FROM Items
			WHERE PreOrderItem_Id in (SELECT Id FROM PreOrderItems WHERE ClientID = @ClientID and PreOrder_Id = @ORDERID)
			IF (@@ROWCOUNT > 0)
				RAISERROR('There is at least one or more items Picked up in this PreOrder.\nPlease Void the Pickedup Items before Voiding this PreOrder', 11, 4)
			*/
			-- Updated by Waqar Q.
			-- isVoid check is added on 17/6
			IF EXISTS (	SELECT *
			FROM Items
			WHERE PreOrderItem_Id in (SELECT Id FROM PreOrderItems WHERE ClientID = @ClientID and PreOrder_Id = @ORDERID)
			AND isVoid = 0)
			BEGIN
				RAISERROR('There is at least one or more items Picked up in this PreOrder ID: %d. Please Void the Pickedup Items before Voiding this PreOrder', 11, 4,@ORDERID)
			END		
			-- Void Order if none of the items picked up	
			UPDATE PreOrderItems SET isVoid = 1 WHERE ClientID = @ClientID and PreOrder_Id = @ORDERID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Mark PreOrderItems for PreOrder ID: %d voided', 11, 3, @ORDERID)
		END

		IF (@ORDERTYPE = 0) BEGIN
			-- Just void the Order, without changes
			-- Waqar Q. added  (@VOIDPAYMENT IS NULL), if now payment then void the order as well
			IF (@VOIDPAYMENT = 1 OR @VOIDPAYMENT IS NULL) BEGIN
				UPDATE Orders SET 
					isVoid = 1,
					OrdersLog_Id = @ORDLOGID
				WHERE ClientID = @ClientID and
					Id = @ORDERID	
			END
			-- Adjust the order so that there was no sale, but payment stays
			ELSE BEGIN
				UPDATE Orders SET
					OrdersLog_Id = @ORDLOGID,
					ACredit = 0.0,
					MCredit = 0.0,
					BCredit = 0.0
				WHERE ClientID = @ClientID and
					Id = @ORDERID
			END
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Mark Order ID: %d voided', 11, 5, @ORDERID)
		END
		ELSE IF (@ORDERTYPE = 1) BEGIN
			UPDATE PreOrders SET 
				isVoid = 1,
				OrdersLog_Id = @ORDLOGID
			WHERE ClientID = @ClientID and
				Id = @ORDERID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Mark PreOrder ID: %d voided', 11, 5, @ORDERID)
		END

		-- Update the Customer's Balance to reflect Void if Account
		IF (@CUSTID > 0) BEGIN
			SET @ABAL = ROUND(@ABAL + @ADIF,2)
			SET @MBAL = ROUND(@MBAL + @MDIF,2)
			SET @BBAL = ROUND(@BBAL + @BDIF,2)

			UPDATE AccountInfo SET 
				ABalance = @ABAL, 
				MBalance = @MBAL, 
				BonusBalance = @BBAL 
			WHERE ClientID = @ClientID and
				Customer_Id = @CUSTID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to update balance for Customer ID: %d', 11, 6, @CUSTID)
		END

		/* Prior Balances do not exist in Cloud Database. */
		--PRINT 'UPDATE PRIOR BALS'
		---- Update Prior Balances
		--SELECT @TRANSID = Id FROM Transactions WHERE ClientID = @ClientID and Order_Id = @ORDERID AND OrderType = @ORDERTYPE
		--IF (@@ERROR <> 0)
		--	RAISERROR('Failed to Gather Processing Order Number', 11, 7)

		--DECLARE MyOrders CURSOR LOCAL FOR 
		--	SELECT 
		--		t.* 
		--	FROM Transactions t
		--		LEFT OUTER JOIN Orders o ON o.id = t.Order_id and t.OrderType = 0
		--	WHERE t.Id > @TRANSID AND o.Customer_Id = @CUSTID AND o.isVoid = 0
		--	UNION
		--	SELECT
		--		t.*
		--	FROM Transactions t
		--		LEFT OUTER JOIN PreOrders pre ON pre.Id = t.Order_Id AND t.OrderType = 1
		--	WHERE t.Id > @TRANSID AND pre.Customer_Id = @CUSTID AND pre.isVoid = 0
		--	ORDER BY t.Id

		--OPEN MyOrders
		--FETCH NEXT FROM MyOrders INTO @ORDNUM, @ORDID, @ORDTYPE, @CASHRESID

		--WHILE (@@FETCH_STATUS = 0) BEGIN
		--	IF (@ORDTYPE = 0) BEGIN
		--		-- Standard Order
		--		UPDATE Orders SET 
		--			PriorMBal = ROUND((PriorMBal + @MDIF),2),
		--			PriorABal = ROUND((PriorABal + @ADIF),2),
		--			PriorBBal = ROUND((PriorBBal + @BDIF),2)
		--		WHERE Id = @ORDID
		--		IF (@@ERROR <> 0)
		--			RAISERROR('Failed to Update Prior Balances for Order ID: %d', 11, 8, @ORDID)
		--	END	
		--	ELSE IF (@ORDTYPE = 1) BEGIN
		--		-- PreOrder
		--		UPDATE Preorders SET
		--			PriorMBal = ROUND((PriorMBal + @MDIF),2),
		--			PriorABal = ROUND((PriorABal + @ADIF),2),
		--			PriorBBal = ROUND((PriorBBal + @BDIF),2)
		--		WHERE Id = @ORDID
		--		IF (@@ERROR <> 0)
		--			RAISERROR('Failed to Update Prior Balances for PreOrder ID: %d', 11, 8, @ORDID)
		--	END

		--	FETCH NEXT FROM MyOrders INTO @ORDNUM, @ORDID, @ORDTYPE, @CASHRESID
		--END

		--CLOSE MyOrders
		--DEALLOCATE MyOrders

		COMMIT TRAN
		SELECT 0 as Result, '' as ErrorMessage, @CREDDIF as CreditDif, @DEBDIF as DebitDif, @ABAL as ABalance, @MBAL as MBalance, @BBAL as BonusBalance
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage, CAST(0.0 AS float) as CreditDif, CAST(0.0 AS float) as DebitDif, CAST(0.0 AS float) as ABalance, CAST(0.0 AS float) as MBalance, CAST(0.0 AS float) as BonusBalance
	END CATCH
END
GO
