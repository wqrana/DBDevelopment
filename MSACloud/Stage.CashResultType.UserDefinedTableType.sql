USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [Stage].[CashResultType]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [Stage].[CashResultType] AS TABLE(
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NULL,
	[POSId] [int] NOT NULL,
	[EmpCashierId] [int] NOT NULL,
	[OpenDate] [datetime2](7) NULL,
	[OpenDateLocal] [datetime2](7) NULL,
	[CloseDate] [datetime2](7) NULL,
	[CloseDateLocal] [datetime2](7) NULL,
	[TotalCash] [float] NULL,
	[OverShort] [float] NULL,
	[Additional] [float] NULL,
	[PaidOuts] [float] NULL,
	[OpenAmount] [float] NULL,
	[CloseAmount] [float] NULL,
	[Sales] [float] NULL,
	[Finished] [bit] NULL,
	[OpenBlob] [varbinary](max) NULL,
	[CloseBlob] [varbinary](max) NULL,
	[CashDrawerId] [int] NULL DEFAULT ((0)),
	[PartitionId] [varchar](32) NULL,
	[PartitionOffset] [varchar](32) NULL,
	[Local_ID] [int] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[Cloud_Id] [int] NULL
)
GO
