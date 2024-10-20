USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Stage].[JobHistory]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stage].[JobHistory](
	[JobHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[JobID] [int] NULL,
	[JobName] [varchar](50) NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[LastRecordLoaded] [int] NULL,
	[JobStatus] [varchar](50) NULL,
	[Notes] [varchar](4000) NULL,
 CONSTRAINT [StageJobHistoryPK] PRIMARY KEY CLUSTERED 
(
	[JobHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
