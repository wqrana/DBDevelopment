USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [queue].[PreOrderItems]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [queue].[PreOrderItems](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[PreSale_Id] [int] NOT NULL,
	[ServingDate] [datetime2](7) NULL,
	[PickupDate] [datetime2](7) NULL,
	[Disposition] [int] NOT NULL,
	[PreOrder_Id] [bigint] NOT NULL,
	[Menu_Id] [int] NULL,
	[Qty] [int] NOT NULL,
	[FullPrice] [float] NULL,
	[PaidPrice] [float] NOT NULL,
	[TaxPrice] [float] NULL,
	[isVoid] [bit] NOT NULL,
	[SoldType] [int] NULL,
	[PickupCount] [int] NOT NULL,
	[IsPosted] [bit] NULL,
	[LastUpdatedUTC] [datetime] NULL,
	[CloudIDSync] [bit] NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[Cloud_Id] [int] NULL,
 CONSTRAINT [PK_Queue_PreOrderItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
