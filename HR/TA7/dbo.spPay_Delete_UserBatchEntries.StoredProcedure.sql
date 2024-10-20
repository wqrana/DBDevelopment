USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Delete_UserBatchEntries]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[spPay_Delete_UserBatchEntries]    Script Date: 6/26/2017 5:56:53 PM ******/
-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Deletes all the entries os a single employee to a Payroll Batch
-- =============================================
CREATE PROCEDURE [dbo].[spPay_Delete_UserBatchEntries]
	-- Add the parameters for the stored procedure here
		@BATCHID nvarchar(50),
		@USERID int,
		@SUPERVISORID int,
		@SUPERVISORNAME nvarchar(50)
-- -- WITH ENCRYPTION
AS

BEGIN
	DECLARE @SQL_SCRIPT NVARCHAR(MAX)
	DECLARE @BatchCount as int
	
	--Check that the Payweek batch has been created.  If it has, then the withholdings can be created
	declare @BatchStatus as int
	SET @BatchStatus = 0
	IF @BatchStatus = 0
	BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
			DELETE FROM [dbo].[tblUSerBatch] where strBatchID = @BATCHID and intUserID = @USERID
			DELETE FROM [dbo].[tblPunchDate] where strBatchID = @BATCHID and e_id = @USERID
			DELETE FROM [dbo].[tblPunchDateDetail] where strBatchID = @BATCHID and e_id = @USERID
			DELETE FROM [dbo].[tblPunchPair] where strBatchID = @BATCHID and e_id = @USERID
			DELETE FROM [dbo].[tblReportWeek] where strBatchID = @BATCHID and e_id = @USERID
			DELETE FROM [dbo].[tblUserBatchTransactions] where strBatchID = @BATCHID and intUserID = @USERID
			DELETE FROM [dbo].[tblUserBatchCompensations] where strBatchID = @BATCHID and intUserID = @USERID
			DELETE FROM [dbo].[tblUserBatchCompensations_ManualEntry] where strBatchID = @BATCHID and intUserID = @USERID
			DELETE FROM [dbo].[tblUserBatchWithholdings] where strBatchID = @BATCHID and intUserID = @USERID
			DELETE FROM [dbo].[tblUserBatchWithholdings_ManualEntry] where strBatchID = @BATCHID and intUserID = @USERID
			DELETE FROM [dbo].[tblUserPayChecks] where strBatchID = @BATCHID and intUserID = @USERID
			DELETE FROM [dbo].[tblCompanyBatchWithholdings] where strBatchID = @BATCHID and intUserID = @USERID
			DELETE FROM [dbo].[tblCompanyBatchWithholdings_ManualEntry] where strBatchID = @BATCHID and intUserID = @USERID
			COMMIT
			return @@rowcount
		END TRY
		BEGIN CATCH
			ROLLBACK ;
			 SELECT   
				ERROR_NUMBER() AS ErrorNumber  
			   ,ERROR_MESSAGE() AS ErrorMessage; 
		END CATCH
	END
	ELSE
			THROW 100003, 'Unable to delete batch.  Period is closed.',1
END

GO
