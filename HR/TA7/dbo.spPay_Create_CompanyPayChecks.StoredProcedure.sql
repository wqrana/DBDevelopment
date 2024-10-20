USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_CompanyPayChecks]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_CompanyPayChecks]    Script Date: 6/26/2017 5:56:53 PM ******/

-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Computes a the payroll checks of all employees in a Batch
--		@BATCHDID nvarchar(50) -- Company Batch
--		@SUPERVISORID int,				--Supevisor calling sp
--		@SUPERVISORNAME nvarchar(50),	--Supevisor calling sp
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Create_CompanyPayChecks]
	-- Add the parameters for the stored procedure here
		@BATCHID nvarchar(50),
		@SUPERVISORID int,
		@SUPERVISORNAME nvarchar(50)
-- WITH ENCRYPTION
AS

BEGIN
--GET BATCH DATA
DECLARE @BatchStatus int
DECLARE @UsersProcessed int

SELECT @BatchStatus =intBatchStatus FROM tblBatch WHERE strBatchID = @BATCHID

IF @BatchStatus = 0
		BEGIN TRY
			BEGIN TRAN
			DECLARE @LastUserID int
			SET @LastUserID = 0
			DECLARE @NextUserID int
			SET @NextUserID = 1
			SET @UsersProcessed = 0
			
			--Iterate throguh all the employees and create the UserBath for each
			while @NextUSerID <> @LastUserID
			BEGIN
			 
			 SET @LastUserID = @NextUSerID 

				SELECT top(1) @NextUSerID= intUserID FROM tblUserBatch
				WHERE strBatchID = @BATCHID AND intUserID>@LastUserID
				ORDER BY intUserID
				IF @NextUSerID <> @LastUserID
				BEGIN
					EXEC [dbo].[spPay_Create_UserPayChecks] @Batchid,@NextUserID, @Supervisorid,@Supervisorname 
				END
				SET @UsersProcessed = @UsersProcessed +1
			END

			--Mark the batch as Check Created
			update tblBatch set intBatchStatus = 2 where strBatchID = @BATCHID 

			COMMIT
			RETURN @UsersProcessed
		END TRY
		BEGIN CATCH
			ROLLBACK ;
			SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 
			SET @UsersProcessed = 0		
			RETURN @UsersProcessed
		END CATCH
ELSE
	BEGIN;
		THROW 100001,'Batch Not Ready For Check Creation',1
		RETURN 0
	END
END


GO
