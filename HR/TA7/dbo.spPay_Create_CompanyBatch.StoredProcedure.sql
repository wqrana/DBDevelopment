USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_CompanyBatch]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 10/3/2016
-- Description:	Creates a new Batch for Payroll 
--				The sp returns the GUID for the BatchID
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Create_CompanyBatch]
	-- Add the parameters for the stored procedure here
	  @BATCHID nvarchar(50) OUTPUT,
	  @COMPANYNAME as nvarchar(50),
      @PAYROLLDESCRIPTION as nvarchar(50),
      @PAYDATE as date,
	  @SUPERVISORID as int,
	  @SUPERVISORNAME as nvarchar(50),
	  @BATCH_TYPE as int,
	  @TEMPLATEID as int
-- WITH ENCRYPTION
AS
BEGIN
Declare @tr_exist int=0
Select @tr_exist= count(distinct so.name)
From sysobjects so, syscomments sc
Where type = 'TR'
And so.id = sc.id
And so.name like '%trig_tblBatchStatus%'

BEGIN TRY
	if @tr_exist>0
	ALTER TABLE tblBatch DISABLE TRIGGER trig_tblBatchStatus;

	SET @BATCHID = NEWID()
	INSERT INTO tblBatch (strBatchID, strCompanyName, strBatchDescription, dtBatchCreated, intCreatedByID, strCreateByName, dtBatchUpdates, 
							intBatchStatus, dtPayDate,intBatchType,intTemplateID)
	VALUES				 (@BATCHID,@COMPANYNAME,@PAYROLLDESCRIPTION,GETDATE() , @SUPERVISORID,@SUPERVISORNAME,GETDATE(), 0, @PAYDATE, @BATCH_TYPE,@TEMPLATEID)

	SELECT 0 AS ErrorNumber,'' AS ErrorMessage 
END TRY
BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage 

		   SET @BATCHID = -1
END CATCH
if @tr_exist>0
	ALTER TABLE tblBatch ENABLE TRIGGER trig_tblBatchStatus;
END


GO
