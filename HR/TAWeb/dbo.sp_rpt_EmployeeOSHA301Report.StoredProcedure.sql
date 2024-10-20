USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_rpt_EmployeeOSHA301Report]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <2021-04-16>
-- Description:	<Fetch the Employee OHSA Reports data>
-- =============================================
CREATE PROCEDURE [dbo].[sp_rpt_EmployeeOSHA301Report] 
	-- Add the parameters for the stored procedure here
	
	@employeeIncidentId int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		

	SELECT Distinct
	
	employeeIncidentOSHA.*,	
	empgrm.ShortFullName as employeeName,
	empgrm.PositionName,
	empgrm.BirthDate as EmployeeBirthDate,
	empgrm.GenderName as EmployeeGender,
	empgrm.EffectiveHireDate,
	empgrm.MailingAddress1 +' '+ISNULL(empgrm.MailingAddress2,'') As MailingAddress,
	empgrm.MailingStateName,
	empgrm.MailingCityName,
	empgrm.MailingZipCode,
	completedByEmp.PositionName as CompletedByPositionName,
	completedByEmp.CelNumber as CompletedByCelNumber

	FROM vw_rpt_EmployeeGeneralRptMain empgrm
	INNER JOIN vw_rpt_EmployeeIncidentOSHA employeeIncidentOSHA On employeeIncidentOSHA.UserInformationId = empgrm.UserInformationId
	LEFT JOIN vw_rpt_EmployeeGeneralRptMain completedByEmp On completedByEmp.UserInformationId = employeeIncidentOSHA.CompletedById
	WHERE employeeIncidentOSHA.EmployeeIncidentId = @employeeIncidentId
	AND  empgrm.DataEntryStatus = 1
	--based on selected employees
	
END
GO
