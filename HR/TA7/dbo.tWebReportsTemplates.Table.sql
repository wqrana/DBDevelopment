USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tWebReportsTemplates]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tWebReportsTemplates](
	[nReportID] [int] NOT NULL,
	[sReportName] [nvarchar](50) NULL,
	[sReportDesc] [nvarchar](50) NULL,
	[nReportType] [int] NULL,
	[sReport] [nvarchar](max) NULL,
	[sOriginalFileName] [nvarchar](50) NULL,
	[sReportTitle] [nvarchar](50) NULL,
	[sReportPolicyName] [nvarchar](50) NULL,
 CONSTRAINT [PK_tWebReportsTemplates] PRIMARY KEY CLUSTERED 
(
	[nReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
