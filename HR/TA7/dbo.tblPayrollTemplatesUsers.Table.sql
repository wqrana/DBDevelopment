USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPayrollTemplatesUsers]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayrollTemplatesUsers](
	[intPayrollTemplateID] [int] NOT NULL,
	[intUserID] [int] NOT NULL,
	[strUserName] [nvarchar](50) NOT NULL,
	[intPayMethodType] [int] NOT NULL,
 CONSTRAINT [PK_tblPayrollTemplateUsers] PRIMARY KEY CLUSTERED 
(
	[intPayrollTemplateID] ASC,
	[intUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblPayrollTemplatesUsers] ADD  DEFAULT ((0)) FOR [intPayMethodType]
GO
