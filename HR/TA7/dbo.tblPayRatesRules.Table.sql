USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPayRatesRules]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayRatesRules](
	[intPayRatesRulesID] [int] NOT NULL,
	[strPayRatesRulesName] [nvarchar](50) NOT NULL,
	[intComputationType] [int] NOT NULL,
	[intComputationPeriod] [int] NOT NULL,
 CONSTRAINT [PK_tblPayRatesRules] PRIMARY KEY CLUSTERED 
(
	[intPayRatesRulesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
