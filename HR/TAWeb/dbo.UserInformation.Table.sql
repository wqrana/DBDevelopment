USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[UserInformation]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInformation](
	[UserInformationId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NULL,
	[IdNumber] [nvarchar](20) NULL,
	[SystemId] [nvarchar](20) NULL,
	[FirstName] [nvarchar](30) NULL,
	[MiddleInitial] [nvarchar](2) NULL,
	[FirstLastName] [nvarchar](30) NULL,
	[SecondLastName] [nvarchar](30) NULL,
	[ShortFullName] [nvarchar](50) NULL,
	[DepartmentId] [int] NULL,
	[SubDepartmentId] [int] NULL,
	[PositionId] [int] NULL,
	[EmployeeTypeID] [int] NULL,
	[EmploymentStatusId] [int] NULL,
	[DefaultJobCodeId] [int] NULL,
	[EthnicityId] [int] NULL,
	[DisabilityId] [int] NULL,
	[EmployeeNote] [nvarchar](50) NULL,
	[GenderId] [int] NULL,
	[BirthDate] [datetime] NULL,
	[BirthPlace] [nvarchar](50) NULL,
	[MaritalStatusId] [int] NULL,
	[SSNEncrypted] [nvarchar](512) NULL,
	[SSNEnd] [nvarchar](max) NULL,
	[PictureFilePath] [nvarchar](512) NULL,
	[ResumeFilePath] [nvarchar](512) NULL,
	[PasswordHash] [nvarchar](512) NULL,
	[CreatedBy] [int] NULL,
	[EmployeeStatusId] [int] NULL,
	[EmployeeStatusDate] [datetime] NULL,
	[AspNetUserId] [nvarchar](128) NULL,
	[RefUserInformationId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[IsRotatingSchedule] [bit] NULL,
	[BaseScheduleId] [int] NULL,
	[HasAllCompany] [bit] NULL,
 CONSTRAINT [PK_dbo.UserInformation] PRIMARY KEY CLUSTERED 
(
	[UserInformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Department_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Department_DepartmentId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Disability_DisabilityId] FOREIGN KEY([DisabilityId])
REFERENCES [dbo].[Disability] ([DisabilityId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Disability_DisabilityId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.EmployeeStatus_EmployeeStatusId] FOREIGN KEY([EmployeeStatusId])
REFERENCES [dbo].[EmployeeStatus] ([EmployeeStatusId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.EmployeeStatus_EmployeeStatusId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.EmployeeType_EmployeeTypeID] FOREIGN KEY([EmployeeTypeID])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.EmployeeType_EmployeeTypeID]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.EmploymentStatus_EmploymentStatusId] FOREIGN KEY([EmploymentStatusId])
REFERENCES [dbo].[EmploymentStatus] ([EmploymentStatusId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.EmploymentStatus_EmploymentStatusId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Ethnicity_EthnicityId] FOREIGN KEY([EthnicityId])
REFERENCES [dbo].[Ethnicity] ([EthnicityId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Ethnicity_EthnicityId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Gender_GenderId] FOREIGN KEY([GenderId])
REFERENCES [dbo].[Gender] ([GenderId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Gender_GenderId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.JobCode_DefaultJobCodeId] FOREIGN KEY([DefaultJobCodeId])
REFERENCES [dbo].[JobCode] ([JobCodeId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.JobCode_DefaultJobCodeId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.MaritalStatus_MaritalStatusId] FOREIGN KEY([MaritalStatusId])
REFERENCES [dbo].[MaritalStatus] ([MaritalStatusId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.MaritalStatus_MaritalStatusId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.SubDepartment_SubDepartmentId] FOREIGN KEY([SubDepartmentId])
REFERENCES [dbo].[SubDepartment] ([SubDepartmentId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.SubDepartment_SubDepartmentId]
GO
