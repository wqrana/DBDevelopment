USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeDentalInsuranceInfo]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_rpt_EmployeeDentalInsuranceInfo]
AS
SELECT 
 UserInformationId,
 dentalIns.EmployeeDentalInsuranceId,
 dentalIns.InsuranceStatusId,
 InsSts.InsuranceStatusName,
 dentalIns.InsuranceStartDate,
 dentalIns.InsuranceExpiryDate,
 (Case 
	When (dentalIns.InsuranceExpiryDate is null) Or Datediff(day,dentalIns.InsuranceExpiryDate,GetDate())<=0 then
	0 
	Else
	1
	End
 ) As IsExpired,
dentalIns.GroupId As ExternalContractId,
dentalIns.InsuranceTypeId,
InsType.InsuranceTypeName,
dentalIns.InsuranceCoverageId,
InsCov.InsuranceCoverageName,
dentalIns.CompanyContribution,
dentalIns.EmployeeContribution,
dentalIns.OtherContribution,
dentalIns.TotalContribution,
dentalIns.PCORIFee,
cobraSts.CobraStatusName,
dentalIns.LeyCobraStartDate,
dentalIns.LeyCobraExpiryDate,
dentalIns.InsurancePremium
FROM EmployeeDentalInsurance dentalIns
LEFT JOIN InsuranceType InsType ON  InsType.InsuranceTypeId = dentalIns.InsuranceTypeId
LEFT JOIN InsuranceCoverage InsCov ON InsCov.InsuranceCoverageId = dentalIns.InsuranceCoverageId
LEFT JOIN InsuranceStatus InsSts  ON InsSts.InsuranceStatusId = dentalIns.InsuranceStatusId
LEFT JOIN CobraStatus cobraSts ON cobraSts.CobraStatusId = dentalIns.CobraStatusId
WHERE dentalIns.DataEntryStatus = 1
GO
