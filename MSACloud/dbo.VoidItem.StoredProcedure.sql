USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[VoidItem]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[VoidItem]
	@ClientID int,
	@ITEMID int,
	@ORDERID int,
	@ORDLOGID int,
	@CUSTID int,
	@ORDERTYPE int
AS
DECLARE @MySalesTax CURSOR,
	-- Balance Variables
	@ABAL float,
	@MBAL float,
	@BBAL float,
	--@PRIABAL float,
	--@PRIMBAL float,
	--@PRIBBAL float,
	@ADIF float,
	@MDIF float,
	@BDIF float,
	-- Order Variables
	@TRANSID int,
	@ORDNUM int,
	@ORDTYPE int,
	@ORDID int,
	@CASHRESID int,
	@OLDACRED float,
	@OLDMCRED float,
	@OLDBCRED float,
	@TMPORDDATE datetime,
	-- Item Variables
	@SOLDTYPE int,
	@PREORDITEMID int,
	@MENUID int,
	@QTY int,
	@FULLPRICE float,
	@PAIDPRICE float,
	@TAXPRICE float,
	@SALESTAXID int, 
	@TAXRATE float, 
	@SALESTAX float,
	-- Calculation Variables
	@TMPBBAL float,
	@TMPTAXTOTAL float,
	@TAXABLESALES float,
	@SALES float,
	@NONTAXABLESALES float,
	@MEALTOTAL float,
	@TMPMTAX float,
	@TMPATAX float,
	@TMPTAX float,
	@NEWMCRED float,
	@NEWACRED float,
	@NEWBCRED float,
	@USEBONUS bit
	
