USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_PayrollAndUsers]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 10/3/2016
-- Description:	Creates a new Batch and UserBatch records for Payroll processing
--				The payroll processing is done later so large companies don't time out.
--				The sp returns the GUID for the BatchID
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Create_PayrollAndUsers]
	-- Add the parameters for the stored procedure here
		@BATCHID nvarchar(50) OUTPUT,
		@COMPANYNAME as nvarchar(50),
		@PAYROLLDESCRIPTION as nvarchar(50),
		@PAYDATE as date,
		@BATCH_TYPE as int,
		@TEMPLATEID as int,
  		@PAYWEEKNUM  int,
		@SUPERVISORID int,
		@SUPERVISORNAME nvarchar(50),
		@PAYROLLSCHEDULEID int,
		@PAYROLLUSERSTATUS int

AS
BEGIN
	BEGIN TRY
	BEGIN TRAN CREATEBATCH
		SET @BATCHID = NEWID()
		
		INSERT INTO tblBatch (strBatchID, strCompanyName, strBatchDescription, dtBatchCreated, intCreatedByID, strCreateByName, dtBatchUpdates, 
							intBatchStatus, dtPayDate,intBatchType,intTemplateID)
		VALUES				 (@BATCHID,@COMPANYNAME,@PAYROLLDESCRIPTION,GETDATE() , @SUPERVISORID,@SUPERVISORNAME,GETDATE(), 0, @PAYDATE, @BATCH_TYPE,@TEMPLATEID)
		
		--CREATE USER BATCHES FOR ALL USERS IN THE BATCH
		INSERT into tblUserBatch (intUserID, strBatchID, intPayWeekNum, intUserBatchStatus, dtStartDatePeriod, dtEndDatePeriod, intCompanyID, intDepartmentID, intSubdepartmentID, intEmployeeTypeID, intPayMethodType) --VALUES (@USERID,@BATCHID,@PAYWEEKNUM,0,@StartDate,@EndDate)
		SELECT intUserID,@BATCHID,@PAYWEEKNUM,0,rw.DTStartDate,rw.DTEndDate, rw.nCompID, rw.nDept,rw.nJobTitleID,rw.nEmployeeType, 0  FROM [dbo].[fnPay_SelectPayrollschedulesUser] (@Payweeknum, @Payrollscheduleid, @Payrolluserstatus)  u inner join tReportweek rw on u.intUserID =rw.e_id and rw.nPayWeekNum = @PAYWEEKNUM

		--Mark the batch as Batch User Created
		update tblBatch set intBatchStatus = 1 where strBatchID = @BATCHID 
		
		--Compute the payroll as a set operation
		exec [dbo].[spPay_Create_UserBatch] @BATCHID,0,@PAYWEEKNUM,@SUPERVISORID,@SUPERVISORNAME,0
		
		--Mark the Payweek as processed
		INSERT INTO tblCompanySchedulesProcessed (strCompanyName, intPayrollScheduleID, strBatchID, intPayWeekNumber)
		SELECT @Companyname, @Payrollscheduleid,@Batchid,@Payweeknum
		COMMIT

END TRY
BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 

		   SET @BATCHID = -1
END CATCH
END

GO
