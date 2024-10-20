USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblGLAccounts]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblGLAccounts](
	[strCompanyName] [nvarchar](50) NOT NULL,
	[strAccountID] [nvarchar](50) NOT NULL,
	[strAccountName] [nvarchar](200) NOT NULL,
	[strAccountDescription] [nvarchar](200) NULL,
	[intAccountType] [int] NOT NULL,
	[intControlTypeID] [int] NOT NULL,
 CONSTRAINT [PK_tblAccounts] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC,
	[strAccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblGLAccounts] ADD  DEFAULT ((0)) FOR [intControlTypeID]
GO
