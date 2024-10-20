USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewAccruableLiceses]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewAccruableLiceses]
AS
SELECT     TOP 100 PERCENT dbo.viewAttendance_Employees.id, dbo.viewAttendance_Employees.name, dbo.viewAttendance_Employees.nCompanyID, 
                      dbo.viewAttendance_Employees.sCompanyName, dbo.viewAttendance_Employees.nDeptID, dbo.viewAttendance_Employees.sDeptName, 
                      dbo.viewAttendance_Employees.nJobTitleID, dbo.viewAttendance_Employees.sJobTitleName, dbo.viewAttendance_Employees.nEmployeeType, 
                      dbo.viewAttendance_Employees.sEmployeeTypeName, dbo.tUserAccrual.sLicenseCode, dbo.tUserAccrual.dblAccruedHours, 
                      dbo.tUserAccrual.dImportDate, dbo.tUserAccrual.dModifiedDate, dbo.tUserExtended.sSupervisorID, dbo.tUserExtended.sSupervisorName
FROM         dbo.viewAttendance_Employees LEFT OUTER JOIN
                      dbo.tUserExtended ON dbo.viewAttendance_Employees.id = dbo.tUserExtended.nUserID LEFT OUTER JOIN
                      dbo.tUserAccrual ON dbo.viewAttendance_Employees.id = dbo.tUserAccrual.nUserID
WHERE     (dbo.viewAttendance_Employees.nStatus >= 0)
GO
