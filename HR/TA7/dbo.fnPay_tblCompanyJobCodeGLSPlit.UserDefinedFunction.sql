USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCompanyJobCodeGLSPlit]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	Converts Job Codes to GL Accounts. Supports percentage splits
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblCompanyJobCodeGLSPlit]
(	
	-- Add the parameters for the function here
	@strCompanyName nvarchar(50),
	@intJobCode int,
	@decPayAmount decimal(18,5)
)
RETURNS 
@tblCompanyJobCodeGLSPlit TABLE 
(
	strCompanyName nvarchar(50),
	intJobCode int,
	strGLAccount nvarchar(50),
	decGLAmount decimal(18,2),
	decGLPercent decimal(18,2)
) 
AS
BEGIN
	-- Compensations in order stated
	insert into @tblCompanyJobCodeGLSPlit
	select 	strCompanyName, intJobCodeID, strGLAccount, convert(decimal(18,2), @decPayAmount * [decPercent]/100) decGLAmount, decPercent  from [dbo].[tblCompanyJobcodeGLLookup] tjc 
	where [intJobCodeID] = @intJobCode and [strCompanyName] = @strCompanyName
	
	DECLARE @SplitCount int
	
	select @SplitCount =  count(*) from @tblCompanyJobCodeGLSPlit
	IF @SplitCount = 0
		BEGIN
		insert into @tblCompanyJobCodeGLSPlit	
		select @strCompanyName,@intJobCode,'',@decPayAmount,100.00
		END 
	ELSE
		BEGIN
		--Check that that the split was correct
		DECLARE @SplitAmount decimal(18,2)
		select @SplitAmount = sum(decGLAmount) from @tblCompanyJobCodeGLSPlit
		if @SplitAmount <> @decPayAmount
			BEGIN
			--Adjust the first entry
				UPDATE top(1) @tblCompanyJobCodeGLSPlit set decGLAmount = decGLAmount + (@decPayAmount -@SplitAmount ) 
			END
		END

	RETURN
END

GO
