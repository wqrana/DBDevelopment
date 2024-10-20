USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [Deleted].[Customers]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Deleted].[Customers](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] NOT NULL,
	[District_Id] [int] NOT NULL,
	[Language_Id] [int] NULL,
	[Grade_Id] [int] NULL,
	[Homeroom_Id] [int] NULL,
	[isStudent] [bit] NULL,
	[UserID] [varchar](16) NULL,
	[PIN] [varchar](16) NULL,
	[LastName] [varchar](24) NOT NULL,
	[FirstName] [varchar](16) NOT NULL,
	[Middle] [varchar](1) NULL,
	[Gender] [varchar](1) NULL,
	[SSN] [varchar](11) NULL,
	[Address1] [varchar](30) NULL,
	[Address2] [varchar](30) NULL,
	[City] [varchar](30) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](10) NULL,
	[Phone] [varchar](14) NULL,
	[LunchType] [int] NULL,
	[AllowAlaCarte] [bit] NULL,
	[CashOnly] [bit] NULL,
	[isActive] [bit] NULL,
	[GraduationDate] [smalldatetime] NULL,
	[SchoolDat] [varchar](25) NULL,
	[isDeleted] [bit] NULL,
	[ExtraInfo] [varchar](30) NULL,
	[EMail] [varchar](60) NULL,
	[DOB] [smalldatetime] NULL,
	[ACH] [bit] NULL,
	[isSnack] [bit] NULL,
	[isStudentWorker] [bit] NULL,
	[isVeteran] [bit] NULL,
	[Ethnicity_Id] [int] NULL,
	[Disability] [int] NULL,
	[isHomeless] [bit] NULL,
	[Disabled] [int] NULL,
	[CreationDate] [datetime2](7) NULL,
	[NotInDistrict] [bit] NULL,
	[MealsLeft] [int] NULL,
	[MealPlan_Id] [int] NULL,
	[STUD_MGMT_ID] [varchar](25) NULL,
	[DeactiveDate] [datetime2](7) NULL,
	[ReactiveDate] [datetime2](7) NULL,
	[GradDate] [datetime2](7) NULL,
	[GraduationDateSet] [bit] NULL,
	[CreationDateLocal] [datetime2](7) NULL,
	[DeactiveDateLocal] [datetime2](7) NULL,
	[ReactiveDateLocal] [datetime2](7) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [bigint] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [Deleted].[Customers] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [Deleted].[Customers] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [Deleted].[Customers] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
