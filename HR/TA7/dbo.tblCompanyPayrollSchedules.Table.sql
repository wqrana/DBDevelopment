USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyPayrollSchedules]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyPayrollSchedules](
	[strCompanyName] [nvarchar](50) NOT NULL,
	[intPayrollScheduleID] [int] NOT NULL,
	[strPayrollSchedule] [nvarchar](50) NOT NULL,
	[strAccountNumber] [nvarchar](50) NOT NULL,
	[intPayrollFrequency] [int] NOT NULL,
	[intPaymentDay] [int] NOT NULL,
	[intPayCycleSchedule] [int] NOT NULL,
 CONSTRAINT [PK_tblCompanyPayrollSchedule] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC,
	[intPayrollScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
