USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tJobCode_Allowances]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tJobCode_Allowances](
	[nJobCodeID] [int] NOT NULL,
	[nCellAllowanceTrans] [int] NULL,
	[sCellDescription] [nvarchar](50) NULL,
	[dblCellMinWorkedHours] [float] NULL,
	[nCellTimePerWeek] [int] NULL,
	[nCarAllowanceTrans] [int] NULL,
	[sCarDescription] [nvarchar](50) NULL,
	[dblCarMinWorkedHours] [float] NULL,
	[nCarTimePerWeek] [int] NULL,
	[sCellBillingCode] [nvarchar](50) NULL,
	[sCarBillingCode] [nvarchar](50) NULL,
	[sCellPayrollCode] [nvarchar](50) NULL,
	[sCarPayrollCode] [nvarchar](50) NULL,
 CONSTRAINT [PK_tJobCode_Allowances] PRIMARY KEY CLUSTERED 
(
	[nJobCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
