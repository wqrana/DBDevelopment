USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tTardinessLetterComputation]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTardinessLetterComputation](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[nTardinessRuleID] [int] NULL,
	[sTardinessRuleName] [nvarchar](50) NULL,
	[nWarningLetterID] [bigint] NULL,
	[dStartDate] [datetime] NULL,
	[dEndDate] [datetime] NULL,
	[dProcessDate] [datetime] NULL,
	[nSupervisorrID] [int] NULL,
	[sSupevisorName] [nvarchar](50) NULL,
	[nLetterCount] [int] NULL,
 CONSTRAINT [PK_tTardinessLetterComputation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tTardinessLetterComputation] ADD  CONSTRAINT [DF_tTardinessLetterComputation_nLetter Count]  DEFAULT ((0)) FOR [nLetterCount]
GO
