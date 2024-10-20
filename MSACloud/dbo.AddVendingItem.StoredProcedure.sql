USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[AddVendingItem]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddVendingItem]
	@ClientID bigint,
	@MACHINEID int,
	@SELECT varchar(8),
	@PRICE float
AS
DECLARE
	@NEWMENUID int,
	@NEWCATID int,
	@NEWCATTYPEID int,
	@SERIALNO varchar(16),
	@MACHNAME varchar(50),
	@MACHID int,
	@CATID int,
	@CATTYPEID int
BEGIN
	SET @NEWMENUID = 0
	SET @NEWCATID = 0
	SET @NEWCATTYPEID = 0
	SET @MACHID = 0
	SET @CATID = 0
	SET @CATTYPEID = 0

	BEGIN TRAN

		-- Get vending machine information
		SELECT 
			@MACHNAME = MachineName, 
			@SERIALNO = SerialNumber, 
			@MACHID = MachineID 
		FROM VendingMachines 
		WHERE 
			ClientID = @ClientID and 
			Id = @MACHINEID

		-- Find Category ID
		SELECT 
			@CATID = Id 
		FROM Category 
		WHERE 
			ClientID = @ClientID and 
			Name = SUBSTRING(@MACHNAME, 1, 20)

		-- If Category does not exist
		IF (@CATID IS NULL OR @CATID <= 0) BEGIN
			/* Cloud DB does not use Index Generator *
			EXEC Main_IndexGenerator_GetIndex @ClientID, 23, 1, @NEWCATID output, 0
			IF (@@error <> 0 OR @NEWCATID <= 0) BEGIN
				ROLLBACK TRAN
				RETURN 1
			END	

			SET @CATID = @NEWCATID
			*/

			-- Find Category Type 'Vending'
			SELECT @CATTYPEID = Id FROM CategoryTypes WHERE ClientID = @ClientID and Name like 'Vending'

			-- If Category Type is missing
			IF (@CATTYPEID IS NULL OR @CATTYPEID <= 0) BEGIN
				/* Cloud DB does not use Index Generator *
				EXEC Main_IndexGenerator_GetIndex @ClientID, 22, 1, @NEWCATTYPEID output, 0
				IF (@@error <> 0 OR @NEWCATTYPEID <= 0) BEGIN
					ROLLBACK TRAN
					RETURN 2
				END		

				SET @CATTYPEID = @NEWCATTYPEID
				*/
				INSERT INTO CategoryTypes (ClientID, [Name], canFree, canReduce, isDeleted, isMealPlan, isMealEquiv)
					VALUES (@ClientID, 'Vending', 0, 0, 0, 0, 0)
				IF (@@error <> 0) BEGIN
					ROLLBACK TRAN
					RETURN 3
				END

				SELECT @CATTYPEID = SCOPE_IDENTITY()
			END

			INSERT INTO Category (ClientID, CategoryType_Id, [Name], isActive, isDeleted, Color, AccountNumber)
				VALUES (@ClientID, @CATTYPEID, SUBSTRING(@MACHNAME, 1, 20), 1, 0, 33023, NULL)	-- Color set to orange (No Reason)
			IF (@@error <> 0) BEGIN
				ROLLBACK TRAN
				RETURN 4
			END

			SELECT @CATID = SCOPE_IDENTITY()
		END

		/* Cloud DB does not use Index Generator *
		EXEC Main_IndexGenerator_GetIndex @ClientID, 24, 1, @NEWMENUID output, 0
		IF (@@error <> 0 OR @NEWMENUID <= 0) BEGIN
			ROLLBACK TRAN
			RETURN 5
		END	
		*/

		INSERT INTO Menu (ClientID, Id, Category_Id, ItemName, M_F6_Code, StudentFullPrice, StudentRedPrice, EmployeePrice, GuestPrice, isTaxable, isDeleted, isScaleItem,
				ItemType, isOnceDay, KitchenItem, MealEquivItem, UPC, PreOrderDesc, ButtonCaption, LastUpdate) 
			VALUES (@ClientID, @NEWMENUID, @CATID, (@MACHNAME + ' - ' + @SELECT), NULL, @PRICE, @PRICE, @PRICE, @PRICE, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, SUBSTRING((@MACHNAME + ' - ' + @SELECT), 1, 30), NULL)
		IF (@@error <> 0) BEGIN
			ROLLBACK TRAN
			RETURN 6
		END

		SELECT @NEWMENUID = SCOPE_IDENTITY()

		INSERT INTO VendingMachineItems (ClientID, VendingMachine_Id, Menu_Id, Vend_Selection)
			VALUES (@ClientID, @MACHINEID, @NEWMENUID, @SELECT)
		IF (@@error <> 0) BEGIN
			ROLLBACK TRAN
			RETURN 7
		END

	COMMIT TRAN
	RETURN 0
END
GO
