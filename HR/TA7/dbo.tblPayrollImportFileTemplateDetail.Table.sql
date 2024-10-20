USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPayrollImportFileTemplateDetail]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayrollImportFileTemplateDetail](
	[intTemplateDetailId] [int] IDENTITY(1,1) NOT NULL,
	[intTemplateId] [int] NULL,
	[intFieldIndex] [int] NULL,
	[sFieldName] [nvarchar](100) NULL,
	[sFieldNameAsValue] [nvarchar](100) NULL,
	[sFieldMapping] [nvarchar](15) NULL,
	[sMappingTable] [nvarchar](50) NULL,
	[sMappingColumn] [nvarchar](50) NULL,
	[sColumnDataType] [nvarchar](50) NULL,
	[dtCreationDate] [datetime] NULL,
 CONSTRAINT [PK_tblPayrollImportFileTemplateDetail] PRIMARY KEY CLUSTERED 
(
	[intTemplateDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblPayrollImportFileTemplateDetail]  WITH CHECK ADD  CONSTRAINT [FK_tblPayrollImportFileTemplateDetail_tblPayrollImportFileTemplateDetail] FOREIGN KEY([intTemplateId])
REFERENCES [dbo].[tblPayrollImportFileTemplate] ([intTemplateId])
GO
ALTER TABLE [dbo].[tblPayrollImportFileTemplateDetail] CHECK CONSTRAINT [FK_tblPayrollImportFileTemplateDetail_tblPayrollImportFileTemplateDetail]
GO
