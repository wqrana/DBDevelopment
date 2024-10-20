USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tUserCompensationAdjust_V1]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tUserCompensationAdjust_V1](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[nUserID] [int] NULL,
	[sAccrualType] [nvarchar](30) NULL,
	[dblAccruedHours] [float] NULL,
	[dEffectiveDate] [datetime] NULL,
	[nAccrualMode] [int] NULL,
	[nDonorUserID] [int] NULL
) ON [PRIMARY]
GO
