USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblChoferilTrabajo]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 04/01/2019
-- Description:	For Choferil Tax Export
-- Parameters:	Payroll Company, Start Date and End Date
--				Required for Planilla Choferl
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblChoferilTrabajo]
(
	@PayrollCompany as nvarchar(50) ,
	@STARTDATE as date,
	@ENDDATE as date
)
RETURNS 
@tbChoferilReport TABLE 
(
	strNumeroPatronalChoferil nvarchar(50),
	strCompanyName nvarchar(50),
	strSSN nvarchar(9),
	strFirstName nvarchar(30),
	strMiddleInital nvarchar(1),
	strLastName1 nvarchar(30),
	strLastName2 nvarchar(30),
	strDriversLicense nvarchar(7),
	decChauffeurWeeks int,
	strQuarter nvarchar(1),
	strYear nvarchar(4)
	) 
	-- WITH ENCRYPTION
AS
BEGIN
insert into @tbChoferilReport

select strNumeroPatronalChoferil as strSeguroChoferilAccount,
	 strCompanyName  ,
	strSSN ,
	StrFirstName,
	strMiddleInital ,
	strLastName1 ,
	strLastName2 ,
	strDriversLicense ,
	decChauffeurWeeks ,
	strQuarter ,
	strYear 
	from [fnPay_tblChoferilSummaryReport](@PayrollCompany ,	@STARTDATE ,	@ENDDATE )


RETURN
END

GO
