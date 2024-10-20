USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tTardinessLetter]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTardinessLetter](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[nUserID] [int] NULL,
	[sName] [nvarchar](50) NULL,
	[nCompanyID] [int] NULL,
	[sCompanyName] [nvarchar](50) NULL,
	[nDeptID] [int] NULL,
	[sDeptName] [nvarchar](50) NULL,
	[nJobTitleID] [int] NULL,
	[sJobTitleName] [nvarchar](50) NULL,
	[nEmployeeTypeID] [int] NULL,
	[sEmployeeTypeName] [nvarchar](50) NULL,
	[nEvaluationLevel] [int] NULL,
	[nPrevEvaluationLevel] [int] NULL,
	[sEvaluationLevelDesc] [nvarchar](50) NULL,
	[sActionTaken] [nvarchar](50) NULL,
	[dStartDateEvaluation] [datetime] NULL,
	[dEndDateEvaluation] [datetime] NULL,
	[dEmploymentDate] [datetime] NULL,
	[nSupervisorID] [int] NULL,
	[sSupervisorName] [nvarchar](50) NULL,
	[sEmployeeComments] [nvarchar](100) NULL,
	[sSupervisorComments] [nvarchar](100) NULL,
	[dWarningIssueDate] [datetime] NULL,
	[dPreviousWarningIssueDate] [datetime] NULL,
	[dWarningReviewedDate] [datetime] NULL,
	[nWarningStatus] [int] NULL,
	[nWarningType] [int] NULL,
	[nWarningTotal] [int] NULL,
	[sWarningType] [nvarchar](50) NULL,
	[dblWarningTime] [float] NULL,
	[nWarningLetterID] [bigint] NULL,
	[dStartDateSuspension] [datetime] NULL,
	[dEndDateSuspension] [datetime] NULL,
	[dTerminationDate] [datetime] NULL,
	[nTardinessRulesID] [int] NULL,
 CONSTRAINT [PK_tTardinessLetter] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
