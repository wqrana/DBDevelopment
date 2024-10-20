USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[AuditLogDetail]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLogDetail](
	[AuditLogDetailId] [int] IDENTITY(1,1) NOT NULL,
	[AuditLogId] [int] NOT NULL,
	[ColumnName] [nvarchar](150) NULL,
	[OldValue] [nvarchar](max) NULL,
	[NewValue] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AuditLogDetail] PRIMARY KEY CLUSTERED 
(
	[AuditLogDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditLogDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditLogDetail_dbo.AuditLog_AuditLogId] FOREIGN KEY([AuditLogId])
REFERENCES [dbo].[AuditLog] ([AuditLogId])
GO
ALTER TABLE [dbo].[AuditLogDetail] CHECK CONSTRAINT [FK_dbo.AuditLogDetail_dbo.AuditLog_AuditLogId]
GO
