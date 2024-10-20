USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[SaveCashResult]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[SaveCashResult] 
	@ClientID bigint,
	@POS_ID int = -3,
	@EMP_CASHIER_ID int = -2,
	@OPENDATE datetime,
	@FINISHED bit = 0,
	@OPENBLOB image = NULL,
	@CASHDRAWER_ID int = 1,
	@CLOSEDATE datetime = NULL,
	@TOTALCASH float = 0.0,
	@OVERSHORT float = 0.0,
	@ADDITIONAL float = 0.0,
	@PAIDOUTS float = 0.0,
	@OPENAMOUNT float = 0.0,
	@CLOSEAMOUNT float = 0.0,
	@SALES float = 0.0,
	@CLOSEBLOB image = NULL,
	@LOCALDB bit = 0,
	@ID int = 0
AS 
DECLARE 
	@CASHRESID int,
	@UPDATECR bit
BEGIN 
	DECLARE 
		@OPENDATELOCAL datetime,
		@OPENDATEUTC datetime,
		@CLOSEDATELOCAL datetime,
		@CLOSEDATEUTC datetime

	BEGIN TRY
		SET @CASHRESID = 0
		SET @UPDATECR = 0

		IF (@ClientID <= 0)
			RAISERROR('Invalid Client ID %d',11,1,@ClientID)
			
		IF (@ID = 0 OR @ID < -1) RAISERROR('Invalid CashResult ID %d passed.',11,1,@ID)
		-- Get Cash Result Index
		--IF (@ID = 0 OR @ID = -1) BEGIN
		--	EXECUTE dbo.GETNEXTINDEX @ClientID, 28, 1, @CASHRESID OUTPUT, @LOCALDB
		--	IF (@@error <> 0 OR @CASHRESID = 0)
		--		RAISERROR('Failed to get a Cash Result ID', 11, 1)
		--END
		--ELSE BEGIN
		--	SET @CASHRESID = @ID
		--END
		IF (@ID = -1) SET @UPDATECR = 0 ELSE SET @UPDATECR = 1
		/*
		IF (@ID > 0)
			SELECT @UPDATECR = CAST(COUNT(Id) as bit) FROM CashResults WHERE ClientID = @ClientID and Id = @CASHRESID
		ELSE
			SET @UPDATECR = 0
		*/
		-- Convert Open and Close Dates
		IF (@OPENDATE IS NOT NULL) BEGIN
			SET @OPENDATELOCAL = @OPENDATE
			SET @OPENDATEUTC = GETUTCDATE()
		END
		ELSE BEGIN
			SET @OPENDATELOCAL = NULL
			SET @OPENDATEUTC = NULL
		END

		IF (@CLOSEDATE IS NOT NULL) BEGIN
			SET @CLOSEDATELOCAL = @CLOSEDATE
			SET @CLOSEDATEUTC = GETUTCDATE()
		END
		ELSE BEGIN
			SET @CLOSEDATELOCAL = NULL
			SET @CLOSEDATEUTC = NULL
		END

		BEGIN TRAN
		BEGIN TRY
			IF (@UPDATECR = 1) BEGIN
				UPDATE CashResults SET
					POS_Id = @POS_ID,
					Emp_Cashier_Id = @EMP_CASHIER_ID,
					CloseDate = @CLOSEDATEUTC,
					TotalCash = @TOTALCASH,
					OverShort = @OVERSHORT,
					Additional = @ADDITIONAL,
					PaidOuts = @PAIDOUTS,
					OpenAmount = @OPENAMOUNT,
					CloseAmount = @CLOSEAMOUNT,
					Sales = @SALES,
					Finished = @FINISHED,
					OpenBlob = @OPENBLOB,
					CloseBlob = @CLOSEBLOB,
					CashDrawer_Id = @CASHDRAWER_ID,
					OpenDateLocal = @OPENDATELOCAL,
					CloseDateLocal = @CLOSEDATELOCAL
				WHERE ClientID = @ClientID	
					and Id = @ID

				IF (@@error <> 0)
					RAISERROR('Failed to Update Cash Result ID: %d.', 11, 2, @ID)

				SET @CASHRESID = @ID
			END
			ELSE BEGIN
				-- Insert Cash Result
				INSERT INTO CashResults (ClientID, POS_Id, Emp_Cashier_Id, OpenDate, CloseDate, TotalCash, OverShort, 
											Additional, PaidOuts, OpenAmount, CloseAmount, Sales, Finished,
											OpenBlob, CloseBlob, CashDrawer_Id, OpenDateLocal, CloseDateLocal)
					VALUES (@ClientID, @POS_ID, @EMP_CASHIER_ID, @OPENDATEUTC, @CLOSEDATEUTC, @TOTALCASH, @OVERSHORT,
								@ADDITIONAL, @PAIDOUTS, @OPENAMOUNT, @CLOSEAMOUNT, @SALES, @FINISHED, 
								@OPENBLOB, @CLOSEBLOB, @CASHDRAWER_ID, @OPENDATELOCAL, @CLOSEDATELOCAL)

				IF (@@error <> 0)
					RAISERROR('Failed to Insert Cash Result.', 11, 2)

				SELECT @CASHRESID = SCOPE_IDENTITY()
			END			

			COMMIT TRAN
			SELECT @CASHRESID as CashResultID, 0 as Result, '' as ErrorMessage
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
			SELECT 0 as CashResultID, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
		END CATCH
	END TRY
	BEGIN CATCH
		SELECT 0 as CashResultID, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
	END CATCH
END
GO
