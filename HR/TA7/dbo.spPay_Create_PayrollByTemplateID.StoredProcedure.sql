USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_PayrollByTemplateID]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Computes a the payroll of all employees in a payroll template.
--		Each user payroll in the template is created. 
--		@BATCHDID nvarchar(50) -- Company Batch
--		@SUPERVISORID int,				--Supevisor calling sp
--		@SUPERVISORNAME nvarchar(50),	--Supevisor calling sp
--		@PAYROLLTEMPLATEID int			--The payroll template
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Create_PayrollByTemplateID]
	-- Add the parameters for the stored procedure here
		@BATCHID nvarchar(50),
		@SUPERVISORID int,
		@SUPERVISORNAME nvarchar(50),
		@TEMPLATEID int
-- WITH ENCRYPTION
AS

BEGIN
--GET BATCH DATA
DECLARE @Companyname nvarchar(50)
DECLARE @Paydate datetime
DECLARE @UsersProcessed int
DECLARE @PayMethodType int

SELECT @Companyname =strCompanyName, @Paydate =dtPayDate FROM tblBatch WHERE strBatchID = @Batchid

IF @Companyname <> ''
		BEGIN TRY
			BEGIN TRAN
			
			--CREATE THE TRANSACTIONS IN THE TEMPLATE
			EXEC [dbo].[spPay_Create_CompensationsFromTemplateID] @BATCHID, @SUPERVISORID,@SUPERVISORNAME
			
			--DELETE USER BATCHES
			DELETE FROM tblUserBatch where strBatchID = @BATCHID
			--CREATE USER BATCHES FOR ALL USERS IN THE BATCH
			INSERT into tblUserBatch (intUserID, strBatchID, intPayWeekNum, intUserBatchStatus, dtStartDatePeriod, dtEndDatePeriod, intCompanyID, intDepartmentID, intSubdepartmentID, intEmployeeTypeID, intPayMethodType) 
			SELECT intUserID,@BATCHID,0,0,@Paydate,@Paydate,u.nCompanyID,u.nDeptID,u.nJobTitleID,u.nEmployeeType,ptuc.intPayMethodType
			FROM [dbo].[tblPayrollTemplatesUsers] ptuc inner join tuser u ON ptuc.intUserID = u.id
			WHERE ptuc.intPayrollTemplateID = @TEMPLATEID

			--Compute all as a group
			EXEC spPay_Create_UserBatch @Batchid, 0, 0, @Supervisorid,@Supervisorname , @PayMethodType


			--Mark the Payweek as processed
			INSERT INTO tblCompanySchedulesProcessed (strCompanyName, intPayrollScheduleID, strBatchID, intPayWeekNumber)
			SELECT @Companyname, 0,@Batchid,0

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
