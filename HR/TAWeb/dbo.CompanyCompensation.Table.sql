USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CompanyCompensation]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyCompensation](
	[CompanyCompensationId] [int] IDENTITY(1,1) NOT NULL,
	[CompensationName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[CompensationTypeId] [int] NOT NULL,
	[ComputationTypeId] [int] NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[ImportTypeId] [int] NOT NULL,
	[GLAccountId] [int] NOT NULL,
	[IsCovidCompensation] [bit] NOT NULL,
	[IsFICASSCCExempt] [bit] NOT NULL,
	[ReportOrder] [int] NULL,
	[GLLookupField] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyCompensation] PRIMARY KEY CLUSTERED 
(
	[CompanyCompensationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyCompensation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyCompensation_dbo.CompensationComputationType_ComputationTypeId] FOREIGN KEY([ComputationTypeId])
REFERENCES [dbo].[CompensationComputationType] ([CompensationComputationTypeId])
GO
ALTER TABLE [dbo].[CompanyCompensation] CHECK CONSTRAINT [FK_dbo.CompanyCompensation_dbo.CompensationComputationType_ComputationTypeId]
GO
ALTER TABLE [dbo].[CompanyCompensation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyCompensation_dbo.CompensationImportType_ImportTypeId] FOREIGN KEY([ImportTypeId])
REFERENCES [dbo].[CompensationImportType] ([CompensationImportTypeId])
GO
ALTER TABLE [dbo].[CompanyCompensation] CHECK CONSTRAINT [FK_dbo.CompanyCompensation_dbo.CompensationImportType_ImportTypeId]
GO
ALTER TABLE [dbo].[CompanyCompensation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyCompensation_dbo.CompensationType_CompensationTypeId] FOREIGN KEY([CompensationTypeId])
REFERENCES [dbo].[CompensationType] ([CompensationTypeId])
GO
ALTER TABLE [dbo].[CompanyCompensation] CHECK CONSTRAINT [FK_dbo.CompanyCompensation_dbo.CompensationType_CompensationTypeId]
GO
ALTER TABLE [dbo].[CompanyCompensation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyCompensation_dbo.GLAccount_GLAccountId] FOREIGN KEY([GLAccountId])
REFERENCES [dbo].[GLAccount] ([GLAccountId])
GO
ALTER TABLE [dbo].[CompanyCompensation] CHECK CONSTRAINT [FK_dbo.CompanyCompensation_dbo.GLAccount_GLAccountId]
GO
