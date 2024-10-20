USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_CompensationsFromTemplateID]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 10/3/2016
-- Description:	Creates a new Batch for Payroll 
--				The sp returns the GUID for the BatchID
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Create_CompensationsFromTemplateID]
	-- Add the parameters for the stored procedure here
	  @BATCHID nvarchar(50),
	  @SUPERVISORID as int,
	  @SUPERVISORNAME as nvarchar(50)
-- WITH ENCRYPTION
AS

BEGIN
BEGIN TRY
		DECLARE  @PAYDATE as date
		DECLARE  @TEMPLATEID as int

		SELECT @PAYDATE =  dtPayDate, @TEMPLATEID =  intTemplateID from tblBatch WHERE strBatchID = @BATCHID
		IF NOT @PAYDATE IS NULL
		BEGIN
			INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry] (strBatchID, intUserID, strCompensationName, decPayRate, dtPayDate, decHours, decPay, strGLAccount, boolDeleted, intSupervisorID, strNote, intEditType)
			SELECT @BATCHID, ptuc.intUserID, ptuc.strCompensationName,0,@PAYDATE,0,0,  uci.strGLAccount,0,@SUPERVISORID, 'Template Entry',1
			FROM [dbo].[tblPayrollTemplatesUserCompensations] ptuc inner join tblUserCompensationItems uci on ptuc.intUserID = uci.intUserID and ptuc.strCompensationName = uci.strCompensationName
			WHERE intPayrollTemplateID = @TemplateID and ptuc.intUserID in (select intUserID from tblUserBatch where strBatchID = @BATCHID)
		END
END TRY
BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 


END CATCH
END


GO
