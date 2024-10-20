USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[Orders]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[Orders](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[Customer_Pr_School_Id] [int] NULL,
	[POS_Id] [int] NOT NULL,
	[School_Id] [int] NULL,
	[Emp_Cashier_Id] [int] NULL,
	[Customer_Id] [int] NOT NULL,
	[OrdersLog_Id] [int] NULL,
	[GDate] [smalldatetime] NOT NULL,
	[OrderDate] [datetime2](7) NOT NULL,
	[OrderDateLocal] [datetime2](7) NULL,
	[LunchType] [int] NULL,
	[ADebit] [float] NULL,
	[MDebit] [float] NULL,
	[ACredit] [float] NULL,
	[BCredit] [float] NULL,
	[MCredit] [float] NULL,
	[CheckNumber] [int] NULL,
	[OverRide] [bit] NULL,
	[isVoid] [bit] NULL,
	[TransType] [int] NULL,
	[CreditAuth_Id] [int] NULL,
	[LocalServerID] [int] NULL,
	[PartitionId] [varchar](32) NULL,
	[PartitionOffset] [varchar](32) NULL,
	[LastUpdatedUTC] [datetime2](7) NOT NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[Orders] ADD  DEFAULT ((0.0)) FOR [BCredit]
GO
ALTER TABLE [Deleted].[Orders] ADD  DEFAULT ((0)) FOR [CreditAuth_Id]
GO
ALTER TABLE [Deleted].[Orders] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[Orders] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[Orders] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
