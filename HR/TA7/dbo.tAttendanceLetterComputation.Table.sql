USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tAttendanceLetterComputation]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAttendanceLetterComputation](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[nAttendanceRuleID] [int] NULL,
	[sAttendanceRuleName] [nvarchar](50) NULL,
	[nWarningLetterID] [bigint] NULL,
	[dStartDate] [datetime] NULL,
	[dEndDate] [datetime] NULL,
	[dProcessDate] [datetime] NULL,
	[nSupervisorrID] [int] NULL,
	[sSupevisorrName] [nvarchar](50) NULL,
	[nLetterCount] [int] NULL,
 CONSTRAINT [PK_tAttendanceLetterComputation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tAttendanceLetterComputation] ADD  CONSTRAINT [DF_tAttendanceLetterComputation_nLetter Count]  DEFAULT ((0)) FOR [nLetterCount]
GO
