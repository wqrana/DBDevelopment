USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[PreOrders]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[PreOrders](
	[ClientID] [bigint] NOT NULL,
	[PreSaleTrans_Id] [int] NOT NULL,
	[Customer_Id] [int] NOT NULL,
	[OrdersLog_Id] [bigint] NULL,
	[PurchasedDate] [datetime2](7) NOT NULL,
	[PurchasedDateLocal] [datetime2](7) NOT NULL,
	[TransferDate] [datetime2](7) NOT NULL,
	[TransferDateLocal] [datetime2](7) NOT NULL,
	[LunchType] [int] NOT NULL,
	[MCredit] [float] NOT NULL,
	[ACredit] [float] NOT NULL,
	[BCredit] [float] NOT NULL,
	[TotalSale] [float] NOT NULL,
	[isVoid] [bit] NOT NULL,
	[ItemCount] [int] NOT NULL,
	[Transtype] [int] NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_PreOrders] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[PreOrders] ADD  DEFAULT ((0.00)) FOR [MCredit]
GO
ALTER TABLE [Deleted].[PreOrders] ADD  DEFAULT ((0.00)) FOR [ACredit]
GO
ALTER TABLE [Deleted].[PreOrders] ADD  DEFAULT ((0.00)) FOR [BCredit]
GO
ALTER TABLE [Deleted].[PreOrders] ADD  DEFAULT ((0)) FOR [isVoid]
GO
ALTER TABLE [Deleted].[PreOrders] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[PreOrders] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[PreOrders] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
