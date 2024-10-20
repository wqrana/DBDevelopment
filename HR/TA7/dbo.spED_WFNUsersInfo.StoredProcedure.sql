USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_WFNUsersInfo]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <529/2024>
-- Description:	<To extract data for WFNUsersInfo excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_WFNUsersInfo]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;	
	DECLARE @pvtColSet1 AS NVARCHAR(MAX),@pvtColSet2 AS NVARCHAR(MAX),@pvtColSet3 AS NVARCHAR(MAX)
	DECLARE @deductionColSet AS NVARCHAR(MAX), @sqlQuery AS NVARCHAR(MAX);
	
	--Earning pair data 
	SET  @pvtColSet1 = STUFF(
		(SELECT ',' +CONCAT('[','Ded-',[strWithHoldingsName],'-$',']') 
		 FROM tblWithholdingsItems 
		 WHERE strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS', 'ST ITAX', 'SUTA')		
		 GROUP BY [strWithHoldingsName] FOR XML PATH('')),
		 1, 1, '');

	SET @pvtColSet2 = STUFF(
		(SELECT ',' +CONCAT('[','Ded-',[strWithHoldingsName],'-%',']') 
		 FROM tblWithholdingsItems 
		 WHERE strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS', 'ST ITAX', 'SUTA')		
		 GROUP BY [strWithHoldingsName] FOR XML PATH('')),
		 1, 1, '');

	SET @pvtColSet3 = STUFF(
		(SELECT ',' + CONCAT('[','Ded-',[strWithHoldingsName],'-$',']')+','+ CONCAT('[','Ded-',[strWithHoldingsName],'-%',']') 
		 FROM tblWithholdingsItems 
		 WHERE strWithHoldingsName not in ('FICA SS', 'FICA MED', 'FICA MED PLUS', 'ST ITAX', 'SUTA')		
		 GROUP BY [strWithHoldingsName] FOR XML PATH('')),
		 1, 1, '');

	SET @deductionColSet = CONCAT('intUserID,',@pvtColSet3);
	
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##WithholdingAmts
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserId,Concat(''Ded-'',[strWithHoldingsName],''-$'') as strWithHoldingsName,decEmployeeAmount as [decWithholdingsAmount]
			FROM tblUserWithholdingsItems
			
		) WithHoldingData   
		 PIVOT (
			SUM([decWithholdingsAmount])
			FOR [strWithHoldingsName] IN (' + @pvtColSet1 + ')	
		) AS PT1	
		) tblDeductions'

	Drop table If Exists ##WithholdingAmts
	Exec sp_executesql @sqlQuery
	
	--select * from ##WithholdingAmts
	--%
	
	SET @sqlQuery = N'
	  SELECT *
	  INTO ##WithholdingsPct
	  FROM(
		SELECT *	
		FROM (
			SELECT intUserId as intUserId1,Concat(''Ded-'',[strWithHoldingsName],''-%'') as strWithHoldingsName,decEmployeePercent as [decWithholdingsAmount]
			FROM tblUserWithholdingsItems
			
		) WithHoldingData   
		 PIVOT (
			SUM([decWithholdingsAmount])
			FOR [strWithHoldingsName] IN (' + @pvtColSet2 + ')	
		) AS PT1	
		) tblDeductions'

	Drop table If Exists ##WithholdingsPct
	Exec sp_executesql @sqlQuery

	--select * from ##WithholdingsPct
	
	
	Set @sqlQuery=N'
	Select '+@deductionColSet+' 
	Into ##tempUserWithholdingitems	
	From ##WithholdingAmts p1
	Inner Join ##WithholdingsPct p2 on p1.intUserId= p2.intUserID1' 
	Drop table If Exists ##tempUserWithholdingitems
	Exec sp_executesql @sqlQuery

	--select * from ##tempUserWithholdingitems
	--select * from ##Withholdings
