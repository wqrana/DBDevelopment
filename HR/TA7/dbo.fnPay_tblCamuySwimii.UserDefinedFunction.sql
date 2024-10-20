USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCamuySwimii]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 3/26/2021
-- Description:	Camuy Coop SWIMII File 
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblCamuySwimii]
(	
	@BATCHID nvarchar(50) 
)
RETURNS @Swimii TABLE 
(
	Exportline nvarchar(200))
AS
BEGIN
INSERT INTO @Swimii
select 
format(convert(bigint, strBankAccountNumber),'00000000000000000')  +
'DEPD' +
format(decBatchNetPay*100,'0000000000') --No decimal point 
+ format(dtPayDate,'000000yyyyMMdd')
+ rtrim(strUserName) + REPLICATE(' ',60-len(rtrim(strusername)))
+'33                EL  INTRIMED                   '
from viewPay_UserPayCheck where strBatchID = @BATCHID

UNION ALL

select 
format(convert(bigint, '40000506'),'00000000000000000')  +
'GLD ' +
format(decBatchNetPayAmount*100,'0000000000') --No decimal point 
+ format(dtPayDate,'000000yyyyMMdd')
+ 'Total Accounts Pay Checks' + REPLICATE(' ',60-len(rtrim('Total Accounts Pay Checks')))
+'33                EL  INTRIMED                   '
from viewPay_Batch where strBatchID = @BATCHID


RETURN
END
GO
