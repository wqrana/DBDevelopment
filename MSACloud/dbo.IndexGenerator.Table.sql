USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[IndexGenerator]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndexGenerator](
	[ClientID] [bigint] NOT NULL,
	[ObjectID] [int] NOT NULL,
	[NextValue] [int] NULL,
 CONSTRAINT [PK_IndexGenerator] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[ObjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
