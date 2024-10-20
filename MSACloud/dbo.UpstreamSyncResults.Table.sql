USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[UpstreamSyncResults]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UpstreamSyncResults](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](100) NULL,
	[StartTimeUtc] [datetime2](7) NULL,
	[EndTimeUtc] [datetime2](7) NULL,
	[InsertUpdateCount] [int] NULL,
	[DeleteCount] [int] NULL,
	[Success] [bit] NULL,
	[StatusMessage] [varchar](max) NULL,
	[ErrorException] [varchar](max) NULL,
 CONSTRAINT [PK_UpstreamSyncResults] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
