USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[ecsFrequency]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[ecsFrequency](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[Name] [varchar](32) NULL,
	[Description] [varchar](max) NULL,
	[isOnce] [bit] NULL,
	[StartTime] [datetime2](7) NULL,
	[StopTime] [datetime2](7) NULL,
	[IntervalFirst] [int] NULL,
	[IntervalSecond] [int] NULL,
	[Frequency] [int] NULL,
	[Monday] [bit] NULL,
	[Tuesday] [bit] NULL,
	[Wednesday] [bit] NULL,
	[Thursday] [bit] NULL,
	[Friday] [bit] NULL,
	[Saturday] [bit] NULL,
	[Sunday] [bit] NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_ecsFrequency] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Deleted].[ecsFrequency] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[ecsFrequency] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[ecsFrequency] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
