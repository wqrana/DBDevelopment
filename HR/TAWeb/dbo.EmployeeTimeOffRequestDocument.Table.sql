USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeTimeOffRequestDocument]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeTimeOffRequestDocument](
	[EmployeeTimeOffRequestDocumentId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeTimeOffRequestId] [int] NOT NULL,
	[DocumentName] [nvarchar](50) NULL,
	[DocumentType] [nvarchar](25) NULL,
	[SubmissionType] [nvarchar](25) NULL,
	[Status] [nvarchar](10) NULL,
	[DocumentFile1] [varbinary](max) NULL,
	[DocumentFile1Name] [nvarchar](max) NULL,
	[DocumentFile1Ext] [nvarchar](max) NULL,
	[DocumentFile2] [varbinary](max) NULL,
	[DocumentFile2Name] [nvarchar](max) NULL,
	[DocumentFile2Ext] [nvarchar](max) NULL,
	[DocumentFile3] [varbinary](max) NULL,
	[DocumentFile3Name] [nvarchar](max) NULL,
	[DocumentFile3Ext] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[TimeoffDays] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeTimeOffRequestDocument] PRIMARY KEY CLUSTERED 
(
	[EmployeeTimeOffRequestDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequestDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeTimeOffRequestDocument_dbo.EmployeeTimeOffRequest_EmployeeTimeOffRequestId] FOREIGN KEY([EmployeeTimeOffRequestId])
REFERENCES [dbo].[EmployeeTimeOffRequest] ([EmployeeTimeOffRequestId])
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequestDocument] CHECK CONSTRAINT [FK_dbo.EmployeeTimeOffRequestDocument_dbo.EmployeeTimeOffRequest_EmployeeTimeOffRequestId]
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequestDocument]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeTimeOffRequestDocument_EmployeeTimeOffRequest] FOREIGN KEY([EmployeeTimeOffRequestId])
REFERENCES [dbo].[EmployeeTimeOffRequest] ([EmployeeTimeOffRequestId])
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequestDocument] CHECK CONSTRAINT [FK_EmployeeTimeOffRequestDocument_EmployeeTimeOffRequest]
GO
