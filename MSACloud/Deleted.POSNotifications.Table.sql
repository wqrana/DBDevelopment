USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[POSNotifications]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[POSNotifications](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[Name] [varchar](16) NULL,
	[Code] [varchar](8) NULL,
	[Description] [varchar](80) NULL,
	[TextColor] [int] NULL,
	[BackColor] [int] NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_POSNotifications] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[POSNotifications] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[POSNotifications] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[POSNotifications] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
