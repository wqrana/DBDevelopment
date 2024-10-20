USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[DentalInsuranceCobraHistory]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DentalInsuranceCobraHistory](
	[DentalInsuranceCobraHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeDentalInsuranceId] [int] NULL,
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
 CONSTRAINT [PK_dbo.DentalInsuranceCobraHistory] PRIMARY KEY CLUSTERED 
(
	[DentalInsuranceCobraHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DentalInsuranceCobraHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.DentalInsuranceCobraHistory_dbo.CobraPaymentStatus_CobraPaymentStatusId] FOREIGN KEY([CobraPaymentStatusId])
REFERENCES [dbo].[CobraPaymentStatus] ([CobraPaymentStatusId])
GO
ALTER TABLE [dbo].[DentalInsuranceCobraHistory] CHECK CONSTRAINT [FK_dbo.DentalInsuranceCobraHistory_dbo.CobraPaymentStatus_CobraPaymentStatusId]
GO
ALTER TABLE [dbo].[DentalInsuranceCobraHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.DentalInsuranceCobraHistory_dbo.EmployeeDentalInsurance_EmployeeDentalInsuranceId] FOREIGN KEY([EmployeeDentalInsuranceId])
REFERENCES [dbo].[EmployeeDentalInsurance] ([EmployeeDentalInsuranceId])
GO
ALTER TABLE [dbo].[DentalInsuranceCobraHistory] CHECK CONSTRAINT [FK_dbo.DentalInsuranceCobraHistory_dbo.EmployeeDentalInsurance_EmployeeDentalInsuranceId]
GO
