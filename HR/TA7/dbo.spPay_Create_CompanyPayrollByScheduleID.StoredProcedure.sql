USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_CompanyPayrollByScheduleID]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Computes a the payroll of all employees assigned to a Payroll Schedule
--				Imports a PayweekNum from TimeAide and creates a Batch
--				Note: Each payweeknum will have its own associated batch.
--		@BATCHDID nvarchar(50) -- Company Batch
--		@COMPANYNAME  nvarchar(50),		--CompanyName
--		@BATCHDESCRIPTION  nvarchar(50),
--		@PAYWEEKNUM  int,				--PayWeek To import
--		@SUPERVISORID int,				--Supevisor calling sp
--		@SUPERVISORNAME nvarchar(50),	--Supevisor calling sp
--		@PAYDATE smalldatetime			--Pay Date
--		@PAYROLLUSERSTATUS int			--Active payroll employees
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Create_CompanyPayrollByScheduleID]
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
DECLARE @LastUserID int
DECLARE @NextUserID int

SELECT @Companyname =strCompanyName, @Paydate =dtPayDate FROM tblBatch WHERE strBatchID = @Batchid

IF @Companyname <> ''
		BEGIN TRY
			BEGIN TRAN
			SET @LastUserID = -1
			SET @NextUserID = 0
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
					EXEC spPay_Create_UserBatch @Batchid, @NextUserID, @Payweeknum, @Supervisorid,@Supervisorname , 0
				END
				SET @UsersProcessed = @UsersProcessed +1
			END
			--Create the Pay Checks
			--NOW the checks are done with the UserBatch
			--			EXECUTE [dbo].[spPay_Create_CompanyPayChecks] @BATCHID ,@SUPERVISORID ,@SUPERVISORNAME

			--Mark the batch as Checks Created
			update tblBatch set intBatchStatus = 2 where strBatchID = @BATCHID 

			--Mark the Payweek as processed
			INSERT INTO tblCompanySchedulesProcessed (strCompanyName, intPayrollScheduleID, strBatchID, intPayWeekNumber)
			SELECT @Companyname, @Payrollscheduleid,@Batchid,@Payweeknum
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
--	BEGIN
		THROW 100001,'Batch not found',1
	--	RETURN 0
---	END
END


GO
