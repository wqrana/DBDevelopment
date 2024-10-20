USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[GetRecalcBalances]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetRecalcBalances] 
(
	@ClientID bigint,
	@FCUSTID int, 
	@FUSEBONUS BIT = 0, 
	@EndDate datetime
)
RETURNS @CustBalances TABLE (CustomerID int, ABalance float, MBalance float, BonusBalance float, TotalBalance float)
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
            @PROCID int,
            @ORDID int,
            @ORDTYPE int,
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

	IF (@EndDate IS NULL) BEGIN
		SET @EndDate = GETDATE()		
	END

	SET @CUSTORDCUR = CURSOR FOR
		SELECT t.Id, t.Order_Id, t.OrderType, o.LunchType, o.MDebit, o.MCredit, o.ADebit, o.ACredit, o.BCredit, o.OrderDate,
			o.isVoid, o.TransType
		FROM Orders o
			LEFT OUTER JOIN Transactions t ON (t.Order_Id = o.Id and t.OrderType = 0 AND t.ClientID = o.ClientID)
		--FROM ProcessOrder po
			--LEFT OUTER JOIN Orders o ON o.id = po.Order_Id and po.OrderType = 0
		WHERE o.ClientID = @ClientID AND o.Customer_Id = @FCUSTID AND (o.Orderdate <= @EndDate)
		UNION ALL
		SELECT t.Id, t.Order_Id, t.OrderType, pre.LunchType, 0.0 as MDebit, pre.MCredit, 0.0 as ADebit, pre.ACredit, pre.BCredit,
			pre.TransferDate, pre.isVoid, pre.Transtype
		FROM PreOrders pre
			LEFT OUTER JOIN Transactions t ON (t.Order_Id = pre.Id and t.OrderType = 1 AND t.ClientID = pre.ClientID)
		--FROM ProcessOrder po
			--LEFT OUTER JOIN PreOrders pre ON pre.Id = po.Order_Id and po.OrderType = 1
		WHERE pre.ClientID = @ClientID AND pre.Customer_Id = @FCUSTID AND (pre.TransferDate <= @EndDate)
		ORDER BY OrderDate

	IF (@@ERROR <> 0) BEGIN
		SET @FERRORCODE = 1
		GOTO PROBLEM
	END

	SET @APPLIEDADEBIT = 0.0
	SET @MBALANCE = 0.0
	SET @ABALANCE = 0.0
	SET @BBALANCE = 0.0

	OPEN @CUSTORDCUR
	FETCH NEXT FROM @CUSTORDCUR
		INTO @PROCID, @ORDID, @ORDTYPE, @LUNCHTYPE, @MDEBIT, @MCREDIT, @ADEBIT, @ACREDIT, @BCREDIT, @CURRORDERDATE, @ISVOID, @TRANSTYPE

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
			
			IF (@@ERROR <> 0) BEGIN
				SET @FERRORCODE = 2
				GOTO PROBLEM
			END
				
			SET @BBALANCE = @BBALANCE + @BONUSPMTS
		END

		IF (@ISVOID = 1) BEGIN
			IF (@TRANSTYPE = 1500) SET @ADJUSTMENT = 1
			ELSE SET @ADJUSTMENT = 0
		END
		ELSE SET @ADJUSTMENT = 0

		IF (@ISVOID = 0 OR @ADJUSTMENT = 1) BEGIN
			IF (@MDEBIT <> 0.0)
				SET @MBALANCE = @MBALANCE + @MDEBIT

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

		IF (@FUSEBONUS = 1 AND @ORDTYPE = 0) BEGIN
			SET @BONUSPMTS = 0.0
			SELECT @BONUSPMTS = Bonus FROM BONUSPMTSONORDER (@ClientID, @ORDID)
			
			IF (@@ERROR <> 0) BEGIN
				SET @FERRORCODE = 3
				GOTO PROBLEM
			END
			
			SET @BBALANCE = @BBALANCE + @BONUSPMTS
		END

		SET @LASTORDERDATE = @CURRORDERDATE
		SET @BONUSPMTS = 0.0
		FETCH NEXT FROM @CUSTORDCUR
			INTO @PROCID, @ORDID, @ORDTYPE, @LUNCHTYPE, @MDEBIT, @MCREDIT, @ADEBIT, @ACREDIT, @BCREDIT, @CURRORDERDATE, @ISVOID, @TRANSTYPE
	END -- END OF ORDER LOOP
	
	CLOSE @CUSTORDCUR
	DEALLOCATE @CUSTORDCUR

	IF (@FUSEBONUS = 1) BEGIN
		IF (@LASTORDERDATE IS NOT NULL) BEGIN
			SELECT @BONUSPMTS = Bonus FROM BONUSPMTSASSIGNED(@ClientID, @FCUSTID, @LASTORDERDATE, @EndDate)
			
			IF (@@error <> 0) BEGIN
				SET @FERRORCODE = 4
				GOTO PROBLEM
			END
		END

		SET @BBALANCE = @BBALANCE + @BONUSPMTS
		SET @BONUSPMTS = 0.0
	END

	SET @NewABal = ROUND(@ABALANCE,2)
	SET @NewMBal = ROUND(@MBALANCE,2)
	SET @NewBBal = ROUND(@BBALANCE,2)

	INSERT @CustBalances
	SELECT @FCUSTID, @NewABal, @NewMBal, @NewBBal, 
		CASE 
			WHEN @FUSEBONUS = 1 THEN (@NewABal + @NewMBal + @NewBBal)
			ELSE (@NewABal + @NewMBal)
		END
			
	PROBLEM:	
	IF (@FERRORCODE <> 0) BEGIN
		IF (CURSOR_STATUS('variable', '@CUSTORDCUR') >= 0) BEGIN
			CLOSE @CUSTORDCUR
			DEALLOCATE @CUSTORDCUR
		END
	END
		
	RETURN
END
GO
