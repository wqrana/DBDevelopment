USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblAppendix4AlternativeMethod]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAppendix4AlternativeMethod](
	[intPay] [int] NOT NULL,
	[intPayPeriod] [int] NOT NULL,
	[dtTableStartDate] [datetime] NOT NULL,
	[decWagesFrom] [decimal](18, 5) NOT NULL,
	[decWagesTo] [decimal](18, 5) NOT NULL,
	[decWithholdingPercent] [decimal](18, 5) NOT NULL
) ON [PRIMARY]
GO
