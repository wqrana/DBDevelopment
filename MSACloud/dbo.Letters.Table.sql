USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[Letters]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Letters](
	[ClientID] [bigint] NOT NULL,
	[District_Id] [bigint] NOT NULL,
	[Language_Id] [bigint] NULL,
	[Letter1] [varbinary](max) NULL,
	[Letter2] [varbinary](max) NULL,
	[Letter3] [varbinary](max) NULL,
 CONSTRAINT [PK_Letters] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[District_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [CST_Unique_DID_LID] UNIQUE NONCLUSTERED 
(
	[ClientID] ASC,
	[District_Id] ASC,
	[Language_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
