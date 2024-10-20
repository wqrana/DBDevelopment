USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tUserCompensationAccruals]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tUserCompensationAccruals](
	[sAccrualType] [nvarchar](50) NOT NULL,
	[sAccrualTypeDesc] [nvarchar](50) NULL,
	[dEffectiveDate] [date] NOT NULL,
	[dPeriodStartDate] [date] NULL,
	[dPeriodEndDate] [date] NULL,
	[nUserID] [int] NOT NULL,
	[sUserName] [nvarchar](50) NULL,
	[dblPeriodHours] [decimal](18, 5) NULL,
	[dblAccruedHours] [decimal](18, 5) NULL,
	[intAdminID] [int] NULL,
	[strAdminName] [nvarchar](50) NULL,
	[dblEffectivePayRate] [nchar](10) NULL,
	[dtAccrualsComputeDate] [date] NULL,
	[nAccrualLogMode] [int] NOT NULL,
 CONSTRAINT [PK_tUserComputationaAccrualsLog] PRIMARY KEY CLUSTERED 
(
	[sAccrualType] ASC,
	[dEffectiveDate] ASC,
	[nUserID] ASC,
	[nAccrualLogMode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tUserCompensationAccruals_sAccrualType_nUserID_dEffectiveDate]    Script Date: 10/18/2024 8:10:09 PM ******/
CREATE NONCLUSTERED INDEX [IX_tUserCompensationAccruals_sAccrualType_nUserID_dEffectiveDate] ON [dbo].[tUserCompensationAccruals]
(
	[sAccrualType] ASC,
	[nUserID] ASC,
	[dEffectiveDate] ASC
)
INCLUDE([dblAccruedHours]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
