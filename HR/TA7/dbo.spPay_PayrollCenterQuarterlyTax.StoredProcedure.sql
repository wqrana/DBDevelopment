USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_PayrollCenterQuarterlyTax]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 1/24/2022
-- Description:	Updates the PaymentStatus of the payroll AND the Payroll Center
-- =============================================
CREATE PROCEDURE [dbo].[spPay_PayrollCenterQuarterlyTax]
	@BATCHID nvarchar(50)
AS
BEGIN
	BEGIN TRY

		DECLARE @PayrollCenterServer nvarchar(100) = ''
		DECLARE @PayrollCenterDatabase nvarchar(100) = ''
		DECLARE @SQL nvarchar(MAX)

		SELECT top(1) @PayrollCenterServer = ci.PayrollCenterServer, @PayrollCenterDatabase = PayrollCenterDatabase from ClientInfo ci
		SELECT @PayrollCenterServer PayrollCenterServer , @PayrollCenterDatabase PayrollCenterDatabase
		
		--INSERT INTO tpdb [PayrollQuarterlyTax]
		SET @SQL = 
		'
		INSERT INTO [tpserver].[tpdb].[dbo].[PayrollQuarterlyTax]
			   ([CompanyName]
			   ,[Quarter]
			   ,[QuarterStartDate]
			   ,[QuarterEndDate]
			   ,[FUTAWHAmount]
			   ,[FUTATaxDepositScheduleId]
			   ,[FUTATaxDepositStatusId]
			   ,[FUTATaxDepositAmount]
			   ,[FUTATaxDepositDate]
			   ,[FUTATaxReceiptNo]
			   ,[FUTATaxStatusDate]
			   ,[FUTATaxStatusByName]
			   ,[FUTATaxConfirmation]
			   ,[FUTATaxRptName]
			   ,[SUTAWHAmount]
			   ,[SUTATaxDepositStatusId]
			   ,[SUTATaxDepositAmount]
			   ,[SUTATaxDepositDate]
			   ,[SUTATaxReceiptNo]
			   ,[SUTATaxStatusDate]
			   ,[SUTATaxStatusByName]
			   ,[SUTATaxConfirmation]
			   ,[SUTATaxRptName]
			   ,[SINOTWHAmount]
			   ,[SINOTTaxDepositStatusId]
			   ,[SINOTTaxDepositAmount]
			   ,[SINOTTaxDepositDate]
			   ,[SINOTTaxReceiptNo]
			   ,[SINOTTaxStatusDate]
			   ,[SINOTTaxStatusByName]
			   ,[SINOTTaxConfirmation]
			   ,[SINOTTaxRptName]
			   ,[CHOFERILWHAmount]
			   ,[CHOFERILTaxDepositStatusId]
			   ,[CHOFERILTaxDepositAmount]
			   ,[CHOFERILTaxDepositDate]
			   ,[CHOFERILTaxReceiptNo]
			   ,[CHOFERILTaxStatusDate]
			   ,[CHOFERILTaxStatusByName]
			   ,[CHOFERILTaxConfirmation]
			   ,[CHOFERILTaxRptName]
			   ,[DataEntryStatus]
			   ,[CreatedDate]
			   ,[CreatedBy]
			   ,[CreatedByName]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT
			 cpi.strCompanyName	[CompanyName]
			   , cast(dc.theyear as varchar(4)) + ''-'' +  cast(TheQuarter as varchar(1)) [Quarter]
			   ,TheFirstOfQuarter [QuarterStartDate]
			   ,TheLastOfQuarter [QuarterEndDate]
			   ,(select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings where strWithHoldingsName = ''FUTA'' and dtPayDate between dc.TheFirstOfQuarter AND dc.TheLastOfQuarter) [FUTAWHAmount]
			   ,(select FUTATaxDepositScheduleId from tblCompanyOptions co where co.strCompanyName = cpi.strCompanyName)  [FUTATaxDepositScheduleId]
			   ,1 [FUTATaxDepositStatusId]
			   ,NULL [FUTATaxDepositAmount]
			   ,NULL [FUTATaxDepositDate]
			   ,NULL [FUTATaxReceiptNo]
			   ,NULL [FUTATaxStatusDate]
			   ,NULL [FUTATaxStatusByName]
			   ,NULL [FUTATaxConfirmation]
			   ,NULL [FUTATaxRptName]
			   ,-(select sum(decWithholdingsAmount)  from viewPay_CompanyBatchWithholdings where strWithHoldingsName = ''SUTA'' and dtPayDate between dc.TheFirstOfQuarter AND dc.TheLastOfQuarter) [SUTAWHAmount]
			   ,1 [SUTATaxDepositStatusId]
			   ,NULL [SUTATaxDepositAmount]
			   ,NULL [SUTATaxDepositDate]
			   ,NULL [SUTATaxReceiptNo]
			   ,NULL [SUTATaxStatusDate]
			   ,NULL [SUTATaxStatusByName]
			   ,NULL [SUTATaxConfirmation]
			   ,NULL [SUTATaxRptName]
			   ,-(select sum(decWithholdingsAmount)  from viewPay_CompanyBatchWithholdings where strWithHoldingsName = ''SINOT'' and dtPayDate between dc.TheFirstOfQuarter AND dc.TheLastOfQuarter) [SINOTWHAmount]
			   ,1 [SINOTTaxDepositStatusId]
			   ,NULL [SINOTTaxDepositAmount]
			   ,NULL [SINOTTaxDepositDate]
			   ,NULL [SINOTTaxReceiptNo]
			   ,NULL [SINOTTaxStatusDate]
			   ,NULL [SINOTTaxStatusByName]
			   ,NULL [SINOTTaxConfirmation]
			   ,NULL [SINOTTaxRptName]
			   ,-(select sum(decWithholdingsAmount)  from viewPay_CompanyBatchWithholdings where strWithHoldingsName = ''CHOFERIL'' and dtPayDate between dc.TheFirstOfQuarter AND dc.TheLastOfQuarter) [CHOFERILWHAmount]
			   ,1 [CHOFERILTaxDepositStatusId]
			   ,NULL [CHOFERILTaxDepositAmount]
			   ,NULL [CHOFERILTaxDepositDate]
			   ,NULL [CHOFERILTaxReceiptNo]
			   ,NULL [CHOFERILTaxStatusDate]
			   ,NULL [CHOFERILTaxStatusByName]
			   ,NULL [CHOFERILTaxConfirmation]
			   ,NULL [CHOFERILTaxRptName]
			   ,1 [DataEntryStatus]
			   ,getdate() [CreatedDate]
			   ,1 [CreatedBy]
			   ,''Identech''[CreatedByName]
			   ,NULL [ModifiedBy]
			   ,NULL [ModifiedDate]
		FROM dbo.tblCompanyPayrollInformation cpi inner join tblCompanyOptions co on cpi.strCompanyName = co.strCompanyName
		cross join
		(select distinct TheYear, TheQuarter, TheFirstOfQuarter, TheLastOfQuarter  from dbo.DateCalendar 
		where TheDate = cast(GETDATE() as date)) DC 
		WHERE co.IdentechTaxesID = 2 
		AND NOT EXISTS(select 1 FROM [tpserver].[tpdb].[dbo].[PayrollQuarterlyTax] pqt where pqt.CompanyName = cpi.strCompanyName and pqt.[Quarter] = cast(dc.theyear as varchar(4)) + ''-'' +  cast(TheQuarter as varchar(1)))
		'
			IF @PayrollCenterServer = ''
				SET @SQL = REPLACE( REPLACE (@SQL,'[tpserver].',@PayrollCenterServer) ,'tpdb',@PayrollCenterDatabase)
			ELSE
				SET @SQL = REPLACE( REPLACE (@SQL,'tpserver',@PayrollCenterServer) ,'tpdb',@PayrollCenterDatabase)
		select @SQL
		exec sp_executesql @sql

	END TRY
	BEGIN CATCH
			 SELECT   
				ERROR_NUMBER() AS ErrorNumber  
			   ,ERROR_MESSAGE() AS ErrorMessage; 
	END CATCH

END
GO
