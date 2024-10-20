USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPayrollCompanyDepartments]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		2016-04-21
-- Description:		Gets the data for 401K report.  Uses the Withholdings  Qualifier 0 to determine which withholdings apply.
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblPayrollCompanyDepartments]
(
	@PayrollCompany as nvarchar(50)
)
RETURNS @tblDepartments TABLE 
(
intDepartmentID  int, 
strDepartmentName nvarchar(50)
)
-- WITH ENCRYPTION
AS
BEGIN

	--Use the Batch End Date to know YTD
	INSERT INTO @tblDepartments
	SELECT ID, Name from tDept where  nCompanyID in (
		select nCompanyID from tblCompanyPayrollRules cpr inner join tPayrollRule pr on cpr.intPayrollRule = pr.ID
		where strPayrollCompany = @PayrollCompany) ORDER BY Name ASC
	RETURN
END


GO
