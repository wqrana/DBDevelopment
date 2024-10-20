USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_Recalculation_UpdateOrdersAndItems]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Main_Recalculation_UpdateOrdersAndItems]
	(
	@ClientID bigint,
	@CUSTID int,
	@UPDLUNCHTYPE bit = 0,
	@ALLTOALA bit = 0,
	@NEWLUNCHTYPE int = 1,
	@LTSTARTDATE datetime = '1/1/1900 00:00:00',
	@LTENDDATE datetime = '1/1/1900 00:00:00',
	@RECALCDR bit = 0,
	@RDRSTARTDATE datetime = '1/1/1900 00:00:00',
	@RDRENDDATE datetime = '1/1/1900 00:00:00')
AS
BEGIN
	DECLARE -- Cursors for Required Data Sets.
			@CUSTORDCUR CURSOR,
			@ORDITEMSCUR CURSOR,
			@ORDTAXCUR CURSOR,
			-- Variables for Orders
			@PROCID int,
			@ORDID int,
			@ORDTYPE int,
			@PRIORBBAL float,
			@ADEBIT float,
			@MDEBIT float,
			@ORDLUNCHTYPE int, 
			@STUDENT bit,
			@TAXRATE float,
			@USINGMEALPLAN int,
			@USINGMEALEQUIV int,
			@USINGBONUS int,
			@EMPTAX int,
			@GUESTTAX int,
			@STUDCASHTAX int,
			@FREETAX int,
			@PAIDTAX int,
			@REDTAX int,
			@MEALTAX int,
			-- Variables for Items in Order
			@ITEMID int,
			@QTY int,
			@ITEMVOID bit,
			@FULLPRICE float,
			@PAIDPRICE float,
			@TAXPRICE float,
			@SOLDTYPE int,
			@PREORDITEMID int,
			@STUDFULLPRICE float,
			@STUDREDPRICE float,
			@EMPPRICE float,
			@GUESTPRICE float,
			@TAXABLEITEM bit,
			@MEALPLANITEM bit,
			@MEALEQUIVITEM bit,
			@CANFREE bit,
			@CANREDUCE bit,
			-- Variables for Sales Tax
			@TAXENTID int, 
			@TAXENTNAME varchar(50), 
			@TAXORDID int, 
			@SALESTAXRATE float, 
			@SALESTAX float,
			-- Variables for Calculations
			@TMPASUBTOTAL float,
			@TMPATAXABLESALES float,
			@TMPATAXTOTAL float,
			@TMPMSUBTOTAL float,
			@TMPMTAXABLESALES float,
			@TMPITEMTOTAL float,
			@SALESTAXTOTAL float,
			@NEGATEVALUE bit,
			@NEWTAXPRICE float,
			@NEWFULLPRICE float,
			@NEWPAIDPRICE float,
			@NONQUALIFIEDTOTAL float,
			@NEWACREDIT float,
			@NEWMCREDIT float,
			@NEWBCREDIT float

	BEGIN TRAN

	BEGIN TRY
		-- Update the LunchTypes First
		IF (@UPDLUNCHTYPE = 1) BEGIN
			UPDATE Orders SET LunchType = @NEWLUNCHTYPE
				WHERE ClientID = @ClientID AND Customer_Id = @CUSTID AND OrderDate >= @LTSTARTDATE AND OrderDate <= @LTENDDATE
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Update Order Lunchtypes for Customer ID: %d', 11, 1, @CUSTID)

			UPDATE PreOrders SET LunchType = @NEWLUNCHTYPE
				WHERE ClientID = @ClientID AND Customer_Id = @CUSTID AND PurchasedDate >= @LTSTARTDATE AND PurchasedDate <= @LTENDDATE
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Update Preorders Lunchtypes for Customer ID: %d', 11, 1, @CUSTID)
		END

		-- Load Orders To Loop Through
		IF (@RECALCDR = 1) BEGIN
			SET @CUSTORDCUR = CURSOR FOR 
			SELECT t.id, o.Id as Order_Id, ISNULL(t.OrderType,0) as OrderType, o.ADebit, o.MDebit, o.LunchType,
				ISNULL(c.isStudent, 0) as Student,
				ISNULL(dbo.TAXPERCENTAGE(@ClientID, o.id), 0.0) as Tax,
				CAST(ISNULL(do.UsingMealPlan, 0) as int) as UsingMealPlan,
				CAST(ISNULL(do.UsingMealEqual, 0) as int) as UsingMealEqual,
				CAST(ISNULL(do.UsingBonus, 0) as int) as UsingBonus,
				CAST(ISNULL(do.isEmployeeTaxable, 1) as int) as EmployeeTax,
				CAST(ISNULL(do.isGuestTaxable, 1) as int) as GuestTaxable,
				CAST(ISNULL(do.isStudCashTaxable, 1) as int) as CashStudent,
				CAST(ISNULL(do.isStudentFreeTaxable, 1) as int) as StudentFreeTax,
				CAST(ISNULL(do.isStudentPaidTaxable, 1) as int) as StudentPaidTax,
				CAST(ISNULL(do.isStudentRedTaxable, 1) as int) as StudentRedTax,
				CAST(ISNULL(do.isMealPlanTaxable, 1) as int) as StudentMealTax
			FROM Orders o
				LEFT OUTER JOIN Transactions t ON t.ClientID = o.ClientID AND t.Order_Id = o.id and t.OrderType = 0
				LEFT OUTER JOIN Schools sc ON sc.ClientID = o.ClientID AND sc.id = o.School_Id
				LEFT OUTER JOIN DistrictOptions do ON do.ClientID = sc.ClientID AND do.District_id = sc.District_Id
				LEFT OUTER JOIN Customers c ON c.ClientID = o.ClientID AND c.id = o.Customer_Id
			WHERE (o.isVoid = 0) AND (o.ClientID = @ClientID AND o.Customer_Id = @CUSTID) AND
				(o.OrderDate >= @RDRSTARTDATE AND o.OrderDate <= @RDRENDDATE)
			UNION ALL
			SELECT t.id, pre.Id as Order_Id, ISNULL(t.OrderType,1) as OrderType, 0.0 as ADebit, 0.0 as MDebit, pre.LunchType,
				ISNULL(c.isStudent, 0) as Student,
				0.0 as Tax,	-- No Tax on Preorders
				CAST(ISNULL(do.UsingMealPlan, 0) as int) as UsingMealPlan,
				CAST(ISNULL(do.UsingMealEqual, 0) as int) as UsingMealEqual,
				CAST(ISNULL(do.UsingBonus, 0) as int) as UsingBonus,
				CAST(ISNULL(do.isEmployeeTaxable, 1) as int) as EmployeeTax,
				CAST(ISNULL(do.isGuestTaxable, 1) as int) as GuestTaxable,
				CAST(ISNULL(do.isStudCashTaxable, 1) as int) as CashStudent,
				CAST(ISNULL(do.isStudentFreeTaxable, 1) as int) as StudentFreeTax,
				CAST(ISNULL(do.isStudentPaidTaxable, 1) as int) as StudentPaidTax,
				CAST(ISNULL(do.isStudentRedTaxable, 1) as int) as StudentRedTax,
				CAST(ISNULL(do.isMealPlanTaxable, 1) as int) as StudentMealTax
			FROM PreOrders pre
				LEFT OUTER JOIN Transactions t ON t.ClientID = pre.ClientID AND t.Order_Id = pre.Id and t.OrderType = 1
				LEFT OUTER JOIN Customers c ON c.ClientID = pre.ClientID AND c.id = pre.Customer_Id
				LEFT OUTER JOIN DistrictOptions do ON do.ClientID = c.ClientID AND do.District_id = c.District_Id
			WHERE (pre.isVoid = 0) AND (pre.ClientID = @ClientID AND pre.Customer_Id = @CUSTID) AND
				(pre.PurchasedDate >= @RDRSTARTDATE AND pre.PurchasedDate <= @RDRENDDATE)
			ORDER BY t.id
		END
		ELSE BEGIN
			SET @CUSTORDCUR = CURSOR FOR 
			SELECT t.id, o.Id as Order_Id, ISNULL(t.OrderType,0) as OrderType, o.ADebit, o.MDebit, o.LunchType,
				ISNULL(c.isStudent, 0) as Student,
				ISNULL(dbo.TAXPERCENTAGE(@ClientID, o.id), 0.0) as Tax,
				CAST(ISNULL(do.UsingMealPlan, 0) as int) as UsingMealPlan,
				CAST(ISNULL(do.UsingMealEqual, 0) as int) as UsingMealEqual,
				CAST(ISNULL(do.UsingBonus, 0) as int) as UsingBonus,
				CAST(ISNULL(do.isEmployeeTaxable, 1) as int) as EmployeeTax,
				CAST(ISNULL(do.isGuestTaxable, 1) as int) as GuestTaxable,
				CAST(ISNULL(do.isStudCashTaxable, 1) as int) as CashStudent,
				CAST(ISNULL(do.isStudentFreeTaxable, 1) as int) as StudentFreeTax,
				CAST(ISNULL(do.isStudentPaidTaxable, 1) as int) as StudentPaidTax,
				CAST(ISNULL(do.isStudentRedTaxable, 1) as int) as StudentRedTax,
				CAST(ISNULL(do.isMealPlanTaxable, 1) as int) as StudentMealTax
			FROM Orders o
				LEFT OUTER JOIN Transactions t ON t.ClientID = o.ClientID AND t.Order_Id = o.id and t.OrderType = 0
				LEFT OUTER JOIN Schools sc ON sc.ClientID = o.ClientID AND sc.Id = o.School_Id
				LEFT OUTER JOIN DistrictOptions do ON do.ClientID = sc.ClientID AND do.District_id = sc.District_Id
				LEFT OUTER JOIN Customers c ON c.ClientID = o.ClientID AND c.id = o.Customer_Id 
			WHERE (o.isVoid = 0) AND (o.Customer_Id = @CUSTID)
			UNION ALL
			SELECT t.id, pre.Id as Order_Id, ISNULL(t.OrderType,1) as OrderType, 0.0 as ADebit, 0.0 as MDebit, pre.LunchType,
				ISNULL(c.isStudent, 0) as Student,
				0.0 as Tax,	-- No Tax on Preorders
				CAST(ISNULL(do.UsingMealPlan, 0) as int) as UsingMealPlan,
				CAST(ISNULL(do.UsingMealEqual, 0) as int) as UsingMealEqual,
				CAST(ISNULL(do.UsingBonus, 0) as int) as UsingBonus,
				CAST(ISNULL(do.isEmployeeTaxable, 1) as int) as EmployeeTax,
				CAST(ISNULL(do.isGuestTaxable, 1) as int) as GuestTaxable,
				CAST(ISNULL(do.isStudCashTaxable, 1) as int) as CashStudent,
				CAST(ISNULL(do.isStudentFreeTaxable, 1) as int) as StudentFreeTax,
				CAST(ISNULL(do.isStudentPaidTaxable, 1) as int) as StudentPaidTax,
				CAST(ISNULL(do.isStudentRedTaxable, 1) as int) as StudentRedTax,
				CAST(ISNULL(do.isMealPlanTaxable, 1) as int) as StudentMealTax
			FROM PreOrders pre
				LEFT OUTER JOIN Transactions t ON t.ClientID = pre.ClientID AND t.Order_Id = pre.Id and t.OrderType = 1
				LEFT OUTER JOIN Customers c ON c.ClientID = pre.ClientID AND c.id = pre.Customer_Id
				LEFT OUTER JOIN DistrictOptions do ON do.ClientID = c.ClientID AND do.District_id = c.District_Id
			WHERE (pre.isVoid = 0) AND (pre.ClientID = @ClientID AND pre.Customer_Id = @CUSTID)
			ORDER BY t.id
		END

		IF (@@ERROR <> 0)
			RAISERROR('Failed to Gather Order information for Customer ID: %d', 11, 2, @CUSTID)

		OPEN @CUSTORDCUR
		FETCH NEXT FROM @CUSTORDCUR
			INTO @PROCID, @ORDID, @ORDTYPE, --@PRIORBBAL, 
					@ADEBIT, @MDEBIT, @ORDLUNCHTYPE, @STUDENT, @TAXRATE, @USINGMEALPLAN, @USINGMEALEQUIV, @USINGBONUS, 
					@EMPTAX, @GUESTTAX, @STUDCASHTAX, @FREETAX, @PAIDTAX, @REDTAX, @MEALTAX

		--PRINT 'LOOP THROUGH CUSTOMERS ORDERS'
		WHILE (@@FETCH_STATUS = 0) BEGIN
			IF (@ORDTYPE < 0 AND @ORDTYPE > 1)
				RAISERROR('Invalid Order Type: %d', 11, 3, @ORDTYPE)

			SET @TMPASUBTOTAL = 0.0
			SET @TMPATAXABLESALES = 0.0
			SET @TMPMSUBTOTAL = 0.0
			SET @TMPMTAXABLESALES = 0.0
			SET @TMPITEMTOTAL = 0.0
			SET @SALESTAXTOTAL = 0.0
			SET @NEWACREDIT = 0.0
			SET @NEWMCREDIT = 0.0
			SET @NEWBCREDIT = 0.0

			-- Load Items for this Order/PreOrder
			IF (@ORDTYPE = 0) BEGIN
				SET @ORDITEMSCUR = CURSOR FOR
					SELECT it.id, it.Qty, it.isVoid, it.FullPrice, it.PaidPrice, it.TaxPrice, it.SoldType, it.PreOrderItem_Id,
						ISNULL(m.StudentFullPrice, it.FullPrice) as StudentFullPrice,
						ISNULL(m.StudentRedPrice, it.FullPrice) as StudentRedPrice,
						ISNULL(m.EmployeePrice, it.FullPrice) as EmployeePrice,
						ISNULL(m.GuestPrice, it.FullPrice) as GuestPrice,
						ISNULL(m.isTaxable, CASE WHEN (it.TaxPrice > 0.0) THEN 1 ELSE 0 END) as isTaxable,
						ISNULL(ct.isMealPlan, 0) as isMealPlan,
						ISNULL(ct.isMealEquiv, 0) as isMealEquiv,
						ISNULL(ct.canFree, 0) as canFree,
						ISNULL(ct.canReduce, 0) as canReduce
					FROM Items it 
						LEFT OUTER JOIN menu m ON m.ClientID = it.ClientID AND m.id = it.Menu_Id
						LEFT OUTER JOIN category cat ON cat.ClientID = m.ClientID AND cat.id = m.Category_Id
						LEFT OUTER JOIN categorytypes ct ON ct.ClientID = cat.ClientID AND ct.id = CategoryType_Id
					WHERE (it.isVoid = 0) AND (it.ClientID = @ClientID AND it.Order_id = @ORDID) 
					ORDER BY ct.isMealEquiv, it.id
			END
			ELSE IF (@ORDTYPE = 1) BEGIN
				SET @ORDITEMSCUR = CURSOR FOR
						SELECT ti.id, ti.Qty, ti.isVoid, ti.FullPrice, ti.PaidPrice, ti.TaxPrice, ti.SoldType, NULL,
							ISNULL(m.StudentFullPrice, ti.FullPrice) as StudentFullPrice,
							ISNULL(m.StudentRedPrice, ti.FullPrice) as StudentRedPrice,
							ISNULL(m.EmployeePrice, ti.FullPrice) as EmployeePrice,
							ISNULL(m.GuestPrice, ti.FullPrice) as GuestPrice,
							ISNULL(m.isTaxable, CASE WHEN (ti.TaxPrice > 0.0) THEN 1 ELSE 0 END) as isTaxable,
							ISNULL(ct.isMealPlan, 0) as isMealPlan,
							ISNULL(ct.isMealEquiv, 0) as isMealEquiv,
							ISNULL(ct.canFree, 0) as canFree,
							ISNULL(ct.canReduce, 0) as canReduce
						FROM PreOrderItems ti
							LEFT OUTER JOIN menu m ON m.ClientID = ti.ClientID AND m.id = ti.Menu_Id
							LEFT OUTER JOIN category cat ON cat.ClientID = m.ClientID AND cat.id = m.Category_Id
							LEFT OUTER JOIN categorytypes ct ON ct.ClientID = cat.ClientID AND ct.id = CategoryType_Id
						WHERE (ti.isVoid = 0) AND (ti.ClientID = @clientID AND ti.PreOrder_id = @ORDID) 
						ORDER BY ct.isMealEquiv, ti.id
			END

			OPEN @ORDITEMSCUR
			FETCH NEXT FROM @ORDITEMSCUR
				INTO @ITEMID, @QTY, @ITEMVOID, @FULLPRICE, @PAIDPRICE, @TAXPRICE, @SOLDTYPE, @PREORDITEMID, @STUDFULLPRICE, @STUDREDPRICE, 
					@EMPPRICE, @GUESTPRICE, @TAXABLEITEM, @MEALPLANITEM, @MEALEQUIVITEM, @CANFREE, @CANREDUCE

			--PRINT 'LOOP THROUGH ITEMS FOR ORDER ID ' + CAST(@ORDID AS VARCHAR)
			WHILE (@@FETCH_STATUS = 0) BEGIN
				IF (@ITEMVOID = 0) BEGIN
					--PRINT 'ITEM ID: ' + CAST(@ITEMID AS VARCHAR) + ' NOT VOID'
					SET @NEWTAXPRICE = 0.0
					SET @NEWFULLPRICE = @GUESTPRICE
					SET @NEWPAIDPRICE = @GUESTPRICE
					SET @NEGATEVALUE = 0

					SET @NEWFULLPRICE = ROUND( 
						CASE 
							WHEN (@MEALEQUIVITEM = 1) THEN @FULLPRICE
							WHEN (@CUSTID = -2) THEN @GUESTPRICE
							WHEN (@CUSTID = -3) THEN @STUDFULLPRICE
							WHEN (@STUDENT = 1 AND (@ORDLUNCHTYPE = 3 OR @ORDLUNCHTYPE = 2 OR @ORDLUNCHTYPE = 1 OR @ORDLUNCHTYPE = 5)) THEN @STUDFULLPRICE
							WHEN (@STUDENT = 0) THEN @EMPPRICE
							ELSE @GUESTPRICE
						END
						,2)

					SET @NEWPAIDPRICE = ROUND( 
						CASE
							WHEN (@ORDTYPE = 0 AND @PREORDITEMID IS NOT NULL AND @SOLDTYPE = 20) THEN 0.0
							WHEN (@MEALEQUIVITEM = 1 AND @ORDLUNCHTYPE = 5 AND @STUDENT = 1 AND @NONQUALIFIEDTOTAL > @STUDFULLPRICE) THEN -(@STUDFULLPRICE) 
							WHEN (@MEALEQUIVITEM = 1 AND @ORDLUNCHTYPE = 5 AND @STUDENT = 0 AND @NONQUALIFIEDTOTAL > @EMPPRICE) THEN -(@EMPPRICE)
							WHEN (@MEALEQUIVITEM = 1 AND @ORDLUNCHTYPE = 5) THEN -(@NONQUALIFIEDTOTAL)
							WHEN (@MEALEQUIVITEM = 1) THEN @PAIDPRICE
							WHEN (@CUSTID = -2) THEN @GUESTPRICE
							WHEN (@CUSTID = -3) THEN @STUDFULLPRICE	
							WHEN (@STUDENT = 1 AND @ORDLUNCHTYPE = 3 AND (@CANFREE = 1 OR @CANREDUCE = 1)) THEN 0.0
							WHEN (@STUDENT = 1 AND @ORDLUNCHTYPE = 3 AND (@CANFREE = 0 AND @CANREDUCE = 0)) THEN @STUDFULLPRICE						
							WHEN (@STUDENT = 1 AND @ORDLUNCHTYPE = 2 AND (@CANFREE = 1 OR @CANREDUCE = 1)) THEN @STUDREDPRICE
							WHEN (@STUDENT = 1 AND @ORDLUNCHTYPE = 2 AND (@CANFREE = 0 AND @CANREDUCE = 0)) THEN @STUDFULLPRICE	
							WHEN (@STUDENT = 1 AND @ORDLUNCHTYPE = 1) THEN @STUDFULLPRICE
							WHEN (@ORDLUNCHTYPE = 5 AND @SOLDTYPE = 30) THEN 0.0
							ELSE @GUESTPRICE
						END
						,2)

					SET @TAXRATE = 
						CASE
							WHEN (@ORDLUNCHTYPE = 1) THEN @TAXRATE * @PAIDTAX
							WHEN (@ORDLUNCHTYPE = 2) THEN @TAXRATE * @REDTAX
							WHEN (@ORDLUNCHTYPE = 3) THEN @TAXRATE * @FREETAX
							WHEN (@ORDLUNCHTYPE = 5) THEN @TAXRATE * @MEALTAX
							WHEN (@CUSTID = -2) THEN @TAXRATE * @GUESTTAX
							WHEN (@CUSTID = -3) THEN @TAXRATE * @STUDCASHTAX
							WHEN (@STUDENT = 0) THEN @TAXRATE * @EMPTAX
							ELSE 0.0
						END

					SET @NEGATEVALUE =
						CASE
							WHEN (@ORDLUNCHTYPE = 5 AND @SOLDTYPE = 30) THEN 1
							WHEN (@ORDLUNCHTYPE = 5 AND @MEALEQUIVITEM = 1) THEN 1
							ELSE 0
						END
					
					IF (@NEWFULLPRICE = 0.0) BEGIN
						--PRINT 'FULL PRICE IS 0.00'
						SET @NEWFULLPRICE = 0.0001
					END

					IF (@CANFREE = 1 OR @CANREDUCE = 1 OR @NEGATEVALUE = 1) BEGIN
						--PRINT 'NEGATE FULL PRICE'
						SET @NEWFULLPRICE = -(@NEWFULLPRICE)
					END
					ELSE BEGIN
						SET @NONQUALIFIEDTOTAL = @NONQUALIFIEDTOTAL + @NEWPAIDPRICE 
					END

				

					-- Update Order Totals.
					SET @TMPITEMTOTAL = @NEWPAIDPRICE * @QTY

					--PRINT 'TEMP ITEM TOTAL: ' + CAST(@TMPITEMTOTAL as varchar)
					IF (@TAXRATE > 0.0 AND @TAXABLEITEM = 1) BEGIN
						SET @NEWTAXPRICE = @TMPITEMTOTAL * @TAXRATE
					END
					ELSE BEGIN
						SET @NEWTAXPRICE = 0.0
					END

					IF (@NEWFULLPRICE >= 0.0) BEGIN
						--PRINT 'ALACARTE ITEM ADD TO ASUBTOTAL - ASUBTOTAL: ' + CAST(@TMPASUBTOTAL as varchar) + ', ITEMTOTAL: ' + CAST(@TMPITEMTOTAL as varchar)
						SET @TMPASUBTOTAL = @TMPASUBTOTAL + @TMPITEMTOTAL
						IF (@TAXRATE > 0.0 AND @TAXABLEITEM = 1) BEGIN
							SET @TMPATAXABLESALES = @TMPATAXABLESALES + @TMPITEMTOTAL
						END
					END
					ELSE BEGIN
						--PRINT 'MEAL ITEM'
						IF (@ORDLUNCHTYPE <> 5) BEGIN
							--PRINT 'QUALIFIED ITEM - MSUBTOTAL: ' + CAST(@TMPMSUBTOTAL as varchar) + ', ITEMTOTAL: ' + CAST(@TMPITEMTOTAL as varchar)
							SET @TMPMSUBTOTAL = @TMPMSUBTOTAL + @TMPITEMTOTAL
							IF (@TAXRATE > 0.0 AND @TAXABLEITEM = 1) BEGIN
								SET @TMPMTAXABLESALES = @TMPMTAXABLESALES + @TMPITEMTOTAL
							END
						END
					END 

					-- Update the Item in Database
					IF (@ORDTYPE = 0) BEGIN
						--PRINT 'UPDATING ITEM IN DB - FULLPRICE: ' + CAST(@NEWFULLPRICE as VARCHAR) + ', PAIDPRICE: ' + CAST(@NEWPAIDPRICE as VARCHAR)
						UPDATE Items SET 
							FullPrice = @NEWFULLPRICE, 
							PaidPrice = @NEWPAIDPRICE, 
							TaxPrice = @NEWTAXPRICE
						WHERE (ClientID = @ClientID AND Id = @ITEMID)
						IF (@@ERROR <> 0)
							RAISERROR('Failed to Update the Prices for Item ID: %d', 11, 4, @ITEMID)
					END
					ELSE IF (@ORDTYPE = 1) BEGIN
						--PRINT 'UPDATING ITEM IN DB - FULLPRICE: ' + CAST(@NEWFULLPRICE as VARCHAR) + ', PAIDPRICE: ' + CAST(@NEWPAIDPRICE as VARCHAR)
						UPDATE PreOrderItems SET 
							FullPrice = @NEWFULLPRICE, 
							PaidPrice = @NEWPAIDPRICE, 
							TaxPrice = @NEWTAXPRICE
						WHERE (ClientID = @ClientID AND Id = @ITEMID)
						IF (@@ERROR <> 0)
							RAISERROR('Failed to Update the Prices for PreOrder Item ID: %d', 11, 4, @ITEMID)
					END

				END -- IF Item not voided

				FETCH NEXT FROM @ORDITEMSCUR
				INTO @ITEMID, @QTY, @ITEMVOID, @FULLPRICE, @PAIDPRICE, @TAXPRICE, @SOLDTYPE, @PREORDITEMID, @STUDFULLPRICE, @STUDREDPRICE, 
				@EMPPRICE, @GUESTPRICE, @TAXABLEITEM, @MEALPLANITEM, @MEALEQUIVITEM, @CANFREE, @CANREDUCE
			END -- END ITEM LOOP

			CLOSE @ORDITEMSCUR
			DEALLOCATE @ORDITEMSCUR

			IF (@ORDTYPE = 0) BEGIN
				-- Calculate the Sales Tax on the Order
				SET @ORDTAXCUR = CURSOR FOR
					SELECT st.TaxEntity_Id, st.TaxEntityName, st.Order_Id, st.TaxRate, st.SalesTax
					FROM SalesTax st
					WHERE (st.ClientID = @ClientID AND st.Order_Id = @ORDID)
					ORDER BY st.TaxEntity_Id
				IF (@@ERROR <> 0)
					RAISERROR('Failed to gather tax information for Order ID: %d', 11, 5, @ORDID)

				OPEN @ORDTAXCUR
				FETCH NEXT FROM @ORDTAXCUR
					INTO @TAXENTID, @TAXENTNAME, @TAXORDID, @SALESTAXRATE, @SALESTAX

				--PRINT 'LOOPING THROUGH TAX FOR ORDER ID ' + CAST(@ORDID AS VARCHAR)
				WHILE (@@FETCH_STATUS = 0) BEGIN
					SET @SALESTAX = ROUND(CEILING((ROUND(((@TMPATAXABLESALES + @TMPMTAXABLESALES) * @SALESTAXRATE), 7) * 100.0)) / 100.0, 2)

					-- Update the New Sales Tax
					--PRINT 'UPDATE SALESTAX ID: ' + CAST(@TAXENTID AS VARCHAR) + ' FOR ORDER ID: ' + CAST(@ORDID AS VARCHAR) + ', SALESTAX: ' + CAST(@SALESTAX as varchar)
					UPDATE SALESTAX SET SALESTAX = @SALESTAX
					WHERE ClientID = @ClientID AND ORDER_ID = @ORDID AND TAXENTITY_ID = @TAXENTID
					IF (@@ERROR <> 0)
						RAISERROR('Failed to Update Sales Tax ID: %d for Order ID: %d', 11, 6, @TAXENTID, @ORDID)

					SET @SALESTAXTOTAL = @SALESTAXTOTAL + @SALESTAX

					FETCH NEXT FROM @ORDTAXCUR
						INTO @TAXENTID, @TAXENTNAME, @TAXORDID, @SALESTAXRATE, @SALESTAX	
				END -- END TAX LOOP

				CLOSE @ORDTAXCUR
				DEALLOCATE @ORDTAXCUR
			END -- ONLY tS Orders

			-- Calculate the Order Information
			IF (@TMPMSUBTOTAL = 0.0) BEGIN
				--PRINT 'NO MEAL IN THIS ORDER'
				SET @NEWACREDIT = @TMPASUBTOTAL + @SALESTAXTOTAL
				SET @NEWMCREDIT = 0.0
				--PRINT 'NEWACREDIT: ' + CAST(@NEWACREDIT as varchar) + ', NEWMCREDIT: ' + CAST(@NEWMCREDIT as varchar)
			END
			ELSE BEGIN
				--PRINT 'MEAL IN THIS ORDER'	
				SET @TMPATAXTOTAL = ROUND(CEILING((ROUND((@TMPATAXABLESALES * @TAXRATE), 7) * 100.0)) / 100.0, 2)
				SET @NEWACREDIT = @TMPASUBTOTAL + @TMPATAXTOTAL
				SET @NEWMCREDIT = @TMPMSUBTOTAL + (@SALESTAXTOTAL - @TMPATAXTOTAL)
				--PRINT 'NEWACREDIT: ' + CAST(@NEWACREDIT as varchar) + ', NEWMCREDIT: ' + CAST(@NEWMCREDIT as varchar)
			END

			IF (@USINGBONUS = 1) BEGIN
				--PRINT 'USING BONUS PULL OUT BONUS FOR ALACARTE ITEMS'
				IF (@PRIORBBAL >= @NEWACREDIT) BEGIN
					SET @NEWBCREDIT = @NEWACREDIT
					SET @NEWACREDIT = 0.0
				END
				ELSE IF ((@PRIORBBAL < @NEWACREDIT) AND (@PRIORBBAL > 0.0)) BEGIN
					SET @NEWBCREDIT = @PRIORBBAL
					SET @NEWACREDIT = @NEWACREDIT - @PRIORBBAL
				END
				ELSE BEGIN
					SET @NEWBCREDIT = 0.0
				END
			END
			ELSE BEGIN
				SET @NEWBCREDIT = 0.0
			END

			IF (@ALLTOALA = 1) BEGIN
				SET @ADEBIT = @ADEBIT + @MDEBIT
				SET @MDEBIT = 0.0
			END

			-- Update the Order / PreOrder
			IF (@ORDTYPE = 0) BEGIN
				--PRINT 'UPDATING ORDER ID: ' + CAST(@ORDID AS VARCHAR) + ', ACREDIT: ' + CAST(@NEWACREDIT as varchar) + ', MCREDIT: ' + CAST(@NEWMCREDIT as varchar) + ', BCREDIT: ' + CAST(@NEWBCREDIT as varchar)
				UPDATE Orders SET ACredit = @NEWACREDIT, MCredit = @NEWMCREDIT, BCredit = @NEWBCREDIT, ADebit = @ADEBIT, MDebit = @MDEBIT
				WHERE ClientID = @ClientID AND Id = @ORDID
				IF (@@ERROR <> 0)
					RAISERROR('Failed to Update Order ID: %d', 11, 7, @ORDID)
			END
			ELSE IF (@ORDTYPE = 1) BEGIN
				--PRINT 'UPDATING ORDER ID: ' + CAST(@ORDID AS VARCHAR) + ', ACREDIT: ' + CAST(@NEWACREDIT as varchar) + ', MCREDIT: ' + CAST(@NEWMCREDIT as varchar) + ', BCREDIT: ' + CAST(@NEWBCREDIT as varchar)
				UPDATE PreOrders SET ACredit = @NEWACREDIT, MCredit = @NEWMCREDIT, BCredit = @NEWBCREDIT
				WHERE ClientID = @ClientID AND Id = @ORDID
				IF (@@ERROR <> 0)
					RAISERROR('Failed to update PreOrder ID: %d', 11, 7, @ORDID)
			END

			FETCH NEXT FROM @CUSTORDCUR
				INTO @PROCID, @ORDID, @ORDTYPE, --@PRIORBBAL, 
						@ADEBIT, @MDEBIT, @ORDLUNCHTYPE, @STUDENT, @TAXRATE, @USINGMEALPLAN, @USINGMEALEQUIV, @USINGBONUS, @EMPTAX,
						@GUESTTAX, @STUDCASHTAX, @FREETAX, @PAIDTAX, @REDTAX, @MEALTAX	
		END

		CLOSE @CUSTORDCUR
		DEALLOCATE @CUSTORDCUR

		COMMIT TRAN
		SELECT 0 As Result, '' as ErrorMessage
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		IF (CURSOR_STATUS('variable', '@CUSTORDCUR') >= 0) BEGIN
			CLOSE @CUSTORDCUR
			DEALLOCATE @CUSTORDCUR
		END
		IF (CURSOR_STATUS('variable', '@ORDITEMSCUR') >= 0) BEGIN
			CLOSE @ORDITEMSCUR
			DEALLOCATE @ORDITEMSCUR
		END
		IF (CURSOR_STATUS('variable', '@ORDTAXCUR') >= 0) BEGIN
			CLOSE @ORDTAXCUR
			DEALLOCATE @ORDTAXCUR
		END

		SELECT ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
	END CATCH
END
GO
