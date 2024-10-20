USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeePerformance]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePerformance](
	[EmployeePerformanceId] [int] IDENTITY(1,1) NOT NULL,
	[SupervisorId] [int] NULL,
	[ActionTakenId] [int] NULL,
	[PerformanceDescriptionId] [int] NULL,
	[PerformanceResultId] [int] NULL,
	[ReviewDate] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[ReviewSummary] [nvarchar](max) NULL,
	[ReviewNote] [nvarchar](max) NULL,
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
 CONSTRAINT [PK_dbo.EmployeePerformance] PRIMARY KEY CLUSTERED 
(
	[EmployeePerformanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeePerformance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeePerformance_dbo.ActionTaken_ActionTakenId] FOREIGN KEY([ActionTakenId])
REFERENCES [dbo].[ActionTaken] ([ActionTakenId])
GO
ALTER TABLE [dbo].[EmployeePerformance] CHECK CONSTRAINT [FK_dbo.EmployeePerformance_dbo.ActionTaken_ActionTakenId]
GO
ALTER TABLE [dbo].[EmployeePerformance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeePerformance_dbo.PerformanceDescription_PerformanceDescriptionId] FOREIGN KEY([PerformanceDescriptionId])
REFERENCES [dbo].[PerformanceDescription] ([PerformanceDescriptionId])
GO
ALTER TABLE [dbo].[EmployeePerformance] CHECK CONSTRAINT [FK_dbo.EmployeePerformance_dbo.PerformanceDescription_PerformanceDescriptionId]
GO
ALTER TABLE [dbo].[EmployeePerformance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeePerformance_dbo.PerformanceResult_PerformanceResultId] FOREIGN KEY([PerformanceResultId])
REFERENCES [dbo].[PerformanceResult] ([PerformanceResultId])
GO
ALTER TABLE [dbo].[EmployeePerformance] CHECK CONSTRAINT [FK_dbo.EmployeePerformance_dbo.PerformanceResult_PerformanceResultId]
GO
ALTER TABLE [dbo].[EmployeePerformance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeePerformance_dbo.UserInformation_SupervisorId] FOREIGN KEY([SupervisorId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeePerformance] CHECK CONSTRAINT [FK_dbo.EmployeePerformance_dbo.UserInformation_SupervisorId]
GO
