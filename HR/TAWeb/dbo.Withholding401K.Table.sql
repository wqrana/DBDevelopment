USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Withholding401K]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Withholding401K](
	[Withholding401KId] [int] IDENTITY(1,1) NOT NULL,
	[Withholding401KName] [nvarchar](max) NOT NULL,
	[Withholding401KDescription] [nvarchar](max) NULL,
	[CompanyWithholdingId] [int] NOT NULL,
	[EEMaxYearlyAmount] [decimal](18, 2) NOT NULL,
	[ERMaxYearlyAmount] [decimal](18, 2) NOT NULL,
	[UseERLimitPercent] [int] NOT NULL,
	[ERMatchPercent] [decimal](18, 2) NOT NULL,
	[ERPeriodMaxPercent] [decimal](18, 2) NOT NULL,
	[401K_1165eStTaxExemptId] [int] NOT NULL,
	[401KTypeId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Withholding401K] PRIMARY KEY CLUSTERED 
(
	[Withholding401KId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
