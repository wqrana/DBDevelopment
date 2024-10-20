USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Stage].[JobControl]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Stage].[JobControl](
	[JobName] [varchar](50) NOT NULL,
	[JobID] [int] NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[LastRecordLoaded] [int] NULL,
	[JobStatus] [varchar](50) NULL,
	[Notes] [varchar](100) NULL,
 CONSTRAINT [PK_Stage_JobControl] PRIMARY KEY CLUSTERED 
(
	[JobName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
