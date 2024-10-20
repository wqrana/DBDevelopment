USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [__ShardManagement].[ShardsLocal]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [__ShardManagement].[ShardsLocal](
	[ShardId] [uniqueidentifier] NOT NULL,
	[Version] [uniqueidentifier] NOT NULL,
	[ShardMapId] [uniqueidentifier] NOT NULL,
	[Protocol] [int] NOT NULL,
	[ServerName] [nvarchar](128) NOT NULL,
	[Port] [int] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[Status] [int] NOT NULL,
	[LastOperationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [pkShardsLocal_ShardId] PRIMARY KEY CLUSTERED 
(
	[ShardId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [ucShardsLocal_ShardMapId_Location] UNIQUE NONCLUSTERED 
(
	[ShardMapId] ASC,
	[Protocol] ASC,
	[ServerName] ASC,
	[DatabaseName] ASC,
	[Port] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [__ShardManagement].[ShardsLocal] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [LastOperationId]
GO
ALTER TABLE [__ShardManagement].[ShardsLocal]  WITH CHECK ADD  CONSTRAINT [fkShardsLocal_ShardMapId] FOREIGN KEY([ShardMapId])
REFERENCES [__ShardManagement].[ShardMapsLocal] ([ShardMapId])
GO
ALTER TABLE [__ShardManagement].[ShardsLocal] CHECK CONSTRAINT [fkShardsLocal_ShardMapId]
GO
