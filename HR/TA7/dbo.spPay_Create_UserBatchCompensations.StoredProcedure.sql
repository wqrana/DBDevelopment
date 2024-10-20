USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_UserBatchCompensations]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Computes the compensations for a batch based on the batch transactions
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Create_UserBatchCompensations]
	-- Add the parameters for the stored procedure here
	@BATCHID nvarchar(50),
	@USERID int,
	@PAYDATE as datetime
-- -- WITH ENCRYPTION
AS

BEGIN
	DECLARE @SQL_SCRIPT NVARCHAR(MAX)
	DECLARE @BatchCount as int
	
	--Check that the Payweek batch has been created and get other necessary information
	DECLARE @BatchProcessedCode as int
	DECLARE @PayPeriod int
	DECLARE @PAYROLL_COMPANY nvarchar(50)
	DECLARE @BATCH_TYPE int
	select top(1) @BatchProcessedCode = intUserBatchStatus, @PAYROLL_COMPANY = strCompanyName, @BATCH_TYPE = intBatchType, @PAYDATE = dtPayDate from viewPay_UserBatchStatus where strBatchID =  @BATCHID AND (intUserID = @USERID OR @USERID = 0)
	
	IF @BatchProcessedCode >= 0 
		BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
			-- SET NOCOUNT ON added to prevent extra result sets from
			-- interfering with SELECT statements.
			SET NOCOUNT ON;

			--DELETE ANY EXISTING ENTRIES IN ORDER TO OVERWRITE
			DELETE FROM tblUserBatchCompensations where strBatchID = @BATCHID AND (intUserID = @USERID OR @USERID = 0)

			DECLARE @JobCodeUse as int
			select @JobCodeUse  = nConfigParam from tSoftwareConfiguration where nConfigID = 1000
	
		if @JobCodeUse = 0
			BEGIN
			--PROCESS BATCH TRANSACTIONS TO GET ENTRY FOR THE PERIOD
			--INSERT INTO tblUserBatchCompensations (strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, dtTimeStamp, strGLAccount, boolDeleted,intEditType,intUBMESequence)
			--select bt.strBatchID, bt.intUserID, uc.strCompensationName,bt.decPayRate, @PAYDATE, SUM(bt.decHours) as decHours, sum(bt.decMoneyValue) as decPay, GETDATE(), uc.strGLAccount,0,0,0
			--from tblUserBatchTransactions bt inner join tblCompensationTransactions ct on bt.strTransactionType = ct.strTransName 
			--inner join [dbo].[tblUserCompensationItems] uc ON bt.intUserID = uc.intUserID and ct.strCompensationName = uc.strCompensationName
			--inner join tblUserBatch ub ON bt.intUserID = ub.intUserID AND bt.strBatchID = ub.strBatchID
			--where bt.strBatchID = @BATCHID 
			--AND (bt.intUserID = @USERID OR @USERID = 0) 
			--GROUP BY bt.strBatchID, bt.intUserID, uc.strCompensationName, bt.decPayRate,uc.strGLAccount

			--Regular Transactions
			INSERT INTO tblUserBatchCompensations (strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, dtTimeStamp, strGLAccount, boolDeleted,intEditType,intUBMESequence)
			select bt.strBatchID, bt.intUserID, uc.strCompensationName,bt.decPayRate, getdate(), SUM(bt.decHours) as decHours, sum(bt.decMoneyValue) as decPay, GETDATE(), uc.strGLAccount,0,0,0
			from tblUserBatchTransactions bt inner join tblCompensationTransactions ct on bt.strTransactionType = ct.strTransName 
			inner join [dbo].[tblUserCompensationItems] uc ON bt.intUserID = uc.intUserID and ct.strCompensationName = uc.strCompensationName
			inner join tblUserBatch ub ON bt.intUserID = ub.intUserID AND bt.strBatchID = ub.strBatchID
			where bt.strBatchID = @BATCHID 
			AND (bt.intUserID = @USERID OR @USERID = 0) 
			and ct.strCompensationName not in (select strCompensationName from tblCompensationTips)
			GROUP BY bt.strBatchID, bt.intUserID, uc.strCompensationName, bt.decPayRate,uc.strGLAccount

			--Propinas
			INSERT INTO tblUserBatchCompensations (strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, dtTimeStamp, strGLAccount, boolDeleted,intEditType,intUBMESequence)
			select bt.strBatchID, bt.intUserID, uc.strCompensationName,bt.decPayRate, getdate(), SUM(bt.decHours) as decHours, sum(bt.decMoneyValue) as decPay, GETDATE(), uc.strGLAccount,0,0,0
			from tblUserBatchTransactions bt inner join tblCompensationTransactions ct on bt.strTransactionType = ct.strTransName 
			inner join [dbo].[tblUserCompensationItems] uc ON bt.intUserID = uc.intUserID and ct.strCompensationName = uc.strCompensationName
			inner join tblUserBatch ub ON bt.intUserID = ub.intUserID AND bt.strBatchID = ub.strBatchID
			inner join tblCompensationTips tips on ct.strCompensationName = tips.strCompensationName
			where bt.strBatchID = @BATCHID 
			AND (bt.intUserID = @USERID OR @USERID = 0) 
			GROUP BY bt.strBatchID, bt.intUserID, uc.strCompensationName, bt.decPayRate,uc.strGLAccount

			END
		ELSE
			BEGIN
			--PROCESS BATCH TRANSACTIONS AND JOB CODE ENTRIES
			IF @PAYROLL_COMPANY = 'Cooperativa de Ahorro y Credito Oriental'
				BEGIN
					INSERT INTO tblUserBatchCompensations (strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, dtTimeStamp, strGLAccount, boolDeleted,intEditType,intUBMESequence)
					select ubc.strBatchID, ubc.intUserID, ubc.strCompensationName,ubc.decPayRate, @PAYDATE, ubc.decHours*jc.decGLPercent/100 as decHours, jc.decGLAmount as decPay, GETDATE(), jc.strGLAccount strGLAccount , 0 boolDeleted, 0 intEditType,0 intUBMESequence FROM
					(select bt.strBatchID, bt.intUserID, uc.strCompensationName,bt.decPayRate, @PAYDATE dtPayDate, SUM(bt.decHours) as decHours, sum(bt.decMoneyValue) as decPay,ucp.strCompanyName,bt.intJobCode
					from tblUserBatchTransactions bt inner join tblCompensationTransactions ct on bt.strTransactionType = ct.strTransName 
					inner join [dbo].[tblUserCompensationItems] uc ON bt.intUserID = uc.intUserID and ct.strCompensationName = uc.strCompensationName
					inner join tblUserCompanyPayroll ucp on ucp.intUserID = bt.intUserID
					where bt.strBatchID = @BATCHID 
					AND (bt.intUserID = @USERID OR @USERID =0)  and uc.strCompensationName = 'Regular Wages'
					GROUP BY bt.strBatchID, strCompanyName, bt.intUserID, uc.strCompensationName, bt.decPayRate,bt.intJobCode) ubc 
					cross apply  [dbo].[fnPay_tblCompanyJobCodeGLSPlit] ( ubc.strCompanyName , ubc.intJobCode  ,ubc.decPay) jc

					--ADDED FOR COOP ORIENTAL
					INSERT INTO tblUserBatchCompensations (strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, dtTimeStamp, strGLAccount, boolDeleted,intEditType,intUBMESequence)
					select bt.strBatchID, bt.intUserID, uc.strCompensationName,bt.decPayRate, @PAYDATE, SUM(bt.decHours) as decHours, sum(bt.decMoneyValue) as decPay, GETDATE(), uc.strGLAccount,0,0,0
					from tblUserBatchTransactions bt inner join tblCompensationTransactions ct on bt.strTransactionType = ct.strTransName 
					inner join [dbo].[tblUserCompensationItems] uc ON bt.intUserID = uc.intUserID and ct.strCompensationName = uc.strCompensationName
					where bt.strBatchID = @BATCHID 
					AND (bt.intUserID = @USERID OR @USERID =0) and uc.strCompensationName <> 'Regular Wages'
					GROUP BY bt.strBatchID, bt.intUserID, uc.strCompensationName, bt.decPayRate,uc.strGLAccount

				END
			ELSE
				BEGIN
				--MARTINAL  REGULAR OVERRIDE
				--PROCESS BATCH TRANSACTIONS TO GET ENTRY FOR THE PERIOD
				INSERT INTO tblUserBatchCompensations (strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, dtTimeStamp, strGLAccount, boolDeleted,intEditType,intUBMESequence)
				select bt.strBatchID, bt.intUserID, uc.strCompensationName,bt.decPayRate, @PAYDATE, SUM(bt.decHours) as decHours, sum(bt.decMoneyValue) as decPay, GETDATE(), uc.strGLAccount,0,0,0
				from tblUserBatchTransactions bt inner join tblCompensationTransactions ct on bt.strTransactionType = ct.strTransName 
				inner join [dbo].[tblUserCompensationItems] uc ON bt.intUserID = uc.intUserID and ct.strCompensationName = uc.strCompensationName
				inner join tblUserBatch ub ON bt.intUserID = ub.intUserID AND bt.strBatchID = ub.strBatchID
				where bt.strBatchID = @BATCHID 
				AND (bt.intUserID = @USERID OR @USERID = 0) 
				GROUP BY bt.strBatchID, bt.intUserID, uc.strCompensationName, bt.decPayRate,uc.strGLAccount
				END
				END
			--INSERT AUTOMATIC COMPENSATIONS RELATING TO THE PERIOD 
			IF @BATCH_TYPE = 0 --REGULAR PAYROLLL
				BEGIN
					--INSERT AUTOMATIC COMPENSATIONS THAT RELATE TO REGULAR PAYROLLS
					INSERT INTO tblUserBatchCompensations (strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, dtTimeStamp, strGLAccount, boolDeleted,intEditType,intUBMESequence)
					select @BATCHID, uc.intUserID, uc.strCompensationName,uc.decHourlyRate, @PAYDATE, 0, uc.decMoneyAmount as decPay, GETDATE(), uc.strGLAccount,0,0,0
					FROM [dbo].[tblUserCompensationItems] uc 
					inner join tblUserBatch ub ON uc.intUserID = ub.intUserID AND ub.strBatchID = @BATCHID
					where uc.intPeriodEntryID = -1
					AND (uc.intUserID = @USERID OR @USERID = 0)

					--This Period Only
					INSERT INTO tblUserBatchCompensations (strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, dtTimeStamp, strGLAccount, boolDeleted,intEditType,intUBMESequence)
					select @BATCHID, uc.intUserID, uc.strCompensationName,uc.decHourlyRate, @PAYDATE, 0, uc.decMoneyAmount as decPay, GETDATE(), uc.strGLAccount,0,0,0
					FROM [dbo].[tblUserCompensationItems] uc inner join tblUserCompanyPayroll ucp on uc.intUserID = ucp.intUserID
					inner join tblUserBatch ub ON uc.intUserID = ub.intUserID AND ub.strBatchID = @BATCHID
					where (uc.intPeriodEntryID = [dbo].[fnPay_PayPeriodsInMonthSearchDate] (ucp.strCompanyName,@PAYDATE,0,uc.intUserID) AND uc.intPeriodEntryID > 0)
					AND (uc.intUserID = @USERID OR @USERID =0)
					
				END
			ELSE --ADDITIONAL
				BEGIN
					--INSERT AUTOMATIC COMPENSATIONS THAT RELATE TO ADDITIONAL PAYROLLS
					INSERT INTO tblUserBatchCompensations (strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, dtTimeStamp, strGLAccount, boolDeleted,intEditType,intUBMESequence)
					select @BATCHID, uc.intUserID, uc.strCompensationName,uc.decHourlyRate, @PAYDATE, 0, uc.decMoneyAmount as decPay, GETDATE(), uc.strGLAccount,0,0,0
					FROM [dbo].[tblUserCompensationItems] uc 
					inner join tblUserBatch ub ON uc.intUserID = ub.intUserID AND ub.strBatchID = @BATCHID
					where uc.intPeriodEntryID = -2
					AND (uc.intUserID = @USERID OR @USERID =0)
				END
			

			--MODIFY and DELETED COMPENSATIONS INTO tblUserBatchCompensations 
			DELETE FROM ubc  
			FROM tblUserBatchCompensations ubc INNER JOIN tblUserBatchCompensations_ManualEntry ubcme 
			ON ubc.strBatchID = ubcme.strBatchID and ubc.intUserID = ubcme.intUserID and ubc.strCompensationName = ubcme.strCompensationName
			AND ubcme.boolDeleted = 1
			WHERE ubc.strBatchID = @BATCHID
			AND (ubc.intUserID = @USERID OR @USERID = 0)

		--INSERT ADDED COMPENSATIONS INTO tblUserBatchCompensations 
			INSERT INTO tblUserBatchCompensations 
			(strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, dtTimeStamp, strGLAccount, boolDeleted,intEditType,intUBMESequence)
			SELECT
			strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, dtTimeStamp, strGLAccount, boolDeleted,intEditType,intSequenceNumber
			FROM tblUserBatchCompensations_ManualEntry 
			WHERE boolDeleted = 0 and strBatchID = @BATCHID 
			AND (intUserID = @USERID OR @USERID = 0)

			--Update Batch to indicate Compensations where processed		
			--UPDATE [dbo].tblUserBatch SET intUserBatchStatus  = 2 where strBatchID =  @BATCHID	AND intUserID = @USERID

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
	if @BatchProcessedCode is null 
			THROW 100002, 'Batch does not exist.',1
	if @BatchProcessedCode > 1
			THROW 100003, 'Batch already processed.',1

END


GO
