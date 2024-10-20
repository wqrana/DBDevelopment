USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPunchDateDetail]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPunchDateDetail](
	[tpdID] [int] IDENTITY(1,1) NOT NULL,
	[e_id] [int] NOT NULL,
	[DtPunchDate] [smalldatetime] NULL,
	[dblHours] [float] NULL,
	[sType] [nvarchar](30) NULL,
	[sExportCode] [nvarchar](10) NULL,
	[nHRProcessedCode] [int] NULL,
	[nWeekID] [bigint] NULL,
	[sNote] [nvarchar](50) NULL,
	[nCompensationStatus] [int] NULL,
	[nAccrualStatus] [int] NULL,
	[dblHoursOriginal] [float] NULL,
	[nAttendanceLetterCode] [int] NULL,
	[nTardinessLetterCode] [int] NULL,
	[intPayWeekNum] [int] NULL,
	[strBatchID] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblPunchDateDetail] PRIMARY KEY CLUSTERED 
(
	[tpdID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblPunchDateDetail] ADD  CONSTRAINT [DF_tblPunchDateDetail_nHRProcessedCode]  DEFAULT ((0)) FOR [nHRProcessedCode]
GO
ALTER TABLE [dbo].[tblPunchDateDetail] ADD  CONSTRAINT [DF_tblPunchDateDetail_nWeekID]  DEFAULT ((0)) FOR [nWeekID]
GO
ALTER TABLE [dbo].[tblPunchDateDetail] ADD  CONSTRAINT [DF_tblPunchDateDetail_sNote]  DEFAULT (N'') FOR [sNote]
GO
ALTER TABLE [dbo].[tblPunchDateDetail] ADD  CONSTRAINT [DF_tblPunchDateDetail_nAttendanceLetterCode]  DEFAULT ((0)) FOR [nAttendanceLetterCode]
GO
ALTER TABLE [dbo].[tblPunchDateDetail] ADD  CONSTRAINT [DF_tblPunchDateDetail_nTardinessLetterCode]  DEFAULT ((0)) FOR [nTardinessLetterCode]
GO
