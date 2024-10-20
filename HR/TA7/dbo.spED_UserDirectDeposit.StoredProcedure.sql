USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_UserDirectDeposit]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <6/6/2024>
-- Description:	<To extract data for User Direct Deposit excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_UserDirectDeposit]
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
	'' as [Direct Deposit Start Date],
	'' as [Direct Deposit End Date],
	'' as [Bank Deposit Deduction Code],
	case userDDInfo.intAccountType
	 When 1  Then 'C' -- checking
	 When 2  Then 'S'-- Saving
	 else ''
	end as [Bank Deposit Type],
	CONCAT('''',strBankRoutingNumber) as [Bank Deposit Transit/ABA],
	CONCAT('''',strBankAccountNumber) as [Bank Deposit Account Number],
	case
	When userDDInfo.decDepositPercent=100.00 then 'Y'
	Else 'N'
	end as [Bank Full Deposit Flag],
	case
	When userDDInfo.decDepositPercent=100.00 then null
	Else 
	iif(userDDInfo.decDepositAmount>0,userDDInfo.decDepositAmount,null)
	end as [Bank Deposit Deduction Amount],
	
	case
	When userDDInfo.decDepositPercent=100.00 then null
	Else 
	iif(userDDInfo.decDepositPercent>0 and userDDInfo.decDepositPercent<100,userDDInfo.decDepositPercent,null)
	end as [Bank Deposit Percent Net],

	case
	when userDDInfo.decDepositAmount>0 then '$'
	When userDDInfo.decDepositPercent>0 then '%'
	end as [Bank Deposit Amount Type Percentage % or Dollar $],
	'' as [Bank Deposit Prenote Code],
	'' as [Bank Deposit Prenote Date]

FROM viewPay_UserRecord userInfo
INNER JOIN tblUserDirectDeposit userDDInfo ON userDDInfo.intUserID = userInfo.intUserID
INNER JOIN tblBankAccountTypes accTypes ON userDDInfo.intAccountType = accTypes.intBankAccountType
Where decDepositPercent>0 or decDepositAmount>0
Order by userInfo.strCompanyName, userInfo.intUserID
 
END
GO
