USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblCoopOrientalFASB]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 11/05/2018
-- Description:	For Coop Oriental: FASB report
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblCoopOrientalFASB]
(	
	-- Add the parameters for the function here
	@PayrollCompany nvarchar(50),
	@STARTDATE date,
	@ENDDATE date
)
RETURNS 
@tblCoopOrientalFASB TABLE 
(
	Nobre nvarchar(50),
	YearsService int,
	POSITION nvarchar(50), 
	SALARIO decimal(18,2),
	Participation nvarchar(50),
	IDLE nvarchar(50),
	AportacionPatronal decimal(18,2),
	BENEFICIOS decimal(18,2),
	NumerEmpleado nvarchar(50), 
	SUCURSAL nvarchar(50), 
	CATEGORIA nvarchar(50)
) 
-- WITH ENCRYPTION
AS
BEGIN
	-- Compensations in order stated
	insert into @tblCoopOrientalFASB
SELECT	
		left(name,50) Nombre
		,datediff(YEAR,ur.dOriginalHiredDate,getdate()) YearsService
		,isnull(ur.strPositionName,'') POSITION
		, ISNULL((select sum(decPay) from viewPay_UserBatchCompensations ubc inner join tblCompensationItems ci on ubc.strCompensationName = ci.strCompensationName
			where ci.intCompensationType = 1 and intUserID = ur.id AND strCompanyName = @PayrollCompany and dtPayDate BETWEEN @StartDate and @EndDate),0) SALARIO
		,'' Participation
		,'' IDLE
		, ISNULL(-(select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings ubc where intUserID =ur.id AND strWithHoldingsName 
		IN ('FICA SS', 'FICA MED','FUTA','SINOT','SUTA') AND strCompanyName = @PayrollCompany and dtPayDate BETWEEN @StartDate and @EndDate),0) AportacionPatronal
		, ISNULL(-(select sum(decWithholdingsAmount) from viewPay_CompanyBatchWithholdings ubc where intUserID =ur.id AND strWithHoldingsName 
		IN ('401K','Plan Medico') AND strCompanyName = @PayrollCompany and dtPayDate BETWEEN @StartDate and @EndDate),0) BENEFICIOS
		,idno NumeroEmpleado
		,isnull(sJobTitleName,'') SUCURSAL
		,'' CATEGORIA
 from viewUser_Reports ur
 inner join
(select intUserID  from viewPay_UserBatchStatus ubs inner join viewUser_Reports ur on ubs.intUserID = ur.id
WHERE strCompanyName = @PayrollCompany and dtPayDate BETWEEN @StartDate and @EndDate
GROUP BY intUserID) UBS
ON ur.id = ubs.intUserID

	RETURN
END


GO
