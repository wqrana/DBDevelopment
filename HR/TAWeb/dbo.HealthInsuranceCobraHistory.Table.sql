USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[HealthInsuranceCobraHistory]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HealthInsuranceCobraHistory](
	[HealthInsuranceCobraHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeHealthInsuranceId] [int] NULL,
	[DueDate] [datetime] NULL,
	[PaymentDate] [datetime] NULL,
	[CobraPaymentStatusId] [int] NULL,
	[PaymentAmount] [decimal](18, 2) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.HealthInsuranceCobraHistory] PRIMARY KEY CLUSTERED 
(
	[HealthInsuranceCobraHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HealthInsuranceCobraHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.HealthInsuranceCobraHistory_dbo.CobraPaymentStatus_CobraPaymentStatusId] FOREIGN KEY([CobraPaymentStatusId])
REFERENCES [dbo].[CobraPaymentStatus] ([CobraPaymentStatusId])
GO
ALTER TABLE [dbo].[HealthInsuranceCobraHistory] CHECK CONSTRAINT [FK_dbo.HealthInsuranceCobraHistory_dbo.CobraPaymentStatus_CobraPaymentStatusId]
GO
ALTER TABLE [dbo].[HealthInsuranceCobraHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.HealthInsuranceCobraHistory_dbo.EmployeeHealthInsurance_EmployeeHealthInsuranceId] FOREIGN KEY([EmployeeHealthInsuranceId])
REFERENCES [dbo].[EmployeeHealthInsurance] ([EmployeeHealthInsuranceId])
GO
ALTER TABLE [dbo].[HealthInsuranceCobraHistory] CHECK CONSTRAINT [FK_dbo.HealthInsuranceCobraHistory_dbo.EmployeeHealthInsurance_EmployeeHealthInsuranceId]
GO
