USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[App_Members]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[App_Members](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[Application_Id] [bigint] NOT NULL,
	[Ethnic_Id] [int] NULL,
	[Customer_Id] [bigint] NULL,
	[Member_Id] [bigint] NULL,
	[Foster] [bit] NULL,
	[Homeless] [bit] NULL,
	[Migrant] [bit] NULL,
	[Runaway] [bit] NULL,
	[NoIncome] [bit] NULL,
	[isStudent] [bit] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_App_Members] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[App_Members] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[App_Members] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[App_Members] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
