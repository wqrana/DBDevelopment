USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblDTRHReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnPay_tblDTRHReport]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date,
	@CUENTAPATRONAL nvarchar(10)
)
RETURNS 
@tblDTRHReport TABLE 
(
	SSN nvarchar(9),  
	FILLER nvarchar(1), 
	TRANSACCION nvarchar(2), 
	LLAVE nvarchar(4), 
	OPERADOR nvarchar(8), 
	TERMINAL nvarchar(4), 
	FECHA nvarchar(6), 
	HORA nvarchar(6), 
	TRIMESTRE nvarchar(3), 
	CODIGO nvarchar(1), 
	SALARIO nvarchar(7), 
	PATRONAL nvarchar(9), 
	FILLER2 nvarchar(4), 
	CODIGDOT nvarchar(8), 
	FILLER3 nvarchar(2), 
	INDICADOR nvarchar(1),
	NUMEROBATCH nvarchar(6),
	FECHAEFECTIVIDAD nvarchar(6),
	CODIGOBATCH nvarchar(3),
	CODIGOPAGINA nvarchar(3),
	ORIGINACION nvarchar(2),
	FIRSTNAME nvarchar(16),
	MIDDLENAME nvarchar(1),
	LASTFATHER nvarchar(16),
	LASTMOTHER nvarchar(16),
	INGRESOPARCIAL nvarchar(1),
	FILLER4 nvarchar(5)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @TRIMESTER nvarchar(3)
	SET @TRIMESTER = concat(datepart(YY,@ENDDATE),datepart(Q,@ENDDATE))

	--Select employees that New law applies
	INSERT INTO @tblDTRHReport

	SELECT 
	LEFT(REPLACE([sSSN],'-',''),9) as SSN ,--9
	' ' as FILLER,
	'W4' as TRANSACCION,
	LEFT(ubs.name,4) as LLAVE,
	'12345678' as OPERADOR,
	'SWCA' as TERMINAL,
	 FORMAT(getdate(), 'yyMMdd') as FECHA,
	 FORMAT(getdate(), 'HHmmss') as HORA,
	 @TRIMESTER as TRIMESTRE,
	 '2' as CODIGO,
	
	iif(COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join [dbo].[tblCompensationsItems_PRPayExport] prp on ubc.strCompensationName = prp.strCompensationName  
	where (prp.boolWages = 1 OR prp.boolAllowances = 1 or prp.boolCommissions=1) and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate  group by intUserID  ),0) < 100000,
	RIGHT('0000000' +
	replace(cast(	COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join [dbo].[tblCompensationsItems_PRPayExport] prp on ubc.strCompensationName = prp.strCompensationName  
	where (prp.boolWages = 1 OR prp.boolAllowances = 1 or prp.boolCommissions=1)  and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate   group by intUserID  ),0) as nvarchar(10)),'.',''),7),'9999999') as SALARIO, --7
	
	Left(@CUENTAPATRONAL,9) as PATRONAL,
	'    ' as FILLER2,
	'00000000' as CODIGDOT,
	'  ' as FILLER3,
	'1' as INDICADOR,
	'000000' as NUMEROBATCH,
	 FORMAT(getdate(), 'yyMMdd') as FECHAEFECTIVIDAD,
	 '000' as CODIGOBATCH,
	 '000' as CODIGOPAGINA,
	 '04' as ORIGINACION,
		cast(left(LTRIM(firstname),16) as char(16)) AS strFirstName,
		cast(left(LTRIM(MiddleInitial),1)  as char(1)) AS strMiddleName,
		cast(left(LTRIM(FirstLastName),16) as char(16))  AS strLastFather,
		cast(left(LTRIM(SecondLastName),16) as char(16))  AS strLastMother, --2

		'N' as INGRESOPARCIAL,
		'     ' as FILLER4

	FROM (SELECT DISTINCT 
	ubs.intUserID, u.id,
	u.name,
	u.FirstName,
	u.MiddleInitial,
	u.FirstLastName,
	u.SecondLastName,
	ubs.[sHomeAddressLine1],
	ubs.[sHomeAddressLine2],
	ubs.[strCity],
	ubs.[strState],
	ubs.[strZipCode],
	[sSSN],--3
	ubs.strCompanyName --4
	 FROM  viewPay_UserBatchStatus as ubs inner join tuser u on ubs.intUserID = u.id where ubs.strCompanyName = @PAYROLLCOMPANY AND ubs.dtPayDate between @STARTDATE and @ENDDATE 
	 ) ubs 
	 WHERE 	COALESCE((select sum(ubc.decPay) from viewpay_UserBatchCompensations ubc inner join [tblCompensationsItems_PRPayExport] prp on ubc.strCompensationName = prp.strCompensationName  
	where (prp.boolWages = 1 OR prp.boolAllowances = 1 OR prp.boolCommissions = 1) and ubc.intUserID = ubs.intUserID  and ubc.dtpaydate between @startdate and @enddate    group by intUserID  ),0) <> 0
	 ORDER BY id ASC


RETURN
END

GO
