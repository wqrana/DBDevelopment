USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [Stage].[TransactionType]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [Stage].[TransactionType] AS TABLE(
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NULL,
	[OrderId] [int] NOT NULL,
	[OrderType] [int] NOT NULL,
	[CashResId] [int] NULL,
	[PartitionId] [varchar](32) NOT NULL,
	[PartitionOffset] [varchar](32) NOT NULL,
	[Local_ID] [int] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[Cloud_Id] [int] NULL
)
GO
