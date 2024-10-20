USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblYearToDateUserCompensations]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/18/2016
-- Description:	Returnd the YearToDate Compensations of an User
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblYearToDateUserCompensations]
(	
	-- Add the parameters for the function here
	@USERID int,
	@SEARCHDATE datetime,
	@CompanyName nvarchar(50)
)
RETURNS 
@YTDUserCompensations TABLE 
(
	intUserID  int,
	strCompensationName nvarchar(50),
	strDescription nvarchar(50),
	decPayYTD decimal(18,5)
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Add the SELECT statement with parameter references here
	insert into @YTDUserCompensations
	SELECT intUserID, strCompensationName, strDescription, [dbo].[fnPay_YearToDateUserBatchcompensations](intUserID,strCompensationName,@SEARCHDATE,@CompanyName)  as decPayYTD
	FROM [dbo].[tblUserCompensationItems] WHERE (intUserID = @USERID OR @USERID = 0) 

	RETURN
END

GO
