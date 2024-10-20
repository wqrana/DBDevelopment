USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPayrollTemplates]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayrollTemplates](
	[intPayrollTemplateID] [int] NOT NULL,
	[strPayrollTemplateName] [nvarchar](50) NOT NULL,
	[strDescription] [nvarchar](50) NOT NULL,
	[intPayrollScheduleID] [int] NOT NULL,
	[intPayrollPeriodID] [int] NOT NULL,
	[intBatchType] [int] NOT NULL,
	[strCompanyName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblPayrollTemplates_1] PRIMARY KEY CLUSTERED 
(
	[intPayrollTemplateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
