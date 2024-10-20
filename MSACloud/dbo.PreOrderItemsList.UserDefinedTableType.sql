USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [dbo].[PreOrderItemsList]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [dbo].[PreOrderItemsList] AS TABLE(
	[PreSale_Id] [int] NULL,
	[ServingDate] [datetime] NOT NULL,
	[PickupDate] [datetime] NULL,
	[Disposition] [int] NULL,
	[Menu_Id] [int] NOT NULL,
	[Qty] [int] NOT NULL,
	[FullPrice] [float] NOT NULL,
	[PaidPrice] [float] NOT NULL,
	[TaxPrice] [float] NOT NULL,
	[isVoid] [bit] NOT NULL,
	[SoldType] [int] NULL,
	[PickupCount] [int] NULL
)
GO
