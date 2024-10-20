USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeDentalInsurance]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeDentalInsurance](
	[EmployeeDentalInsuranceId] [int] IDENTITY(1,1) NOT NULL,
	[IsEnlisted] [bit] NULL,
	[GroupId] [nvarchar](max) NULL,
	[InsuranceCoverageId] [int] NULL,
	[InsuranceTypeId] [int] NULL,
	[InsuranceStatusId] [int] NULL,
	[InsuranceStartDate] [datetime] NULL,
	[InsuranceExpiryDate] [datetime] NULL,
	[CobraStatusId] [int] NULL,
	[LeyCobraStartDate] [datetime] NULL,
	[LeyCobraExpiryDate] [datetime] NULL,
	[EmployeeContribution] [decimal](18, 2) NOT NULL,
	[CompanyContribution] [decimal](18, 2) NOT NULL,
	[OtherContribution] [decimal](18, 2) NOT NULL,
	[TotalContribution] [decimal](18, 2) NOT NULL,
	[PCORIFee] [decimal](18, 2) NOT NULL,
	[InsurancePremium] [decimal](18, 2) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeDentalInsurance] PRIMARY KEY CLUSTERED 
(
	[EmployeeDentalInsuranceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.CobraStatus_CobraStatusId] FOREIGN KEY([CobraStatusId])
REFERENCES [dbo].[CobraStatus] ([CobraStatusId])
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.CobraStatus_CobraStatusId]
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceCoverage_InsuranceCoverageId] FOREIGN KEY([InsuranceCoverageId])
REFERENCES [dbo].[InsuranceCoverage] ([InsuranceCoverageId])
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceCoverage_InsuranceCoverageId]
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceStatus_InsuranceStatusId] FOREIGN KEY([InsuranceStatusId])
REFERENCES [dbo].[InsuranceStatus] ([InsuranceStatusId])
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceStatus_InsuranceStatusId]
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceType_InsuranceTypeId] FOREIGN KEY([InsuranceTypeId])
REFERENCES [dbo].[InsuranceType] ([InsuranceTypeId])
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceType_InsuranceTypeId]
GO
