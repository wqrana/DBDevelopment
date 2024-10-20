USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[CompanyWithholdingLoan]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyWithholdingLoan](
	[CompanyWithholdingLoanId] [int] NOT NULL,
	[CompanyWithholdingId] [int] NOT NULL,
	[LoanDescription] [nvarchar](50) NOT NULL,
	[LoanAmount] [decimal](18, 2) NOT NULL,
	[StartDate] [date] NULL,
	[LoanPeriodLengthId] [int] NOT NULL,
	[EndDate] [date] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[LoanPaymentAmount] [decimal](18, 2) NULL,
 CONSTRAINT [PK_dbo.CompanyWithholdingLoan] PRIMARY KEY CLUSTERED 
(
	[CompanyWithholdingLoanId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CompanyWithholdingLoan]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyWithholdingLoan_dbo.CompanyWithholding_CompanyWithholdingLoanId] FOREIGN KEY([CompanyWithholdingLoanId])
REFERENCES [dbo].[CompanyWithholding] ([CompanyWithholdingId])
GO
ALTER TABLE [dbo].[CompanyWithholdingLoan] CHECK CONSTRAINT [FK_dbo.CompanyWithholdingLoan_dbo.CompanyWithholding_CompanyWithholdingLoanId]
GO
