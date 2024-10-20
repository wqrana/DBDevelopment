USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblEmailReportsPAY]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEmailReportsPAY](
	[intID] [int] IDENTITY(1,1) NOT NULL,
	[strBatchID] [nvarchar](50) NOT NULL,
	[intUserID] [int] NOT NULL,
	[intReportID] [int] NOT NULL,
	[strUserEmail] [nvarchar](200) NOT NULL,
	[strSubject] [nvarchar](200) NOT NULL,
	[strBody] [nvarchar](max) NOT NULL,
	[intSentStatus] [int] NOT NULL,
	[intSupervisorID] [int] NOT NULL,
	[dtScheduledDate] [datetime] NOT NULL,
	[dtEmailSent] [datetime] NULL,
 CONSTRAINT [PK_tblEmailReportsPAY] PRIMARY KEY CLUSTERED 
(
	[intID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
