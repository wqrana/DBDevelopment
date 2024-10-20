USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[SchoolOptions]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SchoolOptions](
	[ClientID] [bigint] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[School_Id] [bigint] NOT NULL,
	[ChangedDate] [datetime2](7) NULL,
	[AlaCarteLimit] [float] NULL,
	[MealPlanLimit] [float] NULL,
	[DoPinPreFix] [bit] NULL,
	[PinPreFix] [varchar](4) NULL,
	[PhotoLogging] [bit] NULL,
	[FingerPrinting] [bit] NULL,
	[BarCodeLength] [int] NULL,
	[StartSchoolYear] [smalldatetime] NULL,
	[EndSchoolYear] [smalldatetime] NULL,
	[StripZeros] [bit] NULL,
	[ChangedDateLocal] [datetime2](7) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_SchoolOptions] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SchoolOptions] ADD  DEFAULT ((0)) FOR [StripZeros]
GO
ALTER TABLE [dbo].[SchoolOptions] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[SchoolOptions] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[SchoolOptions] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
