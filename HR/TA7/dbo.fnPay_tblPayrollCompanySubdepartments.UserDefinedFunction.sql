USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPayrollCompanySubdepartments]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:			Alexander Rivera Toro
-- Create date:		2016-04-21
-- Description:		Gets all the sub-departments related to a Payroll Company
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblPayrollCompanySubdepartments]
(
	@PayrollCompany as nvarchar(50)
)
RETURNS @tblSubdepartments TABLE 
(
intSubdepartmentID  int, 
strSubdepartmentName nvarchar(50)
)
-- WITH ENCRYPTION
AS
BEGIN

	--Use the Batch End Date to know YTD
	INSERT INTO @tblSubdepartments
	select ID,Name from tJobTitle where nDeptID = 0 
	OR nDeptID in (select intDepartmentID from dbo.[fnPay_tblPayrollCompanyDepartments](@PayrollCompany))
	ORDER BY Name ASC
	RETURN
END

GO
