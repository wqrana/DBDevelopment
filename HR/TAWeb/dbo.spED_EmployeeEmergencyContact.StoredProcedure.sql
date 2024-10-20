USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[spED_EmployeeEmergencyContact]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <6/6/2024>
-- Description:	<To extract data for EmergencyContact excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_EmployeeEmergencyContact]
@ClientId int = 2
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  SELECT 
  cmp.CompanyName as [Company Name],
  '' as [Company Federal ID],
  userInfo.EmployeeId as [File #/Employee ID],
  userInfo.ShortFullName as [Employee Full Name],
  format(CAST(dbo.fn_CLREnDecriptSSN(IsNull(userInfo.SSNEncrypted,'0'),'D')as int),'###-##-####') as [Social Security Number],
  emernyCont.ContactPersonName as [Contact Name],
  rel.RelationshipName as [Contact Relationship],
  IIF(emernyCont.IsDefault=1,'Y','N') as [Primary Contact], 
  IIF(isNumeric(emernyCont.MainNumber)=1,Format(Cast(emernyCont.MainNumber as bigint),'(###) ###-####'),emernyCont.MainNumber)  as [Contact Home Phone Dial Number],

  '' as [Contact Work Phone Dial Number],
  '' as [Contact Work Phone Extension],
  '' as [Contact Cell Phone Dial Number],
  IIF(isNumeric(emernyCont.AlternateNumber)=1,Format(Cast(emernyCont.AlternateNumber as bigint),'(###) ###-####'),emernyCont.AlternateNumber)  as [Contact Alternate Phone Dial Number],
  '' as [Contact E-mail],
  '' as [Contact Address Line 1],
  '' as [Contact Address Line 2],
  '' as [Contact Address Line 3],
  '' as [Contact City],
  '' as [Contact State],
  '' as [Contact Zip Code],
  '' as [Contact Country],
  '' as [Doctor Name],
  '' as [Doctor Phone Dial Number],
  '' as [Hospital]
  FROM vw_UserInformation userInfo
  INNER JOIN Company cmp ON cmp.CompanyId = userInfo.CompanyID
  INNER JOIN EmergencyContact emernyCont ON emernyCont.UserInformationId = userInfo.UserInformationId
  INNER JOIN Relationship rel on rel.RelationshipId = emernyCont.RelationshipId
 
  WHERE userInfo.ClientId=@ClientId
  Order by cmp.CompanyName, userInfo.EmployeeId
END
GO
