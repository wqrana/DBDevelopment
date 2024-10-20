USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[INSVENDMACHINEORDER]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[INSVENDMACHINEORDER]
	@ClientID bigint,
	@NEXTORDID int,
	@SCHOOLID int, 
	@CUSTID int, 
	@LUNCHTYPE int, 
	@COST float, 
	@PRIORABAL float, 
	@PRIORMBAL float, 
	@TRANSTYPE int, 
	@NEXTITEMID int, 
	@MENUID int, 
	@NEWBALANCE float, 
	@TRANSNAME varchar(25), 
	@MACHINEID int, 
	@MACHINENAME varchar(50), 
	@VENDSELECT varchar(8), 
	@VENDDATE datetime = '1/1/1900 00:00:00' 
AS 
DECLARE  
	@STATUS int, 
	@MYDATE datetime,
	@ORDLOGID int,
	@ABAL float,
	@MBAL float,
	@BBAL float,
	@SaveOrderResult int,
	@SaveOrderErrMsg nvarchar(4000)
BEGIN 
	SET @ORDLOGID = -1 
	SET @ABAL = 0.0
	SET @MBAL = 0.0
	SET @BBAL = 0.0
	SET @SaveOrderResult = 0

	IF (@VENDDATE = '1/1/1900 00:00:00' OR @VENDDATE IS NULL) SET @VENDDATE = GETDATE() 
 
	IF (@NEXTITEMID <> -1) RAISERROR('Invalid Item ID (%d) provided.', 11, 1, @NEXTITEMID)

	BEGIN TRANSACTION @TRANSNAME 
	BEGIN TRY

		EXECUTE dbo.Main_Order_Save @ClientID, @NEXTORDID OUTPUT, -98, -98, @CUSTID, @TRANSTYPE, 0.0, 0.0, 0.0, @COST, 0.0, @VENDDATE, @ORDLOGID OUTPUT, @ABAL OUTPUT, @MBAL OUTPUT, @BBAL OUTPUT, @SaveOrderResult OUTPUT, @SaveOrderErrMsg OUTPUT, DEFAULT, DEFAULT, DEFAULT, @SCHOOLID, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT
		IF (@@ERROR <> 0 OR @SaveOrderResult <> 0) 
			RAISERROR ('Failed to Save Vending Order: %s', 11, 2, @SaveOrderErrMsg)
 
		INSERT INTO Items (Order_Id, Menu_Id, Qty, FullPrice, PaidPrice, TaxPrice, isVoid, SoldType)  
			Values (@NEXTORDID, @MENUID, 1, @COST, @COST, 0.0, 0, 20)  
		IF (@@error <> 0) RAISERROR('Failed to Save Vending Items', 11, 3)

		SELECT @NEXTITEMID = SCOPE_IDENTITY()
 
		INSERT INTO VendingSales (VendingMachine_Id, MachineName, Item_Id, VendSelection, VendingPrice) 
			Values (@MACHINEID, @MACHINENAME, @NEXTITEMID, @VENDSELECT, @COST) 
		IF (@@error <> 0) RAISERROR('Failed to save to vending sales.', 11, 4)
 
		COMMIT TRANSACTION @TRANSNAME 
		RETURN 0
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION @TRANSNAME
		RETURN ERROR_STATE()
	END CATCH
	
END
GO
