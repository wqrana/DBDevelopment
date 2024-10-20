USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[LunchTypes]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[LunchTypes](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
	[Name] [varchar](20) NOT NULL,
	[Sun] [bit] NULL,
	[Mon] [bit] NULL,
	[Tue] [bit] NULL,
	[Wed] [bit] NULL,
	[Thur] [bit] NULL,
	[Fri] [bit] NULL,
	[Sat] [bit] NULL,
	[StartTime] [smalldatetime] NULL,
	[EndTime] [smalldatetime] NULL,
	[NumMeals] [int] NULL,
	[Reset] [bit] NULL,
	[ResetDay] [int] NULL,
	[Bonus] [int] NULL,
	[BonusOnce] [float] NULL,
	[BonusAmount] [float] NULL,
	[BonusLimit] [float] NULL,
	[CarryLimit] [int] NULL,
	[DollarOnce] [float] NULL,
	[LastUpdatedUTC] [datetime] NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_LunchTypes] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[LunchTypes] ADD  CONSTRAINT [LunchTypes_DefaultUpdateDate]  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[LunchTypes] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[LunchTypes] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
