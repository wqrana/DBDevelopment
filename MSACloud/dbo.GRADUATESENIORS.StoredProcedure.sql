USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GRADUATESENIORS]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GRADUATESENIORS] (@ClientId bigint,@CUSTID int = 0, @ALACARTE float = 0.0, @MEALPLAN float = 0.0,
	@SCHOOLID int = 0, @LUNCHTYPE int = 1, @FULLDELETE bit = 0, @CASHRESID int = NULL) 
AS
BEGIN
	DECLARE @CASHRESAMT float,
			@ABAL float,
			@MBAL float,
			@BBAL float,
			@FDATE datetime,
			@ORDERLOGID int,
			@FNOTES VARCHAR(50),
			@ORDERID int,
			@CUSTLOGID int,
			@TMPUSTR VARCHAR(40),
			@TMPPSTR VARCHAR(40),
			@TMPUSERID VARCHAR(20),
			@TMPPIN VARCHAR(20),
			@FERRORCODE int 

	SET @FERRORCODE = 0
	BEGIN TRAN 
	BEGIN TRY
		IF (@CUSTID <> 0) BEGIN
			SET @CASHRESAMT = 0.0
			SET @ORDERLOGID = 0
			SET @ORDERID = 0
			SET @CUSTLOGID = 0
			SET @FDATE = GETDATE()

			-- Load Current Balance
			SELECT @ABAL = ISNULL(ABalance,0.0), @MBAL = ISNULL(MBalance,0.0), @BBAL = ISNULL(BonusBalance,0.0)
				FROM AccountInfo WITH (UPDLOCK) WHERE Customer_Id = @CUSTID
			IF (@@error <> 0) 
				RAISERROR('Failed to Load Current Balance for Customer Id: %d', 11, 1, @CUSTID)
			--BEGIN
			--	SET @FERRORCODE = 1
			--	GOTO PROBLEM 
			--END

			IF ( (@ALACARTE + @MEALPLAN) > 0 ) BEGIN
				SET @FNOTES = 'Graduating Senior Payment: $' + CAST(ROUND((@ALACARTE + @MEALPLAN), 2) AS VARCHAR)
			END
			ELSE IF ( (@ALACARTE + @MEALPLAN) < 0 ) BEGIN
				SET @FNOTES = 'Graduating Senior Refund: $' + CAST(ROUND((@ALACARTE + @MEALPLAN), 2) AS VARCHAR)
			END
			ELSE BEGIN
				SET @FNOTES = 'Graduating Senior: No Outstanding Balance'
			END

			-- Zero out the Customers Balance if necesary
			IF (@ALACARTE <> 0 OR @MEALPLAN <> 0.0) BEGIN
				UPDATE AccountInfo SET ABalance = (@ABAL + @ALACARTE), MBalance = (@MBAL + @MEALPLAN), BonusBalance = 0.0
					WHERE Customer_Id = @CUSTID
				IF (@@error <> 0) 
					RAISERROR('Failed to Update Account Information for Customer Id: %d', 11, 2, @CUSTID)
				--BEGIN
				--	SET @FERRORCODE = 2
				--	GOTO PROBLEM
				--END

				-- Get Next Order Log Index
				EXECUTE dbo.GETNEXTINDEX @ClientId,21, 1, @ORDERLOGID OUTPUT
				IF (@@error <> 0 OR @ORDERLOGID = 0) 
					RAISERROR('Failed to get an order log id for Cusotmer Id: %d', 11, 3, @CUSTID)
				--BEGIN
				--	SET @FERRORCODE = 3
				--	GOTO PROBLEM
				--END

				-- Insert Order Log
				INSERT INTO OrdersLog (Id, Employee_Id, ChangedDate, Notes) 
					VALUES (@ORDERLOGID, -2, @FDATE, @FNOTES)
				IF (@@error <> 0) 
					RAISERROR('Failed to Insert Order Log Id: %d for Cusotmer Id: %d', 11, 3, @ORDERLOGID, @CUSTID)
				--BEGIN
				--	SET @FERRORCODE = 4
				--	GOTO PROBLEM
				--END

				-- Get Next Order Index
				EXECUTE dbo.GETNEXTINDEX @ClientId,2, 1, @ORDERID OUTPUT
				IF (@@error <> 0 OR @ORDERID = 0) 
					RAISERROR('Failed to get an order id for Cusotmer Id: %d', 11, 3, @CUSTID)
				--BEGIN
				--	SET @FERRORCODE = 5
				--	GOTO PROBLEM
				--END

				-- Insert Order
				--INSERT INTO Orders (Id, OrdersLog_Id, Emp_Cashier_Id, POS_Id, Customer_Id, LunchType, OrderDate, GDate, 
				--					isVoid, OverRide, PriorABal, PriorBBal, PriorMBal, Customer_Pr_School_Id, School_Id,
				--					TransType, ADebit, ACredit, MDebit, MCredit, BCredit)
				--	VALUES (@ORDERID, @ORDERLOGID, -2, -3, @CUSTID, @LUNCHTYPE, @FDATE, CAST(CONVERT(varchar,@FDATE,101) as datetime),
				--			0, 0, @ABAL, @BBAL, @MBAL, @SCHOOLID, @SCHOOLID,
				--			1503, @ALACARTE, 0.0, @MEALPLAN, 0.0, 0.0)
				select top 1 * from Orders

				INSERT INTO Orders (Id, OrdersLog_Id, Emp_Cashier_Id, POS_Id, Customer_Id, LunchType, OrderDate, GDate, 
									isVoid, OverRide,  Customer_Pr_School_Id, School_Id,
									TransType, ADebit, ACredit, MDebit, MCredit, BCredit)
					VALUES (@ORDERID, @ORDERLOGID, -2, -3, @CUSTID, @LUNCHTYPE, @FDATE, CAST(CONVERT(varchar,@FDATE,101) as datetime),
							0, 0,  @SCHOOLID, @SCHOOLID,
							1503, @ALACARTE, 0.0, @MEALPLAN, 0.0, 0.0)

				IF (@@error <> 0) 
					RAISERROR('Failed to Insert Order Id: %d for Cusotmer Id: %d', 11, 3, @ORDERID, @CUSTID)
				--BEGIN
				--	SET @FERRORCODE = 6
				--	GOTO PROBLEM
				--END

				-- Insert Transaction
				INSERT INTO Transactions (Order_Id, OrderType, CashRes_Id)
					VALUES (@ORDERID, 0, @CASHRESID)
				IF (@@error <> 0) 
					RAISERROR('Failed to Insert Transaction Entry for Order Id: %d for Cusotmer Id: %d', 11, 3, @ORDERID, @CUSTID)
				--BEGIN
				--	SET @FERRORCODE = 7
				--	GOTO PROBLEM
				--END
			END
			
			-- Get Next Customer Log Index
			EXECUTE dbo.GETNEXTINDEX @ClientId,20, 1, @CUSTLOGID OUTPUT
			IF (@@error <> 0 OR @CUSTLOGID = 0) 
				RAISERROR('Failed to get a customer log id for Cusotmer Id: %d', 11, 3, @CUSTID)
			--BEGIN
			--	SET @FERRORCODE = 8
			--	GOTO PROBLEM
			--END
			
			-- Insert Customer Log
			--INSERT INTO CustomerLog (Id, Customer_Id, Emp_Changed_Id, ChangedDate, Notes)
			--	VALUES (@CUSTLOGID, @CUSTID, -2, @FDATE, @FNOTES)

			INSERT INTO CustomerLog ( ClientId,Customer_Id, Emp_Changed_Id, ChangedDate, Notes)
				VALUES (@ClientId, @CUSTID, -2, @FDATE, @FNOTES)
			IF (@@error <> 0) 
				RAISERROR('Failed to Insert Customer Log Id: %d for Cusotmer Id: %d', 11, 3, @CUSTLOGID, @CUSTID)
			--BEGIN
			--	SET @FERRORCODE = 9
			--	GOTO PROBLEM
			--END

			-- Set Graduated Date
			UPDATE customers SET GradDate = CURRENT_TIMESTAMP WHERE Id = @CUSTID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Update the Graduated date for Customer ID: %d', 11, 4, @CUSTLOGID, @CUSTID)
			
			-- If Marking as Deleted.
			IF (@FULLDELETE = 1) BEGIN			
				SELECT @TMPUSERID = USERID, @TMPPIN = PIN FROM Customers WHERE Id = @CUSTID
				--SET @TMPSTR = CONVERT(VARCHAR,@FDATE,12) + REPLACE(CONVERT(VARCHAR,@FDATE,8), ':', '')
				--SET @TMPSTR = SUBSTRING(@TMPSTR,1,4) + SUBSTRING(@TMPSTR,11,2)
				SET @TMPUSTR = CONVERT(VARCHAR,@FDATE,12) + REPLACE(CONVERT(VARCHAR,@FDATE,14), ':', '')
				SET @TMPPSTR = @TMPUSTR

				-- New Graduated Userid
				IF (LEN(@TMPUSERID) <= 11) BEGIN
					SET @TMPUSTR = SUBSTRING(@TMPUSTR,1,2) + SUBSTRING(@TMPUSTR,13,3)
				END
				ELSE BEGIN
					IF (LEN(@TMPUSERID) <= 14) BEGIN
						SET @TMPUSTR = SUBSTRING(@TMPUSTR,1,2)
					END
					ELSE BEGIN
						SET @TMPUSTR = ''
					END
				END

				-- New Graduated PIN
				IF (LEN(@TMPPIN) <= 11) BEGIN
					SET @TMPPSTR = SUBSTRING(@TMPPSTR,1,2) + SUBSTRING(@TMPPSTR,13,3)
				END
				ELSE BEGIN
					IF (LEN(@TMPPIN) <= 14) BEGIN
						SET @TMPPSTR = SUBSTRING(@TMPPSTR,1,2)
					END
					ELSE BEGIN
						SET @TMPPSTR = ''
					END
				END

				UPDATE Customers SET UserID = SUBSTRING((@TMPUSTR + UserID), 1, 16), 
										PIN = SUBSTRING((@TMPPSTR + PIN), 1, 16),
										isDeleted = 1,
										Grade_Id = 0,
										Homeroom_Id = 0,
										LunchType = 1,
										MealPlan_Id = 0,
										MealsLeft = 0,
										isActive = 0
					WHERE Id = @CUSTID
				IF (@@error <> 0)
					RAISERROR('Failed to Delete Cusotmer Id: %d', 11, 5, @CUSTID)
			END
			-- Else just marking them inactive
			ELSE BEGIN
				UPDATE Customers SET isActive = 0 WHERE Id = @CUSTID
				IF (@@error <> 0)
					RAISERROR('Failed to Deactivate Cusotmer Id: %d', 11, 6, @CUSTID)
			END
			--IF (@@error <> 0) BEGIN
			--	SET @FERRORCODE = 10
			--	GOTO PROBLEM
			--END	
		END

		COMMIT TRAN
		SELECT 0 AS Result, '' as ErrorMessage

		--PROBLEM: 
		--IF (@FERRORCODE <> 0) BEGIN
		--	ROLLBACK TRAN
		--	SELECT @FERRORCODE AS Result
		--END
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
	END CATCH
END
GO
