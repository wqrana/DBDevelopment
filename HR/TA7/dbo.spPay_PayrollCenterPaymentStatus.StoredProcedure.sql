USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_PayrollCenterPaymentStatus]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 1/24/2022
-- Description:	Updates the PaymentStatus of the payroll AND the Payroll Center
-- =============================================
CREATE PROCEDURE [dbo].[spPay_PayrollCenterPaymentStatus]
	@BATCHID nvarchar(50),
	@PAYMENTSTATUSID int,
	@PaymentStatusByName nvarchar(100),
	@PaymentStatusDate datetime
AS
BEGIN
	BEGIN TRY

		--UPDATE the TimeAidePayroll Payroll
		UPDATE tblBatch set 
			intPaymentStatusId	= @PAYMENTSTATUSID
			,strPaymentStatusByName	= @PaymentStatusByName
			,dtPaymentStatusDate	= @PaymentStatusDate
			WHERE strBatchID = @BATCHID

	END TRY
	BEGIN CATCH
			 SELECT   
				ERROR_NUMBER() AS ErrorNumber  
			   ,ERROR_MESSAGE() AS ErrorMessage; 
	END CATCH
	BEGIN TRY
		DECLARE @PayrollCenterServer nvarchar(100) = ''
		DECLARE @PayrollCenterDatabase nvarchar(100) = ''
		DECLARE @SQL nvarchar(MAX)

		SELECT top(1) @PayrollCenterServer = ci.PayrollCenterServer, @PayrollCenterDatabase = PayrollCenterDatabase from ClientInfo ci
		SELECT @PayrollCenterServer PayrollCenterServer , @PayrollCenterDatabase PayrollCenterDatabase

		IF NOT @PayrollCenterServer IS NULL OR @PayrollCenterServer = ''
		BEGIN
			--Create the payroll entry if it is not created
			SET @SQL = '
						EXEC [dbo].[spPay_PayrollCenterPayrollEntry] ''@BATCHID''
						'
				SET @SQL = REPLACE(@SQL,'@BATCHID',@BATCHID) 
				select @SQL
				exec sp_executesql @sql
			
			--UPDATE the TimeAidePayroll Database 
			SET @SQL = '
			UPDATE [tpserver].[tpdb].[dbo].[Payroll] set 
				PaymentStatusId	= @PAYMENTSTATUSID
				,PaymentStatusByName	= ''@PaymentStatusByName''
				,PaymentStatusDate	= ''@PaymentStatusDate''
			WHERE PayrollExternalId = ''@BATCHID''
			'
			SET @SQL = REPLACE(@SQL,'@PAYMENTSTATUSID',@PAYMENTSTATUSID) 
			SET @SQL = REPLACE(@SQL,'@PaymentStatusByName',@PaymentStatusByName) 
			SET @SQL = REPLACE(@SQL,'@PaymentStatusDate', @PaymentStatusDate) 
			SET @SQL = REPLACE(@SQL,'@BATCHID',@BATCHID) 
			IF @PayrollCenterServer = ''
				SET @SQL = REPLACE( REPLACE (@SQL,'[tpserver].',@PayrollCenterServer) ,'tpdb',@PayrollCenterDatabase)
			ELSE
				SET @SQL = REPLACE( REPLACE (@SQL,'tpserver',@PayrollCenterServer) ,'tpdb',@PayrollCenterDatabase)
			select @SQL
			exec sp_executesql @sql
		END
	END TRY
	BEGIN CATCH
			 SELECT   
				ERROR_NUMBER() AS ErrorNumber  
			   ,ERROR_MESSAGE() AS ErrorMessage; 
	END CATCH

END
GO
