USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[EmployeeCompensation]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCompensation](
	[EmployeeCompensationId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyCompensationId] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[MoneyAmount] [decimal](16, 2) NOT NULL,
	[GLAccountId] [int] NULL,
	[PeriodEntryId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[UserInformationId] [int] NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_EmployeeCompensation] PRIMARY KEY CLUSTERED 
(
	[EmployeeCompensationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeCompensation]  WITH CHECK ADD  CONSTRAINT [FK_CompanyCompensation_PeriodEntry] FOREIGN KEY([PeriodEntryId])
REFERENCES [dbo].[CompensationPeriodEntry] ([CompensationPeriodEntryId])
GO
ALTER TABLE [dbo].[EmployeeCompensation] CHECK CONSTRAINT [FK_CompanyCompensation_PeriodEntry]
GO
ALTER TABLE [dbo].[EmployeeCompensation]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeCompensation_CompanyCompensation] FOREIGN KEY([CompanyCompensationId])
REFERENCES [dbo].[CompanyCompensation] ([CompanyCompensationId])
GO
ALTER TABLE [dbo].[EmployeeCompensation] CHECK CONSTRAINT [FK_EmployeeCompensation_CompanyCompensation]
GO
ALTER TABLE [dbo].[EmployeeCompensation]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeCompensation_GLAccount] FOREIGN KEY([GLAccountId])
REFERENCES [dbo].[GLAccount] ([GLAccountId])
GO
ALTER TABLE [dbo].[EmployeeCompensation] CHECK CONSTRAINT [FK_EmployeeCompensation_GLAccount]
GO
