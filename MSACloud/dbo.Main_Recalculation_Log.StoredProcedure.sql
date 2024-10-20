USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_Recalculation_Log]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Main_Recalculation_Log]
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@CustomerID bigint,
	@PREVABAL float,
	@PREVMBAL float,
	@PREVBBAL float,
	@ABAL float,
	@MBAL float,
	@BBAL float,
	@NOTES varchar(1024) = ''
AS
BEGIN
	BEGIN TRY		
		-- Archive Account Info
		INSERT INTO RecalculationLog (ClientID, ArchiveDate, Customer_Id, PrevABal, PrevMBal, PrevBBal, NewABal, NewMBal, NewBBal, Notes)
			VALUES (@ClientID, GETDATE(), @CustomerID, ROUND(@PREVABAL,2), ROUND(@PREVMBAL,2), ROUND(@PREVBBAL,2), ROUND(@ABAL,2), ROUND(@MBAL,2), ROUND(@BBAL,2), @NOTES)	
		IF (@@ERROR <> 0) BEGIN 
			--PRINT 'ERROR: Inserting Recalculation Log' 
			RETURN 2 
		END
		
		--PRINT 'Recalculation Logged Successful'
		RETURN 0
	END TRY
	BEGIN CATCH
		RETURN -1
	END CATCH
END
GO
