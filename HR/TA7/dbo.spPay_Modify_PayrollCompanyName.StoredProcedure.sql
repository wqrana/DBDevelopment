USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Modify_PayrollCompanyName]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 10/3/2016
-- Description:	Modifies the name of a Payroll Company
--				The sp returns the GUID for the BatchID
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Modify_PayrollCompanyName]
	-- Add the parameters for the stored procedure here
	  @OLD_COMPANYNAME as nvarchar(50),
	  @NEW_COMPANYNAME as nvarchar(50),
	  @SUPERVISORID as int,
	  @SUPERVISORNAME as nvarchar(50)
-- WITH ENCRYPTION
AS

BEGIN
BEGIN TRY
	UPDATE tblBatch SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblCompanyBankAccounts  SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblCompanyCompensations  SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblCompanyGLAccountCategory  SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblCompanyGLAccountMode  SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblCompanyLogo  SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblCompanyPayrollInformation  SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblCompanyPayrollSchedules  SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblCompanySchedulesProcessed  SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblCompanyWithholdings  SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblEzCheckConfiguration  SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblGLAccounts SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME 
	UPDATE tblPaymentSchedule SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE tblUserCompanyPayroll  SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE	[tblCompanyPayrollRules] SET strPayrollCompany = @NEW_COMPANYNAME WHERE strPayrollCompany = @OLD_COMPANYNAME

	UPDATE	tblChristmasBonusTransactions SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE	tblCompanyFileInfo SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE	tblCompanyGLAccountLookup SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE	tblCompanyVoidedChecks SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE	tblPayrollExportFormats SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME
	UPDATE	tblPayCycleLog SET strPayrollCompany = @NEW_COMPANYNAME WHERE strPayrollCompany = @OLD_COMPANYNAME
	UPDATE	tblPayrollTemplates SET strCompanyName = @NEW_COMPANYNAME WHERE strCompanyName = @OLD_COMPANYNAME

RETURN @@ROWCOUNT
END TRY
BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 

END CATCH
END

GO
