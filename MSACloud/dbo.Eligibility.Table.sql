USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[Eligibility]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Eligibility](
	[ClientID] [bigint] NOT NULL,
	[FamSize] [int] NOT NULL,
	[FAnnual] [float] NULL,
	[FMonthly] [float] NULL,
	[FWeekly] [float] NULL,
	[RAnnual] [float] NULL,
	[RMonthly] [float] NULL,
	[RWeekly] [float] NULL,
	[Id] [int] NULL,
	[District_Id] [bigint] NULL,
	[FBiMonthly] [float] NULL,
	[FBiWeekly] [float] NULL,
	[RBiMonthly] [float] NULL,
	[RBiWeekly] [float] NULL,
 CONSTRAINT [PK_Eligibility] PRIMARY KEY CLUSTERED 
(
	[ClientID] ASC,
	[FamSize] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Eligibility] ADD  DEFAULT ((0.00)) FOR [FBiMonthly]
GO
ALTER TABLE [dbo].[Eligibility] ADD  DEFAULT ((0.00)) FOR [FBiWeekly]
GO
ALTER TABLE [dbo].[Eligibility] ADD  DEFAULT ((0.00)) FOR [RBiMonthly]
GO
ALTER TABLE [dbo].[Eligibility] ADD  DEFAULT ((0.00)) FOR [RBiWeekly]
GO
