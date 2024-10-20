USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblSubdepartmentGLSplit_Benefits]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	GL Spit for Autogermana
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblSubdepartmentGLSplit_Benefits]
(	
	@PayrollCompany nvarchar(50),
	@Amount decimal(18,5),
	@intSubDepartmentID int,
	@WithholdingsName nvarchar(50)
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
	--Check that withholding is in list
	if @WithholdingsName in ('HEALTH INS' )
		BEGIN
		insert INTO @tblSubdepartmentGLSplit
		select strGLAccount,  [decGlPercent], @Amount* [decGlPercent]/100 FROM  [tblSubdepartmentGLSplit_benefits] where intSubDepartmentID = @intSubDepartmentID
		END
	
	RETURN
END

GO
