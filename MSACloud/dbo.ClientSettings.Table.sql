USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[ClientSettings]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClientSettings](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClientId] [bigint] NULL,
	[SettingNameId] [smallint] NULL,
	[SettingValue] [nvarchar](400) NULL,
 CONSTRAINT [PK_ClientSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
