USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[CategoryTypes]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoryTypes](
	[ClientID] [bigint] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](15) NOT NULL,
	[canFree] [bit] NULL,
	[canReduce] [bit] NULL,
	[isDeleted] [bit] NOT NULL,
	[isMealPlan] [bit] NULL,
	[isMealEquiv] [bit] NULL,
	[IsFee] [bit] NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_CategoryTypes] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CategoryTypes] ADD  CONSTRAINT [DF__CategoryT__isDel__0663BBFA]  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[CategoryTypes] ADD  CONSTRAINT [DF__tmp_ms_xx__isMea__7A92169B]  DEFAULT ((0)) FOR [isMealPlan]
GO
ALTER TABLE [dbo].[CategoryTypes] ADD  CONSTRAINT [DF__tmp_ms_xx__isMea__7B863AD4]  DEFAULT ((0)) FOR [isMealEquiv]
GO
ALTER TABLE [dbo].[CategoryTypes] ADD  CONSTRAINT [DF__CategoryT__IsFee__361DBC14]  DEFAULT ((0)) FOR [IsFee]
GO
ALTER TABLE [dbo].[CategoryTypes] ADD  CONSTRAINT [DF__tmp_ms_xx__LastU__7C7A5F0D]  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[CategoryTypes] ADD  CONSTRAINT [DF__tmp_ms_xx__Updat__7D6E8346]  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[CategoryTypes] ADD  CONSTRAINT [DF__tmp_ms_xx__Cloud__7E62A77F]  DEFAULT ((0)) FOR [CloudIDSync]
GO
