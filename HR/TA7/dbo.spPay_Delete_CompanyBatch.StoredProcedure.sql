USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Delete_CompanyBatch]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[spPay_Delete_CompanyBatch]    Script Date: 6/26/2017 5:56:53 PM ******/

-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Deletes all the entries of a Payroll Batch
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Delete_CompanyBatch]
	-- Add the parameters for the stored procedure here
	  @BATCHID nvarchar(50),
	  @SUPERVISORID as int,
	  @SUPERVISORNAME as nvarchar(50)
-- -- WITH ENCRYPTION
AS
BEGIN
BEGIN TRY
	BEGIN TRAN
	DELETE FROM [dbo].[tblBatch] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblUSerBatch] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblPunchDate] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblPunchDateDetail] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblPunchPair] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblReportWeek] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblUserBatchTransactions] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblUserBatchCompensations] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblUserBatchCompensations_ManualEntry] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblUserBatchWithholdings] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblUserBatchWithholdings_ManualEntry] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblUserPayChecks] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblCompanyBatchWithholdings] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblCompanyBatchWithholdings_ManualEntry] where strBatchID = @BATCHID
	DELETE FROM [dbo].[tblCompanySchedulesProcessed] where strBatchID = @BATCHID
	COMMIT
	RETURN @@ROWCOUNT
END TRY
BEGIN CATCH
	ROLLBACK ;
	SELECT   
		ERROR_NUMBER() AS ErrorNumber  
	   ,ERROR_MESSAGE() AS ErrorMessage; 
	RETURN 0
END CATCH
END

GO
