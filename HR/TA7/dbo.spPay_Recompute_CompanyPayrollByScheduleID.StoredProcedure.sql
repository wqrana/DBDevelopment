USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Recompute_CompanyPayrollByScheduleID]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[spPay_Recompute_CompanyPayrollByScheduleID]    Script Date: 6/26/2017 5:56:53 PM ******/
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: ??
-- Description:	Creates a Payroll Based on a Payweeknum, and PayrollScheduleID
--				The sp returns the GUID for the BatchID
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Recompute_CompanyPayrollByScheduleID]
	-- Add the parameters for the stored procedure here
		@BATCHID nvarchar(50),
		@PAYWEEKNUM  int,
		@SUPERVISORID int,
		@SUPERVISORNAME nvarchar(50),
		@PAYROLLSCHEDULEID int,
		@PAYROLLUSERSTATUS int
-- WITH ENCRYPTION
AS

BEGIN
--GET BATCH DATA
DECLARE @Companyname nvarchar(50)
DECLARE @Paydate datetime
DECLARE @UsersProcessed int

SELECT @Companyname =strCompanyName, @Paydate =dtPayDate FROM tblBatch WHERE strBatchID = @Batchid

	IF @Companyname <> ''
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

				SELECT top(1) @NextUSerID= intUserID FROM [dbo].[fnPay_SelectPayrollschedulesUser] (@Payweeknum, @Payrollscheduleid, @Payrolluserstatus) 
				WHERE intUserID>@LastUserID
				ORDER BY intUserID
				IF @NextUSerID <> @LastUserID
				BEGIN
					EXECUTE  [dbo].[spPay_Recompute_UserBatchPayweek] @NextUserID ,@Payweeknum ,@Supervisorid   ,@Supervisorname
				END
				SET @UsersProcessed = @UsersProcessed +1
			END

			--Mark the batch as Checks Created
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
		THROW 100001,'Batch not found',1
		RETURN 0
	END
END


GO
