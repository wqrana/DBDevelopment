USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[InterfaceControl]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterfaceControl](
	[InterfaceControlId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](100) NULL,
	[Name] [nvarchar](100) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.InterfaceControl] PRIMARY KEY CLUSTERED 
(
	[InterfaceControlId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InterfaceControl]  WITH CHECK ADD  CONSTRAINT [FK_dbo.InterfaceControl_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[InterfaceControl] CHECK CONSTRAINT [FK_dbo.InterfaceControl_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[InterfaceControl]  WITH CHECK ADD  CONSTRAINT [FK_dbo.InterfaceControl_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[InterfaceControl] CHECK CONSTRAINT [FK_dbo.InterfaceControl_dbo.Company_CompanyId]
GO
