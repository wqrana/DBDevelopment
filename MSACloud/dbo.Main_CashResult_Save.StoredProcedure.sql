USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_CashResult_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[Main_CashResult_Save] 
	@ClientID bigint,
	@POS_ID int = -3,
	@EMP_CASHIER_ID int = -2,
	@OPENDATE datetime2(7),
	@OpenLocalTime datetime2(7),	-- Local Time with offset
	@FINISHED bit = 0,
	@OPENBLOB image = NULL,
	@CASHDRAWER_ID int = 1,
	@CLOSEDATE datetime2(7) = NULL,
	@CloseLocalTime datetime2(7) = NULL,		-- Local time with offset
	@TOTALCASH float = 0.0,
	@OVERSHORT float = 0.0,
	@ADDITIONAL float = 0.0,
	@PAIDOUTS float = 0.0,
	@OPENAMOUNT float = 0.0,
	@CLOSEAMOUNT float = 0.0,
	@SALES float = 0.0,
	@CLOSEBLOB image = NULL,
	@LOCALDB bit = 0,
	@ID int = 0 OUTPUT,
	@Result int = 0 OUTPUT,
	@ErrorMessage nvarchar(4000) = N'' OUTPUT
AS 
DECLARE 
	@CASHRESID int
BEGIN
SET XACT_ABORT ON;
	SET NOCOUNT ON;
	BEGIN TRY
		SET @CASHRESID = 0

		IF (@ClientID <= 0)
			RAISERROR('Invalid Client ID %d', 11, 1, @ClientID)
			
		-- Get Cash Result Index
		/*
		IF (@ID = 0 OR @ID = -1) BEGIN
			EXECUTE dbo.Main_IndexGenerator_GetIndex @ClientID, 28, 1, @CASHRESID OUTPUT, @LOCALDB
			IF (@@error <> 0 OR @CASHRESID = 0)
				RAISERROR('Failed to get a Cash Result ID', 11, 1)
		END
		ELSE BEGIN
			SET @CASHRESID = @ID
		END
		*/
		
		--insert into tempTable (msg) values (CONCAT( @ClientID, ' , ', @CASHRESID, ' , ', @POS_ID , ' , ', @EMP_CASHIER_ID))
		BEGIN TRY
		BEGIN TRAN
		--Munawar Changed Cashresultid to auto and removed from sp-23-12-2015
			INSERT INTO CashResults (ClientID,  POS_Id, Emp_Cashier_Id, OpenDate, CloseDate, TotalCash, OverShort, 
										Additional, PaidOuts, OpenAmount, CloseAmount, Sales, Finished,
										OpenBlob, CloseBlob, CashDrawer_Id, OpenDateLocal, CloseDateLocal)
				VALUES (@ClientID,  @POS_ID, @EMP_CASHIER_ID, @OPENDATE, @CLOSEDATE, @TOTALCASH, @OVERSHORT,
							@ADDITIONAL, @PAIDOUTS, @OPENAMOUNT, @CLOSEAMOUNT, @SALES, @FINISHED, 
							@OPENBLOB, @CLOSEBLOB, @CASHDRAWER_ID, @OpenLocalTime, @CloseLocalTime)
			IF (@@error <> 0)
				RAISERROR('Failed to Insert Cash Result ID: %d', 11, 2, @CASHRESID)

			SELECT @CASHRESID = SCOPE_IDENTITY()

			COMMIT TRAN
			SET @ID = @CASHRESID
			SET @Result = 0
			SET @ErrorMessage = N''
		END TRY
		BEGIN CATCH
			
			SET @ID = 0
			SET @Result = ERROR_STATE()
			SET @ErrorMessage = ERROR_MESSAGE()
			ROLLBACK TRAN
			
		END CATCH
	END TRY
	BEGIN CATCH
	
		SET @ID = 0
		SET @Result = ERROR_STATE()
		SET @ErrorMessage = ERROR_MESSAGE()
	END CATCH
END
GO
