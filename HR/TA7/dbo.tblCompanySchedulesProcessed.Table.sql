USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanySchedulesProcessed]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanySchedulesProcessed](
	[strCompanyName] [nvarchar](50) NOT NULL,
	[intPayrollScheduleID] [int] NOT NULL,
	[strBatchID] [uniqueidentifier] NOT NULL,
	[intPayWeekNumber] [bigint] NOT NULL,
 CONSTRAINT [PK_tblCompanySchedulesProcessed] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC,
	[intPayrollScheduleID] ASC,
	[strBatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
