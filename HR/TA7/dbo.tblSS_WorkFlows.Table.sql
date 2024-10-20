USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblSS_WorkFlows]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSS_WorkFlows](
	[intWorkflowID] [int] NOT NULL,
	[strWorkflowName] [nvarchar](50) NULL,
	[intApprovalLevel1] [int] NULL,
	[intApprovalLevel2] [int] NULL,
	[intApprovalLevel3] [int] NULL,
	[intApprovalLevel4] [int] NULL,
 CONSTRAINT [PK_tblSS_WorkFlows] PRIMARY KEY CLUSTERED 
(
	[intWorkflowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
