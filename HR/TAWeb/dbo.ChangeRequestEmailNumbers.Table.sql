USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[ChangeRequestEmailNumbers]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeRequestEmailNumbers](
	[ChangeRequestEmailNumbersId] [int] IDENTITY(1,1) NOT NULL,
	[UserContactInformationId] [int] NOT NULL,
	[HomeNumber] [nvarchar](20) NULL,
	[CelNumber] [nvarchar](20) NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[OtherNumber] [nvarchar](20) NULL,
	[WorkEmail] [nvarchar](50) NULL,
	[PersonalEmail] [nvarchar](50) NULL,
	[OtherEmail] [nvarchar](50) NULL,
	[WorkNumber] [nvarchar](20) NULL,
	[WorkExtension] [nvarchar](10) NULL,
	[NewHomeNumber] [nvarchar](20) NULL,
	[NewCelNumber] [nvarchar](20) NULL,
	[NewFaxNumber] [nvarchar](20) NULL,
	[NewOtherNumber] [nvarchar](20) NULL,
	[NewWorkEmail] [nvarchar](50) NULL,
	[NewPersonalEmail] [nvarchar](50) NULL,
	[NewOtherEmail] [nvarchar](50) NULL,
	[NewWorkNumber] [nvarchar](20) NULL,
	[NewWorkExtension] [nvarchar](10) NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[ChangeRequestRemarks] [varchar](1000) NULL,
 CONSTRAINT [PK_dbo.ChangeRequestEmailNumbers] PRIMARY KEY CLUSTERED 
(
	[ChangeRequestEmailNumbersId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.UserContactInformation_UserContactInformationId] FOREIGN KEY([UserContactInformationId])
REFERENCES [dbo].[UserContactInformation] ([UserContactInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.UserContactInformation_UserContactInformationId]
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.UserInformation_UserInformationId]
GO
