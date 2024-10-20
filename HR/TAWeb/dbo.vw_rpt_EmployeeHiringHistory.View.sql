USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeHiringHistory]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_rpt_EmployeeHiringHistory]
AS
SELECT      
		UserInformationId,
		EmploymentId,
		OriginalHireDate, 
		EffectiveHireDate, 
		ProbationStartDate, 
		ProbationEndDate, 
		e.EmploymentStatusId,
		st.EmploymentStatusName,
		dbo.fn_calculateServiceInYear(UseHireDateforYearsInService,OriginalHireDate, EffectiveHireDate,e.TerminationDate) ServiceInYear,
		UseHireDateforYearsInService,
		e.TerminationDate,
		e.TerminationTypeId,
		tt.TerminationTypeName,
		e.TerminationReasonId,
		tr.TerminationReasonName,
		e.TerminationNotes
FROM    Employment e
LEFT JOIN  EmploymentStatus st ON e.EmploymentStatusId = st.EmploymentStatusId
LEFT JOIN TerminationType tt ON e.TerminationTypeId = tt.TerminationTypeId
LEFT JOIN TerminationReason tr ON e.TerminationReasonId = tr.TerminationReasonId
WHERE e.DataEntryStatus = 1
GO
