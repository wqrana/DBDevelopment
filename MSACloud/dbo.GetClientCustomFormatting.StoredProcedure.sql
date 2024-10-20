USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GetClientCustomFormatting]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetClientCustomFormatting]
(
    @clientid bigint
	, @settinggroupid int
)
AS
BEGIN
    select  
		cs.ClientId
		, cs.SettingNameId SettingId
		, csn.SettingName
		, csn.SettingsDescription
		, csn.SettingGroupId
		, csg.SettingGroupName
		, cs.SettingValue
	from clientsettings cs
	inner join (select * from clientsettingnames where SettingGroupId = @settinggroupid) csn on (cs.SettingNameId = csn.id)
	inner join (select * from clientsettingsgroup where (id = @settinggroupid)) csg on (csn.SettingGroupId = csg.Id)
	where (1 = 1)

	and (cs.clientid = @clientid)
	and (cs.settingnameid in (select id from ClientSettingNames where (settinggroupid = @settinggroupid)))
END
GO
