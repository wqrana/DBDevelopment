USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tHLTransDailyDetail]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tHLTransDailyDetail](
	[tppID] [int] IDENTITY(1,1) NOT NULL,
	[e_id] [int] NULL,
	[e_idno] [nvarchar](14) NULL,
	[e_name] [nvarchar](30) NULL,
	[DTPunchDate] [smalldatetime] NULL,
	[sType] [nvarchar](30) NULL,
	[pCode] [nvarchar](10) NULL,
	[HoursWorked] [float] NULL,
	[nWeekID] [bigint] NULL,
	[nIsTransAbsent] [int] NULL,
	[nPunchDateDayOfWeek] [int] NULL,
	[nHRAttendanceCat] [int] NULL,
	[nHRProcessedCode] [int] NULL,
	[nHRReportCode] [int] NULL,
	[sMasterTrans] [nvarchar](50) NULL,
	[nCompanyID] [int] NULL,
	[sCompanyName] [nvarchar](50) NULL,
	[nDeptID] [int] NULL,
	[sDeptName] [nvarchar](50) NULL,
	[nJobTitleID] [int] NULL,
	[sJobTitleName] [nvarchar](50) NULL,
	[nEmployeeTypeID] [int] NULL,
	[sEmployeeTypeName] [nvarchar](50) NULL,
	[nAttendanceRevision] [int] NULL,
	[nTardinessRevision] [int] NULL,
	[nSupervisorID] [int] NULL,
	[sSupervisorName] [nvarchar](50) NULL,
	[nAttendanceProcessed] [int] NULL,
	[nAttendanceReportCode] [bigint] NULL,
	[nTardinessProcessed] [int] NULL,
	[nTardinessReportCode] [bigint] NULL,
 CONSTRAINT [PK_tHLTransDailyDetail] PRIMARY KEY CLUSTERED 
(
	[tppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
