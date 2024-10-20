USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[POSNotifications]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POSNotifications](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](16) NULL,
	[Code] [varchar](8) NULL,
	[Description] [varchar](80) NULL,
	[TextColor] [int] NULL,
	[BackColor] [int] NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
	[TextColorS] [varchar](10) NOT NULL,
	[BackColorS] [varchar](10) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_POSNotifications] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[POSNotifications] ADD  CONSTRAINT [DF__POSNotifi__LastU__7F76C749]  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[POSNotifications] ADD  CONSTRAINT [DF__POSNotifi__Updat__006AEB82]  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[POSNotifications] ADD  CONSTRAINT [DF__POSNotifi__Cloud__015F0FBB]  DEFAULT ((0)) FOR [CloudIDSync]
GO
ALTER TABLE [dbo].[POSNotifications] ADD  CONSTRAINT [DF__POSNotifi__IsDel__1432B864]  DEFAULT ((0)) FOR [IsDeleted]
GO
