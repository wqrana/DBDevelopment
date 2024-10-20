USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spTE_SignAndCreateTimeAndEffort]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 3/2/2021
-- Description:	Time and Effort Signature and Backup
--				Creates a backup copy of the data for the T&E sheet
-- =============================================
CREATE PROCEDURE [dbo].[spTE_SignAndCreateTimeAndEffort]
	@UserID as int,
	@MonthStart as date,
	@MonthEnd as date,
	@SignEntry as nvarchar(200),
	@SignHash as nvarchar(MAX),
	@TAEMonthlySignatureID as integer OUTPUT
AS
BEGIN
		DECLARE @PayrollCompany nvarchar(50)
		DECLARE @Month as int = month(@Monthend)
		DECLARE @Year as int = year(@monthend)

--Check that the time period has completed
IF @MonthEnd > GETDATE()
	BEGIN
		return 0
	END
ELSE
	IF NOT EXISTS (select * from tblTimeAndEffortMonthlySign where intUserID = @UserID and intYear = @Year and intMonth = @Month)
	BEGIN 

	select @PayrollCompany= strCompanyName from tblUserCompanyPayroll where intUserID = @UserID

		INSERT INTO [dbo].[tblTimeAndEffortMonthlySign]
			   ([intUserID]
			   ,[strUserName]
			   ,[intMonth]
			   ,[intYear]
			   ,[SignHash]
			   ,[SignEntry]
			   ,[SignDateTime])
		SELECT
				id 
			   ,name 
			   ,@Month 
			   ,@Year 
			   ,@SignHash
			   ,@SignEntry
			   ,getdate() 
		FROM tuser where id = @UserID
	

		--Get primary key
		SET @TAEMonthlySignatureID = SCOPE_IDENTITY()

		-- Make copy of data
		INSERT INTO [dbo].[tblTimeAndEffortMonthly]
			   ([strBatchID]
			   ,[strBatchDescription]
			   ,[intUserID]
			   ,[strUserName]
			   ,[strCompensationName]
			   ,[decPayRate]
			   ,[decHours]
			   ,[intEditType]
			   ,[dtPunchDate]
			   ,[decPay]
			   ,[strCompanyName]
			   ,[strCompany]
			   ,[strDepartment]
			   ,[strSubdepartment]
			   ,[strEmployeeType]
			   ,[intTAEMonthlySignatureID])
		SELECT 
			[strBatchID]
			   ,[strBatchDescription]
			   ,[intUserID]
			   ,[strUserName]
			   ,[strCompensationName]
			   ,[decPayRate]
			   ,[decHours]
			   ,[intEditType]
			   ,[dtPunchDate]
			   ,[decPay]
			   ,[strCompanyName]
			   ,[strCompany]
			   ,[strDepartment]
			   ,[strSubdepartment]
			   ,[strEmployeeType]
			   ,@TAEMonthlySignatureID
		FROM dbo.fnPay_tblTimeAndEffortReport('',@PayrollCompany, @MonthStart, @MonthEnd,@UserID)

		--Return the value
		return 1
		END
	ELSE
		BEGIN
		--Get the singature id
		select @TAEMonthlySignatureID = intTAEMonthlySignatureID from tblTimeAndEffortMonthlySign where intUserID = @UserID and intYear = @Year and intMonth = @Month
		--Return the value
		return 0

		END
	END
GO
