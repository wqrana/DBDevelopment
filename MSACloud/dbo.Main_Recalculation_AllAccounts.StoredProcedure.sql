USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_Recalculation_AllAccounts]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Main_Recalculation_AllAccounts]
(
	@ClientID bigint,
	@SuccessCount int OUTPUT,
	@FailedCount int OUTPUT
)
AS
BEGIN	
	SET NOCOUNT ON;
DECLARE 
	@ID int,
	@UsingBonus bit,
	@Result int,
	@ERRORMSG varchar(1024)
	
	SET @ID = 0
	SET @UsingBonus = 0
	SET @Result = 0
	SET @SuccessCount = 0
	SET @FailedCount = 0	

	DECLARE MyCustomers CURSOR FOR
		SELECT 
			c.Id, 
			do.UsingBonus 
		FROM Customers c
			LEFT OUTER JOIN DistrictOptions do on do.District_Id = c.District_Id
		WHERE c.ClientID = @ClientID and c.isActive = 1 AND c.Id > 0
	
	OPEN MyCustomers
	
	FETCH NEXT FROM MyCustomers INTO @ID, @UsingBonus
	WHILE (@@FETCH_STATUS = 0) BEGIN		
		-- Recalculate the Account
		EXEC @Result = dbo.Main_Recalculation_Process @ClientID, @ID, @UsingBonus, 0, @ERRORMSG OUTPUT
	
		IF (@Result = 0) BEGIN
			SET @SuccessCount = @SuccessCount + 1
			--PRINT 'Customer ID: ' + CAST(@ID as varchar) + ' Recalculated Successful.'
		END
		ELSE BEGIN
			SET @FailedCount = @FailedCount + 1
			EXEC @Result = dbo.Main_Error_Log @Result, 'Main_Recalculation_Process', @ERRORMSG
			--PRINT 'Customer ID: ' + CAST(@ID as varchar) + ' Recalculation Failed.'
		END
		
		--PRINT 'Customer ID: ' + CAST(@ID as varchar) + ', Result: ' + CAST(@Result as varchar)
		FETCH NEXT FROM MyCustomers INTO @ID, @UsingBonus
	END
	
	CLOSE MyCustomers
	DEALLOCATE MyCustomers
	
	--PRINT 'Successful: ' + CAST(@SuccessCount as varchar) + ', Failed: ' + CAST(@FailedCount as varchar) + ', Total: ' + CAST(@SuccessCount + @FailedCount as varchar)
	--SELECT @SuccessCount as Successful, @FailedCount as Failed, (@SuccessCount + @FailedCount) as Loaded
END
GO
