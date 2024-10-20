USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tProjectBillingLookup]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tProjectBillingLookup](
	[nProjectID] [int] NULL,
	[nTransOrigID] [int] NULL,
	[nTransLookUpID] [int] NULL,
	[dblRateMultiplier] [float] NULL,
	[sPayrollCode] [nvarchar](50) NULL,
	[nExport] [int] NULL
) ON [PRIMARY]
GO
