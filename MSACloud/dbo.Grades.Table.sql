USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[Grades]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grades](
	[ClientID] [bigint] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](15) NOT NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_Grades] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Grades] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[Grades] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[Grades] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
