USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyFileInfo]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyFileInfo](
	[intFileID] [int] NOT NULL,
	[strFileName] [nvarchar](50) NOT NULL,
	[strFIlePath] [nvarchar](250) NOT NULL,
	[strCompanyName] [nvarchar](50) NOT NULL,
	[intFileType] [int] NOT NULL,
 CONSTRAINT [PK_tblCompanyFileInfo] PRIMARY KEY CLUSTERED 
(
	[intFileID] ASC,
	[strCompanyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
