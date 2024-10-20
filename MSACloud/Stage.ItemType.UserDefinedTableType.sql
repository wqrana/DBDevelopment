USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [Stage].[ItemType]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [Stage].[ItemType] AS TABLE(
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NULL,
	[OrderId] [int] NOT NULL,
	[MenuId] [int] NOT NULL,
	[Qty] [int] NULL,
	[FullPrice] [float] NULL,
	[PaidPrice] [float] NULL,
	[TaxPrice] [float] NULL,
	[isVoid] [bit] NULL,
	[SoldType] [int] NULL,
	[PreOrderItemId] [int] NULL,
	[Local_ID] [int] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[Cloud_Id] [int] NULL
)
GO
