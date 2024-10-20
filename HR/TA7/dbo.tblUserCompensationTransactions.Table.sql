USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserCompensationTransactions]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserCompensationTransactions](
	[intUserID] [int] NOT NULL,
	[strCompensationName] [nvarchar](50) NOT NULL,
	[strTransName] [nvarchar](50) NOT NULL,
	[intType] [int] NULL,
	[strDescription] [nvarchar](50) NULL,
	[decDefaultMultiplier] [decimal](10, 2) NULL,
	[decDefaultOffsetValue] [decimal](18, 2) NULL,
 CONSTRAINT [PK_tblUserCompensationTransactions] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC,
	[strCompensationName] ASC,
	[strTransName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
