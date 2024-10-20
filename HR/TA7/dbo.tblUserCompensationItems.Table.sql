USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserCompensationItems]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserCompensationItems](
	[intUserID] [int] NOT NULL,
	[strCompensationName] [nvarchar](50) NOT NULL,
	[strDescription] [nvarchar](50) NULL,
	[intCompensationType] [int] NOT NULL,
	[intComputationType] [int] NOT NULL,
	[boolEnabled] [bit] NOT NULL,
	[decHourlyRate] [decimal](18, 5) NOT NULL,
	[decMoneyAmount] [decimal](16, 2) NOT NULL,
	[intGLLookupField] [int] NOT NULL,
	[strGLAccount] [nvarchar](50) NOT NULL,
	[intPeriodEntryID] [int] NOT NULL,
 CONSTRAINT [PK_tblUserCompensationItems_1] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC,
	[strCompensationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [index_tblUserCompensationItemsUseridCompensation]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [index_tblUserCompensationItemsUseridCompensation] ON [dbo].[tblUserCompensationItems]
(
	[intCompensationType] ASC
)
INCLUDE([intUserID],[strCompensationName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblUserCompensationItems] ADD  DEFAULT ((0)) FOR [intGLLookupField]
GO
ALTER TABLE [dbo].[tblUserCompensationItems] ADD  DEFAULT ('') FOR [strGLAccount]
GO
ALTER TABLE [dbo].[tblUserCompensationItems] ADD  DEFAULT ((0)) FOR [intPeriodEntryID]
GO
