USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_rpt_CuadreQuarterlyReport]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <2023-04-13>
-- Description:	<Fetch the Payroll CuadreQuarterly Report data>
-- =============================================
CREATE PROCEDURE [dbo].[spPay_rpt_CuadreQuarterlyReport] 
	-- Add the parameters for the stored procedure here
	@PayrollCompany nvarchar(50),
	@StartDate date,
	@EndDate date 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT 
		repData.[401K SALARIOS EXENTOS] As K401_SALARIOS_EXENTOS,
		repData.[DEPOSITO FED] As DEPOSITO_FED,
		repData.[DEPOSITO PR] As DEPOSITO_PR,
		repData.EFMLAE,
		repData.[EFTPS FED] As EFTPS_FED,
		repData.EPSLA,
		repData.[EXENTO 26] As EXENTO_26,
		repData.[FECHA DEPOSITO FED] As FECHA_DEPOSITO_FED,
		repData.[FECHA DEPOSITO PR] As FECHA_DEPOSITO_PR,
		repData.[FECHA NOMINA] As FECHA_NOMINA,
		repData.[FED USA] As FED_USA,
		repData.[FICA MED] As FICA_MED,
		repData.[FICA MED PLUS] As FICA_MED_PLUS,
		repData.[FICA SS] As FICA_SS,
		repData.FUTA,
		repData.[FUTA DEPOSIT] As FUTA_DEPOSIT,
		repData.[FUTA RECEIPT] As FUTA_RECEIPT,
		repData.[HACIENDA PR] As HACIENDA_PR,
		repData.[HACIENDA RECEIPT] As HACIENDA_RECEIPT,
		repData.[INCOME TAX RETENIDO] As INCOME_TAX_RETENIDO,
		repData.MES,
		repData.[NOMBRE NOMINA] As NOMBRE_NOMINA,
		repData.[SALARIO TRIBUTABLES] As SALARIO_TRIBUTABLES,
		repData.[SALARIOS MED] As SALARIOS_MED,
		repData.[SALARIOS MED PLUS] As SALARIOS_MED_PLUS,
		repData.[SALARIOS SS] As SALARIOS_SS,
		repData.strBatchID,
		repData.TOTAL As TOTAL_FED,
		repData.[TOTAL SALARIOS] As TOTAL_SALARIOS

	FROM [dbo].[fnPay_tblCuadreQuarterlyReport](@PayrollCompany,@StartDate,@EndDate) as repData

END

GO
