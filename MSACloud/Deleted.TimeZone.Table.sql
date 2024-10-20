USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[TimeZone]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[TimeZone](
	[ClientID] [bigint] NOT NULL,
	[TimeZoneID] [int] NOT NULL,
	[TimeZoneName] [varchar](20) NULL,
	[BeginTime] [smalldatetime] NULL,
	[EndTime] [smalldatetime] NULL,
	[MenuItemID] [int] NULL,
	[Action] [smallint] NULL,
	[DayCode] [int] NULL,
	[isDeleted] [bit] NULL,
	[BeginTime1] [smalldatetime] NULL,
	[BeginTime2] [smalldatetime] NULL,
	[BeginTime3] [smalldatetime] NULL,
	[BeginTime4] [smalldatetime] NULL,
	[BeginTime5] [smalldatetime] NULL,
	[BeginTime6] [smalldatetime] NULL,
	[BeginTime7] [smalldatetime] NULL,
	[EndTime1] [smalldatetime] NULL,
	[EndTime2] [smalldatetime] NULL,
	[EndTime3] [smalldatetime] NULL,
	[EndTime4] [smalldatetime] NULL,
	[EndTime5] [smalldatetime] NULL,
	[EndTime6] [smalldatetime] NULL,
	[EndTime7] [smalldatetime] NULL,
	[ID] [bigint] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_TimeZone] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[TimeZone] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [Deleted].[TimeZone] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[TimeZone] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[TimeZone] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
