USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[SchoolOptions]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[SchoolOptions](
	[ClientID] [bigint] NOT NULL,
	[ID] [bigint] NOT NULL,
	[School_Id] [int] NOT NULL,
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
ALTER TABLE [Deleted].[SchoolOptions] ADD  DEFAULT ((0)) FOR [StripZeros]
GO
ALTER TABLE [Deleted].[SchoolOptions] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[SchoolOptions] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[SchoolOptions] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
