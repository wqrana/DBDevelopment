USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_Order_Void]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Main_Order_Void]
	@ClientID bigint,
	@EMPLOYEEID bigint,
	@ORDERID bigint, 
	@ORDERTYPE int,
	@VOIDPAYMENT bit,
	@ORDLOGID bigint = NULL,	-- NULL - No Note, -1 - New note, >0 - Update note
	@ORDLOGNOTE varchar(255) = NULL,
	@ErrorMessage varchar(4000) = '' OUTPUT
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
	@DEBDIF float,
	@ORDLOGEXISTS bit
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SET @ORDLOGEXISTS = 0

	DECLARE @OrdLogIds TABLE (NewOrdLogId bigint)

	BEGIN TRAN
	BEGIN TRY
		SET @CREDDIF = 0.0
		SET @DEBDIF = 0.0

		-- Check for Valid Parameters
		IF (@ClientID <= 0)
			RAISERROR('Invalid Client ID %d', 11, 1, @ClientID)
		IF (@ORDERID = -1 OR @ORDERID = 0)
			RAISERROR('Invalid Order ID %d', 11, 1, @ORDERID)
		IF (@ORDERTYPE <= 0 AND @ORDERTYPE > 1)
			RAISERROR('Invalid Order Type %d', 11, 1, @ORDERTYPE)

		-- Gather Information on the Order for Future Use
		IF (@ORDERTYPE = 0) BEGIN
			SELECT 
				@CUSTID = Customer_Id,
				@ACredit = ACredit, 
				@MCredit = MCredit, 
				@BCredit = ISNULL(BCredit,0.0), 
				@ADebit = ADebit, 
				@MDebit = MDebit, 
				@BDebit = 0.0 
			FROM Orders 
			WHERE ClientID = @ClientID
				and Id = @ORDERID
			IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
				RAISERROR('Failed to Gather Order Information for Adjusting Balance', 11, 5)
		END
		ELSE IF (@ORDERTYPE = 1) BEGIN
			SELECT 
				@CUSTID = Customer_Id,
				@ACredit = ACredit, 
				@MCredit = MCredit, 
				@BCredit = ISNULL(BCredit,0.0), 
				@ADebit = 0.0, 
				@MDebit = 0.0, 
				@BDebit = 0.0 
			FROM PreOrders 
			WHERE ClientID = @ClientID
				and Id = @ORDERID
			IF (@@ERROR <> 0 OR @@ROWCOUNT = 0)
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
			FROM AccountInfo WITH (UPDLOCK) 
			WHERE ClientID = @ClientID
				and Customer_Id = @CUSTID
		END
		ELSE BEGIN
			SET @ABAL = 0.0
			SET @MBAL = 0.0
			SET @BBAL = 0.0
		END
		IF (@@ERROR <> 0) BEGIN
			RAISERROR('Failed to Gather Customer''s Account Balance', 11, 2)
		END

		-- Update or Create order log
		IF (@ORDLOGID IS NOT NULL) BEGIN
			MERGE OrdersLog T
			USING (select @ClientID as ClientID, @ORDLOGID as Id, @EMPLOYEEID as Employee_Id, GETDATE() as ChangedDate, @ORDLOGNOTE as Notes) S
			ON T.Id = S.Id
			WHEN MATCHED THEN
				update set 
					Notes = T.Notes + '\n' + S.Notes
			WHEN NOT MATCHED THEN
				insert (ClientID, Employee_Id, ChangedDate, Notes)
				values (S.ClientID, S.Employee_Id, S.ChangedDate, S.Notes)
			OUTPUT inserted.Id into @OrdLogIds;
			
			-- Commented by farrukh m (allshore) on 05/09/2016: ID column in OrdersLog table is auto generated key. So there's no need of the following code.(PA-519)
			/*IF (@ORDLOGID = -1) BEGIN
				EXEC Main_IndexGenerator_GetIndex @ClientID, 21, 1, @ORDLOGID OUTPUT
				IF (@@ERROR <> 0 OR @ORDLOGID = 0) RAISERROR ('Failed to get an Order log ID', 11, 3)
			END

			SELECT @ORDLOGEXISTS = COUNT(*) FROM OrdersLog WHERE ClientID = @ClientID AND Id = @ORDLOGID
			IF (@@ERROR <> 0) RAISERROR ('Failed to see if order log already exists.', 11, 3)

			IF (@ORDLOGEXISTS = 1) BEGIN
				UPDATE OrdersLog SET
					Employee_Id = @EMPLOYEEID,
					ChangedDate = GETDATE(),
					Notes = @ORDLOGNOTE
				WHERE ClientID = @ClientID AND ID = @ORDLOGID
			END
			ELSE BEGIN
				INSERT INTO OrdersLog (ClientID, Id, Employee_Id, ChangedDate, Notes)
					VALUES (@ClientID, @ORDLOGID, @EMPLOYEEID, GETDATE(), @ORDLOGNOTE)
			END
			*/
			IF (@@ERROR <> 0) RAISERROR ('Failed to save order log ID %d', 11, 3, @ORDLOGID)
			
			SELECT Top 1 @ORDLOGID = NewOrdLogId from @OrdLogIds
		END

		-- Void Items in the Order
		IF (@ORDERTYPE = 0) BEGIN
			UPDATE Items SET isVoid = 1 WHERE ClientID = @ClientID and Order_Id = @ORDERID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Mark Items for Order ID: %d voided', 11, 3, @ORDERID)
		END
		ELSE IF (@ORDERTYPE = 1) BEGIN
			-- Check to see if any of the items were already Picked up
			SELECT *
			FROM Items
			WHERE ClientID = @ClientID 
				and PreOrderItem_Id in 
					(SELECT Id FROM PreOrderItems WHERE ClientID = @ClientID and PreOrder_Id = @ORDERID)
			IF (@@ROWCOUNT > 0)
				RAISERROR('There is at least one or more items Picked up in this PreOrder.\nPlease Void the Pickedup Items before Voiding this PreOrder', 11, 4)
						
			-- Void Order if none of the items picked up	
			UPDATE PreOrderItems SET isVoid = 1 WHERE ClientID = @ClientID and PreOrder_Id = @ORDERID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Mark PreOrderItems for PreOrder ID: %d voided', 11, 3, @ORDERID)
		END

		IF (@ORDERTYPE = 0) BEGIN
			-- Just void the Order, without changes
			IF (@VOIDPAYMENT = 1) BEGIN
				UPDATE Orders SET 
					isVoid = 1,
					OrdersLog_Id = @ORDLOGID
				WHERE ClientID = @ClientID 
					and Id = @ORDERID	
			END
			-- Adjust the order so that there was no sale, but payment stays
			ELSE BEGIN
				UPDATE Orders SET
					OrdersLog_Id = @ORDLOGID,
					ACredit = 0.0,
					MCredit = 0.0,
					BCredit = 0.0
				WHERE ClientID = @ClientID
					and Id = @ORDERID
			END
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Mark Order ID: %d voided', 11, 5, @ORDERID)
		END
		ELSE IF (@ORDERTYPE = 1) BEGIN
			UPDATE PreOrders SET 
				isVoid = 1,
				OrdersLog_Id = @ORDLOGID
			WHERE ClientID = @ClientID
				and Id = @ORDERID
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
			WHERE ClientID = @ClientID
				and Customer_Id = @CUSTID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to update balance for Customer ID: %d', 11, 6, @CUSTID)
		END

		--PRINT 'UPDATE PRIOR BALS'
		---- Update Prior Balances
		--SELECT @TRANSID = Id FROM Transactions WHERE ClientID = @ClientID and Order_Id = @ORDERID AND OrderType = @ORDERTYPE
		--IF (@@ERROR <> 0)
		--	RAISERROR('Failed to Gather Processing Order Number', 11, 7)

		--DECLARE MyOrders CURSOR LOCAL FOR 
		--	SELECT 
		--		t.Id, t.Order_Id, t.OrderType, t.CashRes_Id 
		--	FROM Transactions t
		--		LEFT OUTER JOIN Orders o ON o.id = t.Order_id and t.OrderType = 0 and o.ClientID = t.ClientID
		--	WHERE t.ClientID = @ClientID and t.Id > @TRANSID AND o.Customer_Id = @CUSTID AND o.isVoid = 0
		--	UNION ALL
		--	SELECT
		--		t.Id, t.Order_Id, t.OrderType, t.CashRes_Id
		--	FROM Transactions t
		--		LEFT OUTER JOIN PreOrders pre ON pre.Id = t.Order_Id AND t.OrderType = 1 and pre.ClientID = t.ClientID
		--	WHERE t.ClientID = @ClientID and t.Id > @TRANSID AND pre.Customer_Id = @CUSTID AND pre.isVoid = 0
		--	ORDER BY t.Id

		--OPEN MyOrders

		--BEGIN TRY
		--	FETCH NEXT FROM MyOrders INTO @ORDNUM, @ORDID, @ORDTYPE, @CASHRESID

		--	WHILE (@@FETCH_STATUS = 0) BEGIN
		--		IF (@ORDTYPE = 0) BEGIN
		--			-- Standard Order
		--			UPDATE Orders SET 
		--				PriorMBal = ROUND((PriorMBal + @MDIF),2),
		--				PriorABal = ROUND((PriorABal + @ADIF),2),
		--				PriorBBal = ROUND((PriorBBal + @BDIF),2)
		--			WHERE ClientID = @ClientID
		--				and Id = @ORDID
		--			IF (@@ERROR <> 0)
		--				RAISERROR('Failed to Update Prior Balances for Order ID: %d', 11, 8, @ORDID)
		--		END	
		--		ELSE IF (@ORDTYPE = 1) BEGIN
		--			-- PreOrder
		--			UPDATE Preorders SET
		--				PriorMBal = ROUND((PriorMBal + @MDIF),2),
		--				PriorABal = ROUND((PriorABal + @ADIF),2),
		--				PriorBBal = ROUND((PriorBBal + @BDIF),2)
		--			WHERE ClientID = @ClientID
		--				and Id = @ORDID
		--			IF (@@ERROR <> 0)
		--				RAISERROR('Failed to Update Prior Balances for PreOrder ID: %d', 11, 8, @ORDID)
		--		END

		--		FETCH NEXT FROM MyOrders INTO @ORDNUM, @ORDID, @ORDTYPE, @CASHRESID
		--	END

		--	CLOSE MyOrders
		--	DEALLOCATE MyOrders
		
		--END TRY
		--BEGIN CATCH
		--	CLOSE MyOrders
		--	DEALLOCATE MyOrders

		--	DECLARE @errMsg varchar(4000), @errSev int, @errState int
		--	SET @errMsg = ERROR_MESSAGE()
		--	SET @errSev = ERROR_SEVERITY()
		--	SET @errState = ERROR_STATE()
		--	RAISERROR(@errMsg, @errSev, @errState)
		--END CATCH

		COMMIT TRAN
		SELECT 0 as Result, '' as ErrorMessage,  cast(@CREDDIF as numeric(36,2)) as CreditDif, cast(@DEBDIF  as numeric(36,2)) as DebitDif, cast(@ABAL  as numeric(36,2)) as ABalance, cast(@MBAL  as numeric(36,2)) as MBalance, cast(@BBAL  as numeric(36,2)) as BonusBalance
		SET @ErrorMessage = '' 
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage, 0.0 as CreditDif, 0.0 as DebitDif, 0.0 as ABalance, 0.0 as MBalance, 0.0 as BonusBalance
		SET @ErrorMessage = ERROR_MESSAGE()
	END CATCH
END
GO
