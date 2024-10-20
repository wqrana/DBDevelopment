USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPayrollWagesReport]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 04/21/2023
-- Description:	Wages Report By Dates Function
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblPayrollWagesReport]
(	
	-- Add the parameters for the function here
	@PayrollCompany nvarchar(50),
	@STARTDATE date,
	@ENDDATE date
)
RETURNS TABLE 
AS
RETURN 
(

	-- Compensations in order stated
		SELECT strBatchID, intUserID, ubc.strCompensationName, decPayRate, decHours, decPay, dtTimeStamp, ubc.strGLAccount, intReportOrder, strCompanyName, strBatchDescription, dtPayDate, intPayWeekNum, strUserName, intDepartmentID, intSubdepartmentID, intEmployeeTypeID, strCompany, strDepartment, strSubdepartment, strEmployeeType, sSSN, intSequenceNumber, intEditType, boolDeleted, strEditDescription, intUBMESequence 
		FROM [viewPay_UserBatchCompensations] ubc inner join tblCompensationItems ci on ubc.strCompensationName = ci.strCompensationName  
		WHERE 
		strCompanyName = @PayrollCompany AND dtPayDate between @STARTDATE and @ENDDATE and intCompensationType = 1 
	
	
)


GO
