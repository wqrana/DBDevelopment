USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeHealthInsuranceInfo]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_rpt_EmployeeHealthInsuranceInfo]
AS
SELECT 
 UserInformationId,
 healthIns.EmployeeHealthInsuranceId,
 healthIns.InsuranceStatusId,
 InsSts.InsuranceStatusName,
 healthIns.InsuranceStartDate,
 healthIns.InsuranceExpiryDate,
 (Case 
	When (healthIns.InsuranceExpiryDate is null) Or Datediff(day,healthIns.InsuranceExpiryDate,GetDate())<=0 then
	0 
	Else
	1
	End
 ) As IsExpired,
healthIns.GroupId As ExternalContractId,
healthIns.InsuranceTypeId,
InsType.InsuranceTypeName,
healthIns.InsuranceCoverageId,
InsCov.InsuranceCoverageName,
healthIns.CompanyContribution,
healthIns.EmployeeContribution,
healthIns.OtherContribution,
healthIns.TotalContribution,
healthIns.PCORIFee,
cobraSts.CobraStatusName,
healthIns.LeyCobraStartDate,
healthIns.LeyCobraExpiryDate,
healthIns.InsurancePremium
FROM EmployeeHealthInsurance healthIns
LEFT JOIN InsuranceType InsType ON  InsType.InsuranceTypeId = healthIns.InsuranceTypeId
LEFT JOIN InsuranceCoverage InsCov ON InsCov.InsuranceCoverageId = healthIns.InsuranceCoverageId
LEFT JOIN InsuranceStatus InsSts  ON InsSts.InsuranceStatusId = healthIns.InsuranceStatusId
LEFT JOIN CobraStatus cobraSts ON cobraSts.CobraStatusId = healthIns.CobraStatusId
WHERE healthIns.DataEntryStatus = 1
GO
