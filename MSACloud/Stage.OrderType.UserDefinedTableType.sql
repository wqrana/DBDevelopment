USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [Stage].[OrderType]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [Stage].[OrderType] AS TABLE(
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NULL,
	[CustomerPrSchoolId] [int] NULL,
	[POSId] [int] NOT NULL,
	[SchoolId] [int] NULL,
	[EmpCashierId] [int] NULL,
	[CustomerId] [int] NOT NULL,
	[OrdersLogId] [int] NULL,
	[GDate] [smalldatetime] NULL,
	[OrderDate] [datetime2](7) NOT NULL,
	[OrderDateLocal] [datetime2](7) NULL,
	[LunchType] [int] NULL,
	[ADebit] [float] NULL,
	[ACredit] [float] NULL,
	[BCredit] [float] NULL,
	[MDebit] [float] NULL,
	[MCredit] [float] NULL,
	[CheckNumber] [int] NULL,
	[OverRide] [bit] NULL,
	[isVoid] [bit] NULL,
	[TransType] [int] NULL,
	[CreditAuthId] [int] NULL,
	[PartitionId] [varchar](32) NOT NULL,
	[PartitionOffset] [varchar](32) NOT NULL,
	[Local_Id] [int] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[Cloud_Id] [int] NULL
)
GO
