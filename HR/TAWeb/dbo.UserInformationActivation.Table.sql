USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[UserInformationActivation]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInformationActivation](
	[UserInformationActivationId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[ActivationCode] [uniqueidentifier] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserInformationActivation] PRIMARY KEY CLUSTERED 
(
	[UserInformationActivationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserInformationActivation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformationActivation_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[UserInformationActivation] CHECK CONSTRAINT [FK_dbo.UserInformationActivation_dbo.UserInformation_UserInformationId]
GO
