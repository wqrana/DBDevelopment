USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeEmploymentHistory]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_rpt_EmployeeEmploymentHistory]
AS
SELECT        
		UserInformationId,
		EmploymentId,
		EmploymentHistoryId,  
		StartDate, 
		EndDate,
		EmpHistory.CompanyId,
		CompanyName,
		EmpHistory.DepartmentId,
		DepartmentName, 
		EmpHistory.SubDepartmentId,
		SubDepartmentName,
		SupervisorId,
		EmpHistory.EmployeeTypeId,
		empType.EmployeeTypeName,  
		EmpHistory.EmploymentTypeId,
		empmtType.EmploymentTypeName, 
		EmpHistory.PositionId,
		EmpHistory.EndDate as EmploymentEndDate,
		p.PositionName,
		loc.LocationName,
		loc.LocationId
		
FROM    EmploymentHistory EmpHistory
LEFT JOIN Company cmp on EmpHistory.CompanyId = cmp.CompanyId
LEFT JOIN Department dept on EmpHistory.DepartmentId = dept.DepartmentId
LEFT JOIN SubDepartment subDept on EmpHistory.SubDepartmentId = subDept.SubDepartmentId
LEFT JOIN EmployeeType empType on EmpHistory.EmployeeTypeId = empType.EmployeeTypeId
LEFT JOIN EmploymentType empmtType on EmpHistory.EmploymentTypeId = empmtType.EmploymentTypeId 
LEFT JOIN Position p on  EmpHistory.PositionId = p.PositionId
LEFT JOIN Location loc on EmpHistory.LocationId = loc.LocationId
WHERE EmpHistory.DataEntryStatus = 1
GO