Declare @voidItemQty as table( Qty int)
Declare @voidQty int = 0
BEGIN
	SET @OLDACRED = 0.0
	SET @OLDMCRED = 0.0
	SET @OLDBCRED = 0.0

    BEGIN TRAN

	BEGIN TRY
		-- Check for Valid Parameters Passed
		IF (@ITEMID = -1 OR @ITEMID = 0)
			RAISERROR('Invalid Item ID %d', 11, 1, @ITEMID)
		IF (@ORDERID = -1 OR @ORDERID = 0)
			RAISERROR('Invalid Order ID %d', 11, 1, @ORDERID)
		IF (@ORDLOGID = -1 OR @ORDLOGID = 0)
			RAISERROR('Invalid Order Log ID %d', 11, 1, @ORDLOGID)
		IF (@CUSTID < -3 OR @CUSTID = -1 OR @CUSTID = 0)
			RAISERROR('Invalid Customer ID %d', 11, 1, @CUSTID)
		IF (@ORDERTYPE <= 0 AND @ORDERTYPE > 1)
			RAISERROR('Invalid Order Type %d', 11, 1, @ORDERTYPE)

		-- Load Item and Order Information
		IF (@ORDERTYPE = 1) BEGIN
			SELECT
				@MENUID = poi.Menu_Id, 
				@QTY = poi.Qty, 
				@FULLPRICE = poi.FullPrice, 
				@PAIDPRICE = poi.PaidPrice, 
				@TAXPRICE = poi.TaxPrice, 
				@SOLDTYPE = poi.SoldType,
				@PREORDITEMID = poi.Id,
				@OLDACRED = po.ACredit,
				@OLDMCRED = po.MCredit,
				@OLDBCRED = po.BCredit
				--@PRIABAL = ISNULL(po.PriorABal,0.0),
				--@PRIMBAL = ISNULL(po.PriorMBal,0.0),
				--@PRIBBAL = ISNULL(po.PriorBBal,0.0)
			FROM PreOrderItems poi
				LEFT OUTER JOIN PreOrders po ON po.ClientID = poi.ClientID and po.id = poi.PreOrder_Id
			WHERE poi.ClientID = @ClientID and poi.Id = @ITEMID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to load information for PreOrderItem ID: %d', 11, 1, @ITEMID)
		END
		ELSE BEGIN
			SELECT 
				@MENUID = it.Menu_Id, 
				@QTY = it.Qty, 
				@FULLPRICE = it.FullPrice, 
				@PAIDPRICE = it.PaidPrice, 
				@TAXPRICE = it.TaxPrice, 
				@SOLDTYPE = it.SoldType, 
				@PREORDITEMID = it.PreOrderItem_Id,
				@OLDACRED = o.ACredit,
				@OLDMCRED = o.MCredit,
				@OLDBCRED = o.BCredit
				--@PRIABAL = ISNULL(o.PriorABal,0.0),
				--@PRIMBAL = ISNULL(o.PriorMBal,0.0),
				--@PRIBBAL = ISNULL(o.PriorBBal,0.0)
			FROM Items it
				LEFT OUTER JOIN Orders o ON o.ClientID = it.ClientID and o.id = it.Order_Id
			WHERE it.ClientID = @ClientID and
				it.Id = @ITEMID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to load information for Item ID: %d', 11, 1, @ITEMID)
		END		
		
		-- Load Customer's Balance
		IF (@CUSTID > 0) BEGIN
			SELECT 
				@ABAL = ISNULL(ABalance, 0.0), 
				@MBAL = ISNULL(MBalance, 0.0), 
				@BBAL = ISNULL(BonusBalance, 0.0) 
			FROM AccountInfo 
				WITH (UPDLOCK) 
			WHERE ClientID = @ClientID and
				Customer_Id = @CUSTID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to load balance for customer ID: %d', 11, 2, @CUSTID)

			-- Load District Settings
			SELECT
				@USEBONUS = ISNULL(do.UsingBonus,0)
			FROM Customers c 
				LEFT OUTER JOIN DistrictOptions do ON do.ClientID = c.ClientID and do.District_Id = c.District_Id
			WHERE c.ClientID = @ClientID and
				c.Id = @CUSTID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Get District Settings for Customer ID: %d', 11, 2, @CUSTID)
		END
		ELSE BEGIN
			SET @ABAL = 0.0
			SET @MBAL = 0.0
			SET @BBAL = 0.0
			SET @USEBONUS = 0
		END

		-- Update Item
		IF (@ORDERTYPE = 0) BEGIN
			UPDATE Items SET isVoid = 1 
			OUTPUT inserted.Qty
			INTO @voidItemQty
			WHERE ClientID = @ClientID and Id = @ITEMID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Void Item ID: %d', 11, 3, @ITEMID)
			Select @voidQty = Qty
			From @voidItemQty
			IF (@PREORDITEMID IS NOT NULL) BEGIN
				UPDATE PreOrderItems SET
					PickupCount = PickupCount - ISNULL(@voidQty,0), --PickupCount - 1
					Disposition = 0,
					PickupDate = CASE PickupCount - ISNULL(@voidQty,0) WHEN 0 THEN NULL ELSE PickupDate END	
				WHERE ClientID = @ClientID 
				AND   Id = @PREORDITEMID
				IF (@@ERROR <> 0)
					RAISERROR('Failed to Update pickup status for PreOrderItem ID: %d', 11, 3, @PREORDITEMID)
			END
		END
		ELSE IF (@ORDERTYPE = 1) BEGIN
			-- Check that Item was not picked up
			DECLARE @ITEMNAME varchar(75), @ORDPICKDATE varchar(20)
			SELECT 
				@ITEMNAME = ISNULL(m.ItemName,'Misc Item $' + LTRIM(STR(it.PaidPrice,10,2))), 
				@ORDPICKDATE = CONVERT(varchar,o.OrderDate,100)
			FROM Items it
				INNER JOIN Orders o ON o.ClientID = it.ClientID and o.Id = it.Order_Id
				LEFT OUTER JOIN Menu m ON m.ClientID = it.ClientID and m.Id = it.Menu_Id
			WHERE it.ClientID = @ClientID 
			AND it.PreOrderItem_Id = @PREORDITEMID
			AND ISNULL(it.isVoid,0) = 0
				
			IF (@@ROWCOUNT > 0) 
				RAISERROR('Item %s has already been picked up on %s.\nPlease void the Picked up Item before voiding the Preordered Item.', 11, 4, @ITEMNAME, @ORDPICKDATE)
			
			UPDATE PreOrderItems SET isVoid = 1 WHERE ClientID = @ClientID and Id = @ITEMID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Void Preordered Item ID: %d', 11, 3, @ITEMID)
		END

		SET @TMPTAXTOTAL = 0.0
		SET @TMPMTAX = 0.0
		SET @TMPATAX = 0.0

		-- Update Sales Tax on POS Orders Only
		IF (@ORDERTYPE = 0) BEGIN
			SELECT 
				@TAXABLESALES = dbo.TAXSUBTOTAL(@ClientID, @ORDERID), 
				@NONTAXABLESALES = dbo.NONTAXSUBTOTAL(@ClientID, @ORDERID), 
				@SALES = ROUND(dbo.ITEMTOTAL(@ClientID, @ORDERID), 2),
				@MEALTOTAL = ROUND(dbo.OrderMealTotal(@ClientID, @ORDERID),2)

			SET @MySalesTax = CURSOR LOCAL FOR
				SELECT Id, TaxRate FROM SalesTax WHERE ClientID = @ClientID and Order_Id = @ORDERID

			OPEN @MySalesTax
			FETCH NEXT FROM @MySalesTax INTO @SALESTAXID, @TAXRATE
			
			WHILE((@@FETCH_STATUS = 0) AND (CURSOR_STATUS('variable','@MySalesTax') > 0)) BEGIN
				SET @TMPTAX = (CEILING((@TAXRATE * @TAXABLESALES) * 100) / 100)
				SET @TMPTAXTOTAL = @TMPTAXTOTAL + @TMPTAX

				UPDATE SalesTax SET 
					SalesTax = ROUND(@TMPTAX, 2)
				WHERE ClientID = @ClientID and
					Id = @SALESTAXID
				IF (@@ERROR <> 0)
					RAISERROR('Failed to Update Sales Tax ID: %d for Order ID: %d', 11, 5, @SALESTAXID, @ORDERID)

				FETCH NEXT FROM @MySalesTax INTO @SALESTAXID, @TAXRATE
			END
			
			CLOSE @MySalesTax
			DEALLOCATE @MySalesTax

			IF (@TMPTAXTOTAL > 0.0) BEGIN
				SET @TMPMTAX = @MEALTOTAL * dbo.TAXPERCENTAGE(@ClientID, @ORDERID)
				SET @TMPATAX = @TMPTAXTOTAL - @TMPMTAX
			END
			ELSE BEGIN
				SET @TMPMTAX = 0.0
				SET @TMPATAX = 0.0
			END
		END
		ELSE BEGIN
			SELECT 
				@TAXABLESALES = 0.0, 
				@SALES = ROUND(dbo.PreOrderItemTotal(@ClientID, @ORDERID), 2),
				@MEALTOTAL = ROUND(dbo.PreOrderMealTotal(@ClientID, @ORDERID),2)
			--FROM PreOrders po
				--LEFT OUTER JOIN PreOrderItems poi ON poi.PreOrder_Id = po.Id

			SET @NONTAXABLESALES = @SALES
			SET @TMPMTAX = 0.0
			SET @TMPATAX = 0.0
		END

		SET @TMPBBAL = @BBAL + @OLDBCRED
		SET @NEWMCRED = @TMPMTAX + @MEALTOTAL
		SET @NEWACRED = (@SALES + @TMPTAXTOTAL) - @NEWMCRED
		SET @NEWBCRED = 0.0
		
		IF (@NEWACRED > 0.0 AND @USEBONUS = 1) BEGIN
			IF (@TMPBBAL > @NEWACRED) BEGIN
				SET @NEWBCRED = @NEWACRED
				SET @NEWACRED = 0.0
			END
			ELSE IF (@TMPBBAL > 0.0) BEGIN
				SET @NEWBCRED = @TMPBBAL
				SET @NEWACRED = @NEWACRED - @TMPBBAL
			END
		END
		
		SET @ADIF = @OLDACRED - @NEWACRED
		SET @MDIF = @OLDMCRED - @NEWMCRED
		SET @BDIF = @OLDBCRED - @NEWBCRED		

		IF (@ORDERTYPE = 0) BEGIN
			-- Update Order
			UPDATE Orders SET
				ACredit = ROUND(@NEWACRED,2), 
				MCredit = ROUND(@NEWMCRED,2), 
				BCredit = ROUND(@NEWBCRED,2),
				OrdersLog_Id = @ORDLOGID
			WHERE ClientID = @ClientID and
				Id = @ORDERID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Update Order ID: %d', 11, 5, @ORDERID)
		END
		ELSE IF (@ORDERTYPE = 1) BEGIN
			UPDATE PreOrders SET 
				ACredit = @NEWACRED, 
				MCredit = @NEWMCRED, 
				BCredit = @NEWBCRED,
				OrdersLog_Id = @ORDLOGID
			WHERE ClientID = @ClientID and
				Id = @ORDERID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Update PreOrder ID: %d', 11, 5, @ORDERID)
		END
		
		-- Update Account Info
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
				RAISERROR('Failed to Update Account Balance for Customer ID: %d', 11, 6, @CUSTID)
		END

		/* Prior Balances not used in Cloud Database */
		-- Update Prior Balances
		--SELECT @TRANSID = Id FROM Transactions WHERE Order_Id = @ORDERID AND OrderType = @ORDERTYPE
		--IF (@@ERROR <> 0)
		--	RAISERROR('Failed to Gather Processing Order Number', 11, 7)

		--DECLARE MyOrders CURSOR LOCAL FOR 
		--	SELECT 
		--		t.*, o.OrderDate as OrderDate
		--	FROM Orders o 
		--		LEFT OUTER JOIN Transactions t ON o.id = t.Order_id and t.OrderType = 0
		--	WHERE t.Id > @TRANSID AND o.Customer_Id = @CUSTID 
		--	UNION
		--	SELECT
		--		t.*, pre.TransferDate as OrderDate
		--	FROM PreOrders pre
		--		LEFT OUTER JOIN Transactions t ON pre.Id = t.Order_Id AND t.OrderType = 1
		--	WHERE t.Id > @TRANSID AND pre.Customer_Id = @CUSTID
		--	ORDER BY OrderDate

		--OPEN MyOrders
		--FETCH NEXT FROM MyOrders INTO @ORDNUM, @ORDID, @ORDTYPE, @CASHRESID, @TMPORDDATE

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

		--	FETCH NEXT FROM MyOrders INTO @ORDNUM, @ORDID, @ORDTYPE, @CASHRESID, @TMPORDDATE
		--END

		--CLOSE MyOrders
		--DEALLOCATE MyOrders
		
		-- Commit on Success
		COMMIT TRAN
		SELECT 0 as Result, '' as ErrorMessage, CAST(ISNULL(ROUND(@ADIF+@MDIF+@BDIF,2),0.0) AS Decimal(18,2)) as CreditDif, 0.0 as DebitDif, CAST(@ABAL as Decimal(18,2)) as ABalance, CAST(@MBAL as  Decimal(18,2)) as MBalance, CAST(@BBAL as  Decimal(18,2)) as BonusBalance
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage, 0.0 as CreditDif, 0.0 as DebitDif, 0.0 as ABalance, 0.0 as MBalance, 0.0 as BonusBalance
	END CATCH
END
GO
