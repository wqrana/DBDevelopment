USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_UserWithholdingsItemsFromCompany]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 10/3/2016
-- Description:	Creates user Withholdings to all users that do not have them
-- =============================================

CREATE PROCEDURE [dbo].[spPay_Create_UserWithholdingsItemsFromCompany]
	  @COMPANY_NAME as nvarchar(50),
	  @WITHHOLDINGS_NAME as nvarchar(50),
	  @PAYROLL_USER_STATUS as int,
	  @SUPERVISORID as int,
	  @SUPERVISORNAME as nvarchar(50)
-- WITH ENCRYPTION
AS

BEGIN
BEGIN TRY
	SET NOCOUNT OFF 

-- Applies ALL Company Compensation Items to All Users having a Payroll User Status (Active, Inactive, etc)
	INSERT INTO dbo.tblUserWithholdingsItems 
	 (intUserID, strWithHoldingsName, strDescription, decEmployeePercent, decEmployeeAmount, decCompanyPercent, decCompanyAmount, decMaximumSalaryLimit, 
	 decMinimumSalaryLimit, boolDeleted, strGLAccount, strClassIdentifier, intGLLookupField, strContributionsName, strGLAccount_Contributions)
	select ucp.intUserID,cc.strWithHoldingsName ,cc.strDescription ,cc.decEmployeePercent, cc.decEmployeeAmount, cc.decCompanyPercent, cc.decCompanyAmount, cc.decMaximumSalaryLimit, 
			   cc.decMinimumSalaryLimit, cc.boolDeleted, cc.strGLAccount, strClassIdentifier, cc.intGLLookupField, cc.strContributionsName, cc.strGLAccount_Contributions
	from tblCompanyWithholdings cc inner join tblUserCompanyPayroll ucp on cc.strCompanyName = ucp.strCompanyName
	left outer join tblUserWithholdingsItems uci on cc.strWithHoldingsName = uci.strWithHoldingsName and ucp.intUserID = uci.intUserID
	where  uci.strWithHoldingsName is null and ucp.strCompanyName = @COMPANY_NAME and ucp.intPayrollUserStatus = @PAYROLL_USER_STATUS
	AND cc.strWithHoldingsName = @WITHHOLDINGS_NAME

END TRY
BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 

END CATCH
END


GO
