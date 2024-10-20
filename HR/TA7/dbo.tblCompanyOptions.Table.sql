USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompanyOptions]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompanyOptions](
	[strCompanyName] [nvarchar](50) NOT NULL,
	[boolShowPayRate] [bit] NOT NULL,
	[boolShowIdentechLogo] [bit] NOT NULL,
	[IdentechPayrollId] [int] NOT NULL,
	[IdentechTaxesID] [int] NOT NULL,
	[FederalTaxDepositScheduleId] [int] NOT NULL,
	[FUTATaxDepositScheduleId] [int] NOT NULL,
	[HaciendaTaxDepositScheduleId] [int] NOT NULL,
	[boolEncryptPayStub] [bit] NOT NULL,
 CONSTRAINT [PK_tblCompanyOptions] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblCompanyOptions] ADD  DEFAULT ((0)) FOR [boolShowPayRate]
GO
ALTER TABLE [dbo].[tblCompanyOptions] ADD  DEFAULT ((1)) FOR [boolShowIdentechLogo]
GO
ALTER TABLE [dbo].[tblCompanyOptions] ADD  DEFAULT ((1)) FOR [IdentechPayrollId]
GO
ALTER TABLE [dbo].[tblCompanyOptions] ADD  DEFAULT ((1)) FOR [IdentechTaxesID]
GO
ALTER TABLE [dbo].[tblCompanyOptions] ADD  DEFAULT ((1)) FOR [FederalTaxDepositScheduleId]
GO
ALTER TABLE [dbo].[tblCompanyOptions] ADD  DEFAULT ((1)) FOR [FUTATaxDepositScheduleId]
GO
ALTER TABLE [dbo].[tblCompanyOptions] ADD  DEFAULT ((1)) FOR [HaciendaTaxDepositScheduleId]
GO
ALTER TABLE [dbo].[tblCompanyOptions] ADD  DEFAULT ((0)) FOR [boolEncryptPayStub]
GO
