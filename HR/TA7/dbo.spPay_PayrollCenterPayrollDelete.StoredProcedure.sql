USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_PayrollCenterPayrollDelete]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 2/10/2022
-- Description: Deletes the Payroll Entry in Payroll table of the TimeAidePayroll database
--				Additionally, adds the Company to the TimeAidePayroll database if  it does not exists
-- =============================================
CREATE PROCEDURE [dbo].[spPay_PayrollCenterPayrollDelete]
	-- Add the parameters for the stored procedure here
	  @BATCHID nvarchar(50) ,
	  @CompanyName  nvarchar(50)
AS
BEGIN
BEGIN TRY
	DECLARE @IdentechPayrollId int = 1

  --Check if Payroll is closed (-1) and whether it is processed by Identech (2)
	select @IdentechPayrollId = ISNULL(IdentechPayrollId,1) from tblCompanyOptions co 	where strCompanyName = @CompanyName
	
	IF  @IdentechPayrollId= 2--Identech Processed
	BEGIN
		DECLARE @PayrollCenterServer nvarchar(100) = ''
		DECLARE @PayrollCenterDatabase nvarchar(100) = ''
		DECLARE @SQL nvarchar(MAX)

		SELECT top(1) @PayrollCenterServer = ci.PayrollCenterServer, @PayrollCenterDatabase = PayrollCenterDatabase from ClientInfo ci
		SELECT @PayrollCenterServer PayrollCenterServer , @PayrollCenterDatabase PayrollCenterDatabase
		IF NOT @PayrollCenterServer  IS NULL OR @PayrollCenterServer = ''
		BEGIN

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
					
			SELECT @SQL					
			exec sp_executesql @sql
		END
	END

	END TRY
BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 

END CATCH
END
GO
