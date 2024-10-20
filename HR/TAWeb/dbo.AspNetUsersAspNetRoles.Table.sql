USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[AspNetUsersAspNetRoles]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsersAspNetRoles](
	[AspNetUsers_Id] [nvarchar](128) NOT NULL,
	[AspNetRoles_Id] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsersAspNetRoles] PRIMARY KEY CLUSTERED 
(
	[AspNetUsers_Id] ASC,
	[AspNetRoles_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetUsersAspNetRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUsersAspNetRoles_dbo.AspNetRoles_AspNetRoles_Id] FOREIGN KEY([AspNetRoles_Id])
REFERENCES [dbo].[AspNetRoles] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsersAspNetRoles] CHECK CONSTRAINT [FK_dbo.AspNetUsersAspNetRoles_dbo.AspNetRoles_AspNetRoles_Id]
GO
ALTER TABLE [dbo].[AspNetUsersAspNetRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUsersAspNetRoles_dbo.AspNetUsers_AspNetUsers_Id] FOREIGN KEY([AspNetUsers_Id])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsersAspNetRoles] CHECK CONSTRAINT [FK_dbo.AspNetUsersAspNetRoles_dbo.AspNetUsers_AspNetUsers_Id]
GO
