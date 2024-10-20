USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeCompanyTransfer]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCompanyTransfer](
	[EmployeeCompanyTransferId] [int] IDENTITY(1,1) NOT NULL,
	[FromUserInformationId] [int] NOT NULL,
	[FromCompanyId] [int] NOT NULL,
	[ToUserInformationId] [int] NOT NULL,
	[ToCompanyId] [int] NOT NULL,
	[TransferDate] [datetime] NOT NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeCompanyTransfer] PRIMARY KEY CLUSTERED 
(
	[EmployeeCompanyTransferId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.Company_FromCompanyId] FOREIGN KEY([FromCompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer] CHECK CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.Company_FromCompanyId]
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.Company_ToCompanyId] FOREIGN KEY([ToCompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer] CHECK CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.Company_ToCompanyId]
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.UserInformation_FromUserInformationId] FOREIGN KEY([FromUserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer] CHECK CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.UserInformation_FromUserInformationId]
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.UserInformation_ToUserInformationId] FOREIGN KEY([ToUserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer] CHECK CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.UserInformation_ToUserInformationId]
GO
