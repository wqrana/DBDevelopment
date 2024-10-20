USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[RoleInterfaceControlPrivilege]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleInterfaceControlPrivilege](
	[RoleInterfacePrivilegeId] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NULL,
	[PrivilegeId] [int] NULL,
	[InterfaceControlFormId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.RoleInterfaceControlPrivilege] PRIMARY KEY CLUSTERED 
(
	[RoleInterfacePrivilegeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege] CHECK CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege] CHECK CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.InterfaceControlForm_InterfaceControlFormId] FOREIGN KEY([InterfaceControlFormId])
REFERENCES [dbo].[InterfaceControlForm] ([InterfaceControlFormId])
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege] CHECK CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.InterfaceControlForm_InterfaceControlFormId]
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Privilege_PrivilegeId] FOREIGN KEY([PrivilegeId])
REFERENCES [dbo].[Privilege] ([PrivilegeId])
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege] CHECK CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Privilege_PrivilegeId]
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleId])
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege] CHECK CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Role_RoleId]
GO
