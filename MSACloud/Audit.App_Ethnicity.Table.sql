USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Audit].[App_Ethnicity]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Audit].[App_Ethnicity](
	[Version] [int] NOT NULL,
	[Change_Date] [datetime2](7) NOT NULL,
	[Action] [char](1) NOT NULL,
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[Application_Id] [bigint] NOT NULL,
	[Ethnic_Id] [int] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_App_Ethnicity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC,
	[Version] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Audit].[App_Ethnicity] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Audit].[App_Ethnicity] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Audit].[App_Ethnicity] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
