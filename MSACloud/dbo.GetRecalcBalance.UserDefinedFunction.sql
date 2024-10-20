USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[GetRecalcBalance]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetRecalcBalance] 
(
	@ClientID bigint,
	@FCUSTID int, 
	@FUSEBONUS BIT = 0, 
	@BalanceWanted int = 0, 
	@EndDate datetime
)
/*
-- Balance Wanted --
0 - Total Balance
1 - AlaCarte Balance
2 - Meal Balance
3 - Bonus Balance
*/
RETURNS float
AS
BEGIN
	-- Declare the return variable here
	DECLARE @CUSTORDCUR CURSOR,
            @LASTORDERDATE datetime,
            @CURRORDERDATE datetime,
            @BONUSPMTS float,
            @MBALANCE float,
            @ABALANCE float,
            @BBALANCE float,
            @MDEBIT float,
            @MCREDIT float,
            @ADEBIT float,
            @ACREDIT float,
            @BCREDIT float,
			@APPLIEDADEBIT float,
			@TMPMAPPLIED float,
			@TMPAAPPLIED float,
            @TRANSTYPE int,
			@ID int,
            @ORDID int,
			@ORDERTYPE int,
            @LUNCHTYPE int,
            @ADJUSTMENT bit,
            @ISVOID bit,
            @ACCTINFOEXIST int,
            @FERRORCODE int,
			@NewABal float,
			@NewMBal float,
			@NewBBal float
   
	SET @FERRORCODE = 0
	SET @NEWABAL = 0.0
	SET @NEWMBAL = 0.0
	SET @NEWBBAL = 0.0

	--IF (@EndDate IS NULL) BEGIN
	--	SET @EndDate = GETDATE()		
	--END

    SET @CUSTORDCUR = CURSOR FOR
	/*
      SELECT ID, LUNCHTYPE, MDEBIT, MCREDIT, ADEBIT, ACREDIT, BCREDIT, ORDERDATE, ISVOID, TRANSTYPE
		FROM Orders
        WHERE Customer_Id = @FCUSTID AND (Orderdate <= @EndDate)
		ORDER BY ID
	*/
		SELECT
			t.Id as TRANSID,
			t.Order_Id,
			t.OrderType,
			o.LunchType,
			o.MDebit,
			o.MCredit,
			o.ADebit,
			o.ACredit,
			o.BCredit,
			o.OrderDate as TRANSDATE,
			o.isVoid,
			o.TransType
		FROM Orders o
			LEFT OUTER JOIN Transactions t ON (t.Order_Id = o.Id and t.OrderType = 0 AND t.ClientID = o.ClientID)
		--FROM Transactions t
			--LEFT OUTER JOIN Orders o ON o.id = t.Order_Id and t.OrderType = 0
		WHERE o.ClientID = @ClientID AND o.Customer_Id = @FCUSTID and o.OrderDate <= @EndDate
		UNION ALL
		SELECT
			t.Id,
			t.Order_Id,
			t.OrderType,
			pre.LunchType,
			0.0 as MDebit,
			pre.MCredit,
			0.0 as ADebit,
			pre.ACredit,
			pre.BCredit,
			pre.TransferDate as TRANSDATE,
			pre.isVoid,
			pre.Transtype
		FROM PreOrders pre
			LEFT OUTER JOIN Transactions t ON (t.Order_Id = pre.Id and t.OrderType = 1 and t.ClientID = pre.ClientID)
		--FROM Transactions t
			--LEFT OUTER JOIN PreOrders pre ON pre.Id = t.Order_Id and t.OrderType = 1
		WHERE pre.ClientID = @ClientID AND pre.Customer_Id = @FCUSTID and pre.PurchasedDate <= @EndDate		
		ORDER BY TRANSDATE
      IF (@@error <> 0) BEGIN
         SET @FERRORCODE = 1
         GOTO PROBLEM
      END

	  SET @APPLIEDADEBIT = 0.0
      SET @MBALANCE = 0.0
      SET @ABALANCE = 0.0
      SET @BBALANCE = 0.0

      OPEN @CUSTORDCUR
      FETCH NEXT FROM @CUSTORDCUR
         INTO @ID, @ORDID, @ORDERTYPE, @LUNCHTYPE, @MDEBIT, @MCREDIT, @ADEBIT, @ACREDIT, @BCREDIT, @CURRORDERDATE, @ISVOID, @TRANSTYPE

      WHILE (@@FETCH_STATUS = 0) BEGIN
         SET @ADJUSTMENT = 0
		 SET @APPLIEDADEBIT = 0.0
		 SET @TMPMAPPLIED = 0.0
		 SET @TMPAAPPLIED = 0.0

         IF (@FUSEBONUS = 1) BEGIN
			SET @BONUSPMTS = 0
            IF (@LASTORDERDATE IS NOT NULL) BEGIN
               SELECT @BONUSPMTS = Bonus FROM BONUSPMTSASSIGNED(@ClientID, @FCUSTID, @LASTORDERDATE, @CURRORDERDATE)
            END
            ELSE BEGIN
               SET @LASTORDERDATE = '1/1/1900 00:00:00'
               SELECT @BONUSPMTS = Bonus FROM BONUSPMTSASSIGNED(@ClientID, @FCUSTID, @LASTORDERDATE, @CURRORDERDATE)
            END
               SET @BBALANCE = @BBALANCE + @BONUSPMTS
         END

         IF (@ISVOID = 1) BEGIN
            IF (@TRANSTYPE = 1500) BEGIN
               SET @ADJUSTMENT = 1
            END
         END

         IF (@ISVOID = 0 OR @ADJUSTMENT = 1) BEGIN
            
			IF (@MDEBIT <> 0.0) BEGIN
               SET @MBALANCE = @MBALANCE + @MDEBIT
            END

            IF (@ADEBIT <> 0.0) BEGIN
               IF (@ADEBIT > 0.0) BEGIN
				  IF (@ACREDIT >= @ADEBIT) BEGIN
					SET @ABALANCE = @ABALANCE + @ADEBIT
				  END
				  ELSE BEGIN
					SET @APPLIEDADEBIT = @ADEBIT - @ACREDIT
					SET @ABALANCE = @ABALANCE + @ACREDIT
					IF ((@MBALANCE - @MCREDIT) < 0.0) BEGIN
					  IF (@APPLIEDADEBIT > (-(@MBALANCE - @MCREDIT))) BEGIN
						SET @TMPMAPPLIED = -(@MBALANCE - @MCREDIT)
						SET @TMPAAPPLIED = @APPLIEDADEBIT - @TMPMAPPLIED
						SET @ABALANCE = @ABALANCE + @TMPAAPPLIED
						SET @MBALANCE = @MBALANCE + @TMPMAPPLIED
					  END
					  ELSE BEGIN
						SET @MBALANCE = @MBALANCE + @APPLIEDADEBIT
					  END
					END
					ELSE BEGIN
					  SET @ABALANCE = @ABALANCE + @APPLIEDADEBIT
					END
				  END
