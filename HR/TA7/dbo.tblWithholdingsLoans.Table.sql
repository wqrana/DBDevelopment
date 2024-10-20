USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblWithholdingsLoans]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblWithholdingsLoans](
	[strWithholdingName] [nvarchar](50) NOT NULL,
	[strLoanDescription] [nvarchar](50) NOT NULL,
	[decLoanAmount] [decimal](18, 5) NOT NULL,
	[decLoanPaymentAmount] [decimal](18, 5) NOT NULL,
	[dtStartDate] [date] NULL,
	[intLoanPeriodLength] [int] NOT NULL,
	[dtEndDate] [date] NULL,
 CONSTRAINT [PK_tblWithholdingsLoans] PRIMARY KEY CLUSTERED 
(
	[strWithholdingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblWithholdingsLoans] ADD  CONSTRAINT [DF_tblWithholdingsLoans_intLoanPeriodLenght]  DEFAULT ((0)) FOR [intLoanPeriodLength]
GO
