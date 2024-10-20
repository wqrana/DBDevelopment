USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Update_GLHistory]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 04/20/2020
-- Description:	Updates the GL Accounts for a Payroll Company History
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Update_GLHistory]
	-- Add the parameters for the stored procedure here
	  @COMPANYNAME as nvarchar(50),
      @FROMDATE as date,
	  @SUPERVISORID as int,
	  @SUPERVISORNAME as nvarchar(50)
-- WITH ENCRYPTION
AS
BEGIN
BEGIN TRY

	UPDATE ubc SET strglaccount = uci.strglaccount from tblUserBatchCompensations ubc inner join tblUserCompensationItems uci 
	on ubc.strCompensationName = uci.strCompensationName and ubc.intUserID = uci.intUserID and ubc.strBatchID in
	 (select strBatchID from tblBatch where strCompanyName = @COMPANYNAME)
	and dtPayDate >= @FROMDATE
	
	UPDATE ubc  SET strglaccount = uci.strglaccount from tblUserBatchWithholdings ubc inner join tblUserWithholdingsItems uci 
	on ubc.strWithHoldingsName = uci.strWithHoldingsName and ubc.intUserID = uci.intUserID and ubc.strBatchID in
	 (select strBatchID from tblBatch where strCompanyName = @COMPANYNAME)
	and dtPayDate >= @FROMDATE

	UPDATE ubc  SET strglaccount = uci.strGLAccount_Contributions, strGLContributionPayable = uci.strGLContributionPayable from tblCompanyBatchWithholdings ubc inner join tblUserWithholdingsItems uci 
	on ubc.strWithHoldingsName = uci.strWithHoldingsName and ubc.intUserID = uci.intUserID and ubc.strBatchID in
	 (select strBatchID from tblBatch where strCompanyName = @COMPANYNAME)
	and dtPayDate >= @FROMDATE

END TRY
BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 


END CATCH
END


GO
