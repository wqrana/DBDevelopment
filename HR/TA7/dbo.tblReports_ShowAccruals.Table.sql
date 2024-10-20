USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblReports_ShowAccruals]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblReports_ShowAccruals](
	[intReportID] [int] NOT NULL,
	[strAccrualTypeID] [nvarchar](30) NOT NULL,
	[bShow] [bit] NOT NULL,
 CONSTRAINT [PK_ttblReport_AccrualTypes] PRIMARY KEY CLUSTERED 
(
	[strAccrualTypeID] ASC,
	[intReportID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
