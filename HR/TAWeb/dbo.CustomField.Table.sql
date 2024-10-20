USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CustomField]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomField](
	[CustomFieldId] [int] IDENTITY(1,1) NOT NULL,
	[CustomFieldName] [nvarchar](500) NOT NULL,
	[CustomFieldDescription] [nvarchar](1000) NULL,
	[IsExpirable] [bit] NOT NULL,
	[FieldDisplayOrder] [int] NOT NULL,
	[NotificationScheduleId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[DocumentRequiredById] [int] NULL,
	[CustomFieldTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.CustomField] PRIMARY KEY CLUSTERED 
(
	[CustomFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomField]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CustomField_dbo.NotificationSchedule_NotificationScheduleId] FOREIGN KEY([NotificationScheduleId])
REFERENCES [dbo].[NotificationSchedule] ([NotificationScheduleId])
GO
ALTER TABLE [dbo].[CustomField] CHECK CONSTRAINT [FK_dbo.CustomField_dbo.NotificationSchedule_NotificationScheduleId]
GO
