USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserPayRates]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserPayRates](
	[intUserID] [int] NOT NULL,
	[dtStartDate] [datetime] NOT NULL,
	[intPayPeriod] [int] NOT NULL,
	[intHourlyOrSalary] [int] NOT NULL,
	[decPayRate] [decimal](18, 5) NOT NULL,
	[decPeriodGrossPay] [decimal](18, 5) NOT NULL,
	[decYearlyWages] [decimal](18, 5) NOT NULL,
	[decHoursPerPeriod] [decimal](18, 5) NOT NULL,
 CONSTRAINT [PK_tbUserPayroll] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC,
	[dtStartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
