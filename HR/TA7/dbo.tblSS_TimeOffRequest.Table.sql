USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblSS_TimeOffRequest]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSS_TimeOffRequest](
	[intTORUniqueID] [int] IDENTITY(1,1) NOT NULL,
	[intUserID] [int] NULL,
	[strTransType] [nvarchar](50) NULL,
	[bitSingleDay] [bit] NULL,
	[dtStartDate] [date] NULL,
	[dtEndDate] [date] NULL,
	[dtDayStart] [datetime] NULL,
	[decDayHours] [decimal](18, 2) NULL,
	[strRequestNote] [nvarchar](500) NULL,
	[intTORStatusID] [int] NULL,
	[dtTimestamp] [datetime] NOT NULL,
	[strCompanyName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblSS_TimeOffRequest] PRIMARY KEY CLUSTERED 
(
	[intTORUniqueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
