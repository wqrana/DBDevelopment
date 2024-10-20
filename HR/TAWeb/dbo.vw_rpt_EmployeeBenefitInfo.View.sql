USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeBenefitInfo]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_rpt_EmployeeBenefitInfo]
AS
SELECT 
UserInformationId,
empBenefit.EmployeeBenefitHistoryId,
empBenefit.BenefitId,
ben.BenefitName,
empBenefit.StartDate,
empBenefit.ExpiryDate,
empBenefit.Amount as BenefitAmount,
payFreq.PayFrequencyName,
empBenefit.Notes
FROM EmployeeBenefitHistory empBenefit
LEFT JOIN Benefit ben ON  ben.BenefitId = empBenefit.BenefitId
LEFT JOIN PayFrequency payFreq ON payFreq.PayFrequencyId = empBenefit.PayFrequencyId
WHERE empBenefit.DataEntryStatus = 1
GO
