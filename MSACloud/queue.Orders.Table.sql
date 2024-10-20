USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [queue].[Orders]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [queue].[Orders](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
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
	[IsPosted] [bit] NULL,
	[Local_Id] [int] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[Cloud_Id] [int] NULL,
 CONSTRAINT [PK_Queue_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
