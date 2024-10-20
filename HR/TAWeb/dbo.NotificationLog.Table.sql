USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[NotificationLog]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationLog](
	[NotificationLogId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationScheduleDetailId] [int] NULL,
	[DeliveryStatusId] [int] NOT NULL,
	[EmployeeDocumentId] [int] NULL,
	[EmployeeCredentialId] [int] NULL,
	[EmployeeCustomFieldId] [int] NULL,
	[IsNotificationAsExpired] [bit] NULL,
	[ChangeRequestAddressId] [int] NULL,
	[NotificationTypeId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[UserInformationActivationId] [int] NULL,
	[EmploymentId] [int] NULL,
	[EmployeePerformanceId] [int] NULL,
	[EmployeeTrainingId] [int] NULL,
	[EmployeeHealthInsuranceId] [int] NULL,
	[EmployeeDentalInsuranceId] [int] NULL,
	[EmployeeActionId] [int] NULL,
	[EmployeeBenefitHistoryId] [int] NULL,
	[ReferredUserInformationId] [int] NULL,
	[EmailBlastId] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationLog] PRIMARY KEY CLUSTERED 
(
	[NotificationLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.ChangeRequestAddress_ChangeRequestAddressId] FOREIGN KEY([ChangeRequestAddressId])
REFERENCES [dbo].[ChangeRequestAddress] ([ChangeRequestAddressId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.ChangeRequestAddress_ChangeRequestAddressId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeCredential_EmployeeCredentialId] FOREIGN KEY([EmployeeCredentialId])
REFERENCES [dbo].[EmployeeCredential] ([EmployeeCredentialId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeCredential_EmployeeCredentialId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeCustomField_EmployeeCustomFieldId] FOREIGN KEY([EmployeeCustomFieldId])
REFERENCES [dbo].[EmployeeCustomField] ([EmployeeCustomFieldId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeCustomField_EmployeeCustomFieldId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeDocument_EmployeeDocumentId] FOREIGN KEY([EmployeeDocumentId])
REFERENCES [dbo].[EmployeeDocument] ([EmployeeDocumentId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeDocument_EmployeeDocumentId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.NotificationScheduleDetail_NotificationScheduleDetailId] FOREIGN KEY([NotificationScheduleDetailId])
REFERENCES [dbo].[NotificationScheduleDetail] ([NotificationScheduleDetailId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.NotificationScheduleDetail_NotificationScheduleDetailId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.NotificationType_NotificationTypeId] FOREIGN KEY([NotificationTypeId])
REFERENCES [dbo].[NotificationType] ([NotificationTypeId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.NotificationType_NotificationTypeId]
GO