SELECT 
	strCompanyName as [Company Code],	
	userInfo.intUserId as [Position ID],
	'' as [Change Effective On],
	'Y' as [Is Paid by WFN (Paid or Non Paid)],
	'Y' as [Position Uses Time],
	FirstName as [First Name],
	MiddleInitial as [Middle Name],
	CONCAT(FirstLastName,' ',SecondLastName) as [Last Name],
	Case Len(sSSN) When 9 Then format(CAST(sSSN as int),'###-##-####') Else sSSN End as [Social Security Number],	
	sHomeAddressLine1 as [Address 1 Line 1],
	sHomeAddressLine2 as [Address 1 Line 2],
	'' as [Address 1 Line 3],
	sHomeCity as [Address 1 City],
  'PR' as [Address 1 State Postal Code],
  CONCAT('''',sHomeZipCode) as [Address 1 Zip Code],
  '' as [Work e-mail],
    case
	  when strStatusName='Active' then
	  'A'
	  when strStatusName='Inactive' and dTerminationDate is null then
	  'L'
	  when strStatusName='Inactive' and dTerminationDate is not null then
	  'T'
      when strStatusName='Closed Record' and dTerminationDate is not null then
	  'T'
	  else
	  ''
	end as [Employee Status],
	convert(varchar, dOriginalHiredDate, 101)  as [Hire Date],	
	IIF(dBirthDate is null,'01/01/1900',convert(varchar, dBirthDate, 101)) as [Birth Date],
	convert(varchar, dTerminationDate, 101) as [Termination Date],
	case
		when sSex='Male' 
		then 'M'
		when sSex ='Female'
		then 'F'
		when sSex ='Not Specified'
		then 'N'
		else 'M'
	end as [Gender],
	sHomePhoneHum as [Home Phone Number],
	'' as [Mobile Phone Number],
	(
		Case trim(IsNull(userInfo.sFullPartTimeCode,''))
		When 'Full Time' Then 'FT'
		When 'Part Time' Then 'PT'
		When 'Temporary' Then 'TEMP'
		ELSE ''
		END
	) as [Worker Category],
	'' as [EEOC Job Code],
	'Y' as [FLSA Code],
	'' as [NAICS Workers Comp Code],
	'' as [Special Accounts 1],
	'' as [Home Cost Number],
	userInfo.nDeptID as [Home Department],
	case userPayRate.intHourlyOrSalary			
		When 1 then --incase of salary
		Case  userPayRate.intPayPeriod 
		When 0 then '40'		--0	Weekly,1	BIweekly,2	Semimonthly,3	Monthly,4	Quarterly,5	Semianual,6	Annual,7	Daily (Per Day)
		When 1 then '80'
		When 2 then '86.67'
		When 3 then ''
		When 4 then ''
		When 5 then ''
		When 6 then ''		
		ELSE ''
		End
		else ''
	end as [Standard Hours],
	case userPayRate.intHourlyOrSalary
		When 0 then 'H'		
		When 1 then 'S'
		else 'N'
	end as [Rate Type],
	userPayRate.decPayRate as [Rate 1 Amount],
	''	as [Rate 2 Amount],
	''  as [Reports To Position ID],
	'' as [Job Code], -- use abbrivated title not available
	'' as [Job Title],
	case trim(IsNull(sMaritalStatus,'')) 
	When 'Married' Then 'M'
	When 'Single' Then 'S'
	Else ''
	End	as [Federal Marital Status],
	'' as [Federal Exemptions],
	'PR' as [Worked State Tax Code],
	case trim(IsNull(sMaritalStatus,'')) 
	When 'Married' Then 'M'
	When 'Single' Then 'S'
	Else ''
	End as [State Marital Status],
	'' as [Exemptions In Dollars],
	'' as [Do Not Calculate State Tax],
	'' as [State Extra Tax $],
	'' as [State Extra Tax %],
	'' as [SUI/SDI Tax Jurisdiction Code],
	WHTItems.* --deductions
	
	
	
FROM viewPay_UserRecord userInfo
LEFT JOIN (
		Select ROW_NUMBER() OVER(PARTITION BY intUserID ORDER BY dtStartDate DESC) RecordId,intUserID,dtStartDate,intPayPeriod
		,intHourlyOrSalary,decPayRate  
		From tblUserPayRates
		) userPayRate ON userInfo.intUserID = userPayRate.intUserID AND userPayRate.RecordId=1
LEFT JOIN ##tempUserWithholdingitems WHTItems ON WHTItems.intUserID = userInfo.intUserID
Order by strCompanyName, userInfo.intUserId

END
GO
