USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [dbo].[OrderItemsList]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [dbo].[OrderItemsList] AS TABLE(
	[ClientID] [bigint] NOT NULL,
	[Order_Id] [bigint] NULL,
	[Menu_Id] [bigint] NULL,
	[Qty] [int] NULL,
	[FullPrice] [float] NULL,
	[PaidPrice] [float] NULL,
	[TaxPrice] [float] NULL,
	[isVoid] [bit] NULL,
	[SoldType] [int] NULL,
	[PreOrderItem_Id] [bigint] NULL
)
GO
