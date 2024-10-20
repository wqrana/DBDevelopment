USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[PreOrderItems]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PreOrderItems](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PreSale_Id] [int] NOT NULL,
	[ServingDate] [datetime2](7) NULL,
	[PickupDate] [datetime2](7) NULL,
	[Disposition] [int] NOT NULL,
	[PreOrder_Id] [bigint] NOT NULL,
	[Menu_Id] [bigint] NULL,
	[Qty] [int] NOT NULL,
	[FullPrice] [float] NULL,
	[PaidPrice] [float] NOT NULL,
	[TaxPrice] [float] NULL,
	[isVoid] [bit] NOT NULL,
	[SoldType] [int] NULL,
	[PickupCount] [int] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_PreOrderItems] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PreOrderItems] ADD  DEFAULT ((1)) FOR [Qty]
GO
ALTER TABLE [dbo].[PreOrderItems] ADD  DEFAULT ((0.00)) FOR [PaidPrice]
GO
ALTER TABLE [dbo].[PreOrderItems] ADD  DEFAULT ((0)) FOR [isVoid]
GO
ALTER TABLE [dbo].[PreOrderItems] ADD  DEFAULT ((0)) FOR [PickupCount]
GO
ALTER TABLE [dbo].[PreOrderItems] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[PreOrderItems] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[PreOrderItems] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
