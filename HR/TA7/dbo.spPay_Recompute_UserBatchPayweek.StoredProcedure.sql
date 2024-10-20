USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Recompute_UserBatchPayweek]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[spPay_Recompute_UserBatchPayweek]    Script Date: 6/26/2017 5:56:53 PM ******/

-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Recomputes an existing User Batch PayWeek (Payroll Period)
-- Description:	Checks that the batch exists and is not closed.
--				If the batch is not closed, then it recomputes with current data.
--		@USERID int						--User to import transactions
--		@PAYWEEKNUM  int,				--PayWeek To import
--		@SUPERVISORID int,				--Supevisor calling sp
--		@SUPERVISORNAME nvarchar(50),	--Supevisor calling sp
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Recompute_UserBatchPayweek]
	-- Add the parameters for the stored procedure here
		@USERID int,
		@PAYWEEKNUM  int,
		@SUPERVISORID int,
		@SUPERVISORNAME nvarchar(50)
-- WITH ENCRYPTION
AS

BEGIN
	--Variables
	DECLARE @BATCHID nvarchar(50)
	DECLARE @USERBATCHSTATUS int
	DECLARE @BATCHSTATUS int
	DECLARE @RETURN int
	Set @RETURN = 0

	SELECT @BATCHID = strBatchID, @USERBATCHSTATUS = intUserBatchStatus  FROM [dbo].[tblUserBatch] where intUserID = @USERID and intPayWeekNum = @PAYWEEKNUM
	SELECT @BATCHSTATUS = intBatchStatus  FROM [dbo].[tblBatch] where strBatchID = @BATCHID

	--The batch exists and it is not status = -1 (Paid and Closed)
	if NOT  @BATCHID IS NULL AND @BATCHSTATUS >= 0
	BEGIN TRY
		BEGIN TRANSACTION
	
	EXECUTE @RETURN = [dbo].[spPay_Compute_UserBatch] 
		@BATCHID
		,@USERID
		,@SUPERVISORID
		,@SUPERVISORNAME

		COMMIT
		SET @RETURN = 1
	END TRY
	BEGIN CATCH
		ROLLBACK ;
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 
		   SET @RETURN = 0
	END CATCH

	RETURN @RETURN
END

GO
