USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[RoleType]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleType](
	[RoleTypeId] [int] IDENTITY(1,1) NOT NULL,
	[RoleTypeName] [nvarchar](100) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.RoleType] PRIMARY KEY CLUSTERED 
(
	[RoleTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RoleType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleType_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[RoleType] CHECK CONSTRAINT [FK_dbo.RoleType_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[RoleType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleType_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[RoleType] CHECK CONSTRAINT [FK_dbo.RoleType_dbo.Company_CompanyId]
GO
