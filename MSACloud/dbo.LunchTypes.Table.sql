USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[LunchTypes]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LunchTypes](
	[ClientID] [bigint] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
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
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_LunchTypes] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LunchTypes] ADD  DEFAULT ((-7)) FOR [CarryLimit]
GO
ALTER TABLE [dbo].[LunchTypes] ADD  DEFAULT ((0.0)) FOR [DollarOnce]
GO
ALTER TABLE [dbo].[LunchTypes] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[LunchTypes] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[LunchTypes] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
