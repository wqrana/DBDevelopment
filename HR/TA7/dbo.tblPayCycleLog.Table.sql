USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPayCycleLog]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayCycleLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DTPayPeriodDate] [smalldatetime] NOT NULL,
	[nPayWeekNum] [int] NOT NULL,
	[nPayPeriodType] [int] NOT NULL,
	[sPayPeriodType] [nvarchar](30) NOT NULL,
	[sPeriodNote] [nvarchar](50) NOT NULL,
	[nAdminID] [int] NOT NULL,
	[sAdminName] [nvarchar](50) NOT NULL,
	[DTProcessDate] [smalldatetime] NOT NULL,
	[sStatus] [nvarchar](10) NOT NULL,
	[nCompanyID] [int] NOT NULL,
	[nDeptID] [int] NOT NULL,
	[nJobTitleID] [int] NOT NULL,
	[nEmployeeTypeID] [int] NOT NULL,
	[sAdjustStatus] [nvarchar](50) NOT NULL,
	[strPayrollCompany] [nvarchar](50) NOT NULL,
	[intPayrollScheduleID] [int] NOT NULL,
 CONSTRAINT [PK_tblPayCycleLog] PRIMARY KEY CLUSTERED 
(
	[nPayWeekNum] ASC,
	[strPayrollCompany] ASC,
	[intPayrollScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblPayCycleLog] ADD  CONSTRAINT [DF__tblPayCyc__sAdju__6E6149E0]  DEFAULT ('') FOR [sAdjustStatus]
GO
