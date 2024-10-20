USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_EmploymentHistoryCurrent]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_EmploymentHistoryCurrent]
AS
SELECT        ui.UserInformationId, ui.EmployeeId, ui.ShortFullName, ui.ClientId, EH.EmploymentHistoryId, EH.UserInformationId AS Expr1, EH.StartDate, EH.EndDate, EH.PositionId, EH.EmployeeTypeId, EH.ChangeReason, 
                         EH.LocationId, EH.DepartmentId, EH.SubDepartmentId, EH.EmploymentTypeId, EH.CompanyId, EH.SupervisorId, EH.ApprovedDate, EH.CreatedBy, EH.CreatedDate, EH.DataEntryStatus, 
                         EH.ModifiedBy, EH.ModifiedDate
FROM            dbo.UserInformation AS ui LEFT OUTER JOIN
                         dbo.EmploymentHistory AS EH ON EH.UserInformationId = ui.UserInformationId LEFT OUTER JOIN
                             (SELECT        ClientId, UserInformationId, MAX(StartDate) AS StartDate
                               FROM            dbo.EmploymentHistory
                               GROUP BY ClientId, UserInformationId) AS currentEH ON EH.ClientId = currentEH.ClientId AND EH.UserInformationId = currentEH.UserInformationId AND EH.StartDate = currentEH.StartDate
GO
