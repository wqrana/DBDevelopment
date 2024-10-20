USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tTransDef]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTransDef](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](30) NULL,
	[nTCode] [int] NULL,
	[sTDesc] [nvarchar](30) NULL,
	[pCode] [nvarchar](10) NULL,
	[nIsAbsent] [int] NULL,
	[nAttendaceCategory] [int] NULL,
	[sAttendanceCategory] [nvarchar](50) NULL,
	[nParentCode] [int] NULL,
	[sParentCode] [nvarchar](50) NULL,
	[nAccrualType] [int] NULL,
	[sAccrualType] [nvarchar](50) NULL,
	[sAccrualImportName] [nvarchar](30) NULL,
	[nAttendanceRevision] [int] NULL,
	[nTardinessRevision] [int] NULL,
	[nCountsForVacationAccrual] [int] NULL,
	[nCountsForSickAccrual] [int] NULL,
	[dblPayRateMultiplier] [float] NULL,
	[dblAdditionalPayAmount] [float] NULL,
	[nCountForCompensationAccruals] [int] NULL,
	[sCountForCompensationAccruals] [nvarchar](50) NULL,
	[nIsMoneyTrans] [int] NULL,
	[nIsMoneyAmountFixed] [int] NULL,
	[decMoneyAmount] [numeric](18, 2) NULL,
	[nAttendanceRevLetter] [int] NULL,
	[nTardinessRevLetter] [int] NULL,
	[nCompforCompensationAccrual] [int] NULL,
	[sCompforCompensationAccrual] [nvarchar](50) NULL,
	[decPayRateMultiplier] [decimal](16, 2) NULL,
	[decPayRateOffset] [decimal](16, 2) NULL,
	[nPayRateTransaction] [int] NULL,
	[boolUseSickInFamily] [bit] NOT NULL,
	[decMinimumAccrualTypeBalance] [decimal](18, 2) NULL,
	[decMaximumYearlyTaken] [decimal](18, 2) NULL,
	[boolUseForTimesheetEditor] [bit] NOT NULL,
 CONSTRAINT [PK_tTransDef_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tTransDef] ADD  DEFAULT ((0)) FOR [boolUseSickInFamily]
GO
ALTER TABLE [dbo].[tTransDef] ADD  DEFAULT ((0)) FOR [boolUseForTimesheetEditor]
GO
