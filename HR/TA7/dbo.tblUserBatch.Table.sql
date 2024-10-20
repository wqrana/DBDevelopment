USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserBatch]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserBatch](
	[intUserID] [int] NOT NULL,
	[strBatchID] [nvarchar](50) NOT NULL,
	[intPayWeekNum] [int] NOT NULL,
	[intUserBatchStatus] [int] NOT NULL,
	[dtStartDatePeriod] [datetime] NOT NULL,
	[dtEndDatePeriod] [datetime] NOT NULL,
	[intCompanyID] [int] NULL,
	[intDepartmentID] [int] NULL,
	[intSubdepartmentID] [int] NULL,
	[intEmployeeTypeID] [int] NULL,
	[intPayMethodType] [int] NOT NULL,
 CONSTRAINT [PK_tblUserBatches] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC,
	[strBatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Index [IX_tblUserBatch_intDepartmentID]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tblUserBatch_intDepartmentID] ON [dbo].[tblUserBatch]
(
	[intDepartmentID] ASC
)
INCLUDE([intPayWeekNum],[intCompanyID],[intSubdepartmentID],[intEmployeeTypeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblUserBatch] ADD  DEFAULT ((0)) FOR [intPayMethodType]
GO
