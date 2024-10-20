USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Payment_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Neil Heverly
-- Create date: 05/09/2014
-- Description:	Stored Procedure to create an admin payment
-- =============================================
/*
	Revisions
	03/14/2016 - NAH - Removed references to Index Generator
*/
-- =============================================
CREATE PROCEDURE [dbo].[Admin_Payment_Save]
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@CASHRESID int OUTPUT,				-- Pass id for update, pass -1 for new
	@ORDID int OUTPUT,					-- Pass id for update, pass -1 for new
	@ORDLOGID int OUTPUT,				-- Pass id for add on note, pass -1 for new, pass NULL for no comment
	@CASHIERID int,
	@CustomerID int,
	@AlaCartePayment float,
	@MealPlanPayment float,
	@TransType int,	
	@LocalTime datetime2(7),			-- Local Time with Offset		
	@Result int OUTPUT,
	@ErrorMsg nvarchar(4000) OUTPUT,
	@ABalance float OUTPUT,
	@MBalance float OUTPUT,
	@BonusBalance float OUTPUT,
	@CheckNum int = NULL,				-- NULL -> Not Check, otherwise Check number
	@ORDERDATE datetime = NULL,			-- NULL uses default, otherwise uses provided
	@OPENDATE datetime = NULL,			-- NULL uses default, otherwise uses provided
	@OpenDateLocal datetime2(7) = NULL,
	@OPENAMOUNT float = NULL,	-- NULL used default, otherwise uses provided
	@CLOSEDATE datetime = NULL,			-- NULL uses default, otherwise uses provided
	@CloseDateLocal datetime2(7) = NULL,
	@CLOSEAMOUNT float = NULL,	-- NULL uses default, otherwise uses provided
	@PaymentNote varchar(255) = NULL	-- NULL or '' -> no note, otherwise use provided
AS
BEGIN 
	DECLARE 
		@POSID int,
		@Now datetime,
		@FINISHED bit,
		@TOTALCASH float,
		@CR_Result int,
		@CR_ErrorMsg nvarchar(4000),
		@O_Result int,
		@O_ErrorMsg nvarchar(4000)

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRY 
		IF (@ClientID <= 0) RAISERROR('Invalid Client ID: %d', 11, 1, @ClientID)
		IF (@ORDID = 0) RAISERROR('Invalid Order ID: %d', 11, 1, @ORDID)
		IF (@ORDLOGID = 0) RAISERROR('Invalid Orders Log ID: %d', 11, 1, @ORDLOGID)
		IF (@CASHRESID = 0) RAISERROR('Invalid Cash Result ID: %d', 11, 1, @CASHRESID)
		IF (@CASHIERID = 0 OR (@CASHIERID < 0 AND @CASHIERID <> -2)) RAISERROR('Invalid Cashier ID: %d', 11, 1, @CASHIERID)
		IF (@CustomerID = 0 OR (@CustomerID < 0 AND @CustomerID <> -3 AND @CustomerID <> -2)) RAISERROR('Invalid Customer ID: %d', 11, 1, @CustomerID)

		SET @POSID = -3	--Admin POS
		SET @Now = GETUTCDATE()
		SET @FINISHED = 1
		SET @TOTALCASH = CASE WHEN SUBSTRING(CAST(@TransType as varchar),2,1) = '5' THEN 0.0 ELSE @AlaCartePayment + @MealPlanPayment END
		SET @CR_Result = 0
		SET @CR_ErrorMsg = N''

		IF (@ORDERDATE IS NULL) SET @ORDERDATE = @Now							-- Default is now
		IF (@OPENDATE IS NULL) SET @OPENDATE = DATEADD(second,-1,@Now)			-- Subtract one second
		IF (@OPENAMOUNT IS NULL) SET @OPENAMOUNT = 0.0							-- Default to zero
		IF (@CLOSEDATE IS NULL) SET @CLOSEDATE = DATEADD(second,1,@Now)			-- Add one second
		IF (@CLOSEAMOUNT IS NULL) SET @CLOSEAMOUNT = @OPENAMOUNT + @TOTALCASH	-- Default Openamount + TotalCash

		--PRINT 'BEFORE IDS'
		/*
		IF (@CASHRESID = -1) BEGIN
			EXEC dbo.Main_IndexGenerator_GetIndex @ClientID, 28, 1, @CASHRESID OUTPUT
			IF (@@ERROR <> 0 OR @CASHRESID <= 0) 
			RAISERROR('Failed to get CashResult ID for this transaction.', 11, 2)
		END

		IF (@ORDID = -1) BEGIN
			EXEC dbo.Main_IndexGenerator_GetIndex @ClientID, 2, 1, @ORDID OUTPUT
			IF (@@ERROR <> 0 OR @ORDID <= 0) 
			
			RAISERROR('Failed to get Order ID for this transaction.', 11, 2)
		END

		IF (@ORDLOGID = -1) BEGIN
			EXEC dbo.Main_IndexGenerator_GetIndex @ClientID, 21, 1, @ORDLOGID OUTPUT
			IF (@@ERROR <> 0 OR @ORDLOGID <= 0) 
			
			RAISERROR('Failed to get Orders Log ID for this transaction.', 11, 2)
		END
		*/

		--PRINT 'BEFORE TRANS'
		
		BEGIN TRY 
		BEGIN TRAN 
			-- Call Insert CashResult
			EXEC dbo.Main_CashResult_Save @ClientID, @POSID, @CASHIERID, @OPENDATE, @OpenDateLocal, 1, NULL, 1, @CLOSEDATE, @CloseDateLocal, @TOTALCASH, 0.0,
											0.0, 0.0, @OPENAMOUNT, @CLOSEAMOUNT, 0.0, NULL, 0, @CASHRESID OUTPUT, @CR_Result OUTPUT, @CR_ErrorMsg OUTPUT
			IF (@CR_Result <> 0 OR @CASHRESID = 0) 
			RAISERROR('Save CashResult failed at step %d.  Reason: %s', 11, 3, @CR_Result, @CR_ErrorMsg)

			--PRINT 'AFTER CASH RESULT'
			-- Call Save Order
			 EXEC dbo.Main_Order_Save @ClientID, @ORDID OUTPUT, @POSID, @CASHIERID, @CustomerID, @Transtype, @MealPlanPayment, @AlaCartePayment, 
										0.0, 0.0, 0.0, @LocalTime,
										@ORDLOGID OUTPUT, @ABalance OUTPUT, @MBalance OUTPUT, @BonusBalance OUTPUT, 
										@O_Result OUTPUT, @O_ErrorMsg OUTPUT,
										DEFAULT, @CASHRESID, DEFAULT, DEFAULT, @ORDERDATE, DEFAULT, @CheckNum, DEFAULT, DEFAULT,
										@PaymentNote 
			IF (@O_Result <> 0 OR @ORDID = 0 OR @ORDLOGID = 0) 
			RAISERROR('Save Order failed at step %d.  Reason: %s', 11, 4, @O_Result, @O_ErrorMsg)
			
			--PRINT 'AFTER ORDER'
			COMMIT TRAN
			SET @Result = 0
			SET @ErrorMsg = N''
		END TRY
		BEGIN CATCH
		
			--PRINT 'INNER CATCH'
			
			SET @Result = ERROR_STATE()
			SET @ErrorMsg = ERROR_MESSAGE()
			ROLLBACK TRAN
		END CATCH
	END TRY
	BEGIN CATCH
	
		--PRINT 'OUTER CATCH'
		SET @Result = ERROR_STATE()
		SET @ErrorMsg = ERROR_MESSAGE()
	END CATCH
END
GO
