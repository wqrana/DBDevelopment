USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tParameters]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tParameters](
	[ID] [int] NOT NULL,
	[sComputerName] [nvarchar](50) NULL,
	[sTimeStamp] [nvarchar](50) NULL,
	[nAdminID] [int] NULL,
	[sAdminPWD] [nvarchar](50) NULL,
	[nUserID] [int] NULL,
	[nReportTypeID] [int] NULL,
	[nReportViewID] [int] NULL
) ON [PRIMARY]
GO
