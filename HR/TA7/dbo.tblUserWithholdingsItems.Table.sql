USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserWithholdingsItems]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserWithholdingsItems](
	[intUserID] [int] NOT NULL,
	[strWithHoldingsName] [nvarchar](50) NOT NULL,
	[strDescription] [nvarchar](150) NOT NULL,
	[decEmployeePercent] [decimal](18, 5) NOT NULL,
	[decEmployeeAmount] [decimal](18, 5) NOT NULL,
	[decCompanyPercent] [decimal](18, 5) NOT NULL,
	[decCompanyAmount] [decimal](18, 5) NOT NULL,
	[decMaximumSalaryLimit] [decimal](18, 5) NOT NULL,
	[decMinimumSalaryLimit] [decimal](18, 5) NOT NULL,
	[boolDeleted] [bit] NOT NULL,
	[strGLAccount] [nvarchar](50) NULL,
	[strClassIdentifier] [nvarchar](50) NULL,
	[strContributionsName] [nvarchar](50) NOT NULL,
	[strGLAccount_Contributions] [nvarchar](50) NOT NULL,
	[intGLLookupField] [int] NOT NULL,
	[intPeriodEntryID] [int] NOT NULL,
	[boolApply401kPlan] [bit] NOT NULL,
	[strGLContributionPayable] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblUserWithholdings] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC,
	[strWithHoldingsName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [indexUserWithholdingsDeleted]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexUserWithholdingsDeleted] ON [dbo].[tblUserWithholdingsItems]
(
	[boolDeleted] ASC
)
INCLUDE([strGLAccount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [indexUserWitholdingsDeletedCont]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [indexUserWitholdingsDeletedCont] ON [dbo].[tblUserWithholdingsItems]
(
	[boolDeleted] ASC
)
INCLUDE([strGLAccount_Contributions]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tblUserWithholdingsItems_strWithHoldingsName]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tblUserWithholdingsItems_strWithHoldingsName] ON [dbo].[tblUserWithholdingsItems]
(
	[strWithHoldingsName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblUserWithholdingsItems] ADD  DEFAULT ('') FOR [strContributionsName]
GO
ALTER TABLE [dbo].[tblUserWithholdingsItems] ADD  DEFAULT ('') FOR [strGLAccount_Contributions]
GO
ALTER TABLE [dbo].[tblUserWithholdingsItems] ADD  DEFAULT ((0)) FOR [intGLLookupField]
GO
ALTER TABLE [dbo].[tblUserWithholdingsItems] ADD  DEFAULT ((0)) FOR [intPeriodEntryID]
GO
ALTER TABLE [dbo].[tblUserWithholdingsItems] ADD  DEFAULT ((0)) FOR [boolApply401kPlan]
GO
ALTER TABLE [dbo].[tblUserWithholdingsItems] ADD  DEFAULT ('') FOR [strGLContributionPayable]
GO
