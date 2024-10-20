USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[CategoryTypes]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[CategoryTypes](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
	[Name] [varchar](15) NOT NULL,
	[canFree] [bit] NULL,
	[canReduce] [bit] NULL,
	[isDeleted] [bit] NULL,
	[isMealPlan] [bit] NULL,
	[isMealEquiv] [bit] NULL,
	[IsFee] [bit] NULL,
	[LastUpdatedUTC] [datetime] NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_CategoryTypes] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[CategoryTypes] ADD  DEFAULT ((0)) FOR [isMealPlan]
GO
ALTER TABLE [Deleted].[CategoryTypes] ADD  DEFAULT ((0)) FOR [isMealEquiv]
GO
ALTER TABLE [Deleted].[CategoryTypes] ADD  DEFAULT ((0)) FOR [IsFee]
GO
ALTER TABLE [Deleted].[CategoryTypes] ADD  CONSTRAINT [CategoryTypes_DefaultUpdateDate]  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[CategoryTypes] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[CategoryTypes] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
