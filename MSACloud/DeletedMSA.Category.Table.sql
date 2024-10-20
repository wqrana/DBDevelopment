USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [DeletedMSA].[Category]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DeletedMSA].[Category](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
	[CategoryType_Id] [int] NULL,
	[Name] [varchar](20) NOT NULL,
	[isActive] [bit] NULL,
	[isDeleted] [bit] NULL,
	[Color] [varchar](10) NULL,
	[AccountNumber] [varchar](30) NULL,
	[LastUpdatedUTC] [datetime] NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_Category] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [DeletedMSA].[Category] ADD  CONSTRAINT [Category_DefaultUpdateDate]  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [DeletedMSA].[Category] ADD  CONSTRAINT [DF__tmp_ms_xx__Updat__478773E1]  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [DeletedMSA].[Category] ADD  CONSTRAINT [DF__tmp_ms_xx__Cloud__487B981A]  DEFAULT ((0)) FOR [CloudIDSync]
GO
