USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tAttendanceRulesLetters]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAttendanceRulesLetters](
	[nAttendanceRulesID] [int] NOT NULL,
	[nLetterTemplatesID] [int] NOT NULL,
	[nEvaluationLevel] [int] NOT NULL,
	[sEvaluationLevelDesc] [nvarchar](50) NULL,
	[nWarningType] [int] NULL,
 CONSTRAINT [PK_tAttendanceRulesLetters] PRIMARY KEY CLUSTERED 
(
	[nAttendanceRulesID] ASC,
	[nEvaluationLevel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
