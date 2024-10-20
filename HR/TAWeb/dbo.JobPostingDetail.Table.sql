USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[JobPostingDetail]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobPostingDetail](
	[JobPostingDetailId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[DepartmentId] [int] NULL,
	[LocationId] [int] NULL,
	[NoOfVacancies] [int] NULL,
	[Experience] [nvarchar](max) NULL,
	[SalaryFrom] [decimal](18, 2) NULL,
	[SalaryTo] [decimal](18, 2) NULL,
	[EmploymentTypeId] [int] NULL,
	[JobPostingStatusId] [int] NULL,
	[JobPostingStartDate] [datetime] NULL,
	[JobPostingExpiringDate] [datetime] NULL,
	[JobDescription] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[IsHomeAddress] [bit] NULL,
	[IsMailingAddress] [bit] NULL,
	[IsPreviousEmployment] [bit] NULL,
	[IsEducation] [bit] NULL,
	[IsAvailablity] [bit] NULL,
 CONSTRAINT [PK_dbo.JobPostingDetail] PRIMARY KEY CLUSTERED 
(
	[JobPostingDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[JobPostingDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Department_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[JobPostingDetail] CHECK CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Department_DepartmentId]
GO
ALTER TABLE [dbo].[JobPostingDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingDetail_dbo.EmploymentType_EmploymentTypeId] FOREIGN KEY([EmploymentTypeId])
REFERENCES [dbo].[EmploymentType] ([EmploymentTypeId])
GO
ALTER TABLE [dbo].[JobPostingDetail] CHECK CONSTRAINT [FK_dbo.JobPostingDetail_dbo.EmploymentType_EmploymentTypeId]
GO
ALTER TABLE [dbo].[JobPostingDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingDetail_dbo.JobPostingStatus_JobPostingStatusId] FOREIGN KEY([JobPostingStatusId])
REFERENCES [dbo].[JobPostingStatus] ([JobPostingStatusId])
GO
ALTER TABLE [dbo].[JobPostingDetail] CHECK CONSTRAINT [FK_dbo.JobPostingDetail_dbo.JobPostingStatus_JobPostingStatusId]
GO
ALTER TABLE [dbo].[JobPostingDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO
ALTER TABLE [dbo].[JobPostingDetail] CHECK CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[JobPostingDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[JobPostingDetail] CHECK CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Position_PositionId]
GO
