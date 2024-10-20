USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_UserAdditionalEarningsInfo]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <6/4/2024>
-- Description:	<To extract data for User AdditionalEarningsInfo excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_UserAdditionalEarningsInfo]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

SELECT 
	userInfo.strCompanyName as [Company Name],
	strEIN as [Company Federal ID],
	userInfo.intUserId as [File #/Employee ID],
	userInfo.[name] as [Employee Full Name],
	Case Len(sSSN) When 9 Then format(CAST(sSSN as int),'###-##-####') Else sSSN End as [Social Security Number],
	'' as [Additional Earnings Start Date],
	--CONCAT('<',strCompensationName,'>') as [Additional Earnings Code],
	strCompensationName as [Additional Earnings Code],
	--CONCAT('<',strCompensationName,'>') as [Additional Earnings Description],
	strCompensationName as [Additional Earnings Description],
	--CONCAT('<',decMoneyAmount,'>') as [Additional Earnings Amount]
	decMoneyAmount as [Additional Earnings Amount],
	userCompenInfo.strPeriodEntryName as [Additional Earnings Frequency],
	Case
	When userCompenInfo.intCompensationType=1 Then 'fully taxable'
	else
	'exempt from taxes'
	End	as [Additional Earnings Taxability]
	--STUFF (
	--(SELECT ','+ CONCAT('<',LEFT(strCompensationName,3),'>') FROM viewPay_UserCompensationsRecord where decMoneyAmount>0 and intUserID=userInfo.intUserID  FOR XML PATH (''),type
 --   ).value('(./text())[1]','varchar(max)'),1,1,'') as [Additional Earnings Code],
	--STUFF (
	--(SELECT ','+ CONCAT('<',strCompensationName,'>') FROM viewPay_UserCompensationsRecord where  decMoneyAmount>0 and intUserID=userInfo.intUserID  FOR XML PATH (''),type
 --   ).value('(./text())[1]','varchar(max)'),1,1,'') as [Additional Earnings Description],
	--STUFF (
	--(SELECT ','+ CONCAT('<',decMoneyAmount,'>') FROM viewPay_UserCompensationsRecord where  decMoneyAmount>0 and intUserID=userInfo.intUserID  FOR XML PATH (''),type
 --   ).value('(./text())[1]','varchar(max)'),1,1,'') as [Additional Earnings Amount]


FROM viewPay_UserRecord userInfo
INNER JOIN viewPay_UserCompensationsRecord userCompenInfo ON userCompenInfo.intUserID = userInfo.intUserID
WHERE decMoneyAmount>0
Order by userInfo.strCompanyName, userInfo.intUserID
 
END
GO
