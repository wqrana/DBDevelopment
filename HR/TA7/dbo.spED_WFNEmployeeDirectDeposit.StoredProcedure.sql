USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_WFNEmployeeDirectDeposit]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <6/6/2024>
-- Description:	<To extract data for WFNEmployee Direct Deposit excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_WFNEmployeeDirectDeposit]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Drop table if exists #DDAccountInfo
	SELECT 
		userDDInfo.intUserID,
		ROW_NUMBER() OVER(PARTITION BY intUserID ORDER BY intSequenceNumber) as SeqId,
		strBankRoutingNumber, 
		strBankAccountNumber,
		case
		When IsNull(userDDInfo.decDepositPercent,0)=100.00 then 'Y'
		Else 'N'
		end as FullDepositFlag,
		case
		When userDDInfo.decDepositPercent=100.00 then null
		Else 
		iif(userDDInfo.decDepositAmount>0,userDDInfo.decDepositAmount,null)
		end as DepositDeductionAmount,	
		case
		When userDDInfo.decDepositPercent=100.00 then null
		Else 
		iif(userDDInfo.decDepositPercent>0 and userDDInfo.decDepositPercent<100,userDDInfo.decDepositPercent,null)
		end as DepositPercentNet
	INTO #DDAccountInfo
	FROM tblUserDirectDeposit userDDInfo 
	INNER JOIN tblBankAccountTypes accTypes ON userDDInfo.intAccountType = accTypes.intBankAccountType
	Where decDepositPercent>0 or decDepositAmount>0


SELECT 
	userInfo.strCompanyName as [Company Code],		
	userInfo.[name] as [Employee Name],
	userInfo.intUserId as [Position ID],
	'' as [Change Effective On],
	--1
	'' as [Bank Deposit Deduction Code1],
	( select DepositDeductionAmount 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=1	
	 ) as  [Bank Deposit Deduction Amount1],

	( select DepositPercentNet 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=1	
	 )  as [Bank Deposit Percent Net1],
	( select Concat('''',strBankRoutingNumber) 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=1	
	 ) as [Bank Deposit Transit/ABA1],
	( select Concat('''',strBankAccountNumber) 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=1	
	 ) as [Bank Deposit Account Number1],
	( select FullDepositFlag 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=1	
	 ) as [Bank Full Deposit Flag1],
	--2
	'' as [Bank Deposit Deduction Code2],
	( select DepositDeductionAmount 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=2	
	 ) as  [Bank Deposit Deduction Amount2],

	( select DepositPercentNet 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=2	
	 )  as [Bank Deposit Percent Net2],
	( select Concat('''',strBankRoutingNumber) 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=2	
	 ) as [Bank Deposit Transit/ABA2],
	( select Concat('''',strBankAccountNumber) 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=2	
	 ) as [Bank Deposit Account Number2],
	( select FullDepositFlag 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=2	
	 ) as [Bank Full Deposit Flag2],
	--3
	'' as [Bank Deposit Deduction Code3],
	( select DepositDeductionAmount 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=3	
	 ) as  [Bank Deposit Deduction Amount3],

	( select DepositPercentNet 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=3	
	 )  as [Bank Deposit Percent Net3],
	( select Concat('''',strBankRoutingNumber) 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=3	
	 ) as [Bank Deposit Transit/ABA3],
	( select Concat('''',strBankAccountNumber) 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=3	
	 ) as [Bank Deposit Account Number3],
	( select FullDepositFlag 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=3
	 ) as [Bank Full Deposit Flag3],
	--4
	'' as [Bank Deposit Deduction Code4],
	( select DepositDeductionAmount 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=4	
	 ) as  [Bank Deposit Deduction Amount4],

	( select DepositPercentNet 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=4	
	 )  as [Bank Deposit Percent Net4],
	( select Concat('''',strBankRoutingNumber) 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=4	
	 ) as [Bank Deposit Transit/ABA4],
	( select Concat('''',strBankAccountNumber) 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=4	
	 ) as [Bank Deposit Account Number4],
	( select FullDepositFlag 
	  From #DDAccountInfo
	  Where intUserID = userInfo.intUserID and SeqId=4
	 ) as [Bank Full Deposit Flag4]

FROM viewPay_UserRecord userInfo
WHERE intUserID in ( SELECT distinct intUserID from tblUserDirectDeposit)
Order by userInfo.strCompanyName, userInfo.intUserID
 
END
GO
