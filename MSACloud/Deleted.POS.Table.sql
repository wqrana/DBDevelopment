USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[POS]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[POS](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
	[School_Id] [int] NOT NULL,
	[Name] [varchar](15) NOT NULL,
	[ShortCutsNumber] [int] NULL,
	[ShortCutsBlob] [image] NULL,
	[isQuickSale] [bit] NULL,
	[Quick1] [int] NULL,
	[Quick2] [int] NULL,
	[Quick3] [int] NULL,
	[isMealEqual] [bit] NULL,
	[MealEqual1] [int] NULL,
	[MealEqual2] [int] NULL,
	[MealEqual3] [int] NULL,
	[EnableCCProcessing] [bit] NULL,
	[VeriFoneUserId] [varchar](20) NULL,
	[VeriFonePassword] [varchar](20) NULL,
	[isDeleted] [bit] NOT NULL,
	[LastUpdatedUTC] [datetime] NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_POS] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Deleted].[POS] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [Deleted].[POS] ADD  CONSTRAINT [POS_DefaultUpdateDate]  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[POS] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[POS] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
