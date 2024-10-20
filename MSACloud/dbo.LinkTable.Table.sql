USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[LinkTable]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LinkTable](
	[ClientID] [bigint] NOT NULL,
	[Alias] [varchar](25) NOT NULL,
	[Path] [varchar](256) NULL,
 CONSTRAINT [PK_LinkTable] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[Alias] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
