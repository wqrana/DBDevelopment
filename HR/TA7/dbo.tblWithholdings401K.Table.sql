USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblWithholdings401K]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWithholdings401K](
	[strWithholdingName] [nvarchar](50) NOT NULL,
	[str401KDescription] [nvarchar](50) NOT NULL,
	[decEEMaxYearlyAmount] [decimal](18, 5) NOT NULL,
	[decERMaxYearlyAmount] [decimal](18, 5) NOT NULL,
	[intUseERLimitPercent] [int] NOT NULL,
	[decERMatchPercent] [decimal](18, 5) NOT NULL,
	[decERPeriodMaxPercent] [decimal](18, 5) NOT NULL,
 CONSTRAINT [PK_tblWithholdings401K] PRIMARY KEY CLUSTERED 
(
	[strWithholdingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
