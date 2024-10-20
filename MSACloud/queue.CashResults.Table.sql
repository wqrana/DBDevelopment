USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [queue].[CashResults]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [queue].[CashResults](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
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
	[CashDrawerId] [int] NULL,
	[PartitionId] [varchar](32) NULL,
	[PartitionOffset] [varchar](32) NULL,
	[IsPosted] [bit] NULL,
	[Local_ID] [int] NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[Cloud_Id] [int] NULL,
 CONSTRAINT [PK_Queue_CashResults] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
