USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblReynoldsGLSplit]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReynoldsGLSplit](
	[intUserID] [int] NOT NULL,
	[strGL1] [nvarchar](50) NOT NULL,
	[decGl1Percent] [decimal](18, 5) NOT NULL,
	[strGL2] [nvarchar](50) NOT NULL,
	[decGL2Percent] [decimal](18, 5) NOT NULL
) ON [PRIMARY]
GO
