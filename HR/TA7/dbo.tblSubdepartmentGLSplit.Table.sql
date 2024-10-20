USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblSubdepartmentGLSplit]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSubdepartmentGLSplit](
	[intSubdepartmentID] [int] NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
	[decGlPercent] [decimal](18, 5) NOT NULL
) ON [PRIMARY]
GO