/*
                  IF (@MBALANCE < 0.0) BEGIN
                     IF (@ADEBIT > (-@MBALANCE)) BEGIN
                        SET @ABALANCE = @ABALANCE + (@ADEBIT + @MBALANCE)
                        SET @MBALANCE = 0.0
                     END
                     ELSE BEGIN
                        SET @MBALANCE = @MBALANCE + @ADEBIT
                     END
                  END
                  ELSE BEGIN
                     SET @ABALANCE = @ABALANCE + @ADEBIT
                  END
*/
               END
               ELSE BEGIN
                  SET @ABALANCE = @ABALANCE + @ADEBIT
               END
            END

            IF (@FUSEBONUS = 1) BEGIN
				SET @ACREDIT = @ACREDIT	+ @BCREDIT
				SET @BCREDIT = 0
			END

			IF (@ACREDIT <> 0.0) BEGIN
               IF ( (@FUSEBONUS = 1) AND (@LUNCHTYPE = 5) ) BEGIN
                  IF (@BBALANCE > 0.0) BEGIN
                     IF (@BBALANCE > @ACREDIT) BEGIN
                        SET @BBALANCE = @BBALANCE - @ACREDIT
                        SET @BCREDIT = @ACREDIT
                        SET @ACREDIT = 0.0
                     END
                     ELSE BEGIN
                        SET @BCREDIT = @BBALANCE
                        SET @BBALANCE = 0.0
                        SET @ACREDIT = @ACREDIT - @BCREDIT	
                     END
                  END
               END

               SET @ABALANCE = @ABALANCE - @ACREDIT

            END

            IF (@MCREDIT <> 0.0) BEGIN
               IF (@MCREDIT > 0.0) BEGIN
                  IF (@MBALANCE >= @MCREDIT) BEGIN
                     SET @MBALANCE = @MBALANCE - @MCREDIT
                  END
                  ELSE BEGIN
                     DECLARE @TEMPMCREDIT float
                     SET @TEMPMCREDIT = @MCREDIT
                     IF (@MBALANCE > 0.0) BEGIN
                        SET @TEMPMCREDIT = @TEMPMCREDIT - @MBALANCE
                        SET @MBALANCE = 0.0
                     END
                     IF (@ABALANCE >= @TEMPMCREDIT) BEGIN
                        SET @ABALANCE = @ABALANCE - @TEMPMCREDIT
                     END
                     ELSE BEGIN
                        IF (@ABALANCE > 0.0) BEGIN
                           SET @TEMPMCREDIT = @TEMPMCREDIT - @ABALANCE
                           SET @ABALANCE = 0.0
                        END
                        IF (@TEMPMCREDIT > 0.0) BEGIN
                           SET @MBALANCE = @MBALANCE - @TEMPMCREDIT
                        END
                     END
                  END
               END
               ELSE BEGIN
                  SET @MBALANCE = @MBALANCE - @MCREDIT
               END
            END
         END

         IF (@FUSEBONUS = 1) BEGIN
            SET @BONUSPMTS = 0.0
            SELECT @BONUSPMTS = Bonus FROM BONUSPMTSONORDER (@ClientID, @ORDID)
               SET @BBALANCE = @BBALANCE + @BONUSPMTS
         END

         SET @LASTORDERDATE = @CURRORDERDATE
         SET @BONUSPMTS = 0.0
         FETCH NEXT FROM @CUSTORDCUR
            INTO @ID, @ORDID, @ORDERTYPE, @LUNCHTYPE, @MDEBIT, @MCREDIT, @ADEBIT, @ACREDIT, @BCREDIT, @CURRORDERDATE, @ISVOID, @TRANSTYPE
      END -- END OF ORDER LOOP
      CLOSE @CUSTORDCUR
      DEALLOCATE @CUSTORDCUR

      IF (@FUSEBONUS = 1) BEGIN
         IF (@LASTORDERDATE IS NOT NULL) BEGIN
            SELECT @BONUSPMTS = Bonus FROM BONUSPMTSASSIGNED(@ClientID, @FCUSTID, @LASTORDERDATE, @EndDate)
            IF (@@error <> 0) BEGIN
               SET @FERRORCODE = 9
               GOTO PROBLEM
            END
         END

         SET @BBALANCE = @BBALANCE + @BONUSPMTS
         SET @BONUSPMTS = 0.0
         
      END
   
	SET @NewABal = ROUND(@ABALANCE,2)
	SET @NewMBal = ROUND(@MBALANCE,2)
	SET @NewBBal = ROUND(@BBALANCE,2)

   PROBLEM:
      IF (@FERRORCODE <> 0) BEGIN
		 IF (CURSOR_STATUS('variable', '@CUSTORDCUR') >= 0) BEGIN
			CLOSE @CUSTORDCUR
			DEALLOCATE @CUSTORDCUR
		 END
      END

	DECLARE @ReturnBal float

	IF (@BalanceWanted = 1) BEGIN
		SET @ReturnBal = @NewABal
	END
	ELSE IF (@BalanceWanted = 2) BEGIN
		SET @ReturnBal = @NewMBal
	END
	ELSE IF (@BalanceWanted = 3) BEGIN
		SET @ReturnBal = @NewBBal
	END
	ELSE BEGIN
		IF (@FUSEBONUS = 1) SET @ReturnBal = ROUND((@NewABal + @NewMBal + @NewBBal),2)
		ELSE SET @ReturnBal = ROUND((@NewABal + @NewMBal),2)
	END

	RETURN @ReturnBal
END
GO
