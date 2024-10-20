USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tUserJobCodes]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tUserJobCodes](
	[nUserID] [int] NOT NULL,
	[nJobCodeID] [int] NOT NULL,
	[dblPercent] [decimal](18, 5) NOT NULL,
	[nType] [int] NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tUserJobCodes] PRIMARY KEY CLUSTERED 
(
	[nUserID] ASC,
	[nJobCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tUserJobCodes] ADD  DEFAULT ((0)) FOR [nJobCodeID]
GO
ALTER TABLE [dbo].[tUserJobCodes] ADD  DEFAULT ((0)) FOR [dblPercent]
GO
ALTER TABLE [dbo].[tUserJobCodes] ADD  DEFAULT ((0)) FOR [nType]
GO
ALTER TABLE [dbo].[tUserJobCodes] ADD  DEFAULT ('') FOR [strGLAccount]
GO
