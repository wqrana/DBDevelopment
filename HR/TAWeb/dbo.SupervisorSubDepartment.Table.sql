USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[SupervisorSubDepartment]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupervisorSubDepartment](
	[SupervisorSubDepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[SubDepartmentId] [int] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SupervisorSubDepartment] PRIMARY KEY CLUSTERED 
(
	[SupervisorSubDepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SupervisorSubDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorSubDepartment_dbo.SubDepartment_SubDepartmentId] FOREIGN KEY([SubDepartmentId])
REFERENCES [dbo].[SubDepartment] ([SubDepartmentId])
GO
ALTER TABLE [dbo].[SupervisorSubDepartment] CHECK CONSTRAINT [FK_dbo.SupervisorSubDepartment_dbo.SubDepartment_SubDepartmentId]
GO
ALTER TABLE [dbo].[SupervisorSubDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorSubDepartment_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[SupervisorSubDepartment] CHECK CONSTRAINT [FK_dbo.SupervisorSubDepartment_dbo.UserInformation_UserInformationId]
GO
