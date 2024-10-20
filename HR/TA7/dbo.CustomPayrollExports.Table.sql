USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[CustomPayrollExports]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomPayrollExports](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ExportName] [nvarchar](255) NOT NULL,
	[ExportDescription] [nvarchar](255) NULL,
	[FunctionName] [nvarchar](255) NOT NULL,
	[UseParameterBatchid] [int] NOT NULL,
	[UseParameterPayrollCompany] [int] NOT NULL,
	[UseParameterSearchDates] [int] NOT NULL,
	[ShowPayrollCompany] [int] NOT NULL,
	[ShowPayrollSelect] [int] NOT NULL,
	[ShowSearchDates] [int] NOT NULL,
	[intExportType] [int] NOT NULL,
 CONSTRAINT [PK_CustomPayrollExports] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomPayrollExports] ADD  DEFAULT ((1)) FOR [intExportType]
GO
