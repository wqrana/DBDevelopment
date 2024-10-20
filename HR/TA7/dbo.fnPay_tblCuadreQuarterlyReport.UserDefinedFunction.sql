USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCuadreQuarterlyReport]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 9/24/2021
-- Description:	Report de Cuadre Para Planillas
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblCuadreQuarterlyReport]
(	
		@PAYROLLCOMPANY nvarchar(50),
		@STARTDATE date,
		@ENDDATE date 
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT
		TheMonthName 'MES'
		,b.strBatchID

	, dtPayDate 'FECHA NOMINA'
	,strBatchDescription 'NOMBRE NOMINA'
	,'' 'FED USA'
	,ISNULL((select decEffectiveWages from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName = '   FICA SS'),0)  'SALARIOS SS'
	,ISNULL((select decWithholdingsAmount + decContributionsAmount from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName = '   FICA SS'),0)  'FICA SS'

	,ISNULL((select sum(decEffectiveWages) from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName IN ( '   FICA MED')),0)   'SALARIOS MED'
	,ISNULL((select sum(decWithholdingsAmount + decContributionsAmount) from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName IN ( '   FICA MED')),0)  'FICA MED'

	,ISNULL((select sum(decEffectiveWages) from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName IN ( '   FICA MED PLUS')),0)   'SALARIOS MED PLUS'
	,ISNULL((select sum(decWithholdingsAmount + decContributionsAmount) from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName IN ( '   FICA MED PLUS')),0)  'FICA MED PLUS'
	,'' 'EPSLA'
	,'' 'EFMLAE'
	,ISNULL((select sum(decWithholdingsAmount + decContributionsAmount) from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName = '   FICA SS'),0)  
	+ ISNULL((select sum(decWithholdingsAmount + decContributionsAmount) from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName IN ( '   FICA MED','   FICA MED PLUS')),0)	 'TOTAL'
	,ISNULL((select decFederalTaxDepositAmount from tblBatch ba where ba.strBatchID = b.strBatchID),0) 'DEPOSITO FED'
	,ISNULL((select dtFederalTaxDepositDate from tblBatch ba where ba.strBatchID = b.strBatchID),NULL)  'FECHA DEPOSITO FED'
	, ISNULL((select decHaciendaTaxDepositAmount from tblBatch ba where ba.strBatchID = b.strBatchID),0)  'HACIENDA PR'
	    
	,ISNULL((select decEffectiveWages from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName = 'ST ITAX'),0)    'SALARIO TRIBUTABLES' 

	,ISNULL((select sum(decWithholdingsAmount) + sum(decContributionsAmount) from fnPay_tblCompanyContributionsSalary(b.strBatchID,b.strCompanyName,@STARTDATE,@ENDDATE) 
	where ltrim(rtrim(strWithholdingsName)) IN (select ltrim(rtrim(wi.strWithHoldingsName)) from tblWithholdingsItems wi inner join 
	tblWithholdingsQualifierItems wqi ON wi.strWithHoldingsName = wqi.strWithHoldingsName where intWithHoldingsQualifierID = 1 and intQualifierValue IN (1,3))),0)     '401K SALARIOS EXENTOS' 

	,ISNULL((select decEffectiveWages from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName = 'ST ITAX'),0)    
	+ ISNULL((select sum(decWithholdingsAmount) + sum(decContributionsAmount) from fnPay_tblCompanyContributionsSalary(b.strBatchID,b.strCompanyName,@STARTDATE,@ENDDATE) where ltrim(rtrim(strWithholdingsName)) 
	IN (select ltrim(rtrim(wi.strWithHoldingsName)) from tblWithholdingsItems wi inner join 
		tblWithholdingsQualifierItems wqi ON wi.strWithHoldingsName = wqi.strWithHoldingsName where intWithHoldingsQualifierID = 0 and intQualifierValue IN(1,3))),0) 'TOTAL SALARIOS'

	,ISNULL((select decWithholdingsAmount + decContributionsAmount from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName = '   ST ITAX'),0) 'INCOME TAX RETENIDO'
	,ISNULL((select decHaciendaTaxDepositAmount from tblBatch ba where ba.strBatchID = b.strBatchID),0)   'DEPOSITO PR'
	,ISNULL((select dtHaciendaTaxDepositDate from tblBatch ba where ba.strBatchID = b.strBatchID),NULL)   'FECHA DEPOSITO PR'
	,ISNULL((select SUM(dbo.fnPay_BatchTaxablePay(strBatchID,intUserID)) from tblUserBatch  ubc inner join tUserExtended ue on ubc.intUserID = ue.nUserID 
		where ubc.strBatchID = b.strbatchid and (cast(format(@ENDDATE,'yyyy') as int) - cast(format((dBirthDate),'yyyy') as int))  < 27),0) 'EXENTO 26'
	,ISNULL((select strFederalTaxEFTPSNo from tblBatch ba where ba.strBatchID = b.strBatchID),'') 'EFTPS FED'
	,ISNULL((select strHaciendaTaxReceiptNo from tblBatch ba where ba.strBatchID = b.strBatchID),'') 'HACIENDA RECEIPT'
	,ISNULL((select strFUTATaxReceiptNo from tblBatch ba where ba.strBatchID = b.strBatchID),'') 'FUTA RECEIPT'
	,ISNULL((select decFUTATaxDepositAmount from tblBatch ba where ba.strBatchID = b.strBatchID),0)   'FUTA DEPOSIT'
	,ISNULL((select sum(decWithholdingsAmount + decContributionsAmount) from fnPay_tblCompanyContributionsSalary(b.strBatchID,'',@STARTDATE,@ENDDATE) where strWithholdingsName IN ( '   FUTA')),0)  'FUTA'

from viewPay_Batch B  inner join DateCalendar dc ON b.dtPayDate = dc.TheDate
where strCompanyName = @PAYROLLCOMPANY and dtPayDate BETWEEN @STARTDATE and @ENDDATE
)
GO
