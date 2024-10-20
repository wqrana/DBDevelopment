USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tJobCode]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tJobCode](
	[nJobCodeID] [int] NOT NULL,
	[sJobCodeName] [nvarchar](50) NULL,
	[sJobCodeDesc] [nvarchar](50) NULL,
	[nProjectID] [int] NULL,
	[sPayCode] [nvarchar](50) NULL,
	[dblHourlyBillRate] [float] NULL,
	[dblHourlyPayRate] [float] NULL,
 CONSTRAINT [PK_tJobCode] PRIMARY KEY CLUSTERED 
(
	[nJobCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tJobCode] ADD  CONSTRAINT [DF_tJobCode_dblHourlyBillRate]  DEFAULT ((0)) FOR [dblHourlyBillRate]
GO
ALTER TABLE [dbo].[tJobCode] ADD  CONSTRAINT [DF_tJobCode_dblHourlyPayRate]  DEFAULT ((0)) FOR [dblHourlyPayRate]
GO
