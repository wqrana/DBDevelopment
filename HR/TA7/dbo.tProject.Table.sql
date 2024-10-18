USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tProject]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tProject](
	[nProjectID] [int] NOT NULL,
	[sProjectName] [nvarchar](50) NULL,
	[sProjectPayCode] [nvarchar](50) NULL,
	[sProjectDesc] [nvarchar](50) NULL,
	[nCustomerID] [int] NULL,
 CONSTRAINT [PK_tProjectID] PRIMARY KEY CLUSTERED 
(
	[nProjectID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
