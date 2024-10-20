USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblUserPayrollCompanyRestrictions]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 2/24/2019
-- Description:	Gets the Payroll Companies the User is Allowed to Access
-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblUserPayrollCompanyRestrictions]
(
	@UserID as int
)
RETURNS 
@tblUserPayrollCompanyRestrictions TABLE 
(
	intUserID  int,
	strCompanyName nvarchar(50)
) 
-- WITH ENCRYPTION
AS
BEGIN
IF @UserID IN (6666) 
BEGIN
	INSERT INTO @tblUserPayrollCompanyRestrictions 
	Select @UserID,strCompanyName from tblCompanyPayrollInformation
END
ELSE
BEGIN
	INSERT INTO @tblUserPayrollCompanyRestrictions 
	select ucr.intuserid, ucr.strcompanyname from tblUserPayrollCompanyRestrictions ucr inner join tblCompanyPayrollInformation cpi ON ucr.strcompanyname = cpi.strCompanyName
	WHERE ucr.intUserid = @UserID
	if @@ROWCOUNT = 0
		BEGIN
			INSERT INTO @tblUserPayrollCompanyRestrictions 
			select @UserID, strCompanyName  from tblCompanyPayrollInformation
		END

END
RETURN
END

GO
