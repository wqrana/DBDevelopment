USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[CashResults]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[CashResults](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[POS_Id] [int] NOT NULL,
	[Emp_Cashier_Id] [int] NOT NULL,
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
	[CashDrawer_Id] [int] NULL,
	[LocalServerID] [int] NULL,
	[PartitionId] [varchar](32) NULL,
	[PartitionOffset] [varchar](32) NULL,
	[LastUpdatedUTC] [datetime] NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_CashResults] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Deleted].[CashResults] ADD  DEFAULT ((0)) FOR [CashDrawer_Id]
GO
ALTER TABLE [Deleted].[CashResults] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[CashResults] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[CashResults] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
