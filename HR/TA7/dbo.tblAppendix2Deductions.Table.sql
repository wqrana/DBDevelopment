USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblAppendix2Deductions]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAppendix2Deductions](
	[intKey] [int] NOT NULL,
	[intPayPeriod] [int] NOT NULL,
	[dtTableStartDate] [datetime] NOT NULL,
	[decGrossWageFrom] [decimal](18, 5) NOT NULL,
	[decGrossWageTo] [decimal](18, 5) NOT NULL,
	[decDeductionAmount] [decimal](18, 5) NOT NULL
) ON [PRIMARY]
GO
