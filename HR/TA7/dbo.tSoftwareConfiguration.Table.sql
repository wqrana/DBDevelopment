USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tSoftwareConfiguration]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tSoftwareConfiguration](
	[nConfigID] [int] NOT NULL,
	[nConfigParam] [int] NULL,
	[sConfigDesc] [nvarchar](50) NULL,
	[nConfigType] [int] NULL,
	[objConfigParam] [image] NULL,
 CONSTRAINT [PK_tSoftwareConfiguration] PRIMARY KEY CLUSTERED 
(
	[nConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
