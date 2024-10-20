USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  View [dbo].[vw_rpt_EmployeeContactInfo]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_rpt_EmployeeContactInfo]
AS
SELECT 
  UserInformationId
, UserContactInformationId
,NotificationEmail
, HomeNumber
, CelNumber
, FaxNumber
, OtherNumber
, WorkEmail
, PersonalEmail
, OtherEmail
, WorkNumber
, WorkExtension
, HomeAddress1
, HomeAddress2
, HomeCityId
, homeCity.CityName as   HomeCityName
, HomeStateId
, homeState.StateName as HomeStateName
, HomeCountryId
, HomeZipCode
, MailingAddress1
, MailingAddress2
, MailingCityId
, mailingCity.CityName as  MailingCityName
, MailingStateId
, mailingState.StateName as MailingStateName
, MailingZipCode
FROM UserContactInformation uif
LEFT JOIN City homeCity ON homeCity.CityId = uif.HomeCityId
LEFT JOIN State homeState ON homeState.StateId = uif.HomeStateId
LEFT JOIN City mailingCity ON mailingCity.CityId = uif.MailingCityId
LEFT JOIN State mailingState ON mailingState.StateId = uif.MailingStateId
WHERE uif.DataEntryStatus = 1

GO
