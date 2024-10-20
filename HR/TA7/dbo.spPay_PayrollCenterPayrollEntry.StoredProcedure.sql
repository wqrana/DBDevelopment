USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_PayrollCenterPayrollEntry]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 2/10/2022
-- Description: Creates the entry Payroll entry to the TimeAidePayroll database
--				Additionally, adds the Company to the TimeAidePayroll database if  it does not exists

CREATE PROCEDURE [dbo].[spPay_PayrollCenterPayrollEntry]
	-- Add the parameters for the stored procedure here
	  @BATCHID nvarchar(50) 
AS
BEGIN
BEGIN TRY


	DECLARE @CompanyName  nvarchar(50)
	DECLARE @PayrollStatus int= 0
	DECLARE @IdentechPayrollId int = 1

  --Check if Payroll is closed (-1) and whether it is processed by Identech (2)
	select @CompanyName =  b.strCompanyName, @PayrollStatus = intBatchStatus,@IdentechPayrollId = ISNULL(IdentechPayrollId,1) from tblBatch b inner join tblCompanyOptions co on b.strCompanyName = co.strCompanyName
	where strBatchID = @BATCHID

	IF  @IdentechPayrollId= 2--Identech Processed
	BEGIN
		DECLARE @PayrollCenterServer nvarchar(100) = ''
		DECLARE @PayrollCenterDatabase nvarchar(100) = ''
		DECLARE @SQL nvarchar(MAX)

		SELECT top(1) @PayrollCenterServer = ci.PayrollCenterServer, @PayrollCenterDatabase = PayrollCenterDatabase from ClientInfo ci
		SELECT @PayrollCenterServer PayrollCenterServer , @PayrollCenterDatabase PayrollCenterDatabase
		IF NOT @PayrollCenterServer  IS NULL OR @PayrollCenterServer = ''
		BEGIN
			SET @SQL =
			'
			BEGIN
				INSERT INTO [tpserver].[tpdb].[dbo].[Company]
						   ([CompanyName]
						   ,[DBServerName]
						   ,[DBName]
						   ,[DBUser]
						   ,[DBPassword]
						   ,[DataEntryStatus])
				select strCompanyName [CompanyName]
						   ,cast(SERVERPROPERTY(''servername'') as nvarchar(50)) [DBServerName]
						   ,DB_NAME() [DBName]
						   ,''Identech'' [DBUser]
						   ,''iden3902319'' [DBPassword]
						   ,1 [DataEntryStatus] from dbo.tblCompanyPayrollInformation
						   	 where strCompanyName not in (select CompanyName from [tpserver].[tpdb].[dbo].[Company] ) 

			END
			'
			SET @SQL = REPLACE (@SQL,'@CompanyName',@CompanyName)
			IF @PayrollCenterServer = ''
				SET @SQL = REPLACE( REPLACE (@SQL,'[tpserver].',@PayrollCenterServer) ,'tpdb',@PayrollCenterDatabase)
			ELSE
				SET @SQL = REPLACE( REPLACE (@SQL,'tpserver',@PayrollCenterServer) ,'tpdb',@PayrollCenterDatabase)

					select @SQL
			exec sp_executesql @sql

			--IF payroll has been deleted, the delete unless it has been paid (PaymentStatusId <> 2).
			SET @SQL =
				'
				IF NOT EXISTS (select 1 from [dbo].[tblBatch] where strBatchID = ''@BATCHID'')
				BEGIN
					DELETE from [tpserver].[tpdb].[dbo].[Payroll] where PayrollExternalId = ''@BATCHID'' and PaymentStatusId <> 2
				END
				'
					SET @SQL = REPLACE (@SQL,'@BATCHID',@BATCHID)
			IF @PayrollCenterServer = ''
				SET @SQL = REPLACE( REPLACE (@SQL,'[tpserver].',@PayrollCenterServer) ,'tpdb',@PayrollCenterDatabase)
			ELSE
				SET @SQL = REPLACE( REPLACE (@SQL,'tpserver',@PayrollCenterServer) ,'tpdb',@PayrollCenterDatabase)
					select @SQL
					exec sp_executesql @sql



			SET @SQL =
			'
			IF NOT EXISTS (select 1 from [tpserver].[tpdb].[dbo].[Payroll] where PayrollExternalId = ''@BATCHID'')
			BEGIN
				INSERT INTO [tpserver].[tpdb].[dbo].[Payroll]
						   ([PayrollExternalId]
						   ,[CompanyName]
						   ,[PayrollName]
						   ,[PayDate]
						   ,[PayrollStatusId]
						   ,[Compensations]
						   ,[Withholdings]
						   ,[Contributions]
						   ,[PaymentStatusId]
						   ,[FederalTaxDepositStatusId]
						   ,[FederalTaxDepositAmount]
						   ,[FederalTaxStatusDate]
						   ,[HaciendaTaxDepositStatusId]
						   ,[HaciendaTaxDepositAmount]
						   ,[HaciendaTaxStatusDate]
						   ,[PayrollTypeName]
						   ,[TemplateTypeName]
						   ,[CompanyPayrollSummary]
						   ,[PaymentConfirmation]
						   ,[FederalTaxConfirmation]
						   ,[HaciendaTaxConfirmation]
						   ,[ClosedBy]
						   ,[ClosedDate]
						   ,[DataEntryStatus]
						   ,[CreatedByName]
						   ,[CreatedBy]
						   ,[CreatedDate]
						   ,[ModifiedBy]
						   ,[ModifiedDate]
						   ,[FUTATaxDepositStatusId]
						   ,[FUTATaxDepositAmount]
						   ,[FUTATaxStatusDate]
						   ,[FUTATaxConfirmation]
						   ,[SSPayableAmount]
						   ,[FUTATaxDepositDate]
						   ,[MedPayableAmount]
						   ,[FederalTaxDepositDate]
						   ,[HaciendaTaxDepositDate]
						   ,[BatchTypeName]
						   ,[PayWeekNum]
						   ,[StartDate]
						   ,[EndDate]
						   ,[DirectDepositAmount]
						   ,[CheckDepositAmount]
						   ,[FederalTaxDepositScheduleId]
						   ,[HaciendaTaxDepositScheduleId]
						   ,[FUTATaxDepositScheduleId]
						   ,[ClosedbyName]
						   ,[PaymentStatusByName]
						   ,[PaymentStatusDate]
						   ,[PayrollSummaryRptName]
						   ,[PaymentConfirmationRptName]
						   ,[FederalTaxEFTPSNo]
						   ,[FederalTaxStatusByName]
						   ,[FederalTaxRptName]
						   ,[HaciendaTaxReceiptNo]
						   ,[HaciendaTaxStatusByName]
						   ,[HaciendaTaxRptName]
						   ,[FUTATaxReceiptNo]
						   ,[FUTATaxStatusByName]
						   ,[FUTATaxRptName]
							,[HaciendaPayableAmount]
							,[FUTAPayableAmount]
							,[MedPlusPayableAmount])
					 SELECT
							strBatchID [PayrollExternalId]
						   ,strCompanyName [CompanyName]
						   ,strBatchDescription [PayrollName]
						   ,dtPayDate [PayDate]
						   ,case intBatchStatus when -1 then 1 else 2 END [PayrollStatusId]
						   ,decBatchCompensationAmount [Compensations]
						   ,-decBatchDeductionAmount [Withholdings]
						   ,-isnull(dbo.fnPay_BatchTotalContributions(strBatchID),0) [Contributions]
						   ,1 [PaymentStatusId]
						   ,1 [FederalTaxDepositStatusId]
						   ,NULL  [FederalTaxDepositAmount]
						   ,NULL [FederalTaxStatusDate]
						   ,1 [HaciendaTaxDepositStatusId]
						   ,NULL  [HaciendaTaxDepositAmount]
						   ,NULL [HaciendaTaxStatusDate]
						   , strBatchTypeName [PayrollTypeName]
							 ,IIF(intTemplateID = 0,''REGULAR'',''TEMPLATE'') [TemplateTypeName]
						   ,NULL [CompanyPayrollSummary]
						   ,NULL [PaymentConfirmation]
						   ,NULL [FederalTaxConfirmation]
						   ,NULL [HaciendaTaxConfirmation]
						   ,ClosedByUserID [ClosedBy]
						   ,ClosedDateTime [ClosedDate]
						   ,1 [DataEntryStatus]
						   ,IIF(intCreatedByID IS NULL, NULL,(select name from tuser where id = intCreatedByID) )   [CreatedByName]
						   ,intCreatedByID [CreatedBy]
						   ,dtBatchCreated [CreatedDate]
						   ,NULL [ModifiedBy]
						   ,NULL [ModifiedDate]
						   ,NULL [FUTATaxDepositStatusId]
						   ,NULL [FUTATaxDepositAmount]
						   ,NULL [FUTATaxStatusDate]
						   ,NULL [FUTATaxConfirmation]

						   ,-isnull((select sum(decWithholdingsAmount) from tblUserBatchWithholdings ubw
						   where ubw.strBatchID = b.strBatchID and strWithHoldingsName in (''FICA SS'')  ),0) -
						    isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings cbw
						   where cbw.strBatchID = b.strBatchID and cbw.strWithHoldingsName in (''FICA SS'')  ),0) [SSPayableAmount]
						   ,NULL [FUTATaxDepositDate]

						   ,-isnull((select sum(decWithholdingsAmount) from tblUserBatchWithholdings ubw
						   where ubw.strBatchID = b.strBatchID and strWithHoldingsName in (''FICA MED'')  ),0) -
						    isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings cbw
						   where cbw.strBatchID = b.strBatchID and cbw.strWithHoldingsName in (''FICA MED'')  ),0)  [MedPayableAmount]

						   ,NULL [FederalTaxDepositDate]
						   ,NULL [HaciendaTaxDepositDate]
							, strBatchTypeName [BatchTypeName]
						   ,ISNULL((select top(1) intPayWeekNum from tbluserbatch ub where ub.strBatchID = b.strBatchID ),0) [PayWeekNum]
						   ,ISNULL((select top(1) dtStartDatePeriod from tbluserbatch ub where ub.strBatchID = b.strBatchID ),0)[StartDate]
						   ,ISNULL((select top(1) dtEndDatePeriod from tbluserbatch ub where ub.strBatchID = b.strBatchID ),0)[EndDate]
						   ,ISNULL((select sum(decCheckAmount) from tblUserPayChecks upc where upc.strBatchID = b.strBatchID and intPayMethodType =2),0) [DirectDepositAmount]
						   ,ISNULL((select sum(decCheckAmount) from tblUserPayChecks upc where upc.strBatchID = b.strBatchID and intPayMethodType =1),0) [CheckDepositAmount]
						   ,(select FederalTaxDepositScheduleId from tblCompanyOptions co where co.strCompanyName = b.strCompanyName) [FederalTaxDepositScheduleId]
						   ,(select HaciendaTaxDepositScheduleId from tblCompanyOptions co where co.strCompanyName = b.strCompanyName)  [HaciendaTaxDepositScheduleId]
						   ,(select FUTATaxDepositScheduleId from tblCompanyOptions co where co.strCompanyName = b.strCompanyName)   [FUTATaxDepositScheduleId]
						   ,IIF(ClosedByUserID IS NULL, NULL,(select name from tuser where id = ClosedByUserID) )  [ClosedbyName]
						   ,NULL [PaymentStatusByName]
						   ,NULL [PaymentStatusDate]
						   ,NULL [PayrollSummaryRptName]
						   ,NULL [PaymentConfirmationRptName]
						   ,NULL [FederalTaxEFTPSNo]
						   ,NULL [FederalTaxStatusByName]
						   ,NULL [FederalTaxRptName]
						   ,NULL [HaciendaTaxReceiptNo]
						   ,NULL [HaciendaTaxStatusByName]
						   ,NULL [HaciendaTaxRptName]
						   ,NULL [FUTATaxReceiptNo]
						   ,NULL [FUTATaxStatusByName]
						   ,NULL [FUTATaxRptName]
						   ,-isnull((select sum(decWithholdingsAmount) from tblUserBatchWithholdings ubw
						   where ubw.strBatchID = b.strBatchID and strWithHoldingsName in (''ST ITAX'')  ),0) [HaciendaPayableAmount]
						   ,-isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings cbw
						   where cbw.strBatchID = b.strBatchID and strWithHoldingsName in (''FUTA'')  ),0)  [FUTAPayableAmount]
						   
						   ,-isnull((select sum(decWithholdingsAmount) from tblUserBatchWithholdings ubw
						   where ubw.strBatchID = b.strBatchID and strWithHoldingsName in (''FICA MED PLUS'')  ),0) -
						    isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings cbw
						   where cbw.strBatchID = b.strBatchID and cbw.strWithHoldingsName in (''FICA MED PLUS'')  ),0)  [MedPayableAmount]
						   FROM dbo.viewPay_Batch b
						   where strBatchID = ''@BATCHID''
					END
					ELSE
							UPDATE [tpserver].[tpdb].[dbo].[Payroll]
							SET
							[PayrollStatusId] = case intBatchStatus when -1 then 1 else 2 END 
							,[Compensations] =  dbo.fnPay_BatchTotalCompensations(b.strBatchID)  
							,[Withholdings] = -dbo.fnPay_BatchTotalWithholdings(b.strBatchID) 
							,[Contributions] = -isnull(dbo.fnPay_BatchTotalContributions(strBatchID),0) 
							,[ClosedBy] = ClosedByUserID 
							,[ClosedDate] = ClosedDateTime 
							,[SSPayableAmount] =-isnull((select sum(decWithholdingsAmount) from tblUserBatchWithholdings ubw
									where ubw.strBatchID = b.strBatchID and strWithHoldingsName in (''FICA SS'')  ),0) -
									isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings cbw
									where cbw.strBatchID = b.strBatchID and cbw.strWithHoldingsName in (''FICA SS'')  ),0)
					    
							,[MedPayableAmount] = -isnull((select sum(decWithholdingsAmount) from tblUserBatchWithholdings ubw
								   where ubw.strBatchID = b.strBatchID and strWithHoldingsName in (''FICA MED'')  ),0) -
									isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings cbw
								   where cbw.strBatchID = b.strBatchID and cbw.strWithHoldingsName in (''FICA MED'')  ),0)
							,[DirectDepositAmount] = ISNULL((select sum(decCheckAmount) from tblUserPayChecks upc where upc.strBatchID = b.strBatchID and intPayMethodType =2),0) 
							,[CheckDepositAmount] =ISNULL((select sum(decCheckAmount) from tblUserPayChecks upc where upc.strBatchID = b.strBatchID and intPayMethodType =1),0) 
							,[FederalTaxDepositScheduleId] = (select FederalTaxDepositScheduleId from tblCompanyOptions co where co.strCompanyName = b.strCompanyName) 
							,[HaciendaTaxDepositScheduleId] =(select HaciendaTaxDepositScheduleId from tblCompanyOptions co where co.strCompanyName = b.strCompanyName)  
							,[FUTATaxDepositScheduleId] =(select FUTATaxDepositScheduleId from tblCompanyOptions co where co.strCompanyName = b.strCompanyName)   
							,[ClosedbyName] = IIF(ClosedByUserID IS NULL, NULL,(select name from tuser where id = ClosedByUserID) )  
							,[HaciendaPayableAmount] =-isnull((select sum(decWithholdingsAmount) from tblUserBatchWithholdings ubw
							where ubw.strBatchID = b.strBatchID and strWithHoldingsName in (''ST ITAX'')  ),0) 
							,[FUTAPayableAmount] =isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings cbw
							where cbw.strBatchID = b.strBatchID and strWithHoldingsName in (''FUTA'')  ),0)  

							,[MedPlusPayableAmount] = isnull((select sum(decWithholdingsAmount) from tblUserBatchWithholdings ubw
								   where ubw.strBatchID = b.strBatchID and strWithHoldingsName in (''FICA MED PLUS'')  ),0) +
									isnull((select sum(decWithholdingsAmount) from tblCompanyBatchWithholdings cbw
								   where cbw.strBatchID = b.strBatchID and cbw.strWithHoldingsName in (''FICA MED PLUS'')  ),0)

							FROM dbo.tblbatch b inner join [tpserver].[tpdb].[dbo].[Payroll] P 
							ON b.strBatchID = p.PayrollExternalId
							where b.strBatchID = ''@BATCHID''
					'
				SET @SQL = REPLACE (@SQL,'@BATCHID',@BATCHID)
			IF @PayrollCenterServer = ''
				SET @SQL = REPLACE( REPLACE (@SQL,'[tpserver].',@PayrollCenterServer) ,'tpdb',@PayrollCenterDatabase)
			ELSE
				SET @SQL = REPLACE( REPLACE (@SQL,'tpserver',@PayrollCenterServer) ,'tpdb',@PayrollCenterDatabase)
				select @SQL
				exec sp_executesql @sql
		END
	END
	ELSE
	BEGIN
		--Payroll is not closed
		 SELECT   @CompanyName Company
		 ,	IIF(@IdentechPayrollId <> 2,'Not Identech Payroll','Identech Payroll') Identech
		 ,IIF(@PayrollStatus <> -1,'Payroll Not Closed','Closed') PayrollState

	END

	END TRY
BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 

END CATCH
END
GO
