USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyGLAccountCategory]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyGLAccountCategory](
	[strCompanyName] [nvarchar](50) NOT NULL,
	[intCompanyID] [int] NOT NULL,
	[intDepartmentID] [int] NOT NULL,
	[intSubdepartmentID] [int] NOT NULL,
	[intEmployeeTypeID] [int] NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
	[intPositionID] [int] NOT NULL,
 CONSTRAINT [PK_tblCompanyGLAccountLookup_1] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC,
	[intCompanyID] ASC,
	[intDepartmentID] ASC,
	[intSubdepartmentID] ASC,
	[intEmployeeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCompanyGLAccountCategory] ADD  DEFAULT ((0)) FOR [intPositionID]
GO
