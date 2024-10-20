USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [Stage].[PreOrderItemsType]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [Stage].[PreOrderItemsType] AS TABLE(
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NULL,
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
	[LastUpdatedUTC] [datetime] NULL,
	[CloudIDSync] [bit] NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[Cloud_Id] [int] NULL
)
GO
