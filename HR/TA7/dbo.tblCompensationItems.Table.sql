USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompensationItems]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompensationItems](
	[strCompensationName] [nvarchar](50) NOT NULL,
	[strDescription] [nvarchar](50) NULL,
	[intCompensationType] [int] NOT NULL,
	[intComputationType] [int] NOT NULL,
	[boolEnabled] [bit] NOT NULL,
	[intImportType] [int] NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
	[boolCovidCompensation] [bit] NOT NULL,
	[boolFICASSCCExempt] [bit] NOT NULL,
 CONSTRAINT [PK_tblCompensationItems] PRIMARY KEY CLUSTERED 
(
	[strCompensationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCompensationItems] ADD  DEFAULT ('') FOR [strGLAccount]
GO
ALTER TABLE [dbo].[tblCompensationItems] ADD  DEFAULT ((0)) FOR [boolCovidCompensation]
GO
ALTER TABLE [dbo].[tblCompensationItems] ADD  DEFAULT ((0)) FOR [boolFICASSCCExempt]
GO
