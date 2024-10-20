USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Stage].[TempOrders]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stage].[TempOrders](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientID] [bigint] NOT NULL,
	[Customer_Pr_School_Id] [int] NULL,
	[POS_Id] [int] NOT NULL,
	[School_Id] [int] NULL,
	[Emp_Cashier_Id] [int] NULL,
	[Customer_Id] [int] NOT NULL,
	[OrdersLog_Id] [int] NULL,
	[OrderDate] [datetime2](7) NOT NULL,
	[LunchType] [int] NULL,
	[MDebit] [float] NULL,
	[MCredit] [float] NULL,
	[CheckNumber] [int] NULL,
	[OverRide] [bit] NULL,
	[isVoid] [bit] NULL,
	[GDate] [smalldatetime] NULL,
	[ADebit] [float] NULL,
	[ACredit] [float] NULL,
	[PriorABal] [float] NULL,
	[PriorMBal] [float] NULL,
	[TransType] [int] NULL,
	[PriorBBal] [float] NULL,
	[BCredit] [float] NULL,
	[CreditAuth_Id] [int] NULL,
	[PartitionId] [varchar](32) NOT NULL,
	[PartitionOffset] [varchar](32) NOT NULL,
 CONSTRAINT [PK_TempOrders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
