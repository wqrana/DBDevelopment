USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedTableType [Stage].[BonusPaymentType]    Script Date: 10/18/2024 11:30:48 PM ******/
CREATE TYPE [Stage].[BonusPaymentType] AS TABLE(
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[Customer_Id] [bigint] NOT NULL,
	[BonusDate] [datetime2](7) NOT NULL,
	[BonusDateLocal] [datetime2](7) NOT NULL,
	[MealPlan] [bigint] NULL,
	[BonusPaid] [float] NULL,
	[PriorBal] [float] NULL,
	[Order_Id] [bigint] NULL,
	[PartitionId] [varchar](32) NULL,
	[PartitionOffset] [varchar](32) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[Local_ID] [int] NULL,
	[Cloud_Id] [int] NULL
)
GO
