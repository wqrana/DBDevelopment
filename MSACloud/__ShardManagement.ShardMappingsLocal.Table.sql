USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [__ShardManagement].[ShardMappingsLocal]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardMappingsLocal](
	[MappingId] [uniqueidentifier] NOT NULL,
	[ShardId] [uniqueidentifier] NOT NULL,
	[ShardMapId] [uniqueidentifier] NOT NULL,
	[MinValue] [varbinary](128) NOT NULL,
	[MaxValue] [varbinary](128) NULL,
	[Status] [int] NOT NULL,
	[LockOwnerId] [uniqueidentifier] NOT NULL,
	[LastOperationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [pkShardMappingsLocal_MappingId] PRIMARY KEY CLUSTERED 
(
	[MappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [ucShardMappingsLocal_ShardMapId_MinValue] UNIQUE NONCLUSTERED 
(
	[ShardMapId] ASC,
	[MinValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [__ShardManagement].[ShardMappingsLocal] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [LockOwnerId]
GO
ALTER TABLE [__ShardManagement].[ShardMappingsLocal] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [LastOperationId]
GO
ALTER TABLE [__ShardManagement].[ShardMappingsLocal]  WITH CHECK ADD  CONSTRAINT [fkShardMappingsLocal_ShardId] FOREIGN KEY([ShardId])
REFERENCES [__ShardManagement].[ShardsLocal] ([ShardId])
GO
ALTER TABLE [__ShardManagement].[ShardMappingsLocal] CHECK CONSTRAINT [fkShardMappingsLocal_ShardId]
GO
ALTER TABLE [__ShardManagement].[ShardMappingsLocal]  WITH CHECK ADD  CONSTRAINT [fkShardMappingsLocal_ShardMapId] FOREIGN KEY([ShardMapId])
REFERENCES [__ShardManagement].[ShardMapsLocal] ([ShardMapId])
GO
ALTER TABLE [__ShardManagement].[ShardMappingsLocal] CHECK CONSTRAINT [fkShardMappingsLocal_ShardMapId]
GO
