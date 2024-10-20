USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPayrollVerification]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 2/25/2022
-- Description:	Function to check possible errors in Payroll.
--				Returns a grid of errors and observations.
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblPayrollVerification]
(
	-- Add the parameters for the function here
	@BATCHID nvarchar(50) 
)
RETURNS 
@PayrollVerification TABLE 
(
	-- Add the column definitions for the TABLE variable here
	intUserID int,
	strUsername nvarchar(50),
	strFieldName nvarchar(200),
	strFieldValue nvarchar(200)
)
AS
BEGIN

----INSERT INTO @PayrollVerification 
----select 0, strCompanyName,strBatchDescription, dtPayDate from tblBatch where strBatchID = @BATCHID 

----Paycheck checks
----		Negative Checks 
INSERT INTO @PayrollVerification 
select intUserID,strUserName, 'Negative Pay Checks',decCheckAmount from viewPay_UserPayCheck where strBatchID = @BATCHID and decCheckAmount < 0
--		Missing Account,  Routing Number
INSERT INTO @PayrollVerification 
select intUserID,strUserName, 'Error Bank Acount','Account Num: ' + strBankAccountNumber+ ' Routing Num: ' + strBankRoutingNumber from viewPay_UserPayCheck where strBatchID = @BATCHID and intPayMethodType = 2 AND (strBankAccountNumber = '' OR strBankRoutingNumber = '')
--		Missing PayMethod
INSERT INTO @PayrollVerification 
select intUserID,strUserName, 'Error Pay Method','Pay Method: NONE' from viewPay_UserPayCheck where strBatchID = @BATCHID and intPayMethodType = 0
--		Missing SSN Number
INSERT INTO @PayrollVerification 
select intUserID,strUserName, 'Missing SSN Number',sSSN from viewPay_UserPayCheck where strBatchID = @BATCHID and intPayMethodType = 2 AND sSSN = ''

--INSERT INTO @PayrollVerification 
----select ubs.intUserID,strUserName, 'Error Pay Check(s) Amount', 'Pay:'+ cast(isnull(decBatchNetPay,0) as varchar(12)) + ' , Pay Check(s): ' +cast(isnull(upc.decCheckAmount,0) as varchar(12))  from viewPay_UserBatchStatus ubs left outer join 
--select ubs.intUserID,strUserName, 'Error Pay Check(s) Amount', 'Pay:'+ Format(isnull(decBatchNetPay,0),'C') + ' , Pay Check(s): ' + Format(isnull(upc.decCheckAmount,0),'C') from viewPay_UserBatchStatus ubs left outer join 
--(select strBatchID, intUserID , sum(decCheckAmount) decCheckAmount from tblUserPayChecks  group by strBatchID, intUserID ) upc
--on ubs.strBatchID = upc.strBatchID AND ubs.intUserID = upc.intUserID 
--where ubs.decBatchNetPay <> isnull(upc.decCheckAmount,0) and ubs.strBatchID = @BATCHID


	RETURN 
END
GO
