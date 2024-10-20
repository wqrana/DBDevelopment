USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyJobcodeGLLookup]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyJobcodeGLLookup](
	[strCompanyName] [nvarchar](50) NOT NULL,
	[intJobCodeID] [int] NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
	[decPercent] [decimal](18, 5) NOT NULL,
 CONSTRAINT [PK_tblCompanyJobcodeGLLookup] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC,
	[intJobCodeID] ASC,
	[strGLAccount] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCompanyJobcodeGLLookup] ADD  DEFAULT ((100.00)) FOR [decPercent]
GO
