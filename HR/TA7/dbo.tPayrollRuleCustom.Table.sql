USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tPayrollRuleCustom]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tPayrollRuleCustom](
	[nPayrollRuleID] [int] NOT NULL,
	[nUseBultos] [int] NOT NULL,
	[nMeal30MinWaiver] [int] NULL,
	[decWaveDifferentialHours] [decimal](18, 2) NULL,
	[decWaveDifferential] [decimal](18, 2) NULL,
	[intWaveDifferentialTransactionID] [int] NULL,
	[intRoundEndOfMealPeriod] [int] NOT NULL,
 CONSTRAINT [PK_tPayrollRuleCustom_1] PRIMARY KEY CLUSTERED 
(
	[nPayrollRuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tPayrollRuleCustom] ADD  DEFAULT ((0)) FOR [intRoundEndOfMealPeriod]
GO
