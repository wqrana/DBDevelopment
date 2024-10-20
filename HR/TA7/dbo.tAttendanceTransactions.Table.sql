USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tAttendanceTransactions]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAttendanceTransactions](
	[tppID] [int] IDENTITY(1,1) NOT NULL,
	[e_id] [int] NULL,
	[e_name] [nvarchar](30) NULL,
	[DTPunchDate] [smalldatetime] NULL,
	[sType] [nvarchar](30) NULL,
	[pCode] [nvarchar](10) NULL,
	[HoursWorked] [float] NULL,
	[nWeekID] [bigint] NULL,
	[nProcessedCode] [int] NULL,
	[nAttendanceRevLetter] [int] NULL,
	[nWarningLetterID] [bigint] NULL,
 CONSTRAINT [PK_tAttendanceTransactions] PRIMARY KEY CLUSTERED 
(
	[tppID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
