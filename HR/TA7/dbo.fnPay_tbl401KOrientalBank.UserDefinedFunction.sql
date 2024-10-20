USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tbl401KOrientalBank]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 6/14/2016
-- Description:	401K export format for Oriental Bank
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tbl401KOrientalBank]
(
	@PayrollCompany as nvarchar(50) ,
	@BATCHID as nvarchar(50)
)
RETURNS 
@tbl401KOrientalBank TABLE 
(
SocialSecurityNumber nvarchar(50),
LastName nvarchar(50),
FirstName nvarchar(50),
Initial nvarchar(20),
Address1 nvarchar(50),
Address2 nvarchar(50),
City  nvarchar(50),
State nvarchar(50),
Zip nvarchar(50),
DateofBirth   nvarchar(50),
DateofHire  nvarchar(50),
DateofTermination  nvarchar(50),
DateofReHire  nvarchar(50),
PeriodHours decimal(18,2),
PeriodSalary decimal(18,2),
EmployeePretax decimal(18,2),
EmployerMatch decimal(18,2),
Loan401k decimal(18,2),
EmployeePostTax decimal(18,2),
GananciaPatronal decimal(18,2)
) 
AS
BEGIN
--Select employees that New law applies
INSERT INTO @tbl401KOrientalBank
select 
	ue.sssn as sSSN ,
	'"' + SUBSTRING(u.name,1, (SELECT PATINDEX('%,%', u.name))-1) + '"' AS LastName, 
	
	'"' + LTRIM(SUBSTRING(u.name,(SELECT PATINDEX('%,%', u.name))+1,100)) + '"' AS FirstName,
	
	LEFT(iif(CHARINDEX(' ', REVERSE(SUBSTRING(u.name,(SELECT PATINDEX('%,%', u.name))+1,100)))< LEN(REVERSE(SUBSTRING(u.name,(SELECT PATINDEX('%,%', u.name))+1,100))),	
	substring(RIGHT(SUBSTRING(u.name,(SELECT PATINDEX('%,%', u.name))+1,100), 
	CHARINDEX(' ', REVERSE(SUBSTRING(u.name,(SELECT PATINDEX('%,%', u.name))+1,100))) - 1),1,1),''),1) AS strMiddleName, --1 

	'"' + ue.[sHomeAddressLine1] + '"' as Address1,
	'"' + ue.[sHomeAddressLine2] + '"' as Address2,

	[sHomeCity],
	[sHomeState],
	[sHomeZipCode],
	iif([dBirthDate] is null,'',convert(varchar(10),[dBirthDate],101)) as BirthDate,
	iif([dOriginalHiredDate] is null,'',convert(varchar(10),[dOriginalHiredDate],101)) as HireDate,
	iif([dTerminationDate] is null,'',convert(varchar(10),[dTerminationDate],101)) as TermDate , 
	iif(dRehireDate is null,'',convert(varchar(10),dRehireDate,101))  as RehireDate ,
	(	
		SELECT	iif(sum(decHours) is null, 0, sum(decHours)) as decHours 
		FROM	tblUserBatchCompensations 
		where	intUserID = u.id
				AND strBatchID = @BATCHID
	) as PeriodHours,
	(
		SELECT  iif(sum(decPay) is null, 0, sum(decPay)) as decPay 
		FROM	tblUserBatchCompensations 
		where	intUserID = u.id 
				AND strBatchID = @BATCHID
	) as PeriodPay,
	(
		SELECT	iif(sum(decWithholdingsAmount) is null, 0, -sum(decWithholdingsAmount))  
		FROM	tblUserBatchWithholdings 
		where	intUserID = u.id 
				AND strBatchID = @BATCHID
				AND strWithHoldingsName IN (select strWithHoldingsName FROM [tblWithholdingsQualifierItems] where [intWithHoldingsQualifierID] = 1 and [intQualifierValue] IN (1))
	) as Pre401k,
	(
		SELECT	iif(sum(decWithholdingsAmount) is null, 0, -sum(decWithholdingsAmount)) 
		FROM	tblCompanyBatchWithholdings 
		where	intUserID = u.id 
				AND strBatchID = @BATCHID 
				and strWithHoldingsName IN (select strWithHoldingsName FROM [tblWithholdingsQualifierItems] where [intWithHoldingsQualifierID] = 1 and [intQualifierValue] IN (1,2))
	) as Company401k,
	(
		SELECT	iif(sum(decWithholdingsAmount) is null, 0, -sum(decWithholdingsAmount))  
		FROM	tblUserBatchWithholdings 
		where	intUserID = u.id 
				AND strBatchID = @BATCHID
				AND strWithHoldingsName IN (select strWithHoldingsName FROM [tblWithholdingsQualifierItems] where [intWithHoldingsQualifierID] = 1 and [intQualifierValue] IN (4))
	) as Loan401k,
	(
		SELECT	iif(sum(decWithholdingsAmount) is null, 0, -sum(decWithholdingsAmount))  
		FROM	tblUserBatchWithholdings 
		where	intUserID = u.id 
				AND strBatchID = @BATCHID
				AND strWithHoldingsName IN (select strWithHoldingsName FROM [tblWithholdingsQualifierItems] where [intWithHoldingsQualifierID] = 1 and [intQualifierValue] IN (2))
	) as EmployeePostTax ,
	0 as GananciaPatronal 
	--DEBUG
	--,ubs.dtStartDatePeriod , ubs.dtEndDatePeriod
from 
	tUserExtended as ue 
	INNER JOIN tuser as u on ue.nUserID = u.id 
	inner join viewPay_UserBatchStatus ubs ON u.id = ubs.intUserID 
where 
	(u.nStatus = 1 OR (ue.dTerminationDate between DATEADD(yy, DATEDIFF(yy, 0,  ubs.dtEndDatePeriod), 0) and ubs.dtEndDatePeriod)) and ubs.strBatchID = @BATCHID

RETURN
END

GO
