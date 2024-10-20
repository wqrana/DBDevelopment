USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [__ShardManagement].[ShardMapsLocal]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardMapsLocal](
	[ShardMapId] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[MapType] [int] NOT NULL,
	[KeyType] [int] NOT NULL,
	[LastOperationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [pkShardMapsLocal_ShardMapId] PRIMARY KEY CLUSTERED 
(
	[ShardMapId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [__ShardManagement].[ShardMapsLocal] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [LastOperationId]
GO
