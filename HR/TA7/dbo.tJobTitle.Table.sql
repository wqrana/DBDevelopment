USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tJobTitle]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tJobTitle](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](30) NULL,
	[Code] [nvarchar](10) NULL,
	[nDeptID] [int] NULL,
	[boolUSECFSEAssignment] [bit] NOT NULL,
	[strCFSECode] [nvarchar](50) NOT NULL,
	[decCFSECompanyPercent] [decimal](18, 5) NOT NULL,
 CONSTRAINT [PK_tJobTitle] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tJobTitle] ADD  DEFAULT ((0)) FOR [boolUSECFSEAssignment]
GO
ALTER TABLE [dbo].[tJobTitle] ADD  DEFAULT ('') FOR [strCFSECode]
GO
ALTER TABLE [dbo].[tJobTitle] ADD  DEFAULT ((0)) FOR [decCFSECompanyPercent]
GO
