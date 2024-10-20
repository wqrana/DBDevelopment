USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblAppendix1Exemptions]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblAppendix1Exemptions](
	[intPayPeriod] [int] NOT NULL,
	[dtTableStartDate] [datetime] NOT NULL,
	[decIndividualExemption] [decimal](18, 5) NOT NULL,
	[decMarrriedCompleteExemption] [decimal](18, 5) NOT NULL,
	[decMarriedHalfExemption] [decimal](18, 5) NOT NULL,
	[decVeteransException] [decimal](18, 5) NOT NULL,
	[decDependentException] [decimal](18, 5) NOT NULL,
	[decDependentHalfException] [decimal](18, 5) NOT NULL,
	[decDeductionsAllowance] [decimal](18, 5) NOT NULL
) ON [PRIMARY]
GO
