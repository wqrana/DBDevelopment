USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_CustomerLog_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Main_CustomerLog_Save]
	@ClientID bigint, 
	@CustomerLogID int output,	-- Pass -1 for new record.
	@CustomerID int,
	@EmployeeID int,
	@LocalTime datetime2(7),
	@CustLogMsg varchar(255),
	@Result int output,
	@ErrorMessage varchar(4000) = '' output
AS
BEGIN
	-- Add Log
	BEGIN TRY
		IF ((@CustomerLogID = 0) OR (@ClientID <= 0))
			RAISERROR('Invalid Customer Log ID or Client ID passed.',11,1)

		IF (@CustomerLogID = -1) BEGIN
			EXEC dbo.GETNEXTINDEX @ClientID, 21, 1, @CustomerLogID output

			IF ((@@ERROR <> 0) OR (@CustomerLogID <= 0))
				RAISERROR('Failed to get Customer Log ID', 11, 2)
		END

		INSERT INTO CustomerLog (ClientID, Customer_Id, Emp_Changed_Id, ChangedDate, Notes, ChangedDateLocal) 
			VALUES				
				(@ClientID, @CustomerID, @EmployeeID, GETUTCDATE(), @CustLogMsg, @LocalTime)
		SELECT @CustomerLogID = SCOPE_IDENTITY();

		IF (@@ERROR <> 0)
			RAISERROR('Failed to Save Log to Customer', 11, 3)

		SET @Result = 0
		SET @ErrorMessage = ''
	END TRY
	BEGIN CATCH
		SET @Result = CASE ERROR_STATE() WHEN 0 THEN ERROR_NUMBER() ELSE ERROR_STATE() END
		SET @ErrorMessage = ERROR_MESSAGE()
	END CATCH
END
GO
