USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [queue].[BonusPayments]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [queue].[BonusPayments](
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
	[IsPosted] [bit] NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[Local_ID] [int] NULL,
	[Cloud_Id] [int] NULL,
 CONSTRAINT [PK_Queue_BonusPayments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
