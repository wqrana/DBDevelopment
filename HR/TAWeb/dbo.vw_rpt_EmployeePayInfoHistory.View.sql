USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeePayInfoHistory]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_rpt_EmployeePayInfoHistory]
AS
SELECT   UserInformationId, 
		 PayInformationHistoryId,
		 EmploymentId,
		 StartDate, 
		 EndDate, 
		 PayInfo.EEOCategoryId,
		 eeoCat.EEOCategoryName, 
		 PayInfo.PayTypeId,
		 payt.PayTypeName, 
		 PayInfo.PayFrequencyId,
		 payF.PayFrequencyName, 
		 RateAmount, 
		 PayInfo.RateFrequencyId,
		 PayInfo.YearlyGrossPay,
		 PayInfo.PeriodGrossPay,
		 PayInfo.PeriodHours,
		 payinfo.EndDate as payInfoEndDate,
		 rateF.RateFrequencyName,
		 ChangeReason,
		 ps.PayScaleName
FROM     PayInformationHistory PayInfo
LEFT JOIN  EEOCategory eeoCat on PayInfo.EEOCategoryId = eeoCat.EEOCategoryId
LEFT JOIN  PayType payT on PayInfo.PayTypeId = payT.PayTypeId
LEFT JOIN  PayFrequency payF on PayInfo.PayFrequencyId = payF.PayFrequencyId
LEFT JOIN  RateFrequency rateF on PayInfo.RateFrequencyId = rateF.RateFrequencyId
LEFT JOIN  PayScale ps on ps.PayScaleId = PayInfo.PayScaleId
WHERE PayInfo.DataEntryStatus = 1
GO
