USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeSupervisor]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeSupervisor](
	[EmployeeSupervisorId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeUserId] [int] NOT NULL,
	[SupervisorUserId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeSupervisor] PRIMARY KEY CLUSTERED 
(
	[EmployeeSupervisorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeSupervisor]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeSupervisor_dbo.UserInformation_EmployeeUserId] FOREIGN KEY([EmployeeUserId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeSupervisor] CHECK CONSTRAINT [FK_dbo.EmployeeSupervisor_dbo.UserInformation_EmployeeUserId]
GO
ALTER TABLE [dbo].[EmployeeSupervisor]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeSupervisor_dbo.UserInformation_SupervisorUserId] FOREIGN KEY([SupervisorUserId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeSupervisor] CHECK CONSTRAINT [FK_dbo.EmployeeSupervisor_dbo.UserInformation_SupervisorUserId]
GO
