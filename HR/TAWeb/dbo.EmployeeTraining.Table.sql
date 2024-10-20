USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeTraining]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeTraining](
	[EmployeeTrainingId] [int] IDENTITY(1,1) NOT NULL,
	[TrainingId] [int] NOT NULL,
	[Type] [nvarchar](max) NULL,
	[TrainingDate] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[Note] [nvarchar](max) NULL,
	[DocName] [nvarchar](max) NULL,
	[DocFilePath] [nvarchar](max) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[TrainingTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeTraining] PRIMARY KEY CLUSTERED 
(
	[EmployeeTrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeTraining]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeTraining_dbo.Training_TrainingId] FOREIGN KEY([TrainingId])
REFERENCES [dbo].[Training] ([TrainingId])
GO
ALTER TABLE [dbo].[EmployeeTraining] CHECK CONSTRAINT [FK_dbo.EmployeeTraining_dbo.Training_TrainingId]
GO
ALTER TABLE [dbo].[EmployeeTraining]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeTraining_dbo.TrainingType_TrainingTypeId] FOREIGN KEY([TrainingTypeId])
REFERENCES [dbo].[TrainingType] ([TrainingTypeId])
GO
ALTER TABLE [dbo].[EmployeeTraining] CHECK CONSTRAINT [FK_dbo.EmployeeTraining_dbo.TrainingType_TrainingTypeId]
GO
ALTER TABLE [dbo].[EmployeeTraining]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeTraining_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeTraining] CHECK CONSTRAINT [FK_dbo.EmployeeTraining_dbo.UserInformation_UserInformationId]
GO
