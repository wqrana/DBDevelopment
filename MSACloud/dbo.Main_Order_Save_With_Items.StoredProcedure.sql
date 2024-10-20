USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_Order_Save_With_Items]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Main_Order_Save_With_Items]
	@ClientID bigint, 	
	@POS_ID int,
	@EMP_CASH_ID int,
	@CUST_ID int,
	@TRANSTYPE int,
	@MDEBIT float,
	@ADEBIT float,
	@MCREDIT float,
	@ACREDIT float,
	@BCREDIT float,
	@LocalTime datetime2(7),			-- Local Time with offset
	@ResultCode int OUTPUT,
	@ErrorMsg nvarchar(4000) OUTPUT,
	@LUNCHTYPE int = -1,
	@SCHOOL_ID int = -1,
	@ORDERDATE datetime = NULL,
	@CREDITAUTH int = NULL,
	@CHECKNUM int = NULL,
	@OVERRIDE bit = 0,
	@VOID bit = 0,
	@OrderItemsValues [dbo].[OrderItemsList] READONLY
AS
BEGIN

DECLARE @ORDID int; -- Pass -1 for new
DECLARE @ORDLOG_ID int; -- Pass -1 for new, Pass NULL for no log
DECLARE	@ABalance float;
DECLARE	@MBalance float;
DECLARE	@BonusBalance float;
DECLARE @MEALPLANID int;
DECLARE @CASHRESID int;
DECLARE @ORDLOGNOTE varchar(255);

SET @ORDID = -1;
SET @ORDLOG_ID = NULL;
SET @MEALPLANID = -1;
SET @CASHRESID = NULL;
SET @ORDLOGNOTE = NULL;

	BEGIN TRY
	BEGIN TRAN
		EXEC Main_Order_Save @ClientID,
		@ORDID OUTPUT,
		@POS_ID,
		@EMP_CASH_ID,
		@CUST_ID,
		@TRANSTYPE,
		@MDEBIT,
		@ADEBIT,
		@MCREDIT,
		@ACREDIT,
		@BCREDIT,
		@LocalTime,
		@ORDLOG_ID OUTPUT,
		@ABalance OUTPUT,
		@MBalance OUTPUT,
		@BonusBalance OUTPUT,
		@ResultCode OUTPUT,
		@ErrorMsg OUTPUT,
		@MEALPLANID,
		@CASHRESID,
		@LUNCHTYPE,
		@SCHOOL_ID,
		@ORDERDATE,
		@CREDITAUTH,
		@CHECKNUM,
		@OVERRIDE,
		@VOID,
		@ORDLOGNOTE

		IF (@ResultCode <> 0 OR @ErrorMsg <> N'' OR @ORDID = 0)
		BEGIN
			SET @ErrorMsg = 'Insert Order Failed with Error: ' + @ErrorMsg
			RAISERROR(@ErrorMsg, 11, @ResultCode)
		END
		ELSE
		BEGIN
			INSERT INTO ITEMS (ClientID, Order_Id, Menu_Id, Qty, FullPrice, PaidPrice, TaxPrice, isVoid, SoldType, PreOrderItem_Id, LastUpdatedUTC)
			SELECT [ClientID],
					@ORDID,
					[Menu_Id],
					[Qty], 
					[FullPrice], 
					[PaidPrice], 
					[TaxPrice], 
					[isVoid], 
					[SoldType], 
					[PreOrderItem_Id],
					GETUTCDATE()
					FROM @OrderItemsValues
		END
	COMMIT TRAN
	SET @ResultCode = 0;
	SET @ErrorMsg = N''
	SELECT @ORDID AS OrderId, @ABalance AS ABalance, @MBalance AS MBalance, @BonusBalance AS BonusBalance
	END TRY
	BEGIN CATCH
		SET @ResultCode = ERROR_STATE()
		SET @ErrorMsg = ERROR_MESSAGE()
		ROLLBACK TRAN
	END CATCH
END
GO
