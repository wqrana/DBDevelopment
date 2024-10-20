USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[DownstreamSyncResults]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DownstreamSyncResults](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[SuccessCount] [int] NULL,
	[FailureCount] [int] NULL,
	[TotalMergeCount] [int] NULL,
	[TotalDeleteCount] [int] NULL,
	[StatusMessage] [varchar](4000) NULL,
	[ResultsJson] [varchar](max) NULL,
	[SyncTimeUTC] [datetime2](7) NULL,
	[ClientID] [bigint] NOT NULL,
 CONSTRAINT [PK_DownstreamSyncResults] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
