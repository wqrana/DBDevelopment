USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblYearToDateUserWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	Returnd the YearToDate Withholdings of an User
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblYearToDateUserWithholdings]
(	
	-- Add the parameters for the function here
	@USERID int,
	@SEARCHDATE datetime,
	@CompanyName nvarchar(50)
)
RETURNS 
@YTDUserWithholdings TABLE 
(
	intUserID  int,
	strWithHoldingsName nvarchar(50),
	strDescription nvarchar(50),
	decWithholdingsYTD decimal(18,5)
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Add the SELECT statement with parameter references here
	insert into @YTDUserWithholdings
	SELECT intUserID, strWithHoldingsName, strDescription, [dbo].[fnPay_YearToDateUserBatchWithholdings](intUserID,strWithHoldingsName,@SEARCHDATE,@CompanyName)  as decWithholdingsYTD
	FROM [dbo].[tblUserWithholdingsItems] where intUserID = @USERID 
	RETURN
END

GO
