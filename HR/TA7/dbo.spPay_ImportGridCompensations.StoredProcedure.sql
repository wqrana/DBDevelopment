USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_ImportGridCompensations]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPay_ImportGridCompensations]
	-- Add the parameters for the stored procedure here
	  @BATCHID nvarchar(50) 
AS
BEGIN
BEGIN TRY

DECLARE @AdditionalPayroll int 
DECLARE @TemplateID int 

SELECT @AdditionalPayroll = intBatchType, @TemplateID = intTemplateID from tblbatch where strBatchID = @BATCHID

IF @AdditionalPayroll = 1 and @TemplateID = 0
	BEGIN
					--Compute the PayChecks for all UserIDs
				DECLARE @LoopUserID int = 0
				WHILE(1 = 1)
				BEGIN
				SELECT @LoopUserID = MIN(ub.intUserID)
				FROM [dbo].[tblBatchImportCompensationAmount] ub 
				WHERE ub.strBatchID = @BATCHID and  ub.intUserID > @LoopUserID and ub.intUserID NOT IN (select intuserid from tblUserBatch where strBatchID = @BATCHID)
				IF @LoopUserID IS NULL BREAK
					EXEC	  [dbo].[spPay_Insert_UserBatch] @BATCHID  ,@LoopUserID ,0,0,'',0
				END

	END

INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID]
           ,[intUserID]
           ,[strCompensationName]
           ,[decPayRate]
           ,[dtPayDate]
           ,[decHours]
           ,[decPay]
           ,[dtTimeStamp]
           ,[strGLAccount]
           ,[boolDeleted]
           ,[intSupervisorID]
           ,[strNote]
           ,[intEditType])
SELECT imp.[strBatchID]
      ,imp.[intUserID]
	  ,imp.[strCompensationName]
	  ,0
      ,imp.[dtPayDate]
	  ,0
      ,imp.[decMoneyAmount]
	  ,getdate()
	  ,uci.strGLAccount
	  ,0
	  ,imp.intSupervisorID
	  ,'Import Grid'
	  ,1
  FROM [dbo].[tblBatchImportCompensationAmount] imp inner join tblUserCompensationItems uci 
  on imp.intuserid = uci.intUserID and imp.strCompensationName = uci.strCompensationName
  where [intImportStatus]= 0 and imp.strbatchid = @batchid


    UPDATE [dbo].[tblBatchImportCompensationAmount] set intImportStatus = 1 where strbatchid = @batchid
END TRY
BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 

		   SET @BATCHID = -1
END CATCH
END
GO
