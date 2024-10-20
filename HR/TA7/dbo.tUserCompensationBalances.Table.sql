USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tUserCompensationBalances]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tUserCompensationBalances](
	[nUserID] [int] NOT NULL,
	[sAccrualType] [nvarchar](30) NOT NULL,
	[dblAccruedHours] [decimal](18, 5) NULL,
	[dBalanceStartDate] [datetime] NOT NULL,
	[dblAccrualDailyHours] [decimal](18, 5) NULL,
	[sAccrualDays] [nvarchar](50) NULL,
	[nSuperID] [int] NULL,
	[dtModifiedDate] [smalldatetime] NULL,
 CONSTRAINT [PK_tUserCompensationEntry] PRIMARY KEY CLUSTERED 
(
	[nUserID] ASC,
	[sAccrualType] ASC,
	[dBalanceStartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
