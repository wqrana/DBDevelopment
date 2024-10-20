USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserTransactionPayRates]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserTransactionPayRates](
	[nUserID] [int] NOT NULL,
	[dStartDate] [datetime] NOT NULL,
	[sTransName] [nvarchar](50) NOT NULL,
	[intPayPeriod] [int] NOT NULL,
	[intHourlyOrSalary] [int] NOT NULL,
	[decPayRate] [decimal](18, 5) NOT NULL,
	[decHoursPerPeriod] [decimal](18, 5) NOT NULL,
	[nInactivate] [int] NOT NULL,
	[decPeriodWages] [decimal](18, 5) NOT NULL,
	[decPeriodComissions] [decimal](18, 5) NOT NULL,
	[decPeriodHours] [decimal](18, 5) NOT NULL,
	[dtPeriodStartDate] [date] NULL,
	[dtPeriodEndDate] [date] NULL,
 CONSTRAINT [PK_tUserTransRates] PRIMARY KEY CLUSTERED 
(
	[nUserID] ASC,
	[dStartDate] ASC,
	[sTransName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblUserTransactionPayRates] ADD  DEFAULT ((0)) FOR [decPayRate]
GO
ALTER TABLE [dbo].[tblUserTransactionPayRates] ADD  DEFAULT ((0)) FOR [decHoursPerPeriod]
GO
ALTER TABLE [dbo].[tblUserTransactionPayRates] ADD  DEFAULT ((0)) FOR [decPeriodWages]
GO
ALTER TABLE [dbo].[tblUserTransactionPayRates] ADD  DEFAULT ((0)) FOR [decPeriodComissions]
GO
ALTER TABLE [dbo].[tblUserTransactionPayRates] ADD  DEFAULT ((0)) FOR [decPeriodHours]
GO
