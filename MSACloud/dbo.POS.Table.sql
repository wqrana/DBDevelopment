USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[POS]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[POS](
	[ClientID] [bigint] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[School_Id] [bigint] NOT NULL,
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
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_POS] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[POS] ADD  DEFAULT ((0)) FOR [isMealEqual]
GO
ALTER TABLE [dbo].[POS] ADD  DEFAULT ((-1)) FOR [MealEqual1]
GO
ALTER TABLE [dbo].[POS] ADD  DEFAULT ((-1)) FOR [MealEqual2]
GO
ALTER TABLE [dbo].[POS] ADD  DEFAULT ((-1)) FOR [MealEqual3]
GO
ALTER TABLE [dbo].[POS] ADD  DEFAULT ((0)) FOR [EnableCCProcessing]
GO
ALTER TABLE [dbo].[POS] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[POS] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[POS] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[POS] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
