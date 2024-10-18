USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[FRStatusHistory]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[FRStatusHistory](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
	[StatusDate] [smalldatetime] NOT NULL,
	[StatusData] [varbinary](max) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_FRStatusHistory] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Deleted].[FRStatusHistory] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[FRStatusHistory] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[FRStatusHistory] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
