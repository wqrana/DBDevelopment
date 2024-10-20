USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_UserCompensationItemsFromCompany]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 10/3/2016
-- Description:	Applies a compensation to  all the users of a specific PayrollUserStatus
--				The sp returns the GUID for the BatchID
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Create_UserCompensationItemsFromCompany]
	  @COMPANY_NAME as nvarchar(50),
	  @COMPENSATION_NAME as nvarchar(50),
	  @PAYROLL_USER_STATUS as int,
	  @SUPERVISORID as int,
	  @SUPERVISORNAME as nvarchar(50)
-- WITH ENCRYPTION
AS

BEGIN
BEGIN TRY
	SET NOCOUNT OFF 

-- Applies ALL Company Compensation Items to All Users having a Payroll User Status (Active, Inactive, etc)
	INSERT INTO dbo.tblUserCompensationItems 
	 (intUserID  ,strCompensationName ,strDescription ,intCompensationType,intComputationType,boolEnabled
			   ,decHourlyRate ,decMoneyAmount ,intGLLookupField ,strGLAccount ,intPeriodEntryID)
	select ucp.intUserID,cc.strCompensationName ,cc.strDescription ,cc.intCompensationType,cc.intComputationType,cc.boolEnabled
			   ,0 as decHourlyRate , 0 as decMoneyAmount , 0 as intGLLookupField ,cc.strGLAccount , 0 as intPeriodEntryID
	from tblCompanyCompensations cc inner join tblUserCompanyPayroll ucp on cc.strCompanyName = ucp.strCompanyName
	left outer join tblUserCompensationItems uci on cc.strCompensationName = uci.strCompensationName and ucp.intUserID = uci.intUserID
	where  uci.strCompensationName is null and ucp.strCompanyName = @COMPANY_NAME and ucp.intPayrollUserStatus = @PAYROLL_USER_STATUS
	AND cc.strCompensationName = @COMPENSATION_NAME

END TRY
BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 

END CATCH
END


GO
