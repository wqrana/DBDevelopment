USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[DetailedDailyCashier_Report]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DetailedDailyCashier_Report](
	[CASHRESID] [bigint] NULL,
	[SCHID] [bigint] NULL,
	[SchoolID] [varchar](30) NOT NULL,
	[SchoolName] [varchar](60) NOT NULL,
	[POSName] [varchar](19) NOT NULL,
	[UserID] [varchar](16) NULL,
	[FirstName] [varchar](16) NULL,
	[Middle] [varchar](1) NULL,
	[LastName] [varchar](24) NULL,
	[POSID] [bigint] NOT NULL,
	[SessionType] [int] NOT NULL,
	[SessionTypeName] [varchar](5) NULL,
	[OpenDate] [datetime2](7) NULL,
	[CloseDate] [datetime2](7) NULL,
	[OpenAmount] [float] NULL,
	[CloseAmount] [float] NULL,
	[Deposit] [float] NULL,
	[Additional] [float] NULL,
	[PaidOuts] [float] NULL,
	[OverShort] [float] NULL,
	[CashTaken] [float] NULL,
	[ChecksTaken] [float] NULL,
	[CreditTaken] [float] NULL,
	[Refunds] [float] NULL,
	[TotalTaken] [float] NULL,
	[CashSalesCount] [int] NULL,
	[CashSales] [float] NULL,
	[AccountSalesChargedCount] [int] NULL,
	[AccountSalesCharged] [float] NULL,
	[AccountSalesPartialCount] [int] NULL,
	[AccountSalesPartial] [float] NULL,
	[AccountSalesFullCount] [int] NULL,
	[AccountSalesFull] [float] NULL,
	[AccountSalesAboveCount] [int] NULL,
	[AccountSalesAbove] [float] NULL,
	[TaxCollected] [float] NULL,
	[TotalSales] [float] NULL,
	[TotalSalesCount] [int] NULL
) ON [PRIMARY]
GO
