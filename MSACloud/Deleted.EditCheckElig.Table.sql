USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[EditCheckElig]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[EditCheckElig](
	[ClientID] [bigint] NOT NULL,
	[ID] [bigint] NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[School_Id] [int] NOT NULL,
	[FreeElig] [int] NULL,
	[RedElig] [int] NULL,
	[PaidElig] [int] NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_EditCheckElig] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[EditCheckElig] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[EditCheckElig] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[EditCheckElig] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
