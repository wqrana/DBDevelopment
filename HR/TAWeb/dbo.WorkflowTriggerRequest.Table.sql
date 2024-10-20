USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[WorkflowTriggerRequest]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTriggerRequest](
	[WorkflowTriggerRequestId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowTriggerId] [int] NOT NULL,
	[ChangeRequestAddressId] [int] NULL,
	[ChangeRequestEmergencyContactId] [int] NULL,
	[SelfServiceEmployeeDocumentId] [int] NULL,
	[SelfServiceEmployeeCredentialId] [int] NULL,
	[EmployeeTimeOffRequestId] [int] NULL,
	[ChangeRequestEmailNumbersId] [int] NULL,
	[ChangeRequestEmployeeDependentId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowTriggerRequest] PRIMARY KEY CLUSTERED 
(
	[WorkflowTriggerRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestAddress_ChangeRequestAddressId] FOREIGN KEY([ChangeRequestAddressId])
REFERENCES [dbo].[ChangeRequestAddress] ([ChangeRequestAddressId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestAddress_ChangeRequestAddressId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmailNumbers_ChangeRequestEmailNumbersId] FOREIGN KEY([ChangeRequestEmailNumbersId])
REFERENCES [dbo].[ChangeRequestEmailNumbers] ([ChangeRequestEmailNumbersId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmailNumbers_ChangeRequestEmailNumbersId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmergencyContact_ChangeRequestEmergencyContactId] FOREIGN KEY([ChangeRequestEmergencyContactId])
REFERENCES [dbo].[ChangeRequestEmergencyContact] ([ChangeRequestEmergencyContactId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmergencyContact_ChangeRequestEmergencyContactId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmployeeDependent_ChangeRequestEmployeeDependentId] FOREIGN KEY([ChangeRequestEmployeeDependentId])
REFERENCES [dbo].[ChangeRequestEmployeeDependent] ([ChangeRequestEmployeeDependentId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmployeeDependent_ChangeRequestEmployeeDependentId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.EmployeeTimeOffRequest_EmployeeTimeOffRequestId] FOREIGN KEY([EmployeeTimeOffRequestId])
REFERENCES [dbo].[EmployeeTimeOffRequest] ([EmployeeTimeOffRequestId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.EmployeeTimeOffRequest_EmployeeTimeOffRequestId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.SelfServiceEmployeeCredential_SelfServiceEmployeeCredentialId] FOREIGN KEY([SelfServiceEmployeeCredentialId])
REFERENCES [dbo].[SelfServiceEmployeeCredential] ([SelfServiceEmployeeCredentialId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.SelfServiceEmployeeCredential_SelfServiceEmployeeCredentialId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.SelfServiceEmployeeDocument_SelfServiceEmployeeDocumentId] FOREIGN KEY([SelfServiceEmployeeDocumentId])
REFERENCES [dbo].[SelfServiceEmployeeDocument] ([SelfServiceEmployeeDocumentId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.SelfServiceEmployeeDocument_SelfServiceEmployeeDocumentId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.WorkflowTrigger_WorkflowTriggerId] FOREIGN KEY([WorkflowTriggerId])
REFERENCES [dbo].[WorkflowTrigger] ([WorkflowTriggerId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.WorkflowTrigger_WorkflowTriggerId]
GO
