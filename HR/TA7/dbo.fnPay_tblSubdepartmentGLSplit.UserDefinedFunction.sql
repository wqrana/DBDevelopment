USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblSubdepartmentGLSplit]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	GL Spit for Autogermana
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblSubdepartmentGLSplit]
(	
	@PayrollCompany nvarchar(50),
	@Amount decimal(18,5),
	@intSubDepartmentID int,
	@CompensationName nvarchar(50)
)
RETURNS 
@tblSubdepartmentGLSplit TABLE 
(
	strGLAccount nvarchar(50),
	decGlPercent decimal(18,2),
	decPay decimal(18,2)
) 
AS
BEGIN
	-- Compensations in order stated
	--If this is a lookup compensation, then check for split
		if (select intGLLookupField from tblCompanyCompensations where strCompensationName = @CompensationName and strCompanyName = @PayrollCompany) > 0
		BEGIN
		insert INTO @tblSubdepartmentGLSplit
		select strGLAccount,  [decGlPercent], @Amount* [decGlPercent]/100 FROM  [tblSubdepartmentGLSplit] where intSubDepartmentID = @intSubDepartmentID
		END
	
	RETURN
END

GO
