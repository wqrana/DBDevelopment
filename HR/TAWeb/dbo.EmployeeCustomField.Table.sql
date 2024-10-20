USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeCustomField]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCustomField](
	[EmployeeCustomFieldId] [int] IDENTITY(1,1) NOT NULL,
	[CustomFieldId] [int] NOT NULL,
	[CustomFieldValue] [nvarchar](500) NULL,
	[CustomFieldNote] [nvarchar](250) NULL,
	[ExpirationDate] [datetime] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[ReturnDate] [date] NULL,
	[IssuanceDate] [date] NULL,
 CONSTRAINT [PK_dbo.EmployeeCustomField] PRIMARY KEY CLUSTERED 
(
	[EmployeeCustomFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeCustomField]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCustomField_dbo.CustomField_CustomFieldId] FOREIGN KEY([CustomFieldId])
REFERENCES [dbo].[CustomField] ([CustomFieldId])
GO
ALTER TABLE [dbo].[EmployeeCustomField] CHECK CONSTRAINT [FK_dbo.EmployeeCustomField_dbo.CustomField_CustomFieldId]
GO
ALTER TABLE [dbo].[EmployeeCustomField]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCustomField_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeCustomField] CHECK CONSTRAINT [FK_dbo.EmployeeCustomField_dbo.UserInformation_UserInformationId]
GO
