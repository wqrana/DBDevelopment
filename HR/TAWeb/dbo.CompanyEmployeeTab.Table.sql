USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CompanyEmployeeTab]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyEmployeeTab](
	[CompanyEmployeeTabId] [int] IDENTITY(1,1) NOT NULL,
	[FormId] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyEmployeeTab] PRIMARY KEY CLUSTERED 
(
	[CompanyEmployeeTabId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyEmployeeTab]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[CompanyEmployeeTab] CHECK CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[CompanyEmployeeTab]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[CompanyEmployeeTab] CHECK CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[CompanyEmployeeTab]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Form_FormId] FOREIGN KEY([FormId])
REFERENCES [dbo].[Form] ([FormId])
GO
ALTER TABLE [dbo].[CompanyEmployeeTab] CHECK CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Form_FormId]
GO
