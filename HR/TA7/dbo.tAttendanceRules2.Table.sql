USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tAttendanceRules2]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tAttendanceRules2](
	[ID] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[nPeriodType] [int] NULL,
	[sPeriodType] [nvarchar](50) NULL,
	[nPeriodLength] [int] NULL,
	[dPolicyStartDate] [datetime] NULL,
	[nPolicyHours_Incidences] [int] NULL,
	[nCustomerType] [int] NULL,
	[nSearchPeriod] [int] NULL,
	[nPolicyType] [int] NULL,
 CONSTRAINT [PK_tAttendanceRules2] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
