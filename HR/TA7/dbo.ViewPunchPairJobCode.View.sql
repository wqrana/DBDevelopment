USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[ViewPunchPairJobCode]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViewPunchPairJobCode]
AS
SELECT     dbo.viewUser_Reports.id, dbo.viewUser_Reports.name, dbo.viewUser_Reports.idno, dbo.viewUser_Reports.nStatus, dbo.viewUser_Reports.sNotes, 
                      dbo.viewUser_Reports.sCompanyName, dbo.viewUser_Reports.sDeptName, dbo.viewUser_Reports.sJobTitleName, 
                      dbo.viewUser_Reports.sEmployeeTypeName, dbo.viewUser_Reports.sPayrollRuleName, dbo.viewUser_Reports.sScheduleName, 
                      dbo.tPunchPair.DTPunchDate, dbo.tPunchPair.DTimeIn, dbo.tPunchPair.DTimeOut, dbo.tPunchPair.HoursWorked, dbo.tPunchPair.sType, 
                      dbo.tPunchPair.pCode, dbo.tPunchPair.bTrans, dbo.tPunchPair.sTCode, dbo.tPunchPair.sTDesc, dbo.tJobCode.sJobCodeName, 
                      dbo.tJobCode.sJobCodeDesc, dbo.tProject.sProjectName, dbo.tProject.sProjectPayCode, dbo.tCustomers.nCustomerID, 
                      dbo.tCustomers.sCustomerName
FROM         dbo.tPunchPair INNER JOIN
                      dbo.tJobCode ON dbo.tPunchPair.nJobCodeID = dbo.tJobCode.nJobCodeID INNER JOIN
                      dbo.tProject ON dbo.tJobCode.nProjectID = dbo.tProject.nProjectID INNER JOIN
                      dbo.viewUser_Reports ON dbo.tPunchPair.e_id = dbo.viewUser_Reports.id INNER JOIN
                      dbo.tCustomers ON dbo.tProject.nCustomerID = dbo.tCustomers.nCustomerID
GO
