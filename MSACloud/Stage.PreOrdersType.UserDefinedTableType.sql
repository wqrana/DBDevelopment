USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [Stage].[PreOrdersType]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [Stage].[PreOrdersType] AS TABLE(
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NULL,
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
	[PartitionId] [varchar](32) NULL,
	[PartitionOffset] [varchar](32) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
	[Cloud_Id] [int] NULL
)
GO
