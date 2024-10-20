USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[AuditLog]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLog](
	[AuditLogId] [int] IDENTITY(1,1) NOT NULL,
	[ReferenceId] [int] NULL,
	[UserInformationId] [int] NULL,
	[UserSessionLogDetailId] [int] NULL,
	[TableName] [nvarchar](150) NULL,
	[Remarks] [nvarchar](max) NULL,
	[ActionType] [nvarchar](150) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[ReferenceId1] [bigint] NULL,
	[RefUserInformationId] [int] NULL,
 CONSTRAINT [PK_dbo.AuditLog] PRIMARY KEY CLUSTERED 
(
	[AuditLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuditLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditLog_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[AuditLog] CHECK CONSTRAINT [FK_dbo.AuditLog_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[AuditLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditLog_dbo.UserSessionLogDetail_UserSessionLogDetailId] FOREIGN KEY([UserSessionLogDetailId])
REFERENCES [dbo].[UserSessionLogDetail] ([UserSessionLogDetailId])
GO
ALTER TABLE [dbo].[AuditLog] CHECK CONSTRAINT [FK_dbo.AuditLog_dbo.UserSessionLogDetail_UserSessionLogDetailId]
GO
