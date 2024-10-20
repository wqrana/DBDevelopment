USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tCompensationComputationLog]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCompensationComputationLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[intUserID] [int] NULL,
	[strAccrualType] [nvarchar](50) NULL,
	[dtPunchDate] [smalldatetime] NOT NULL,
	[dblHours] [float] NULL,
	[intAccrualStatus] [int] NULL,
	[dblEffectivePayRate] [nchar](10) NULL,
	[intAdminID] [int] NULL,
	[dtAccrualsComputeDate] [smalldatetime] NULL,
 CONSTRAINT [PK_tCompensationComputationLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
