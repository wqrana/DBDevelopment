USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[DataSyncStatus]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataSyncStatus](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProcessName] [varchar](35) NULL,
	[StartTimeUTC] [datetime2](7) NULL,
	[EndTimeUTC] [datetime2](7) NULL,
	[BlobURL] [varchar](255) NULL,
	[Success] [bit] NULL,
 CONSTRAINT [PK_DataSyncStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
