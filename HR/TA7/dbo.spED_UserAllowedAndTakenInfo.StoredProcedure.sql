USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_UserAllowedAndTakenInfo]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <6/4/2024>
-- Description:	<To extract data for User AllowedAndTakenInfo excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_UserAllowedAndTakenInfo]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @YSDate datetime = Cast(concat('01/01/',year(getdate())) as datetime)
Declare @YTDate datetime = Getdate()

SELECT 
	userInfo.strCompanyName as [Company Name],
	strEIN as [Company Federal ID],
	userInfo.intUserId as [File #/Employee ID],
	userInfo.[name] as [Employee Full Name],
	Case Len(sSSN) When 9 Then format(CAST(sSSN as int),'###-##-####') Else sSSN End as [Social Security Number],
	CONCAT(accrType.sAccrualCodeID,'|',accrType.sAccrualTypeDesc) as [Allowed/Taken Code/Description],
	'NA' as [Allowed Amount],
	AllowedATakenInfo.[Used Hours] as [Taken Amount],
	AllowedATakenInfo.[End Balance] as [Balance Amount]

FROM viewPay_UserRecord userInfo
INNER JOIN( Select * 
			From tUserCompensationRules ucr
			Cross Apply
			[dbo].[fnCompensationBalanceReport_Extended]  (        	  
			   ucr.nUserID,  	  
			   ucr.sAccrualType,  	  
			   @YSDate,  	  
			   @YTDate)) AllowedATakenInfo on  AllowedATakenInfo.nUserID = userInfo.intUserID and AllowedATakenInfo.[Start Balance]>0
INNER JOIN tAccrualTypes accrType on accrType.sAccrualCodeID = AllowedATakenInfo.[Accrual Type]
Order by userInfo.strCompanyName, userInfo.intUserID
 
END
GO
