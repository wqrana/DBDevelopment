USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmploymentHistory]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmploymentHistory](
	[EmploymentHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[PositionId] [int] NULL,
	[EmployeeTypeId] [int] NULL,
	[EmploymentTypeId] [int] NULL,
	[ChangeReason] [varchar](200) NULL,
	[LocationId] [int] NULL,
	[DepartmentId] [int] NOT NULL,
	[SubDepartmentId] [int] NULL,
	[CompanyId] [int] NOT NULL,
	[SupervisorId] [int] NULL,
	[ApprovedDate] [datetime] NULL,
	[EmploymentId] [int] NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[UserInformation_Id] [int] NULL,
	[ClosedBy] [int] NULL,
 CONSTRAINT [PK_dbo.EmploymentHistory] PRIMARY KEY CLUSTERED 
(
	[EmploymentHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_StartDate] UNIQUE NONCLUSTERED 
(
	[UserInformationId] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Department_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Department_DepartmentId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.EmployeeType_EmployeeTypeId] FOREIGN KEY([EmployeeTypeId])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.EmployeeType_EmployeeTypeId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Employment_EmploymentId] FOREIGN KEY([EmploymentId])
REFERENCES [dbo].[Employment] ([EmploymentId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Employment_EmploymentId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.EmploymentType_EmploymentTypeId] FOREIGN KEY([EmploymentTypeId])
REFERENCES [dbo].[EmploymentType] ([EmploymentTypeId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.EmploymentType_EmploymentTypeId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.SubDepartment_SubDepartmentId] FOREIGN KEY([SubDepartmentId])
REFERENCES [dbo].[SubDepartment] ([SubDepartmentId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.SubDepartment_SubDepartmentId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.UserInformation_UserInformation_Id] FOREIGN KEY([UserInformation_Id])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.UserInformation_UserInformation_Id]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.UserInformation_UserInformationId]
GO
