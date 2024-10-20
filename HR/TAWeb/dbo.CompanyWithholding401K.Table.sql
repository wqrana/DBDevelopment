USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CompanyWithholding401K]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyWithholding401K](
	[CompanyWithholding401KId] [int] NOT NULL,
	[CompanyWithholdingId] [int] NOT NULL,
	[EEMaxYearlyAmount] [decimal](18, 5) NOT NULL,
	[ERMaxYearlyAmount] [decimal](18, 5) NOT NULL,
	[Is401K1165eStTaxExempted] [bit] NOT NULL,
	[Withholding401KTypeId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_CompanyWithholding401K] PRIMARY KEY CLUSTERED 
(
	[CompanyWithholding401KId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
