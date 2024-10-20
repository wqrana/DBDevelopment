USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[ClientSettingNames]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientSettingNames](
	[Id] [smallint] IDENTITY(1,1) NOT NULL,
	[SettingGroupId] [smallint] NULL,
	[SettingName] [nvarchar](80) NULL,
	[SettingsDescription] [nvarchar](800) NULL,
 CONSTRAINT [PK_ClientSettingNames] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
