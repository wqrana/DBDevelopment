USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Recompute_UserBatch]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
CREATE PROCEDURE [dbo].[spPay_Recompute_UserBatch]
	-- Add the parameters for the stored procedure here
		@BATCHID nvarchar(50),
		@USERID  int,
		@SUPERVISORID int,
		@SUPERVISORNAME nvarchar(50)
-- WITH ENCRYPTION
AS

BEGIN
	--Variables
	DECLARE @BATCHID2 nvarchar(50)
	DECLARE @USERBATCHSTATUS int
	DECLARE @BATCHSTATUS int
	DECLARE @PAYDATE date
	DECLARE @RETURN int
	Set @RETURN = 0


	SELECT @BATCHID2 = strBatchID, @USERBATCHSTATUS = intUserBatchStatus  FROM [dbo].[tblUserBatch] where intUserID = @USERID and strBatchID = @BATCHID
	SELECT @BATCHSTATUS = intBatchStatus ,@PAYDATE =  dtPayDate FROM [dbo].[tblBatch] where strBatchID = @BATCHID

	--The batch exists and it is not status = -1 (Paid and Closed)
	if NOT  @BATCHID2 IS NULL AND @BATCHSTATUS >= 0
	BEGIN TRY
		BEGIN TRANSACTION
	
		--CREATE THE USER BATCH WITH THE CURRENT INFORMATION
		--Compute Compensations
		EXECUTE  [dbo].[spPay_Create_UserBatchCompensations]  @BATCHID,@USERID,@PAYDATE
			
		--Compute Withholdings
		EXECUTE	 [dbo].[spPay_Create_UserBatchWithholdings] @BATCHID,@USERID,@PAYDATE 

		--Create Pay Checks
		EXECUTE [dbo].[spPay_Create_UserPayChecks]@BATCHID  ,@USERID  ,@SUPERVISORID  ,@SUPERVISORNAME
  		--Commit the transaction
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
