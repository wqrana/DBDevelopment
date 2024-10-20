USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompensationImportTypes]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompensationImportTypes](
	[intImportType] [int] NOT NULL,
	[strImportTypeName] [nvarchar](50) NULL,
	[strDescription] [nvarchar](50) NULL,
	[boolEnabled] [bit] NULL,
 CONSTRAINT [PK_tblCompensationImportTypes] PRIMARY KEY CLUSTERED 
(
	[intImportType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
