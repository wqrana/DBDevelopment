USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[Items]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[Items](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[Order_Id] [bigint] NOT NULL,
	[Menu_Id] [bigint] NOT NULL,
	[Qty] [int] NULL,
	[FullPrice] [float] NULL,
	[PaidPrice] [float] NULL,
	[TaxPrice] [float] NULL,
	[isVoid] [bit] NULL,
	[SoldType] [int] NULL,
	[PreOrderItem_Id] [int] NULL,
	[LastUpdatedUTC] [datetime] NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_Items] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[Items] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[Items] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[Items] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
