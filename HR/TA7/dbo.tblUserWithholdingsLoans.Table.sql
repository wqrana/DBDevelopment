USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserWithholdingsLoans]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserWithholdingsLoans](
	[intUserID] [int] NOT NULL,
	[strWithholdingName] [nvarchar](50) NOT NULL,
	[strLoanDescription] [nvarchar](50) NULL,
	[decLoanAmount] [decimal](18, 5) NOT NULL,
	[decLoanPaymentAmount] [decimal](18, 5) NOT NULL,
	[dtStartDate] [date] NULL,
	[intLoanPeriodLength] [int] NULL,
	[dtEndDate] [date] NULL,
	[strLoanNumber] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblUserWithholdingsLoans] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC,
	[strWithholdingName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
