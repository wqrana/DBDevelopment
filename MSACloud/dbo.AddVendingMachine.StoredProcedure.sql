USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[AddVendingMachine]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[AddVendingMachine]
	@ClientID bigint,
	@MACHINENAME varchar(50),
	@MACHINEID int,
	@SERIALNO varchar(16),
	@VERSION varchar(6)
AS
DECLARE
	@VENDMACHID int,
	@NEXTMACHINEID int
BEGIN
	SET @VENDMACHID = 0
	SET @NEXTMACHINEID = -1

	/* Cloud DB does not use Index Generator *
	EXECUTE GETNEXTINDEX @ClientID, 62, 1, @VENDMACHID OUTPUT
	IF (@@error <> 0 OR @VENDMACHID <= 0) BEGIN
		ROLLBACK TRAN
		RETURN 1
	END
	*/

	BEGIN TRAN	

	--IF (@MACHINEID = -1) BEGIN
	--	SELECT @NEXTMACHINEID = MAX(MachineID) + 1 FROM VendingMachines WHERE ClientID = @ClientID
	--	SET @MACHINEID = @NEXTMACHINEID
	--END

	IF (@MACHINEID = -1) BEGIN
		ROLLBACK TRAN
		RETURN 2
	END

	INSERT INTO VendingMachines	(ClientID, MachineName, MachineID, isDeleted, School_Id, SerialNumber, Version) 
		VALUES (@ClientID, @MACHINENAME, @MACHINEID, 0, NULL, @SERIALNO, @VERSION)
	IF (@@error <> 0) BEGIN
		ROLLBACK TRAN
		RETURN 3
	END

	COMMIT TRAN
	RETURN 0
END
GO
