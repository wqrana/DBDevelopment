USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  User [identech]    Script Date: 10/18/2024 8:10:08 PM ******/
CREATE USER [identech] FOR LOGIN [identech] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [identech]
GO
ALTER ROLE [db_datareader] ADD MEMBER [identech]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [identech]
GO
