USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[Adteligibility]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Adteligibility](
	[ClientID] [bigint] NOT NULL,
	[AFAnnual] [float] NULL,
	[AFMonthly] [float] NULL,
	[AFWeekly] [float] NULL,
	[ARAnnual] [float] NULL,
	[ARMonthly] [float] NULL,
	[ARWeekly] [float] NULL,
	[Id] [int] NOT NULL,
	[District_Id] [bigint] NULL,
	[AFBiMonthly] [float] NULL,
	[AFBiWeekly] [float] NULL,
	[ARBiMonthly] [float] NULL,
	[ARBiWeekly] [float] NULL,
 CONSTRAINT [PK_Adteligibility] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Adteligibility] ADD  DEFAULT ((0.00)) FOR [AFBiMonthly]
GO
ALTER TABLE [dbo].[Adteligibility] ADD  DEFAULT ((0.00)) FOR [AFBiWeekly]
GO
ALTER TABLE [dbo].[Adteligibility] ADD  DEFAULT ((0.00)) FOR [ARBiMonthly]
GO
ALTER TABLE [dbo].[Adteligibility] ADD  DEFAULT ((0.00)) FOR [ARBiWeekly]
GO
