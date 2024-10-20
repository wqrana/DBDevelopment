USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[INSCASHRESULT]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[INSCASHRESULT] 
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
	@CASHRESID int
BEGIN
	DECLARE 
		@OPENDATELOCAL datetime,
		@OPENDATEUTC datetime,
		@CLOSEDATELOCAL datetime,
		@CLOSEDATEUTC datetime
	BEGIN TRY
		SET @CASHRESID = 0

		IF (@ClientID <= 0)
			RAISERROR('Invalid Client ID %d', 11, 1, @ClientID)

		IF (@ID = 0) RAISERROR ('Invalid CashResult ID %d passed.', 11, 1, @ID)
			
		-- Get Cash Result Index
		--IF (@ID = 0 OR @ID = -1) BEGIN
		--	EXECUTE dbo.GETNEXTINDEX 44, 28, 1, @CASHRESID OUTPUT, @LOCALDB
		--	IF (@@error <> 0 OR @CASHRESID = 0)
		--		RAISERROR('Failed to get a Cash Result ID', 11, 1)
		--END
		--ELSE BEGIN
			--SET @CASHRESID = @ID
		--END

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
