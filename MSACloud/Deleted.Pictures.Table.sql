USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[Pictures]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[Pictures](
	[ClientID] [bigint] NOT NULL,
	[Customer_Id] [int] NOT NULL,
	[Picture] [image] NULL,
	[PictureExtension] [varchar](5) NOT NULL,
	[StorageAccountName] [varchar](256) NOT NULL,
	[ContainerName] [varchar](63) NOT NULL,
	[PictureFileName] [varchar](1024) NULL,
	[LastUpdatedUTC] [datetime] NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_Pictures] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[Customer_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Deleted].[Pictures] ADD  DEFAULT ('jpg') FOR [PictureExtension]
GO
ALTER TABLE [Deleted].[Pictures] ADD  DEFAULT ('adminhq') FOR [StorageAccountName]
GO
ALTER TABLE [Deleted].[Pictures] ADD  DEFAULT ('customerspics') FOR [ContainerName]
GO
ALTER TABLE [Deleted].[Pictures] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[Pictures] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[Pictures] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
ALTER TABLE [Deleted].[Pictures]  WITH CHECK ADD CHECK  ((lower([ContainerName])=[ContainerName] AND charindex('-',[ContainerName])=(0) AND (ascii([ContainerName])>=(48) AND ascii([ContainerName])<=(57) OR ascii([ContainerName])>=(97) AND ascii([ContainerName])<=(122))))
GO
