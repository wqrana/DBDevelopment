USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[UserMenu]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserMenu](
	[LinkId] [int] IDENTITY(1,1) NOT NULL,
	[ParentLinkId] [int] NULL,
	[FormId] [int] NULL,
	[UserInterfaceId] [int] NULL,
	[Weight] [int] NULL,
	[Title] [nvarchar](100) NULL,
	[Alt] [nvarchar](100) NULL,
	[Anchor] [nvarchar](100) NULL,
	[AnchorClass] [nvarchar](100) NULL,
	[Description] [nvarchar](100) NULL,
	[CompanyId] [int] NULL,
	[InterfaceControlId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserMenu] PRIMARY KEY CLUSTERED 
(
	[LinkId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserMenu]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserMenu_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[UserMenu] CHECK CONSTRAINT [FK_dbo.UserMenu_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[UserMenu]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserMenu_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[UserMenu] CHECK CONSTRAINT [FK_dbo.UserMenu_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[UserMenu]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserMenu_dbo.Form_FormId] FOREIGN KEY([FormId])
REFERENCES [dbo].[Form] ([FormId])
GO
ALTER TABLE [dbo].[UserMenu] CHECK CONSTRAINT [FK_dbo.UserMenu_dbo.Form_FormId]
GO
ALTER TABLE [dbo].[UserMenu]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserMenu_dbo.InterfaceControl_InterfaceControlId] FOREIGN KEY([InterfaceControlId])
REFERENCES [dbo].[InterfaceControl] ([InterfaceControlId])
GO
ALTER TABLE [dbo].[UserMenu] CHECK CONSTRAINT [FK_dbo.UserMenu_dbo.InterfaceControl_InterfaceControlId]
GO
