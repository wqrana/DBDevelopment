USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tReportWeekReview]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tReportWeekReview](
	[intReportWeekID] [bigint] NOT NULL,
	[intReviewedID] [int] NULL,
	[strReviewedName] [nvarchar](50) NULL,
	[strReviewedDateTime] [nvarchar](50) NULL,
	[intApprovedID] [int] NULL,
	[strApprovedName] [nvarchar](50) NULL,
	[strApprovedDateTime] [nvarchar](50) NULL,
 CONSTRAINT [PK_tReportWeekReview] PRIMARY KEY CLUSTERED 
(
	[intReportWeekID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
