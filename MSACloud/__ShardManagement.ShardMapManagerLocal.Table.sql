USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [__ShardManagement].[ShardMapManagerLocal]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardMapManagerLocal](
	[StoreVersionMajor] [int] NOT NULL,
	[StoreVersionMinor] [int] NOT NULL,
 CONSTRAINT [pkShardMapManagerLocal_StoreVersionMajor] PRIMARY KEY CLUSTERED 
(
	[StoreVersionMajor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
