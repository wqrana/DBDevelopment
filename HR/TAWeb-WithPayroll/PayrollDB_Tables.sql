USE [TimeAideWebPayrollUAT]
GO
/****** Object:  Table [dbo].[AccrualRule]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccrualRule](
	[AccrualRuleId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualRuleName] [nvarchar](max) NULL,
	[AccrualRuleDescription] [nvarchar](max) NULL,
	[ReferenceTypeId] [int] NULL,
	[BeginningOfYearDate] [datetime] NULL,
	[AccrualTypeId] [int] NULL,
	[AccrualTypeUnavailable] [nvarchar](max) NULL,
	[AccrualPeriodTypeId] [int] NULL,
	[AccumulationTypeId] [int] NULL,
	[AccumulationMultiplier] [float] NULL,
	[UseYearsWorked] [bit] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AccrualRule] PRIMARY KEY CLUSTERED 
(
	[AccrualRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccrualRuleTier]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccrualRuleTier](
	[AccrualRuleTierId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualRuleId] [int] NOT NULL,
	[TierNo] [int] NOT NULL,
	[TierDescription] [nvarchar](max) NULL,
	[YearsWorkedFrom] [float] NULL,
	[YearsWorkedTo] [float] NULL,
	[WaitingPeriodType] [bit] NOT NULL,
	[WaitingPeriodLength] [int] NULL,
	[AllowedMaxHoursTypeId] [int] NULL,
	[AllowedMaxHours] [float] NULL,
	[AccrualTypeExcess] [nvarchar](max) NULL,
	[ResetAccruedHoursTypeId] [int] NULL,
	[ResetHours] [float] NULL,
	[ResetDate] [datetime] NULL,
	[MinWorkedHoursType] [bit] NOT NULL,
	[AccrualHours] [float] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AccrualRuleTier] PRIMARY KEY CLUSTERED 
(
	[AccrualRuleTierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccrualRuleWorkedHoursTier]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccrualRuleWorkedHoursTier](
	[AccrualRuleWorkedHoursTierId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualRuleId] [int] NOT NULL,
	[AccrualRuleTierId] [int] NOT NULL,
	[TierNo] [int] NOT NULL,
	[TierDescription] [nvarchar](max) NULL,
	[TierWorkedHoursMin] [float] NOT NULL,
	[TierWorkedHoursMax] [float] NULL,
	[AccrualHours] [float] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AccrualRuleWorkedHoursTier] PRIMARY KEY CLUSTERED 
(
	[AccrualRuleWorkedHoursTierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AccrualType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccrualType](
	[AccrualTypeId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualTypeName] [nvarchar](150) NOT NULL,
	[AccrualTypeDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CompanyId] [int] NULL,
	[IsUsedBySystem] [bit] NULL,
 CONSTRAINT [PK_dbo.AccrualType] PRIMARY KEY CLUSTERED 
(
	[AccrualTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActionTaken]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActionTaken](
	[ActionTakenId] [int] IDENTITY(1,1) NOT NULL,
	[ActionTakenName] [nvarchar](150) NOT NULL,
	[ActionTakenDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ActionTaken] PRIMARY KEY CLUSTERED 
(
	[ActionTakenId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ActionType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActionType](
	[ActionTypeId] [int] IDENTITY(1,1) NOT NULL,
	[ActionTypeName] [nvarchar](max) NOT NULL,
	[ActionTypeDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ActionType] PRIMARY KEY CLUSTERED 
(
	[ActionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantAction]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantAction](
	[ApplicantActionId] [int] IDENTITY(1,1) NOT NULL,
	[ApprovedById] [int] NULL,
	[ActionTypeId] [int] NULL,
	[ActionDate] [datetime] NOT NULL,
	[ActionEndDate] [datetime] NULL,
	[ActionName] [nvarchar](max) NULL,
	[ActionDescription] [nvarchar](max) NULL,
	[ActionNotes] [nvarchar](max) NULL,
	[ActionExpiryDate] [datetime] NULL,
	[ActionClosingInfo] [nvarchar](max) NULL,
	[ActionApprovedDate] [datetime] NULL,
	[DocName] [nvarchar](max) NULL,
	[DocFilePath] [nvarchar](max) NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantAction] PRIMARY KEY CLUSTERED 
(
	[ApplicantActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantApplication]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantApplication](
	[ApplicantApplicationId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[ApplicantReferenceTypeId] [int] NULL,
	[ApplicantReferenceSourceId] [int] NULL,
	[DateApplied] [datetime] NOT NULL,
	[DateAvailable] [datetime] NULL,
	[Rate] [decimal](18, 2) NULL,
	[RateFrequencyId] [int] NULL,
	[IsMondayShift] [bit] NULL,
	[MondayStartShift] [datetime] NULL,
	[MondayEndShift] [datetime] NULL,
	[IsTuesdayShift] [bit] NULL,
	[TuesdayStartShift] [datetime] NULL,
	[TuesdayEndShift] [datetime] NULL,
	[IsWednesdayShift] [bit] NULL,
	[WednesdayStartShift] [datetime] NULL,
	[WednesdayEndShift] [datetime] NULL,
	[IsThursdayShift] [bit] NULL,
	[ThursdayStartShift] [datetime] NULL,
	[ThursdayEndShift] [datetime] NULL,
	[IsFridayShift] [bit] NULL,
	[FridayStartShift] [datetime] NULL,
	[FridayEndShift] [datetime] NULL,
	[IsSaturdayShift] [bit] NULL,
	[SaturdayStartShift] [datetime] NULL,
	[SaturdayEndShift] [datetime] NULL,
	[IsSundayShift] [bit] NULL,
	[SundayStartShift] [datetime] NULL,
	[SundayEndShift] [datetime] NULL,
	[IsOvertime] [bit] NULL,
	[IsWorkedBefore] [bit] NULL,
	[WorkedBeforeDate] [datetime] NULL,
	[IsRelativeInCompany] [bit] NULL,
	[RelativeName] [nvarchar](max) NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[JobLocationId] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantApplication] PRIMARY KEY CLUSTERED 
(
	[ApplicantApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantApplicationLocation]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantApplicationLocation](
	[ApplicantApplicationLocationId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantApplicationId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_ApplicantApplicationLocation] PRIMARY KEY CLUSTERED 
(
	[ApplicantApplicationLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantCompany]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantCompany](
	[ApplicantCompanyId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantCompany] PRIMARY KEY CLUSTERED 
(
	[ApplicantCompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantContactInformation]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantContactInformation](
	[ApplicantContactInformationId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantInformationId] [int] NOT NULL,
	[HomeAddress1] [nvarchar](50) NULL,
	[HomeAddress2] [nvarchar](50) NULL,
	[HomeCityId] [int] NULL,
	[HomeStateId] [int] NULL,
	[HomeCountryId] [int] NULL,
	[HomeZipCode] [nvarchar](10) NULL,
	[MailingAddress1] [nvarchar](50) NULL,
	[MailingAddress2] [nvarchar](50) NULL,
	[MailingCityId] [int] NULL,
	[MailingStateId] [int] NULL,
	[MailingCountryId] [int] NULL,
	[MailingZipCode] [nvarchar](10) NULL,
	[HomeNumber] [nvarchar](20) NULL,
	[CelNumber] [nvarchar](20) NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[OtherNumber] [nvarchar](20) NULL,
	[WorkEmail] [nvarchar](50) NULL,
	[PersonalEmail] [nvarchar](50) NULL,
	[OtherEmail] [nvarchar](50) NULL,
	[WorkNumber] [nvarchar](20) NULL,
	[WorkExtension] [nvarchar](10) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantContactInformation] PRIMARY KEY CLUSTERED 
(
	[ApplicantContactInformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantCustomField]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantCustomField](
	[ApplicantCustomFieldId] [int] IDENTITY(1,1) NOT NULL,
	[CustomFieldId] [int] NOT NULL,
	[CustomFieldValue] [nvarchar](500) NULL,
	[CustomFieldNote] [nvarchar](250) NULL,
	[ExpirationDate] [datetime] NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantCustomField] PRIMARY KEY CLUSTERED 
(
	[ApplicantCustomFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantDocument]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantDocument](
	[ApplicantDocumentId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NOT NULL,
	[DocumentName] [nvarchar](250) NULL,
	[DocumentPath] [nvarchar](250) NULL,
	[DocumentNote] [nvarchar](250) NULL,
	[ExpirationDate] [datetime] NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantDocument] PRIMARY KEY CLUSTERED 
(
	[ApplicantDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantEducation]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantEducation](
	[ApplicantEducationId] [int] IDENTITY(1,1) NOT NULL,
	[InstitutionName] [nvarchar](max) NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Note] [nvarchar](max) NULL,
	[DateCompleted] [datetime] NOT NULL,
	[DocName] [nvarchar](max) NULL,
	[DocFilePath] [nvarchar](max) NULL,
	[DegreeId] [int] NOT NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantEducation] PRIMARY KEY CLUSTERED 
(
	[ApplicantEducationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantEmployment]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantEmployment](
	[ApplicantEmploymentId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantCompanyId] [int] NULL,
	[ApplicantPositionId] [int] NULL,
	[ApplicantExitTypeId] [int] NULL,
	[CompanyTelephone] [nvarchar](max) NULL,
	[CompanyAddress] [nvarchar](max) NULL,
	[EmploymentStartDate] [datetime] NULL,
	[EmploymentEndDate] [datetime] NULL,
	[Rate] [decimal](18, 2) NULL,
	[RateFrequencyId] [int] NULL,
	[SuperviorName] [nvarchar](max) NULL,
	[ExitReason] [nvarchar](max) NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[IsCurrentEmployment] [bit] NULL,
 CONSTRAINT [PK_dbo.ApplicantEmployment] PRIMARY KEY CLUSTERED 
(
	[ApplicantEmploymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantEmploymentType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantEmploymentType](
	[ApplicantEmploymentTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeTypeId] [int] NOT NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantEmploymentType] PRIMARY KEY CLUSTERED 
(
	[ApplicantEmploymentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantExitType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantExitType](
	[ApplicantExitTypeId] [int] IDENTITY(1,1) NOT NULL,
	[ExitTypeName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantExitType] PRIMARY KEY CLUSTERED 
(
	[ApplicantExitTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantInformation]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantInformation](
	[ApplicantInformationId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantExternalId] [int] NULL,
	[FirstName] [nvarchar](30) NULL,
	[MiddleInitial] [nvarchar](1) NULL,
	[FirstLastName] [nvarchar](30) NULL,
	[SecondLastName] [nvarchar](30) NULL,
	[ShortFullName] [nvarchar](50) NULL,
	[GenderId] [int] NULL,
	[BirthDate] [datetime] NULL,
	[SSNEncrypted] [nvarchar](512) NULL,
	[PictureFilePath] [nvarchar](512) NULL,
	[ResumeFilePath] [nvarchar](512) NULL,
	[CreatedBy] [int] NULL,
	[ApplicantStatusId] [int] NULL,
	[UserInformationId] [int] NULL,
	[JobPostingDetailId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[DisabilityId] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantInformation] PRIMARY KEY CLUSTERED 
(
	[ApplicantInformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantInterview]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantInterview](
	[ApplicantInterviewId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantInterviewQuestionId] [int] NOT NULL,
	[ApplicantAnswer] [nvarchar](max) NULL,
	[ApplicantInterviewAnswerId] [int] NULL,
	[InterviewAnswerValue] [float] NULL,
	[InterviewAnswerMaxValue] [float] NULL,
	[Note] [nvarchar](max) NULL,
	[ApplicantInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantInterview] PRIMARY KEY CLUSTERED 
(
	[ApplicantInterviewId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantInterviewAnswer]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantInterviewAnswer](
	[ApplicantInterviewAnswerId] [int] IDENTITY(1,1) NOT NULL,
	[AnswerName] [nvarchar](400) NOT NULL,
	[Description] [nvarchar](400) NULL,
	[AnswerValue] [float] NOT NULL,
	[AnswerMaxValue] [float] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantInterviewAnswer] PRIMARY KEY CLUSTERED 
(
	[ApplicantInterviewAnswerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantInterviewQAnswer]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantInterviewQAnswer](
	[ApplicantInterviewQAnswerId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantInterviewId] [int] NOT NULL,
	[ApplicantQAnswerOptionId] [int] NULL,
	[AnswerValue] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantInterviewQAnswer] PRIMARY KEY CLUSTERED 
(
	[ApplicantInterviewQAnswerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantInterviewQuestion]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantInterviewQuestion](
	[ApplicantInterviewQuestionId] [int] IDENTITY(1,1) NOT NULL,
	[QuestionName] [nvarchar](400) NOT NULL,
	[Description] [nvarchar](400) NULL,
	[IsPositionSpecific] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[ApplicantAnswerTypeId] [int] NULL,
	[IsRequired] [bit] NULL,
 CONSTRAINT [PK_dbo.ApplicantInterviewQuestion] PRIMARY KEY CLUSTERED 
(
	[ApplicantInterviewQuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantPosition]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantPosition](
	[ApplicantPositionId] [int] IDENTITY(1,1) NOT NULL,
	[PositionName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantPosition] PRIMARY KEY CLUSTERED 
(
	[ApplicantPositionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantQAnswerOption]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantQAnswerOption](
	[ApplicantQAnswerOptionId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantInterviewQuestionId] [int] NULL,
	[AnswerOptionName] [nvarchar](500) NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantQAnswerOption] PRIMARY KEY CLUSTERED 
(
	[ApplicantQAnswerOptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantReferenceSource]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantReferenceSource](
	[ApplicantReferenceSourceId] [int] IDENTITY(1,1) NOT NULL,
	[ReferenceSourceName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantReferenceSource] PRIMARY KEY CLUSTERED 
(
	[ApplicantReferenceSourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantReferenceType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantReferenceType](
	[ApplicantReferenceTypeId] [int] IDENTITY(1,1) NOT NULL,
	[ReferenceTypeName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantReferenceType] PRIMARY KEY CLUSTERED 
(
	[ApplicantReferenceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicantStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicantStatus](
	[ApplicantStatusId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicantStatusName] [nvarchar](500) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[UseAsHire] [bit] NOT NULL,
	[UseAsApply] [bit] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicantStatus] PRIMARY KEY CLUSTERED 
(
	[ApplicantStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ApplicationConfiguration]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationConfiguration](
	[ApplicationConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[ApplicationConfigurationName] [nvarchar](150) NOT NULL,
	[ApplicationConfigurationValue] [nvarchar](150) NULL,
	[ModuleFormName] [nvarchar](max) NULL,
	[ValueType] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ApplicationConfiguration] PRIMARY KEY CLUSTERED 
(
	[ApplicationConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppraisalGoal]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalGoal](
	[AppraisalGoalId] [int] IDENTITY(1,1) NOT NULL,
	[GoalName] [nvarchar](max) NOT NULL,
	[GoalDescription] [nvarchar](max) NULL,
	[AppraisalRatingScaleId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalGoal] PRIMARY KEY CLUSTERED 
(
	[AppraisalGoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppraisalRatingScale]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalRatingScale](
	[AppraisalRatingScaleId] [int] IDENTITY(1,1) NOT NULL,
	[ScaleName] [nvarchar](max) NOT NULL,
	[ScaleDescription] [nvarchar](max) NULL,
	[ScaleMaxValue] [decimal](18, 2) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalRatingScale] PRIMARY KEY CLUSTERED 
(
	[AppraisalRatingScaleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppraisalRatingScaleDetail]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalRatingScaleDetail](
	[AppraisalRatingScaleDetailId] [int] IDENTITY(1,1) NOT NULL,
	[AppraisalRatingScaleId] [int] NOT NULL,
	[RatingLevelId] [int] NOT NULL,
	[RatingValue] [decimal](18, 2) NOT NULL,
	[RatingName] [nvarchar](max) NOT NULL,
	[RatingDescription] [nvarchar](max) NULL,
	[RatingAbbreviation] [nvarchar](max) NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalRatingScaleDetail] PRIMARY KEY CLUSTERED 
(
	[AppraisalRatingScaleDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppraisalResult]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalResult](
	[AppraisalResultId] [int] IDENTITY(1,1) NOT NULL,
	[ResultName] [nvarchar](max) NOT NULL,
	[ResultDescription] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalResult] PRIMARY KEY CLUSTERED 
(
	[AppraisalResultId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppraisalSkill]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalSkill](
	[AppraisalSkillId] [int] IDENTITY(1,1) NOT NULL,
	[SkillName] [nvarchar](max) NOT NULL,
	[SkillDescription] [nvarchar](max) NULL,
	[AppraisalRatingScaleId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalSkill] PRIMARY KEY CLUSTERED 
(
	[AppraisalSkillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppraisalTemplate]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalTemplate](
	[AppraisalTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[TemplateName] [nvarchar](max) NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalTemplate] PRIMARY KEY CLUSTERED 
(
	[AppraisalTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppraisalTemplateGoal]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalTemplateGoal](
	[AppraisalTemplateGoalId] [int] IDENTITY(1,1) NOT NULL,
	[AppraisalTemplateId] [int] NOT NULL,
	[AppraisalGoalId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalTemplateGoal] PRIMARY KEY CLUSTERED 
(
	[AppraisalTemplateGoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppraisalTemplateSkill]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppraisalTemplateSkill](
	[AppraisalTemplateSkillId] [int] IDENTITY(1,1) NOT NULL,
	[AppraisalTemplateId] [int] NOT NULL,
	[AppraisalSkillId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AppraisalTemplateSkill] PRIMARY KEY CLUSTERED 
(
	[AppraisalTemplateSkillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
	[AspNetUsers_Id] [nvarchar](128) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[ChangePassword] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsersAspNetRoles]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUsersAspNetRoles](
	[AspNetUsers_Id] [nvarchar](128) NOT NULL,
	[AspNetRoles_Id] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUsersAspNetRoles] PRIMARY KEY CLUSTERED 
(
	[AspNetUsers_Id] ASC,
	[AspNetRoles_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditLog]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLog](
	[AuditLogId] [int] IDENTITY(1,1) NOT NULL,
	[ReferenceId] [int] NULL,
	[UserInformationId] [int] NULL,
	[UserSessionLogDetailId] [int] NULL,
	[TableName] [nvarchar](150) NULL,
	[Remarks] [nvarchar](max) NULL,
	[ActionType] [nvarchar](150) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[ReferenceId1] [bigint] NULL,
 CONSTRAINT [PK_dbo.AuditLog] PRIMARY KEY CLUSTERED 
(
	[AuditLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuditLogDetail]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLogDetail](
	[AuditLogDetailId] [int] IDENTITY(1,1) NOT NULL,
	[AuditLogId] [int] NOT NULL,
	[ColumnName] [nvarchar](150) NULL,
	[OldValue] [nvarchar](max) NULL,
	[NewValue] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.AuditLogDetail] PRIMARY KEY CLUSTERED 
(
	[AuditLogDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BankAccountType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BankAccountType](
	[BankAccountTypeId] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.BankAccountType] PRIMARY KEY CLUSTERED 
(
	[BankAccountTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BaseSchedule]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BaseSchedule](
	[BaseScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[NoOfPunch] [int] NULL,
	[IsSunday] [bit] NULL,
	[IsMonday] [bit] NULL,
	[IsTuesday] [bit] NULL,
	[IsWednesday] [bit] NULL,
	[IsThursday] [bit] NULL,
	[IsFriday] [bit] NULL,
	[IsSaturday] [bit] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.BaseSchedule] PRIMARY KEY CLUSTERED 
(
	[BaseScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BaseScheduleDayInfo]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BaseScheduleDayInfo](
	[BaseScheduleDayInfoId] [int] IDENTITY(1,1) NOT NULL,
	[BaseScheduleId] [int] NOT NULL,
	[DayOfWeek] [int] NULL,
	[NoOfPunch] [int] NULL,
	[IsRight] [bit] NULL,
	[TimeIn1] [datetime] NULL,
	[TimeOut1] [datetime] NULL,
	[TimeIn2] [datetime] NULL,
	[TimeOut2] [datetime] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.BaseScheduleDayInfo] PRIMARY KEY CLUSTERED 
(
	[BaseScheduleDayInfoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Benefit]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Benefit](
	[BenefitId] [int] IDENTITY(1,1) NOT NULL,
	[BenefitName] [nvarchar](max) NOT NULL,
	[BenefitDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Benefit] PRIMARY KEY CLUSTERED 
(
	[BenefitId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].['BENEFIT LIST$']    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['BENEFIT LIST$'](
	[ID] [nvarchar](255) NULL,
	[NAME] [nvarchar](255) NULL,
	[DESCRIPTION] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BENEFITS$]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BENEFITS$](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[BENEFIT NAME] [nvarchar](255) NULL,
	[START DATE] [nvarchar](255) NULL,
	[END DATE] [nvarchar](255) NULL,
	[AMOUNT] [nvarchar](255) NULL,
	[FREQUENCY] [nvarchar](255) NULL,
	[COMPANY CONTRIBUTION] [nvarchar](255) NULL,
	[EMPLOYEE CONTRIBUTION] [nvarchar](255) NULL,
	[TOTAL] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Certification]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Certification](
	[CertificationId] [int] IDENTITY(1,1) NOT NULL,
	[CertificationName] [char](50) NOT NULL,
	[Description] [char](200) NULL,
	[CertificationTypeId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Certification] PRIMARY KEY CLUSTERED 
(
	[CertificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CertificationType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CertificationType](
	[CertificationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[CertificationTypeName] [varchar](50) NOT NULL,
	[Description] [varchar](200) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CertificationType] PRIMARY KEY CLUSTERED 
(
	[CertificationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CFSECode]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CFSECode](
	[CFSECodeId] [int] IDENTITY(1,1) NOT NULL,
	[CFSECodeName] [varchar](150) NOT NULL,
	[CFSECodeDescription] [varchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CFSECode] PRIMARY KEY CLUSTERED 
(
	[CFSECodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChangePasswordByAdminReason]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangePasswordByAdminReason](
	[ChangePasswordByAdminReasonId] [int] IDENTITY(1,1) NOT NULL,
	[Reason] [nvarchar](max) NOT NULL,
	[ChangeByUserId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[UserInformationId] [int] NULL,
 CONSTRAINT [PK_dbo.ChangePasswordByAdminReason] PRIMARY KEY CLUSTERED 
(
	[ChangePasswordByAdminReasonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChangeRequestAddress]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeRequestAddress](
	[ChangeRequestAddressId] [int] IDENTITY(1,1) NOT NULL,
	[UserContactInformationId] [int] NOT NULL,
	[Address1] [nvarchar](50) NULL,
	[Address2] [nvarchar](50) NULL,
	[CityId] [int] NULL,
	[StateId] [int] NULL,
	[CountryId] [int] NULL,
	[ZipCode] [nvarchar](10) NULL,
	[NewAddress1] [nvarchar](50) NULL,
	[NewAddress2] [nvarchar](50) NULL,
	[NewCityId] [int] NULL,
	[NewStateId] [int] NULL,
	[NewCountryId] [int] NULL,
	[NewZipCode] [nvarchar](10) NULL,
	[AddressType] [nvarchar](max) NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ChangeRequestAddress] PRIMARY KEY CLUSTERED 
(
	[ChangeRequestAddressId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChangeRequestEmailNumbers]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeRequestEmailNumbers](
	[ChangeRequestEmailNumbersId] [int] IDENTITY(1,1) NOT NULL,
	[UserContactInformationId] [int] NOT NULL,
	[HomeNumber] [nvarchar](20) NULL,
	[CelNumber] [nvarchar](20) NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[OtherNumber] [nvarchar](20) NULL,
	[WorkEmail] [nvarchar](50) NULL,
	[PersonalEmail] [nvarchar](50) NULL,
	[OtherEmail] [nvarchar](50) NULL,
	[WorkNumber] [nvarchar](20) NULL,
	[WorkExtension] [nvarchar](10) NULL,
	[NewHomeNumber] [nvarchar](20) NULL,
	[NewCelNumber] [nvarchar](20) NULL,
	[NewFaxNumber] [nvarchar](20) NULL,
	[NewOtherNumber] [nvarchar](20) NULL,
	[NewWorkEmail] [nvarchar](50) NULL,
	[NewPersonalEmail] [nvarchar](50) NULL,
	[NewOtherEmail] [nvarchar](50) NULL,
	[NewWorkNumber] [nvarchar](20) NULL,
	[NewWorkExtension] [nvarchar](10) NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[ChangeRequestRemarks] [varchar](1000) NULL,
 CONSTRAINT [PK_dbo.ChangeRequestEmailNumbers] PRIMARY KEY CLUSTERED 
(
	[ChangeRequestEmailNumbersId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChangeRequestEmergencyContact]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeRequestEmergencyContact](
	[ChangeRequestEmergencyContactId] [int] IDENTITY(1,1) NOT NULL,
	[EmergencyContactId] [int] NOT NULL,
	[RelationshipId] [int] NULL,
	[ContactPersonName] [nvarchar](50) NULL,
	[IsDefault] [bit] NOT NULL,
	[MainNumber] [nvarchar](20) NULL,
	[AlternateNumber] [nvarchar](20) NULL,
	[NewRelationshipId] [int] NULL,
	[NewContactPersonName] [nvarchar](50) NULL,
	[NewIsDefault] [bit] NOT NULL,
	[NewMainNumber] [nvarchar](20) NULL,
	[NewAlternateNumber] [nvarchar](20) NULL,
	[RequestTypeId] [int] NOT NULL,
	[ReasonForDelete] [nvarchar](max) NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ChangeRequestEmergencyContact] PRIMARY KEY CLUSTERED 
(
	[ChangeRequestEmergencyContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChangeRequestEmployeeDependent]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeRequestEmployeeDependent](
	[ChangeRequestEmployeeDependentId] [int] IDENTITY(1,1) NOT NULL,
	[NewFirstName] [nvarchar](max) NULL,
	[NewLastName] [nvarchar](max) NULL,
	[NewBirthDate] [datetime] NULL,
	[NewSSN] [nvarchar](max) NULL,
	[NewDependentStatusId] [int] NULL,
	[NewGenderId] [int] NULL,
	[NewRelationshipId] [int] NULL,
	[NewExpiryDate] [datetime] NULL,
	[NewIsHealthInsurance] [bit] NULL,
	[NewIsDentalInsurance] [bit] NULL,
	[NewIsTaxPurposes] [bit] NULL,
	[NewIsFullTimeStudent] [bit] NULL,
	[NewSchoolAttending] [nvarchar](max) NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[BirthDate] [datetime] NULL,
	[SSN] [nvarchar](max) NULL,
	[DependentStatusId] [int] NULL,
	[GenderId] [int] NULL,
	[RelationshipId] [int] NULL,
	[ExpiryDate] [datetime] NULL,
	[IsHealthInsurance] [bit] NOT NULL,
	[IsDentalInsurance] [bit] NOT NULL,
	[IsTaxPurposes] [bit] NOT NULL,
	[IsFullTimeStudent] [bit] NOT NULL,
	[SchoolAttending] [nvarchar](max) NULL,
	[EmployeeDependentId] [int] NOT NULL,
	[ReasonForDelete] [nvarchar](max) NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[ChangeRequestRemarks] [varchar](1000) NULL,
 CONSTRAINT [PK_dbo.ChangeRequestEmployeeDependent] PRIMARY KEY CLUSTERED 
(
	[ChangeRequestEmployeeDependentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChangeRequestStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChangeRequestStatus](
	[ChangeRequestStatusId] [int] IDENTITY(1,1) NOT NULL,
	[ChangeRequestStatusName] [nvarchar](500) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ChangeRequestStatus] PRIMARY KEY CLUSTERED 
(
	[ChangeRequestStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatConversation]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatConversation](
	[ChatConversationId] [int] IDENTITY(1,1) NOT NULL,
	[ChatConversationTitle] [nvarchar](250) NOT NULL,
	[ChatInitiatedById] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ChatConversation] PRIMARY KEY CLUSTERED 
(
	[ChatConversationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatConversationParticipant]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatConversationParticipant](
	[ChatConversationParticipantId] [int] IDENTITY(1,1) NOT NULL,
	[ChatConversationId] [int] NOT NULL,
	[ParticipantId] [int] NOT NULL,
	[LastMessageReadTime] [datetime] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ChatConversationParticipant] PRIMARY KEY CLUSTERED 
(
	[ChatConversationParticipantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatMessage]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatMessage](
	[ChatMessageId] [int] IDENTITY(1,1) NOT NULL,
	[ChatConversationParticipantId] [int] NOT NULL,
	[ChatConversationId] [int] NOT NULL,
	[ChatMessageText] [nvarchar](max) NULL,
	[ChatDocumentFilePath] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ChatMessage] PRIMARY KEY CLUSTERED 
(
	[ChatMessageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatUsers]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatUsers](
	[ChatUserId] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](max) NULL,
	[UserID] [nvarchar](max) NULL,
	[ConnectionID] [nvarchar](max) NULL,
	[UserInformationName] [nvarchar](max) NULL,
	[ActiveChatConversationId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ChatUsers] PRIMARY KEY CLUSTERED 
(
	[ChatUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[City]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[City](
	[CityId] [int] IDENTITY(1,1) NOT NULL,
	[CityCode] [nvarchar](20) NULL,
	[CityName] [nvarchar](200) NOT NULL,
	[CityDescription] [nvarchar](200) NULL,
	[StateId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.City] PRIMARY KEY CLUSTERED 
(
	[CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Client]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Client](
	[ClientId] [int] IDENTITY(1,1) NOT NULL,
	[ClientName] [nvarchar](50) NOT NULL,
	[Address1] [nvarchar](50) NULL,
	[Address2] [nvarchar](50) NULL,
	[CountryId] [int] NULL,
	[StateId] [int] NULL,
	[CityId] [int] NULL,
	[ZipCode] [nvarchar](50) NULL,
	[Phone] [nvarchar](50) NULL,
	[Fax] [nvarchar](50) NULL,
	[Email] [nvarchar](100) NULL,
	[WebSite] [nvarchar](50) NULL,
	[ContactName] [nvarchar](50) NULL,
	[PayrollName] [nvarchar](50) NULL,
	[PayrollAddress1] [nvarchar](50) NULL,
	[PayrollAddress2] [nvarchar](50) NULL,
	[PayrollCountryId] [int] NULL,
	[PayrollStateId] [int] NULL,
	[PayrollCityId] [int] NULL,
	[PayrollZipCode] [nvarchar](50) NULL,
	[EIN] [nvarchar](50) NULL,
	[PayrollFax] [nvarchar](50) NULL,
	[PayrollContactName] [nvarchar](50) NULL,
	[PayrollContactTitle] [nvarchar](50) NULL,
	[PayrollContactPhone] [nvarchar](50) NULL,
	[PayrollEmail] [nvarchar](50) NULL,
	[CompanyStartDate] [date] NULL,
	[SICCode] [nvarchar](50) NULL,
	[NAICSCode] [nvarchar](50) NULL,
	[SeguroChoferilAccount] [nvarchar](50) NULL,
	[DepartamentoDelTrabajoAccount] [nvarchar](50) NULL,
	[DepartamentoDelTrabajoRate] [decimal](18, 5) NULL,
	[IsTimeAideWindow] [bit] NOT NULL,
	[DBServerName] [nvarchar](max) NULL,
	[DBName] [nvarchar](max) NULL,
	[DBUser] [nvarchar](max) NULL,
	[DBPassword] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Client] PRIMARY KEY CLUSTERED 
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ClosingNotificationType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClosingNotificationType](
	[ClosingNotificationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[ClosingNotificationTypeName] [nvarchar](max) NULL,
	[ClosingNotificationTypeDescription] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ClosingNotificationType] PRIMARY KEY CLUSTERED 
(
	[ClosingNotificationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CobraPaymentStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CobraPaymentStatus](
	[CobraPaymentStatusId] [int] IDENTITY(1,1) NOT NULL,
	[CobraPaymentStatusName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CobraPaymentStatus] PRIMARY KEY CLUSTERED 
(
	[CobraPaymentStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CobraStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CobraStatus](
	[CobraStatusId] [int] IDENTITY(1,1) NOT NULL,
	[CobraStatusName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CobraStatus] PRIMARY KEY CLUSTERED 
(
	[CobraStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[CompanyId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](50) NOT NULL,
	[CompanyDescription] [nvarchar](200) NULL,
	[ParentCompany] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](50) NULL,
	[Address1] [nvarchar](100) NULL,
	[Address2] [nvarchar](100) NULL,
	[CityId] [int] NULL,
	[StateId] [int] NULL,
	[ZipCode] [nvarchar](9) NULL,
	[ContactName] [nvarchar](50) NULL,
	[ContactTelephone] [nvarchar](max) NULL,
	[ContactEmail] [nvarchar](50) NULL,
	[ContactPosition] [nvarchar](50) NULL,
	[NAICS] [nvarchar](9) NULL,
	[DUNS] [nvarchar](max) NULL,
	[EmployerID] [nvarchar](9) NULL,
	[NameInLetters] [nvarchar](200) NULL,
	[SIC] [nvarchar](4) NULL,
	[PortalPictureFilePath] [nvarchar](max) NULL,
	[PortalWelcomeStatement] [nvarchar](max) NULL,
	[CreatedBy] [int] NULL,
	[CompanyLogo] [varbinary](max) NULL,
	[ClientId] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[IsDefaultPortalPicture] [bit] NULL,
	[IsDefaultPortalStatement] [bit] NULL,
	[DefaultLetterSigneeId] [int] NULL,
	[DefaultLetterTemplateId] [int] NULL,
 CONSTRAINT [PK_dbo.Company] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyAnnouncement]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyAnnouncement](
	[CompanyAnnouncementId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Message] [nvarchar](max) NULL,
	[StartDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyAnnouncement] PRIMARY KEY CLUSTERED 
(
	[CompanyAnnouncementId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyCompensation]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyCompensation](
	[CompanyCompensationId] [int] IDENTITY(1,1) NOT NULL,
	[CompensationName] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[CompensationTypeId] [int] NOT NULL,
	[ComputationTypeId] [int] NOT NULL,
	[IsEnabled] [bit] NOT NULL,
	[ImportTypeId] [int] NOT NULL,
	[IsCovidCompensation] [bit] NOT NULL,
	[IsFICASSCCExempt] [bit] NOT NULL,
	[ReportOrder] [int] NULL,
	[GLLookupField] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[GLAccountId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.CompanyCompensation] PRIMARY KEY CLUSTERED 
(
	[CompanyCompensationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyCompensationPRPayExport]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyCompensationPRPayExport](
	[CompanyCompensationPRPayExportId] [int] NOT NULL,
	[CompanyCompensationId] [int] NULL,
	[CustomIncome1] [bit] NOT NULL,
	[CustomIncome2] [bit] NOT NULL,
	[CustomIncome3] [bit] NOT NULL,
	[CustomIncome4] [bit] NOT NULL,
	[CustomIncome5] [bit] NOT NULL,
	[NonTaxable1] [bit] NOT NULL,
	[NonTaxable2] [bit] NOT NULL,
	[NonTaxable3] [bit] NOT NULL,
	[NonTaxable4] [bit] NOT NULL,
	[NonTaxable5] [bit] NOT NULL,
	[Wages] [bit] NOT NULL,
	[Commissions] [bit] NOT NULL,
	[Allowances] [bit] NOT NULL,
	[Tips] [bit] NOT NULL,
	[Income401K] [bit] NOT NULL,
	[OtherRetirement] [bit] NOT NULL,
	[Cafeteria] [bit] NOT NULL,
	[Reimbursements] [bit] NOT NULL,
	[CODA401K] [bit] NOT NULL,
	[ExemptSalaries] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyCompensationPRPayExport] PRIMARY KEY CLUSTERED 
(
	[CompanyCompensationPRPayExportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyConfigurableLink]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyConfigurableLink](
	[CompanyConfigurableLinkId] [int] IDENTITY(1,1) NOT NULL,
	[LinkName] [nvarchar](max) NULL,
	[LinkURL] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyConfigurableLink] PRIMARY KEY CLUSTERED 
(
	[CompanyConfigurableLinkId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyContribution]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyContribution](
	[CompanyContributionId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](150) NULL,
	[CompanyId] [int] NULL,
	[WitholdingPrePostTypeId] [int] NOT NULL,
	[WitholdingComputationTypeId] [int] NOT NULL,
	[ContributionTaxTypeId] [int] NULL,
	[EmployeeContributionPercentage] [decimal](18, 5) NOT NULL,
	[EmployeeContributionAmount] [decimal](18, 5) NOT NULL,
	[CompanyContributionPercent] [decimal](18, 5) NOT NULL,
	[CompanyContributionAmount] [decimal](18, 5) NOT NULL,
	[MaximumSalaryLimit] [decimal](18, 5) NOT NULL,
	[MinimumSalaryLimit] [decimal](18, 5) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[intReportOrder] [int] NOT NULL,
	[GLAccountId] [int] NOT NULL,
	[GLContributionAccountId] [int] NULL,
	[GLContributionPayableAccountId] [int] NULL,
	[GLLookupFieldId] [int] NOT NULL,
	[Is401kPlan] [bit] NOT NULL,
	[IsCompanyContribution] [bit] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CompanyContributionName] [nvarchar](150) NULL,
 CONSTRAINT [PK_CompanyContribution] PRIMARY KEY CLUSTERED 
(
	[CompanyContributionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyContribution401K]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyContribution401K](
	[CompanyContribution401KId] [int] NOT NULL,
	[CompanyContributionId] [int] NOT NULL,
	[PlanDescription] [nvarchar](250) NULL,
	[EEMaxYearlyAmount] [decimal](18, 5) NULL,
	[ERMaxYearlyAmount] [decimal](18, 5) NULL,
	[EmployerMatchPercentage] [decimal](18, 5) NULL,
	[EmployerPeriodMax] [decimal](18, 5) NULL,
	[EmployerPercentageLimitType] [decimal](18, 5) NULL,
	[Is401K1165eStTaxExempted] [bit] NOT NULL,
	[Withholding401KTypeId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_CompanyContribution401K] PRIMARY KEY CLUSTERED 
(
	[CompanyContribution401KId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyContributionCompensationExclusion]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyContributionCompensationExclusion](
	[CompanyContributionCompensationExclusionId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyContributionId] [int] NOT NULL,
	[CompanyCompensationId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_CompanyContributionCompensationExclusion] PRIMARY KEY CLUSTERED 
(
	[CompanyContributionCompensationExclusionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyContributionPRPayExport]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyContributionPRPayExport](
	[CompanyContributionPRPayExportId] [int] NOT NULL,
	[CompanyContributionId] [int] NOT NULL,
	[CustomDeduction1] [bit] NOT NULL,
	[CustomDeduction2] [bit] NOT NULL,
	[CustomDeduction3] [bit] NOT NULL,
	[CustomDeduction4] [bit] NOT NULL,
	[CustomDeduction5] [bit] NOT NULL,
	[IsWithholding] [bit] NOT NULL,
	[IsFICA] [bit] NOT NULL,
	[IsSocialSecurity] [bit] NOT NULL,
	[IsMedicare] [bit] NOT NULL,
	[IsDisability] [bit] NOT NULL,
	[IsChauffeurInsurance] [bit] NOT NULL,
	[IsOtherDeduction] [bit] NOT NULL,
	[IsHealthCoverageContribution] [bit] NOT NULL,
	[Charitable_Contribution] [bit] NOT NULL,
	[IsMoneySaving] [bit] NOT NULL,
	[IsMedicarePlus] [bit] NOT NULL,
	[IsCoda401K] [bit] NOT NULL,
	[IsCodaExemptSalary] [bit] NOT NULL,
	[IsMedicalInsurance] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_CompanyContributionPRPayExport] PRIMARY KEY CLUSTERED 
(
	[CompanyContributionPRPayExportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyDocument]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyDocument](
	[CompanyDocumentId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentName] [nvarchar](max) NULL,
	[DocumentFilePath] [nvarchar](max) NULL,
	[DocumentUserId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyDocument] PRIMARY KEY CLUSTERED 
(
	[CompanyDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyEmployeeTab]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyEmployeeTab](
	[CompanyEmployeeTabId] [int] IDENTITY(1,1) NOT NULL,
	[FormId] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyEmployeeTab] PRIMARY KEY CLUSTERED 
(
	[CompanyEmployeeTabId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyMedia]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyMedia](
	[CompanyMediaId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[IsDefaultMedia] [bit] NOT NULL,
	[MediaFilePath] [nvarchar](300) NULL,
	[FileName] [nvarchar](100) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[MediaType] [nvarchar](15) NULL,
	[PosterFilePath] [nvarchar](300) NULL,
	[PosterFileName] [nvarchar](100) NULL,
 CONSTRAINT [PK__CompanyMedia__C54EF7461C1F2ED6] PRIMARY KEY CLUSTERED 
(
	[CompanyMediaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyWithholding]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyWithholding](
	[CompanyWithholdingId] [int] IDENTITY(1,1) NOT NULL,
	[WithHoldingName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](150) NULL,
	[WitholdingPrePostTypeId] [int] NOT NULL,
	[WitholdingComputationTypeId] [int] NOT NULL,
	[WithholdingTaxTypeId] [int] NOT NULL,
	[EmployeeWithholdingPercentage] [decimal](18, 2) NOT NULL,
	[EmployeeWithholdingAmount] [decimal](18, 2) NOT NULL,
	[CompanyWithholdingPercent] [decimal](18, 2) NOT NULL,
	[CompanyWithholdingAmount] [decimal](18, 2) NOT NULL,
	[MaximumSalaryLimit] [decimal](18, 2) NOT NULL,
	[MinimumSalaryLimit] [decimal](18, 2) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[intReportOrder] [int] NOT NULL,
	[GLAccountId] [int] NOT NULL,
	[GLLookupFieldId] [int] NOT NULL,
	[IsLoan] [bit] NOT NULL,
	[Is401kPlan] [bit] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyWithholding] PRIMARY KEY CLUSTERED 
(
	[CompanyWithholdingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyWithholding401K]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyWithholding401K](
	[CompanyWithholding401KId] [int] NOT NULL,
	[CompanyWithholdingId] [int] NOT NULL,
	[EEMaxYearlyAmount] [decimal](18, 5) NOT NULL,
	[ERMaxYearlyAmount] [decimal](18, 5) NOT NULL,
	[Is401K1165eStTaxExempted] [bit] NOT NULL,
	[Withholding401KTypeId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_CompanyWithholding401K] PRIMARY KEY CLUSTERED 
(
	[CompanyWithholding401KId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyWithholdingCompensationExclusion]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyWithholdingCompensationExclusion](
	[CompanyWithholdingCompensationExclusionId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyWithholdingId] [int] NOT NULL,
	[CompanyCompensationId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyWithholdingCompensationExclusion] PRIMARY KEY CLUSTERED 
(
	[CompanyWithholdingCompensationExclusionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyWithholdingLoan]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyWithholdingLoan](
	[CompanyWithholdingLoanId] [int] NOT NULL,
	[CompanyWithholdingId] [int] NOT NULL,
	[LoanDescription] [nvarchar](50) NOT NULL,
	[LoanAmount] [decimal](18, 2) NOT NULL,
	[StartDate] [date] NULL,
	[LoanPeriodLengthId] [int] NOT NULL,
	[EndDate] [date] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyWithholdingLoan] PRIMARY KEY CLUSTERED 
(
	[CompanyWithholdingLoanId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompanyWithholdingPRPayExport]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyWithholdingPRPayExport](
	[CompanyWithholdingPRPayExportId] [int] NOT NULL,
	[CompanyWithholdingId] [int] NOT NULL,
	[CustomDeduction1] [bit] NOT NULL,
	[CustomDeduction2] [bit] NOT NULL,
	[CustomDeduction3] [bit] NOT NULL,
	[CustomDeduction4] [bit] NOT NULL,
	[CustomDeduction5] [bit] NOT NULL,
	[IsWithholding] [bit] NOT NULL,
	[IsFICA] [bit] NOT NULL,
	[IsSocialSecurity] [bit] NOT NULL,
	[IsMedicare] [bit] NOT NULL,
	[IsDisability] [bit] NOT NULL,
	[IsChauffeurInsurance] [bit] NOT NULL,
	[IsOtherDeduction] [bit] NOT NULL,
	[IsHealthCoverageContribution] [bit] NOT NULL,
	[Charitable_Contribution] [bit] NOT NULL,
	[IsMoneySaving] [bit] NOT NULL,
	[IsMedicarePlus] [bit] NOT NULL,
	[IsCoda401K] [bit] NOT NULL,
	[IsCodaExemptSalary] [bit] NOT NULL,
	[IsMedicalInsurance] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompanyWithholdingPRPayExport] PRIMARY KEY CLUSTERED 
(
	[CompanyWithholdingPRPayExportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompensationAccrualType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompensationAccrualType](
	[CompensationAccrualTypeId] [int] IDENTITY(1,1) NOT NULL,
	[CompensationAccrualTypeName] [nvarchar](150) NOT NULL,
	[CompensationAccrualTypeDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompensationAccrualType] PRIMARY KEY CLUSTERED 
(
	[CompensationAccrualTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompensationComputationType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompensationComputationType](
	[CompensationComputationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[CompensationComputationTypeName] [nvarchar](max) NOT NULL,
	[CompensationComputationTypeDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompensationComputationType] PRIMARY KEY CLUSTERED 
(
	[CompensationComputationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompensationImportType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompensationImportType](
	[CompensationImportTypeId] [int] IDENTITY(1,1) NOT NULL,
	[CompensationImportTypeName] [nvarchar](max) NOT NULL,
	[CompensationImportTypeDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompensationImportType] PRIMARY KEY CLUSTERED 
(
	[CompensationImportTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompensationPeriodEntry]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompensationPeriodEntry](
	[CompensationPeriodEntryId] [int] IDENTITY(1,1) NOT NULL,
	[CompensationPeriodEntryName] [nvarchar](max) NOT NULL,
	[CompensationPeriodEntryDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompensationPeriodEntry] PRIMARY KEY CLUSTERED 
(
	[CompensationPeriodEntryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompensationTransaction]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompensationTransaction](
	[CompensationTransactionId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyCompensationId] [int] NULL,
	[TransactionId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompensationTransaction] PRIMARY KEY CLUSTERED 
(
	[CompensationTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CompensationType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompensationType](
	[CompensationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[CompensationTypeName] [nvarchar](max) NOT NULL,
	[CompensationTypeDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CompensationType] PRIMARY KEY CLUSTERED 
(
	[CompensationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].['CONTACT INFO$']    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['CONTACT INFO$'](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[ADDRESS 1] [nvarchar](255) NULL,
	[ADDRESS 2] [nvarchar](255) NULL,
	[CITY] [nvarchar](255) NULL,
	[STATE] [nvarchar](255) NULL,
	[COUNTRY] [nvarchar](255) NULL,
	[ZIP CODE] [float] NULL,
	[PHONE NUMBER] [nvarchar](255) NULL,
	[SAME AS MAILING YES/NO] [nvarchar](255) NULL,
	[LOGIN EMAIL] [nvarchar](255) NULL,
	[EMERGENCY CONTACT NAME] [nvarchar](255) NULL,
	[RELATIONSHIP] [nvarchar](255) NULL,
	[EMERGENCY CONTACT PHONE] [nvarchar](255) NULL,
	[EMERGENCY CONTACT EMAIL] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].['CONTACT INFO$'_xlnm#_FilterDatabase]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['CONTACT INFO$'_xlnm#_FilterDatabase](
	[ID] [nvarchar](255) NULL,
	[NAME] [nvarchar](255) NULL,
	[ADDRESS 1] [nvarchar](255) NULL,
	[ADDRESS 2] [nvarchar](255) NULL,
	[CITY] [nvarchar](255) NULL,
	[STATE] [nvarchar](255) NULL,
	[COUNTRY] [nvarchar](255) NULL,
	[ZIP CODE] [nvarchar](255) NULL,
	[PHONE NUMBER] [nvarchar](255) NULL,
	[SAME AS MAILING YES/NO] [nvarchar](255) NULL,
	[LOGIN EMAIL] [nvarchar](255) NULL,
	[EMERGENCY CONTACT NAME] [nvarchar](255) NULL,
	[RELATIONSHIP] [nvarchar](255) NULL,
	[EMERGENCY CONTACT PHONE] [nvarchar](255) NULL,
	[EMERGENCY CONTACT EMAIL] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[CountryCode] [nvarchar](150) NOT NULL,
	[CountryName] [nvarchar](150) NOT NULL,
	[CountryDescription] [varchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Country] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CountryIPAddress]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CountryIPAddress](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[CountryCode] [nvarchar](150) NOT NULL,
	[CountryName] [nvarchar](150) NOT NULL,
	[CountryDescription] [nvarchar](150) NULL,
	[StartIPNumber] [nvarchar](150) NULL,
	[EndIPNumber] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CountryIPAddress] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CREDENCIALES$]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CREDENCIALES$](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[LICENSE NAME] [nvarchar](255) NULL,
	[LICENSING INSTITUTION] [nvarchar](255) NULL,
	[NUMBER] [nvarchar](255) NULL,
	[LICENSE ISSUANCE DATE] [nvarchar](255) NULL,
	[LICENSE EXP DATE] [nvarchar](255) NULL,
	[POSITION SPECIFIC YES/NO] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Credential]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credential](
	[CredentialId] [int] IDENTITY(1,1) NOT NULL,
	[CredentialName] [varchar](1000) NULL,
	[CredentialDescription] [varchar](1000) NULL,
	[NotificationScheduleId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[SelfServiceDisplay] [bit] NOT NULL,
	[SelfServiceUpload] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Credential] PRIMARY KEY CLUSTERED 
(
	[CredentialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].['CREDENTIAL LIST$']    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['CREDENTIAL LIST$'](
	[ID] [nvarchar](255) NULL,
	[NAME] [nvarchar](255) NULL,
	[DESCRIPTION] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CredentialType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CredentialType](
	[CredentialTypeId] [int] IDENTITY(1,1) NOT NULL,
	[CredentialTypeName] [varchar](50) NOT NULL,
	[Description] [varchar](200) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CredentialType] PRIMARY KEY CLUSTERED 
(
	[CredentialTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomField]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomField](
	[CustomFieldId] [int] IDENTITY(1,1) NOT NULL,
	[CustomFieldName] [nvarchar](500) NOT NULL,
	[CustomFieldDescription] [nvarchar](1000) NULL,
	[IsExpirable] [bit] NOT NULL,
	[FieldDisplayOrder] [int] NOT NULL,
	[NotificationScheduleId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[DocumentRequiredById] [int] NULL,
	[CustomFieldTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.CustomField] PRIMARY KEY CLUSTERED 
(
	[CustomFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CustomFieldType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomFieldType](
	[CustomFieldTypeId] [int] IDENTITY(1,1) NOT NULL,
	[CustomFieldTypeName] [nvarchar](150) NOT NULL,
	[CustomFieldTypeDescription] [nvarchar](150) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.CustomFieldType] PRIMARY KEY CLUSTERED 
(
	[CustomFieldTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataMigrationLog]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataMigrationLog](
	[DataMigrationLogId] [int] IDENTITY(1,1) NOT NULL,
	[LogName] [nvarchar](500) NULL,
	[LogDescription] [nvarchar](2000) NULL,
	[LogRemarks] [nvarchar](2000) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.DataMigrationLog] PRIMARY KEY CLUSTERED 
(
	[DataMigrationLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DataMigrationLogDetail]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataMigrationLogDetail](
	[DataMigrationLogDetailId] [int] IDENTITY(1,1) NOT NULL,
	[LogCommandName] [nvarchar](500) NULL,
	[LogDetailName] [nvarchar](500) NULL,
	[LogDescription] [nvarchar](2000) NULL,
	[LogRemarks] [nvarchar](2000) NULL,
	[RowCount] [int] NOT NULL,
	[DataMigrationLogId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.DataMigrationLogDetail] PRIMARY KEY CLUSTERED 
(
	[DataMigrationLogDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DateCalendar]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DateCalendar](
	[TheDate] [date] NULL,
	[TheDay] [int] NULL,
	[TheDaySuffix] [char](2) NULL,
	[TheDayName] [nvarchar](30) NULL,
	[TheDayOfWeek] [int] NULL,
	[TheDayOfWeekInMonth] [tinyint] NULL,
	[TheDayOfYear] [int] NULL,
	[IsWeekend] [int] NOT NULL,
	[TheWeek] [int] NULL,
	[TheISOweek] [int] NULL,
	[TheFirstOfWeek] [date] NULL,
	[TheLastOfWeek] [date] NULL,
	[TheWeekOfMonth] [tinyint] NULL,
	[TheMonth] [int] NULL,
	[TheMonthName] [nvarchar](30) NULL,
	[TheFirstOfMonth] [date] NULL,
	[TheLastOfMonth] [date] NULL,
	[TheFirstOfNextMonth] [date] NULL,
	[TheLastOfNextMonth] [date] NULL,
	[TheQuarter] [int] NULL,
	[TheFirstOfQuarter] [date] NULL,
	[TheLastOfQuarter] [date] NULL,
	[TheYear] [int] NULL,
	[TheISOYear] [int] NULL,
	[TheFirstOfYear] [date] NULL,
	[TheLastOfYear] [date] NULL,
	[IsLeapYear] [bit] NULL,
	[Has53Weeks] [int] NOT NULL,
	[Has53ISOWeeks] [int] NOT NULL,
	[MMYYYY] [char](6) NULL,
	[Style101] [char](10) NULL,
	[Style103] [char](10) NULL,
	[Style112] [char](8) NULL,
	[Style120] [char](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Degree]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Degree](
	[DegreeId] [int] IDENTITY(1,1) NOT NULL,
	[DegreeName] [nvarchar](max) NOT NULL,
	[DegreeDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Degree] PRIMARY KEY CLUSTERED 
(
	[DegreeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].['DENTAL INSURANCE$']    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['DENTAL INSURANCE$'](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[STATUS] [nvarchar](255) NULL,
	[START DATE] [nvarchar](255) NULL,
	[EXPIRY DATE] [nvarchar](255) NULL,
	[CONTRACT ID] [nvarchar](255) NULL,
	[TYPE PRIMARY/SECONDARY] [nvarchar](255) NULL,
	[COVERAGE] [nvarchar](255) NULL,
	[MONTHLY COMPANY CONTRIBUTION] [nvarchar](255) NULL,
	[MONTHLY EMPLOYEE CONTRIBUTION] [float] NULL,
	[OTHER] [nvarchar](255) NULL,
	[TOTAL] [nvarchar](255) NULL,
	[COBRA YES/NO] [nvarchar](255) NULL,
	[COBRA STATUS] [nvarchar](255) NULL,
	[COBRA START DATE] [nvarchar](255) NULL,
	[COBRA EXPIRY DATE] [nvarchar](255) NULL,
	[COBRA INSURANCE PREMIUM] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].['DENTAL INSURANCE$'_xlnm#_FilterDatabase]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['DENTAL INSURANCE$'_xlnm#_FilterDatabase](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[STATUS] [nvarchar](255) NULL,
	[START DATE] [nvarchar](255) NULL,
	[EXPIRY DATE] [nvarchar](255) NULL,
	[CONTRACT ID] [nvarchar](255) NULL,
	[TYPE PRIMARY/SECONDARY] [nvarchar](255) NULL,
	[COVERAGE] [nvarchar](255) NULL,
	[MONTHLY COMPANY CONTRIBUTION] [nvarchar](255) NULL,
	[MONTHLY EMPLOYEE CONTRIBUTION] [float] NULL,
	[OTHER] [nvarchar](255) NULL,
	[TOTAL] [nvarchar](255) NULL,
	[COBRA YES/NO] [nvarchar](255) NULL,
	[COBRA STATUS] [nvarchar](255) NULL,
	[COBRA START DATE] [nvarchar](255) NULL,
	[COBRA EXPIRY DATE] [nvarchar](255) NULL,
	[COBRA INSURANCE PREMIUM] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DentalInsuranceCobraHistory]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DentalInsuranceCobraHistory](
	[DentalInsuranceCobraHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeDentalInsuranceId] [int] NULL,
	[DueDate] [datetime] NULL,
	[PaymentDate] [datetime] NULL,
	[CobraPaymentStatusId] [int] NULL,
	[PaymentAmount] [decimal](18, 2) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.DentalInsuranceCobraHistory] PRIMARY KEY CLUSTERED 
(
	[DentalInsuranceCobraHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[DepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentName] [varchar](50) NOT NULL,
	[DepartmentDescription] [varchar](200) NULL,
	[USECFSEAssignment] [bit] NOT NULL,
	[CFSECodeId] [int] NULL,
	[CFSECompanyPercent] [decimal](18, 5) NULL,
	[JobCertificationSigneeId] [int] NULL,
	[JobCertificationTemplateId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Department] PRIMARY KEY CLUSTERED 
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DependentStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DependentStatus](
	[DependentStatusId] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [nvarchar](500) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.DependentStatus] PRIMARY KEY CLUSTERED 
(
	[DependentStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DEPENDIENTES$]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DEPENDIENTES$](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[FIRST NAME] [nvarchar](255) NULL,
	[LAST NAME] [nvarchar](255) NULL,
	[MIDDLE NAME] [nvarchar](255) NULL,
	[SOCIAL SECURITY NUM] [nvarchar](255) NULL,
	[BIRTH DATE] [nvarchar](255) NULL,
	[GENDER] [nvarchar](255) NULL,
	[RELATIONSHIP] [nvarchar](255) NULL,
	[STATUS] [nvarchar](255) NULL,
	[FULL TIME STUDENT YES/NO] [nvarchar](255) NULL,
	[SCHOOL ATTENDING] [nvarchar](255) NULL,
	[HEALTH INSURANCE] [nvarchar](255) NULL,
	[DENTAL INSURANCE] [nvarchar](255) NULL,
	[TAX PURPOSES] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Disability]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Disability](
	[DisabilityId] [int] IDENTITY(1,1) NOT NULL,
	[DisabilityName] [nvarchar](500) NOT NULL,
	[DisabilityDescription] [nvarchar](1000) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Disability] PRIMARY KEY CLUSTERED 
(
	[DisabilityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Document]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Document](
	[DocumentId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentName] [nvarchar](500) NOT NULL,
	[DocumentDescription] [nvarchar](1000) NULL,
	[IsExpirable] [bit] NOT NULL,
	[NotificationScheduleId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[DocumentRequiredById] [int] NULL,
	[SelfServiceDisplay] [bit] NOT NULL,
	[SelfServiceUpload] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Document] PRIMARY KEY CLUSTERED 
(
	[DocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].['DOCUMENT LIST$']    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['DOCUMENT LIST$'](
	[ID] [nvarchar](255) NULL,
	[NAME] [nvarchar](255) NULL,
	[DESCRIPTION] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DocumentRequiredBy]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DocumentRequiredBy](
	[DocumentRequiredById] [int] IDENTITY(1,1) NOT NULL,
	[DocumentRequiredByName] [nvarchar](max) NOT NULL,
	[DocumentRequiredByDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.DocumentRequiredBy] PRIMARY KEY CLUSTERED 
(
	[DocumentRequiredById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EDUCATION$]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EDUCATION$](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[EDUCATION LEVEL] [nvarchar](255) NULL,
	[TITLE NAME] [nvarchar](255) NULL,
	[INSTITUTION NAME] [nvarchar](255) NULL,
	[GRAD DATE] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].['EEO CATEGORIES$']    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['EEO CATEGORIES$'](
	[ID] [float] NULL,
	[NUMBER] [float] NULL,
	[CATEGORY] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EEOCategory]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EEOCategory](
	[EEOCategoryId] [int] IDENTITY(1,1) NOT NULL,
	[EEONumber] [nvarchar](5) NOT NULL,
	[EEOCategoryName] [nvarchar](50) NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CompanyId] [int] NULL,
 CONSTRAINT [PK_dbo.EEOCategory] PRIMARY KEY CLUSTERED 
(
	[EEOCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmailBlast]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailBlast](
	[EmailBlastId] [int] IDENTITY(1,1) NOT NULL,
	[EmailTemplateId] [int] NOT NULL,
	[IsSavedAsDraft] [bit] NULL,
	[ClientId] [int] NULL,
	[CompanyId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmailBlast] PRIMARY KEY CLUSTERED 
(
	[EmailBlastId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmailBlastDetail]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailBlastDetail](
	[EmailBlastDetailId] [int] IDENTITY(1,1) NOT NULL,
	[EmailBlastId] [int] NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[SentDate] [datetime] NULL,
	[ClientId] [int] NULL,
	[CompanyId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_EmailBlastDetail] PRIMARY KEY CLUSTERED 
(
	[EmailBlastDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmailTemplate]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailTemplate](
	[EmailTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[EmailSubject] [nvarchar](50) NOT NULL,
	[EmailBody] [nvarchar](max) NULL,
	[EmailTypeId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmailTemplate] PRIMARY KEY CLUSTERED 
(
	[EmailTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmailType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailType](
	[EmailTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EmailTypeName] [nvarchar](1000) NULL,
	[EmailTypeDescription] [nvarchar](1000) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmailType] PRIMARY KEY CLUSTERED 
(
	[EmailTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmergencyContact]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmergencyContact](
	[EmergencyContactId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NULL,
	[RelationshipId] [int] NULL,
	[ContactPersonName] [nvarchar](50) NULL,
	[IsDefault] [bit] NOT NULL,
	[MainNumber] [nvarchar](20) NULL,
	[AlternateNumber] [nvarchar](20) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmergencyContact] PRIMARY KEY CLUSTERED 
(
	[EmergencyContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeAccrualBalance]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAccrualBalance](
	[EmployeeAccrualBalanceId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualTypeId] [int] NOT NULL,
	[AccruedHours] [decimal](18, 5) NULL,
	[BalanceStartDate] [datetime] NOT NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAccrualBalance] PRIMARY KEY CLUSTERED 
(
	[EmployeeAccrualBalanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeAccrualRule]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAccrualRule](
	[EmployeeAccrualRuleId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualTypeId] [int] NOT NULL,
	[AccrualRuleId] [int] NULL,
	[AccrualDailyHours] [decimal](18, 5) NULL,
	[StartOfRuleDate] [datetime] NOT NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAccrualRule] PRIMARY KEY CLUSTERED 
(
	[EmployeeAccrualRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeAction]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAction](
	[EmployeeActionId] [int] IDENTITY(1,1) NOT NULL,
	[ApprovedById] [int] NULL,
	[ActionTypeId] [int] NULL,
	[ActionDate] [datetime] NOT NULL,
	[ActionEndDate] [datetime] NULL,
	[ActionName] [nvarchar](max) NULL,
	[ActionDescription] [nvarchar](max) NULL,
	[ActionNotes] [nvarchar](max) NULL,
	[ActionExpiryDate] [datetime] NULL,
	[ActionClosingInfo] [nvarchar](max) NULL,
	[ActionApprovedDate] [datetime] NULL,
	[DocName] [nvarchar](max) NULL,
	[DocFilePath] [nvarchar](max) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAction] PRIMARY KEY CLUSTERED 
(
	[EmployeeActionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeAppraisal]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAppraisal](
	[EmployeeAppraisalId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[SubDepartmentId] [int] NULL,
	[EmployeeTypeId] [int] NULL,
	[AppraisalTemplateId] [int] NOT NULL,
	[AppraisalReviewDate] [datetime] NULL,
	[AppraisalDueDate] [datetime] NULL,
	[EvaluationStartDate] [datetime] NULL,
	[EvaluationEndDate] [datetime] NULL,
	[NextAppraisalDueDate] [datetime] NULL,
	[AppraisalResultId] [int] NULL,
	[AppraisalOverallScore] [decimal](18, 2) NULL,
	[AppraisalTotalMaxValue] [decimal](18, 2) NULL,
	[AppraisalOverallPct] [decimal](18, 2) NULL,
	[AppraisalReviewerComments] [nvarchar](max) NULL,
	[AppraisalEmployeeComments] [nvarchar](max) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAppraisal] PRIMARY KEY CLUSTERED 
(
	[EmployeeAppraisalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeAppraisalDocument]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAppraisalDocument](
	[EmployeeAppraisalDocumentId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeAppraisalId] [int] NOT NULL,
	[AppraisalDocumentName] [nvarchar](max) NULL,
	[DocumentFileName] [nvarchar](max) NULL,
	[DocumentFilePath] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAppraisalDocument] PRIMARY KEY CLUSTERED 
(
	[EmployeeAppraisalDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeAppraisalGoal]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAppraisalGoal](
	[EmployeeAppraisalGoalId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeAppraisalId] [int] NOT NULL,
	[AppraisalGoalId] [int] NOT NULL,
	[AppraisalRatingScaleDetailId] [int] NOT NULL,
	[GoalRatingName] [nvarchar](max) NULL,
	[GoalRatingValue] [decimal](18, 2) NOT NULL,
	[GoalScaleMaxValue] [decimal](18, 2) NOT NULL,
	[ReviewerComments] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAppraisalGoal] PRIMARY KEY CLUSTERED 
(
	[EmployeeAppraisalGoalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeAppraisalSkill]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeAppraisalSkill](
	[EmployeeAppraisalSkillId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeAppraisalId] [int] NOT NULL,
	[AppraisalSkillId] [int] NOT NULL,
	[AppraisalRatingScaleDetailId] [int] NOT NULL,
	[SkillRatingName] [nvarchar](max) NULL,
	[SkillRatingValue] [decimal](18, 2) NOT NULL,
	[SkillScaleMaxValue] [decimal](18, 2) NOT NULL,
	[ReviewerComments] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeAppraisalSkill] PRIMARY KEY CLUSTERED 
(
	[EmployeeAppraisalSkillId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeBenefitEnlisted]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeBenefitEnlisted](
	[EmployeeBenefitEnlistedId] [int] IDENTITY(1,1) NOT NULL,
	[BenefitId] [int] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeBenefitEnlisted] PRIMARY KEY CLUSTERED 
(
	[EmployeeBenefitEnlistedId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeBenefitHistory]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeBenefitHistory](
	[EmployeeBenefitHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NULL,
	[Amount] [decimal](18, 2) NULL,
	[BenefitId] [int] NULL,
	[PayFrequencyId] [int] NULL,
	[ExpiryDate] [datetime] NULL,
	[Notes] [nvarchar](max) NULL,
	[EmployeeContribution] [decimal](18, 2) NULL,
	[CompanyContribution] [decimal](18, 2) NULL,
	[OtherContribution] [decimal](18, 2) NULL,
	[TotalContribution] [decimal](18, 2) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeBenefitHistory] PRIMARY KEY CLUSTERED 
(
	[EmployeeBenefitHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeChangeRequest]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeChangeRequest](
	[EmployeeChangeRequestId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NULL,
	[InterfaceControlFormId] [int] NULL,
	[OldValue] [varchar](max) NULL,
	[NewValue] [varchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeCompanyTransfer]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCompanyTransfer](
	[EmployeeCompanyTransferId] [int] IDENTITY(1,1) NOT NULL,
	[FromUserInformationId] [int] NOT NULL,
	[FromCompanyId] [int] NOT NULL,
	[ToUserInformationId] [int] NOT NULL,
	[ToCompanyId] [int] NOT NULL,
	[TransferDate] [datetime] NOT NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeCompanyTransfer] PRIMARY KEY CLUSTERED 
(
	[EmployeeCompanyTransferId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeCompensation]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCompensation](
	[EmployeeCompensationId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyCompensationId] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[MoneyAmount] [decimal](16, 2) NOT NULL,
	[GLAccountId] [int] NULL,
	[PeriodEntryId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[UserInformationId] [int] NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_EmployeeCompensation] PRIMARY KEY CLUSTERED 
(
	[EmployeeCompensationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeCompensationPreviousHistory]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCompensationPreviousHistory](
	[EmployeeCompensationPreviousHistoryId] [int] NOT NULL,
	[PayDate] [datetime] NOT NULL,
	[PeriodWages] [decimal](18, 5) NOT NULL,
	[PeriodComissions] [decimal](18, 5) NOT NULL,
	[PeriodHours] [decimal](18, 2) NOT NULL,
	[UserInformationId] [int] NULL,
 CONSTRAINT [PK_tblUserCompensationsHistor] PRIMARY KEY CLUSTERED 
(
	[EmployeeCompensationPreviousHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeContribution]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeContribution](
	[EmployeeContributionId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyContributionId] [int] NOT NULL,
	[Enabled] [bit] NOT NULL,
	[MoneyAmount] [decimal](16, 2) NOT NULL,
	[GLContributionAccountId] [int] NULL,
	[GLContributionPayableAccountId] [int] NULL,
	[PeriodEntryId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[UserInformationId] [int] NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_EmployeeContribution] PRIMARY KEY CLUSTERED 
(
	[EmployeeContributionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeCredential]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCredential](
	[EmployeeCredentialId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeCredentialName] [nvarchar](max) NULL,
	[EmployeeCredentialDescription] [nvarchar](200) NULL,
	[IssueDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NULL,
	[Note] [nvarchar](200) NULL,
	[DocumentName] [nvarchar](500) NULL,
	[DocumentPath] [nvarchar](500) NULL,
	[DocumentFile] [image] NULL,
	[CredentialId] [int] NOT NULL,
	[ExpirationDateRequired] [int] NULL,
	[IsRequired] [bit] NOT NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CredentialTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeCredential] PRIMARY KEY CLUSTERED 
(
	[EmployeeCredentialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeCustomField]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeCustomField](
	[EmployeeCustomFieldId] [int] IDENTITY(1,1) NOT NULL,
	[CustomFieldId] [int] NOT NULL,
	[CustomFieldValue] [nvarchar](500) NULL,
	[CustomFieldNote] [nvarchar](250) NULL,
	[ExpirationDate] [datetime] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[ReturnDate] [date] NULL,
	[IssuanceDate] [date] NULL,
 CONSTRAINT [PK_dbo.EmployeeCustomField] PRIMARY KEY CLUSTERED 
(
	[EmployeeCustomFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeDentalInsurance]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeDentalInsurance](
	[EmployeeDentalInsuranceId] [int] IDENTITY(1,1) NOT NULL,
	[IsEnlisted] [bit] NULL,
	[GroupId] [nvarchar](max) NULL,
	[InsuranceCoverageId] [int] NULL,
	[InsuranceTypeId] [int] NULL,
	[InsuranceStatusId] [int] NULL,
	[InsuranceStartDate] [datetime] NULL,
	[InsuranceExpiryDate] [datetime] NULL,
	[CobraStatusId] [int] NULL,
	[LeyCobraStartDate] [datetime] NULL,
	[LeyCobraExpiryDate] [datetime] NULL,
	[EmployeeContribution] [decimal](18, 2) NOT NULL,
	[CompanyContribution] [decimal](18, 2) NOT NULL,
	[OtherContribution] [decimal](18, 2) NOT NULL,
	[TotalContribution] [decimal](18, 2) NOT NULL,
	[PCORIFee] [decimal](18, 2) NOT NULL,
	[InsurancePremium] [decimal](18, 2) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeDentalInsurance] PRIMARY KEY CLUSTERED 
(
	[EmployeeDentalInsuranceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeDependent]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeDependent](
	[EmployeeDependentId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](max) NOT NULL,
	[LastName] [nvarchar](max) NULL,
	[BirthDate] [datetime] NULL,
	[SSN] [nvarchar](max) NULL,
	[DependentStatusId] [int] NULL,
	[GenderId] [int] NULL,
	[RelationshipId] [int] NULL,
	[ExpiryDate] [datetime] NULL,
	[IsHealthInsurance] [bit] NOT NULL,
	[IsDentalInsurance] [bit] NOT NULL,
	[IsTaxPurposes] [bit] NOT NULL,
	[IsFullTimeStudent] [bit] NOT NULL,
	[SchoolAttending] [nvarchar](max) NULL,
	[DocName] [nvarchar](max) NULL,
	[DocFilePath] [nvarchar](max) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeDependent] PRIMARY KEY CLUSTERED 
(
	[EmployeeDependentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeDocument]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeDocument](
	[EmployeeDocumentId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentId] [int] NOT NULL,
	[DocumentName] [nvarchar](250) NULL,
	[DocumentPath] [nvarchar](250) NULL,
	[DocumentNote] [nvarchar](250) NULL,
	[ExpirationDate] [datetime] NULL,
	[UserInformationId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[SubmissionDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.EmployeeDocument] PRIMARY KEY CLUSTERED 
(
	[EmployeeDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeEducation]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeEducation](
	[EmployeeEducationId] [int] IDENTITY(1,1) NOT NULL,
	[InstitutionName] [nvarchar](max) NOT NULL,
	[Title] [nvarchar](max) NULL,
	[Note] [nvarchar](max) NULL,
	[DateCompleted] [datetime] NOT NULL,
	[DocName] [nvarchar](max) NULL,
	[DocFilePath] [nvarchar](max) NULL,
	[DegreeId] [int] NOT NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeEducation] PRIMARY KEY CLUSTERED 
(
	[EmployeeEducationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeEmployeeGroup]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeEmployeeGroup](
	[EmployeeEmployeeGroupId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeGroupId] [int] NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_EmployeeEmployeeGroup] PRIMARY KEY CLUSTERED 
(
	[EmployeeEmployeeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeFutureSchedule]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeFutureSchedule](
	[EmployeeFutureScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NULL,
	[StartDate] [datetime] NULL,
	[BaseScheduleId] [int] NULL,
	[Note] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeFutureSchedule] PRIMARY KEY CLUSTERED 
(
	[EmployeeFutureScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeGroup]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeGroup](
	[EmployeeGroupId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeGroupName] [nvarchar](150) NOT NULL,
	[EmployeeGroupDescription] [nvarchar](150) NULL,
	[EmployeeGroupTypeId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeGroup] PRIMARY KEY CLUSTERED 
(
	[EmployeeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeGroupType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeGroupType](
	[EmployeeGroupTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeGroupTypeName] [nvarchar](150) NOT NULL,
	[EmployeeGroupTypeDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CompanyId] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeGroupType] PRIMARY KEY CLUSTERED 
(
	[EmployeeGroupTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeHealthInsurance]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeHealthInsurance](
	[EmployeeHealthInsuranceId] [int] IDENTITY(1,1) NOT NULL,
	[IsEnlisted] [bit] NULL,
	[GroupId] [nvarchar](max) NULL,
	[InsuranceCoverageId] [int] NULL,
	[InsuranceTypeId] [int] NULL,
	[InsuranceStatusId] [int] NULL,
	[InsuranceStartDate] [datetime] NULL,
	[InsuranceExpiryDate] [datetime] NULL,
	[CobraStatusId] [int] NULL,
	[LeyCobraStartDate] [datetime] NULL,
	[LeyCobraExpiryDate] [datetime] NULL,
	[EmployeeContribution] [decimal](18, 2) NOT NULL,
	[CompanyContribution] [decimal](18, 2) NOT NULL,
	[OtherContribution] [decimal](18, 2) NOT NULL,
	[TotalContribution] [decimal](18, 2) NOT NULL,
	[PCORIFee] [decimal](18, 2) NOT NULL,
	[InsurancePremium] [decimal](18, 2) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeHealthInsurance] PRIMARY KEY CLUSTERED 
(
	[EmployeeHealthInsuranceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeIncident]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeIncident](
	[EmployeeIncidentId] [int] IDENTITY(1,1) NOT NULL,
	[IncidentTypeId] [int] NULL,
	[LocationId] [int] NULL,
	[IncidentAreaId] [int] NULL,
	[OSHACaseClassificationId] [int] NULL,
	[OSHAInjuryClassificationId] [int] NULL,
	[IncidentBodyPartId] [int] NULL,
	[IncidentInjuryDescriptionId] [int] NULL,
	[IncidentInjurySourceId] [int] NULL,
	[IncidentTreatmentFacilityId] [int] NULL,
	[IsOSHARecordable] [bit] NOT NULL,
	[IncidentDate] [datetime] NULL,
	[IncidentTime] [datetime] NULL,
	[EmployeeBeganWorkTime] [datetime] NULL,
	[RestrictedFromWorkDays] [int] NULL,
	[AwayFromWorkDays] [int] NULL,
	[EmployeeDoingBeforeIncident] [nvarchar](max) NULL,
	[HowIncidentOccured] [nvarchar](max) NULL,
	[DateOfDeath] [datetime] NULL,
	[PhysicianName] [nvarchar](max) NULL,
	[IsTreatedInEmergencyRoom] [bit] NOT NULL,
	[IsHospitalizedOvernight] [bit] NOT NULL,
	[HospitalizedDays] [int] NULL,
	[CompletedById] [int] NULL,
	[CompletedDate] [datetime] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeIncident] PRIMARY KEY CLUSTERED 
(
	[EmployeeIncidentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeNotification]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeNotification](
	[EmployeeNotificationId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeNotificationName] [nvarchar](150) NOT NULL,
	[EmployeeNotificationDescription] [nvarchar](150) NULL,
	[EmployeeNotificationTypeId] [int] NOT NULL,
	[NotificationScheduleId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeNotification] PRIMARY KEY CLUSTERED 
(
	[EmployeeNotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeNotificationType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeNotificationType](
	[EmployeeNotificationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeNotificationTypeName] [nvarchar](150) NOT NULL,
	[EmployeeNotificationTypeDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CompanyId] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeNotificationType] PRIMARY KEY CLUSTERED 
(
	[EmployeeNotificationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePayAccount]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePayAccount](
	[EmployeePayAccountId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NULL,
	[Name] [nvarchar](50) NULL,
	[PayBankId] [int] NULL,
	[BankAccountTypeId] [int] NULL,
	[AccountNumber] [nvarchar](25) NULL,
	[DepositPct] [decimal](18, 2) NULL,
	[DepositAmt] [decimal](18, 2) NULL,
	[IsPrimary] [bit] NULL,
	[PayType] [nvarchar](2) NULL,
	[EndDate] [datetime] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePayAccount] PRIMARY KEY CLUSTERED 
(
	[EmployeePayAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePayroll]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePayroll](
	[EmployeePayrollId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [int] NULL,
	[UserInformationId] [int] NULL,
	[PayWeekNumber] [int] NULL,
	[EmployeePayrollStatusId] [int] NULL,
	[PayrollStartDate] [datetime] NULL,
	[PayrollEndDate] [datetime] NULL,
	[PayMethodTypeId] [int] NULL,
	[CompanyId] [int] NULL,
	[DepartmentId] [int] NULL,
	[SubDepartmentId] [int] NULL,
	[PositionId] [int] NULL,
	[EmploymentTypeId] [int] NULL,
	[EmployeeTypeId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePayroll] PRIMARY KEY CLUSTERED 
(
	[EmployeePayrollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePayrollCheck]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePayrollCheck](
	[EmployeePayrollCheckId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [int] NULL,
	[UserInformationId] [int] NULL,
	[PayDate] [datetime] NULL,
	[CheckNumber] [int] NULL,
	[CheckAmount] [decimal](18, 5) NULL,
	[PayMethodTypeId] [int] NULL,
	[EmployeePayAccountId] [int] NULL,
	[PayBankId] [int] NULL,
	[BankAccountTypeId] [int] NULL,
	[AccountNumber] [nvarchar](25) NULL,
	[DepositPct] [decimal](18, 2) NULL,
	[DepositAmt] [decimal](18, 2) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePayCheck] PRIMARY KEY CLUSTERED 
(
	[EmployeePayrollCheckId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePayrollCompensation]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePayrollCompensation](
	[EmployeePayrollCompensationId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [int] NULL,
	[UserInformationId] [int] NULL,
	[CompanyCompensationId] [int] NULL,
	[PayDate] [datetime] NULL,
	[Hours] [float] NULL,
	[PayRate] [decimal](18, 5) NULL,
	[PayAmount] [decimal](18, 5) NULL,
	[GLAccountId] [int] NULL,
	[PayrollEditTypeId] [int] NULL,
	[EmployeePayrollCompensationEditId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePayrollCompensation] PRIMARY KEY CLUSTERED 
(
	[EmployeePayrollCompensationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePayrollCompensationManual]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePayrollCompensationManual](
	[EmployeePayrollCompensationManualId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [int] NULL,
	[UserInformationId] [int] NULL,
	[CompanyCompensationId] [int] NULL,
	[PayDate] [datetime] NULL,
	[Hours] [float] NULL,
	[PayRate] [decimal](18, 5) NULL,
	[PayAmount] [decimal](18, 5) NULL,
	[GLAccountId] [int] NULL,
	[PayrollEditTypeId] [int] NULL,
	[ClientId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePayrollCompensationManual] PRIMARY KEY CLUSTERED 
(
	[EmployeePayrollCompensationManualId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePayrollContribution]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePayrollContribution](
	[EmployeePayrollContributionId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [int] NULL,
	[UserInformationId] [int] NULL,
	[CompanyContributionId] [int] NULL,
	[PayDate] [datetime] NULL,
	[EffectivePayAmount] [decimal](18, 2) NULL,
	[WithholdingAmount] [decimal](18, 5) NULL,
	[WitholdingPrePostTypeId] [int] NULL,
	[GLAccountId] [int] NULL,
	[GLContributionPayableId] [int] NULL,
	[PayrollEditTypeId] [int] NULL,
	[EmployeePayrollContributionEditId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePayrollContribution] PRIMARY KEY CLUSTERED 
(
	[EmployeePayrollContributionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePayrollContributionManual]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePayrollContributionManual](
	[EmployeePayrollContributionManualId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [int] NULL,
	[UserInformationId] [int] NULL,
	[CompanyContributionId] [int] NULL,
	[PayDate] [datetime] NULL,
	[EffectivePayAmount] [decimal](18, 2) NULL,
	[WithholdingAmount] [decimal](18, 5) NULL,
	[WitholdingPrePostTypeId] [int] NULL,
	[GLAccountId] [int] NULL,
	[GLContributionPayableId] [int] NULL,
	[PayrollEditTypeId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePayrollContributionManual] PRIMARY KEY CLUSTERED 
(
	[EmployeePayrollContributionManualId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePayrollStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePayrollStatus](
	[EmployeePayrollStatusId] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePayrollStatus] PRIMARY KEY CLUSTERED 
(
	[EmployeePayrollStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePayrollTransaction]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePayrollTransaction](
	[EmployeePayrollTransactionId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [int] NULL,
	[UserInformationId] [int] NULL,
	[PunchDate] [datetime] NULL,
	[TransactionId] [int] NULL,
	[Hours] [float] NULL,
	[MoneyValue] [decimal](18, 5) NULL,
	[PayRate] [decimal](18, 5) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePayrollTransaction] PRIMARY KEY CLUSTERED 
(
	[EmployeePayrollTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePayrollWithholding]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePayrollWithholding](
	[EmployeePayrollWithholdingId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [int] NULL,
	[UserInformationId] [int] NULL,
	[CompanyWithholdingId] [int] NULL,
	[PayDate] [datetime] NULL,
	[EffectivePayAmount] [decimal](18, 2) NULL,
	[WithholdingAmount] [decimal](18, 5) NULL,
	[WitholdingPrePostTypeId] [int] NULL,
	[GLAccountId] [int] NULL,
	[PayrollEditTypeId] [int] NULL,
	[EmployeePayrollWithholdingEditId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePayrollWithholding] PRIMARY KEY CLUSTERED 
(
	[EmployeePayrollWithholdingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePayrollWithholdingManual]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePayrollWithholdingManual](
	[EmployeePayrollWithholdingManualId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollId] [int] NULL,
	[UserInformationId] [int] NULL,
	[CompanyWithholdingId] [int] NULL,
	[PayDate] [datetime] NULL,
	[EffectivePayAmount] [decimal](18, 2) NULL,
	[WithholdingAmount] [decimal](18, 5) NULL,
	[WitholdingPrePostTypeId] [int] NULL,
	[GLAccountId] [int] NULL,
	[PayrollEditTypeId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePayrollWithholdingManual] PRIMARY KEY CLUSTERED 
(
	[EmployeePayrollWithholdingManualId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeePerformance]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeePerformance](
	[EmployeePerformanceId] [int] IDENTITY(1,1) NOT NULL,
	[SupervisorId] [int] NULL,
	[ActionTakenId] [int] NULL,
	[PerformanceDescriptionId] [int] NULL,
	[PerformanceResultId] [int] NULL,
	[ReviewDate] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[ReviewSummary] [nvarchar](max) NULL,
	[ReviewNote] [nvarchar](max) NULL,
	[DocName] [nvarchar](max) NULL,
	[DocFilePath] [nvarchar](max) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeePerformance] PRIMARY KEY CLUSTERED 
(
	[EmployeePerformanceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeRotatingSchedule]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeRotatingSchedule](
	[EmployeeRotatingScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NULL,
	[BaseScheduleId] [int] NULL,
	[Note] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeRotatingSchedule] PRIMARY KEY CLUSTERED 
(
	[EmployeeRotatingScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeStatus](
	[EmployeeStatusId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeStatusName] [nvarchar](500) NOT NULL,
	[EmployeeStatusDescription] [nvarchar](1000) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeStatus] PRIMARY KEY CLUSTERED 
(
	[EmployeeStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeSupervisor]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeSupervisor](
	[EmployeeSupervisorId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeUserId] [int] NOT NULL,
	[SupervisorUserId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeSupervisor] PRIMARY KEY CLUSTERED 
(
	[EmployeeSupervisorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeTimeAndAttendanceSetting]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeTimeAndAttendanceSetting](
	[EmployeeTimeAndAttendanceSettingId] [int] IDENTITY(1,1) NOT NULL,
	[EnableWebPunch] [bit] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[UserInformationId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.EmployeeTimeAndAttendanceSetting] PRIMARY KEY CLUSTERED 
(
	[EmployeeTimeAndAttendanceSettingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeTimeOffRequest]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeTimeOffRequest](
	[EmployeeTimeOffRequestId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualType] [nvarchar](max) NULL,
	[TransType] [nvarchar](max) NULL,
	[IsSingleDay] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[DayHours] [decimal](18, 2) NULL,
	[WorkingDays] [decimal](18, 2) NULL,
	[RequestNote] [nvarchar](max) NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeTimeOffRequest] PRIMARY KEY CLUSTERED 
(
	[EmployeeTimeOffRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeTimeOffRequest_202211117]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeTimeOffRequest_202211117](
	[EmployeeTimeOffRequestId] [int] IDENTITY(1,1) NOT NULL,
	[AccrualType] [nvarchar](max) NULL,
	[TransType] [nvarchar](max) NULL,
	[IsSingleDay] [bit] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[DayHours] [decimal](18, 2) NULL,
	[WorkingDays] [decimal](18, 2) NULL,
	[RequestNote] [nvarchar](max) NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeTimeOffRequestDocument]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeTimeOffRequestDocument](
	[EmployeeTimeOffRequestDocumentId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeTimeOffRequestId] [int] NULL,
	[DocumentName] [nvarchar](50) NULL,
	[DocumentType] [nvarchar](25) NULL,
	[SubmissionType] [nvarchar](25) NULL,
	[Status] [nvarchar](10) NULL,
	[DocumentFile1] [varbinary](max) NULL,
	[DocumentFile1Name] [nvarchar](50) NULL,
	[DocumentFile1Ext] [nvarchar](5) NULL,
	[DocumentFile2] [varbinary](max) NULL,
	[DocumentFile2Name] [nvarchar](50) NULL,
	[DocumentFile2Ext] [nvarchar](5) NULL,
	[DocumentFile3] [varbinary](max) NULL,
	[DocumentFile3Name] [nvarchar](50) NULL,
	[DocumentFile3Ext] [nvarchar](5) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[TimeoffDays] [int] NULL,
 CONSTRAINT [PK_EmployeeTimeOffRequestDocument] PRIMARY KEY CLUSTERED 
(
	[EmployeeTimeOffRequestDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeTraining]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeTraining](
	[EmployeeTrainingId] [int] IDENTITY(1,1) NOT NULL,
	[TrainingId] [int] NOT NULL,
	[Type] [nvarchar](max) NULL,
	[TrainingDate] [datetime] NOT NULL,
	[ExpiryDate] [datetime] NULL,
	[Note] [nvarchar](max) NULL,
	[DocName] [nvarchar](max) NULL,
	[DocFilePath] [nvarchar](max) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[TrainingTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeTraining] PRIMARY KEY CLUSTERED 
(
	[EmployeeTrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeType](
	[EmployeeTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeTypeName] [nvarchar](150) NOT NULL,
	[EmployeeTypeDescription] [nvarchar](150) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeType] PRIMARY KEY CLUSTERED 
(
	[EmployeeTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeVeteranStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeVeteranStatus](
	[EmployeeVeteranStatusId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[VeteranStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeVeteranStatus] PRIMARY KEY CLUSTERED 
(
	[EmployeeVeteranStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeWebScheduledPeriod]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeWebScheduledPeriod](
	[EmployeeWebScheduledPeriodId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NULL,
	[EmployeeWebTimeSheetId] [int] NULL,
	[Note] [nvarchar](200) NULL,
	[PeriodStartDate] [datetime] NULL,
	[PeriodEndDate] [datetime] NULL,
	[PeriodHours] [float] NULL,
	[PayFrequencyId] [int] NULL,
	[PayWeekNumber] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeWebScheduledPeriod] PRIMARY KEY CLUSTERED 
(
	[EmployeeWebScheduledPeriodId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeWebScheduledPeriodDetail]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeWebScheduledPeriodDetail](
	[EmployeeWebScheduledPeriodDetailId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeWebScheduledPeriodId] [int] NULL,
	[UserInformationId] [int] NULL,
	[Note] [nvarchar](200) NULL,
	[NoOfPunch] [int] NULL,
	[PunchDate] [datetime] NULL,
	[TimeIn1] [datetime] NULL,
	[TimeOut1] [datetime] NULL,
	[TimeIn2] [datetime] NULL,
	[TimeOut2] [datetime] NULL,
	[WorkDayTypeId] [int] NULL,
	[DayHours] [float] NULL,
	[PayWeekNumber] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeWebScheduledPeriodDetail] PRIMARY KEY CLUSTERED 
(
	[EmployeeWebScheduledPeriodDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeWebTimeSheet]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeWebTimeSheet](
	[EmployeeWebTimeSheetId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NULL,
	[PayWeekNumber] [int] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[RegularHours] [float] NULL,
	[MealHours] [float] NULL,
	[SingleOTHours] [float] NULL,
	[DoubleOTHours] [float] NULL,
	[OtherHours] [float] NULL,
	[HoursSummary] [nvarchar](250) NULL,
	[PayFrequencyId] [int] NULL,
	[ReviewStatusId] [int] NULL,
	[ReviewSupervisorId] [int] NULL,
	[IsLocked] [bit] NULL,
	[BaseScheduleId] [int] NULL,
	[EmployeeTypeId] [int] NULL,
	[DepartmentId] [int] NULL,
	[SubDepartmentId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmployeeWebTimeSheet] PRIMARY KEY CLUSTERED 
(
	[EmployeeWebTimeSheetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmployeeWithholding]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeWithholding](
	[EmployeeWithholdingId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[EmployeeWithholdingPercentage] [decimal](18, 5) NOT NULL,
	[EmployeeWithholdingAmount] [decimal](18, 5) NOT NULL,
	[CompanyWithholdingPercent] [decimal](18, 5) NOT NULL,
	[CompanyWithholdingAmount] [decimal](18, 5) NOT NULL,
	[MaximumSalaryLimit] [decimal](18, 5) NOT NULL,
	[MinimumSalaryLimit] [decimal](18, 5) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[GLAccountId] [int] NOT NULL,
	[GLLookupFieldId] [int] NOT NULL,
	[ClassIdentifier] [nvarchar](50) NULL,
	[Apply401kPlan] [bit] NOT NULL,
	[PeriodEntryId] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CompanyWithholdingId] [int] NULL,
	[WitholdingPrePostTypeId] [int] NULL,
	[WitholdingComputationTypeId] [int] NULL,
	[WithholdingTaxTypeId] [int] NULL,
	[intReportOrder] [int] NULL,
	[Enabled] [bit] NULL,
	[MoneyAmount] [decimal](18, 5) NULL,
	[LoanAmount] [decimal](18, 5) NULL,
	[RemainingBalance] [int] NULL,
	[LoanNumber] [int] NULL,
 CONSTRAINT [PK_EmployeeWithholding] PRIMARY KEY CLUSTERED 
(
	[EmployeeWithholdingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Employment]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employment](
	[EmploymentId] [int] IDENTITY(1,1) NOT NULL,
	[OriginalHireDate] [datetime] NOT NULL,
	[EffectiveHireDate] [datetime] NOT NULL,
	[ProbationStartDate] [datetime] NULL,
	[ProbationEndDate] [datetime] NULL,
	[EmploymentStatusId] [int] NULL,
	[TerminationDate] [datetime] NULL,
	[TerminationTypeId] [int] NULL,
	[TerminationReasonId] [int] NULL,
	[DocumentName] [nvarchar](500) NULL,
	[DocumentPath] [nvarchar](500) NULL,
	[TerminationEligibilityId] [int] NULL,
	[UseHireDateforYearsInService] [bit] NOT NULL,
	[TerminationNotes] [nvarchar](500) NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[IsExitInterview] [bit] NULL,
	[ExitInterviewDocName] [nvarchar](500) NULL,
	[ExitInterviewDocPath] [nvarchar](500) NULL,
 CONSTRAINT [PK_dbo.Employment] PRIMARY KEY CLUSTERED 
(
	[EmploymentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EMPLOYMENT$]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLOYMENT$](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[COMPANY] [nvarchar](255) NULL,
	[DEPARTMENT] [nvarchar](255) NULL,
	[SUBDEPARTMENT] [nvarchar](255) NULL,
	[POSITION] [nvarchar](255) NULL,
	[LOCATION] [nvarchar](255) NULL,
	[ID SUPERVISOR] [float] NULL,
	[NAME SUPERVISOR] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EMPLOYMENT$_xlnm#_FilterDatabase]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EMPLOYMENT$_xlnm#_FilterDatabase](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[COMPANY] [nvarchar](255) NULL,
	[DEPARTMENT] [nvarchar](255) NULL,
	[SUBDEPARTMENT] [nvarchar](255) NULL,
	[POSITION] [nvarchar](255) NULL,
	[LOCATION] [nvarchar](255) NULL,
	[ID SUPERVISOR] [float] NULL,
	[NAME SUPERVISOR] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmploymentHistory]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmploymentHistory](
	[EmploymentHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[PositionId] [int] NULL,
	[EmployeeTypeId] [int] NULL,
	[EmploymentTypeId] [int] NULL,
	[ChangeReason] [varchar](200) NULL,
	[LocationId] [int] NULL,
	[DepartmentId] [int] NOT NULL,
	[SubDepartmentId] [int] NULL,
	[CompanyId] [int] NOT NULL,
	[SupervisorId] [int] NULL,
	[ApprovedDate] [datetime] NULL,
	[EmploymentId] [int] NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[UserInformation_Id] [int] NULL,
	[ClosedBy] [int] NULL,
 CONSTRAINT [PK_dbo.EmploymentHistory] PRIMARY KEY CLUSTERED 
(
	[EmploymentHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_StartDate] UNIQUE NONCLUSTERED 
(
	[UserInformationId] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmploymentHistoryAuthorizer]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmploymentHistoryAuthorizer](
	[EmploymentHistoryAuthorizerId] [int] IDENTITY(1,1) NOT NULL,
	[AuthorizeById] [int] NULL,
	[EmploymentHistoryId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmploymentHistoryAuthorizer] PRIMARY KEY CLUSTERED 
(
	[EmploymentHistoryAuthorizerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmploymentStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmploymentStatus](
	[EmploymentStatusId] [int] IDENTITY(1,1) NOT NULL,
	[EmploymentStatusName] [varchar](50) NOT NULL,
	[EmploymentStatusDescription] [varchar](200) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmploymentStatus] PRIMARY KEY CLUSTERED 
(
	[EmploymentStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EmploymentType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmploymentType](
	[EmploymentTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EmploymentTypeName] [nvarchar](150) NOT NULL,
	[EmploymentTypeDescription] [nvarchar](150) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.EmploymentType] PRIMARY KEY CLUSTERED 
(
	[EmploymentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ethnicity]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ethnicity](
	[EthnicityId] [int] IDENTITY(1,1) NOT NULL,
	[EthnicityName] [nvarchar](500) NOT NULL,
	[EthnicityDescription] [nvarchar](1000) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Ethnicity] PRIMARY KEY CLUSTERED 
(
	[EthnicityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ETHNICITY$]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ETHNICITY$](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[DESCRIPTION] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Form]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Form](
	[FormId] [int] NOT NULL,
	[ModuleId] [int] NOT NULL,
	[FormName] [nvarchar](100) NULL,
	[Url] [nvarchar](200) NULL,
	[Label] [nvarchar](100) NULL,
	[LabelPlural] [nvarchar](100) NULL,
	[ParentFormId] [int] NULL,
	[CompanyId] [int] NULL,
	[IsSuperUserOnlyForm] [bit] NOT NULL,
	[IsTab] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Form] PRIMARY KEY CLUSTERED 
(
	[FormId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Gender]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Gender](
	[GenderId] [int] IDENTITY(1,1) NOT NULL,
	[GenderName] [nvarchar](20) NOT NULL,
	[GenderDescription] [nvarchar](50) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Gender] PRIMARY KEY CLUSTERED 
(
	[GenderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].['GENERAL INFO$']    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['GENERAL INFO$'](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[SOCIAL SECURITY] [float] NULL,
	[BIRTH DATE] [datetime] NULL,
	[MARITIAL STATUS] [nvarchar](255) NULL,
	[GENDER] [nvarchar](255) NULL,
	[BIRTH PLACE] [nvarchar](255) NULL,
	[DISABILITY YES/NO] [nvarchar](255) NULL,
	[VETERAN STATUS] [nvarchar](255) NULL,
	[ETHNICITY] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GLAccount]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GLAccount](
	[GLAccountId] [int] IDENTITY(1,1) NOT NULL,
	[GLAccountName] [nvarchar](150) NOT NULL,
	[GLAccountDescription] [nvarchar](150) NULL,
	[GLAccountTypeId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.GLAccount] PRIMARY KEY CLUSTERED 
(
	[GLAccountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GLAccountType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GLAccountType](
	[GLAccountTypeId] [int] IDENTITY(1,1) NOT NULL,
	[GLAccountTypeName] [nvarchar](150) NOT NULL,
	[GLAccountTypeDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.GLAccountType] PRIMARY KEY CLUSTERED 
(
	[GLAccountTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].['HEADCOUNT FROM TA7$']    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['HEADCOUNT FROM TA7$'](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[SS] [float] NULL,
	[COMPANY] [nvarchar](255) NULL,
	[DEPARTMENT] [nvarchar](255) NULL,
	[POSITION] [nvarchar](255) NULL,
	[EMPLOYEE TYPE] [nvarchar](255) NULL,
	[BIRTH DATE] [datetime] NULL,
	[HIRE DATE] [datetime] NULL,
	[EMPLOYMENT TYPE] [nvarchar](255) NULL,
	[FTE] [nvarchar](255) NULL,
	[ADDRESS 1] [nvarchar](255) NULL,
	[ADDRESS 2] [nvarchar](255) NULL,
	[CITY] [nvarchar](255) NULL,
	[STATE] [nvarchar](255) NULL,
	[COUNTRY] [nvarchar](255) NULL,
	[ZIP CODE] [float] NULL,
	[PHONENUMBER] [nvarchar](255) NULL,
	[PAY RATE] [float] NULL,
	[MARITIAL STATUS] [nvarchar](255) NULL,
	[GENDER] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].['HEADCOUNT FROM TA7$'_xlnm#_FilterDatabase]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['HEADCOUNT FROM TA7$'_xlnm#_FilterDatabase](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[SS] [float] NULL,
	[COMPANY] [nvarchar](255) NULL,
	[DEPARTMENT] [nvarchar](255) NULL,
	[POSITION] [nvarchar](255) NULL,
	[EMPLOYEE TYPE] [nvarchar](255) NULL,
	[BIRTH DATE] [datetime] NULL,
	[HIRE DATE] [datetime] NULL,
	[EMPLOYMENT TYPE] [nvarchar](255) NULL,
	[FTE] [nvarchar](255) NULL,
	[ADDRESS 1] [nvarchar](255) NULL,
	[ADDRESS 2] [nvarchar](255) NULL,
	[CITY] [nvarchar](255) NULL,
	[STATE] [nvarchar](255) NULL,
	[COUNTRY] [nvarchar](255) NULL,
	[ZIP CODE] [float] NULL,
	[PHONENUMBER] [nvarchar](255) NULL,
	[PAY RATE] [float] NULL,
	[MARITIAL STATUS] [nvarchar](255) NULL,
	[GENDER] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].['HEALTH INSURANCE$']    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['HEALTH INSURANCE$'](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[STATUS] [nvarchar](255) NULL,
	[START DATE] [nvarchar](255) NULL,
	[EXPIRY DATE] [nvarchar](255) NULL,
	[CONTRACT ID] [nvarchar](255) NULL,
	[TYPE PRIMARY/SECONDARY] [nvarchar](255) NULL,
	[COVERAGE] [nvarchar](255) NULL,
	[MONTHLY COMPANY CONTRIBUTION] [nvarchar](255) NULL,
	[MONTHLY EMPLOYEE CONTRIBUTION] [float] NULL,
	[OTHER] [nvarchar](255) NULL,
	[TOTAL] [nvarchar](255) NULL,
	[COBRA YES/NO] [nvarchar](255) NULL,
	[COBRA STATUS] [nvarchar](255) NULL,
	[COBRA START DATE] [nvarchar](255) NULL,
	[COBRA EXPIRY DATE] [nvarchar](255) NULL,
	[COBRA INSURANCE PREMIUM] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].['HEALTH INSURANCE$'_xlnm#_FilterDatabase]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['HEALTH INSURANCE$'_xlnm#_FilterDatabase](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[STATUS] [nvarchar](255) NULL,
	[START DATE] [nvarchar](255) NULL,
	[EXPIRY DATE] [nvarchar](255) NULL,
	[CONTRACT ID] [nvarchar](255) NULL,
	[TYPE PRIMARY/SECONDARY] [nvarchar](255) NULL,
	[COVERAGE] [nvarchar](255) NULL,
	[MONTHLY COMPANY CONTRIBUTION] [nvarchar](255) NULL,
	[MONTHLY EMPLOYEE CONTRIBUTION] [float] NULL,
	[OTHER] [nvarchar](255) NULL,
	[TOTAL] [nvarchar](255) NULL,
	[COBRA YES/NO] [nvarchar](255) NULL,
	[COBRA STATUS] [nvarchar](255) NULL,
	[COBRA START DATE] [nvarchar](255) NULL,
	[COBRA EXPIRY DATE] [nvarchar](255) NULL,
	[COBRA INSURANCE PREMIUM] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HealthInsuranceCobraHistory]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HealthInsuranceCobraHistory](
	[HealthInsuranceCobraHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeHealthInsuranceId] [int] NULL,
	[DueDate] [datetime] NULL,
	[PaymentDate] [datetime] NULL,
	[CobraPaymentStatusId] [int] NULL,
	[PaymentAmount] [decimal](18, 2) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.HealthInsuranceCobraHistory] PRIMARY KEY CLUSTERED 
(
	[HealthInsuranceCobraHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HIRING$]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HIRING$](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[HIRE DATE] [datetime] NULL,
	[EMPLOYEE TYPE] [nvarchar](255) NULL,
	[EMPLOYMENT TYPE] [nvarchar](255) NULL,
	[FTE] [nvarchar](255) NULL,
	[PROBATION PERIOD YES/NO] [nvarchar](255) NULL,
	[PP START] [nvarchar](255) NULL,
	[PP END] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncidentArea]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncidentArea](
	[IncidentAreaId] [int] IDENTITY(1,1) NOT NULL,
	[IncidentAreaName] [nvarchar](max) NOT NULL,
	[IncidentAreaDescription] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.IncidentArea] PRIMARY KEY CLUSTERED 
(
	[IncidentAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncidentBodyPart]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncidentBodyPart](
	[IncidentBodyPartId] [int] IDENTITY(1,1) NOT NULL,
	[IncidentBodyPartName] [nvarchar](max) NOT NULL,
	[IncidentBodyPartDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.IncidentBodyPart] PRIMARY KEY CLUSTERED 
(
	[IncidentBodyPartId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncidentInjuryDescription]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncidentInjuryDescription](
	[IncidentInjuryDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[IncidentInjuryDescriptionName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.IncidentInjuryDescription] PRIMARY KEY CLUSTERED 
(
	[IncidentInjuryDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncidentInjurySource]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncidentInjurySource](
	[IncidentInjurySourceId] [int] IDENTITY(1,1) NOT NULL,
	[IncidentInjurySourceName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.IncidentInjurySource] PRIMARY KEY CLUSTERED 
(
	[IncidentInjurySourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncidentTreatmentFacility]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncidentTreatmentFacility](
	[IncidentTreatmentFacilityId] [int] IDENTITY(1,1) NOT NULL,
	[TreatmentFacilityName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[TreatmentFacilityAddress] [nvarchar](max) NULL,
	[StateId] [int] NULL,
	[CityId] [int] NULL,
	[ZipCode] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.IncidentTreatmentFacility] PRIMARY KEY CLUSTERED 
(
	[IncidentTreatmentFacilityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IncidentType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IncidentType](
	[IncidentTypeId] [int] IDENTITY(1,1) NOT NULL,
	[IncidentTypeName] [nvarchar](max) NOT NULL,
	[IncidentTypeDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.IncidentType] PRIMARY KEY CLUSTERED 
(
	[IncidentTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InsuranceCoverage]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InsuranceCoverage](
	[InsuranceCoverageId] [int] IDENTITY(1,1) NOT NULL,
	[InsuranceCoverageName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.InsuranceCoverage] PRIMARY KEY CLUSTERED 
(
	[InsuranceCoverageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InsuranceStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InsuranceStatus](
	[InsuranceStatusId] [int] IDENTITY(1,1) NOT NULL,
	[InsuranceStatusName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.InsuranceStatus] PRIMARY KEY CLUSTERED 
(
	[InsuranceStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InsuranceType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InsuranceType](
	[InsuranceTypeId] [int] IDENTITY(1,1) NOT NULL,
	[InsuranceTypeName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.InsuranceType] PRIMARY KEY CLUSTERED 
(
	[InsuranceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InterfaceControl]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterfaceControl](
	[InterfaceControlId] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](100) NULL,
	[Name] [nvarchar](100) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.InterfaceControl] PRIMARY KEY CLUSTERED 
(
	[InterfaceControlId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[InterfaceControlForm]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InterfaceControlForm](
	[InterfaceControlFormId] [int] IDENTITY(1,1) NOT NULL,
	[InterfaceControlId] [int] NULL,
	[ModuleId] [int] NULL,
	[FormId] [int] NULL,
	[PrivilegeId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.InterfaceControlForm] PRIMARY KEY CLUSTERED 
(
	[InterfaceControlFormId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobCertificationSignee]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobCertificationSignee](
	[JobCertificationSigneeId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Position] [nvarchar](max) NULL,
	[Signature] [varbinary](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.JobCertificationSignee] PRIMARY KEY CLUSTERED 
(
	[JobCertificationSigneeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobCertificationTemplate]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobCertificationTemplate](
	[JobCertificationTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[TemplateBody] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[TemplateTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.JobCertificationTemplate] PRIMARY KEY CLUSTERED 
(
	[JobCertificationTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobCode]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobCode](
	[JobCodeId] [int] IDENTITY(1,1) NOT NULL,
	[JobCodeName] [varchar](50) NOT NULL,
	[JobCodeDescription] [varchar](200) NULL,
	[Enabled] [bit] NOT NULL,
	[ProjectId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.JobCode] PRIMARY KEY CLUSTERED 
(
	[JobCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobPostingDetail]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobPostingDetail](
	[JobPostingDetailId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[DepartmentId] [int] NULL,
	[LocationId] [int] NULL,
	[NoOfVacancies] [int] NULL,
	[Experience] [nvarchar](max) NULL,
	[SalaryFrom] [decimal](18, 2) NULL,
	[SalaryTo] [decimal](18, 2) NULL,
	[EmploymentTypeId] [int] NULL,
	[JobPostingStatusId] [int] NULL,
	[JobPostingStartDate] [datetime] NULL,
	[JobPostingExpiringDate] [datetime] NULL,
	[JobDescription] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[IsHomeAddress] [bit] NULL,
	[IsMailingAddress] [bit] NULL,
	[IsPreviousEmployment] [bit] NULL,
	[IsEducation] [bit] NULL,
	[IsAvailablity] [bit] NULL,
 CONSTRAINT [PK_dbo.JobPostingDetail] PRIMARY KEY CLUSTERED 
(
	[JobPostingDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobPostingLocation]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobPostingLocation](
	[JobPostingLocationId] [int] IDENTITY(1,1) NOT NULL,
	[JobPostingDetailId] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.JobPostingLocation] PRIMARY KEY CLUSTERED 
(
	[JobPostingLocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[JobPostingStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[JobPostingStatus](
	[JobPostingStatusId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.JobPostingStatus] PRIMARY KEY CLUSTERED 
(
	[JobPostingStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location](
	[LocationId] [int] IDENTITY(1,1) NOT NULL,
	[LocationName] [nvarchar](50) NOT NULL,
	[LocationDescription] [nvarchar](200) NULL,
	[Address] [nvarchar](max) NULL,
	[Address2] [nvarchar](100) NULL,
	[LocationCityId] [int] NULL,
	[LocationStateId] [int] NULL,
	[LocationCountryId] [int] NULL,
	[ZipCode] [nvarchar](max) NULL,
	[PhysicalAddress1] [nvarchar](max) NULL,
	[PhysicalAddress2] [nvarchar](100) NULL,
	[PhysicalCityId] [int] NULL,
	[PhysicalStateId] [int] NULL,
	[PhysicalZipCode] [nvarchar](9) NULL,
	[PhoneNumber1] [nvarchar](10) NULL,
	[ExtensionNumber1] [nvarchar](10) NULL,
	[PhoneNumber2] [nvarchar](10) NULL,
	[ExtensionNumber2] [nvarchar](10) NULL,
	[PhoneNumber3] [nvarchar](10) NULL,
	[ExtensionNumber3] [nvarchar](10) NULL,
	[FaxNumber] [nvarchar](10) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Location] PRIMARY KEY CLUSTERED 
(
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MaritalStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MaritalStatus](
	[MaritalStatusId] [int] IDENTITY(1,1) NOT NULL,
	[MaritalStatusName] [nvarchar](20) NOT NULL,
	[MaritalStatusDescription] [nvarchar](50) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.MaritalStatus] PRIMARY KEY CLUSTERED 
(
	[MaritalStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Module]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Module](
	[ModuleId] [int] NOT NULL,
	[Code] [nvarchar](20) NULL,
	[ModuleName] [nvarchar](100) NOT NULL,
	[ModuleLabel] [nvarchar](100) NOT NULL,
	[CompanyId] [int] NULL,
	[ParentModuleId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Module] PRIMARY KEY CLUSTERED 
(
	[ModuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationLog]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationLog](
	[NotificationLogId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationScheduleDetailId] [int] NULL,
	[DeliveryStatusId] [int] NOT NULL,
	[EmployeeDocumentId] [int] NULL,
	[EmployeeCredentialId] [int] NULL,
	[EmployeeCustomFieldId] [int] NULL,
	[IsNotificationAsExpired] [bit] NULL,
	[ChangeRequestAddressId] [int] NULL,
	[NotificationTypeId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[UserInformationActivationId] [int] NULL,
	[EmploymentId] [int] NULL,
	[EmployeePerformanceId] [int] NULL,
	[EmployeeTrainingId] [int] NULL,
	[EmployeeHealthInsuranceId] [int] NULL,
	[EmployeeDentalInsuranceId] [int] NULL,
	[EmployeeActionId] [int] NULL,
	[EmployeeBenefitHistoryId] [int] NULL,
	[ReferredUserInformationId] [int] NULL,
	[EmailBlastId] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationLog] PRIMARY KEY CLUSTERED 
(
	[NotificationLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationLogEmail]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationLogEmail](
	[NotificationLogEmailId] [int] IDENTITY(1,1) NOT NULL,
	[SenderAddress] [nvarchar](max) NULL,
	[ToAddress] [nvarchar](max) NULL,
	[CcAddress] [nvarchar](max) NULL,
	[BccAddress] [nvarchar](max) NULL,
	[NotificationLogId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationLogEmail] PRIMARY KEY CLUSTERED 
(
	[NotificationLogEmailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationLogMessageReadBy]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationLogMessageReadBy](
	[NotificationLogMessageReadById] [int] IDENTITY(1,1) NOT NULL,
	[NotificationLogId] [int] NULL,
	[ReadById] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[WorkflowTriggerRequestId] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationLogMessageReadBy] PRIMARY KEY CLUSTERED 
(
	[NotificationLogMessageReadById] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationMessage]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationMessage](
	[NotificationMessageId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationMessageName] [nvarchar](50) NOT NULL,
	[NotificationMessageDescription] [nvarchar](200) NULL,
	[Message] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationMessage] PRIMARY KEY CLUSTERED 
(
	[NotificationMessageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationRole]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationRole](
	[NotificationRoleId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationRoleName] [nvarchar](50) NOT NULL,
	[NotificationRoleDescription] [nvarchar](200) NULL,
	[NotificationLevel] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationRole] PRIMARY KEY CLUSTERED 
(
	[NotificationRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationSchedule]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationSchedule](
	[NotificationScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationScheduleName] [nvarchar](50) NOT NULL,
	[NotificationScheduleDescription] [nvarchar](200) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationSchedule] PRIMARY KEY CLUSTERED 
(
	[NotificationScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationScheduleDetail]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationScheduleDetail](
	[NotificationScheduleDetailId] [int] IDENTITY(1,1) NOT NULL,
	[DaysBefore] [int] NOT NULL,
	[NotificationScheduleId] [int] NOT NULL,
	[NotificationMessageId] [int] NOT NULL,
	[ExcludeUser] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[ExcludeSupervisor] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.NotificationScheduleDetail] PRIMARY KEY CLUSTERED 
(
	[NotificationScheduleDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationScheduleEmployeeGroup]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationScheduleEmployeeGroup](
	[NotificationScheduleEmployeeGroupId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationScheduleDetailId] [int] NOT NULL,
	[EmployeeGroupId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationScheduleEmployeeGroup] PRIMARY KEY CLUSTERED 
(
	[NotificationScheduleEmployeeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationServiceEvent]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationServiceEvent](
	[NotificationServiceEventId] [int] IDENTITY(1,1) NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[EventMessage] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationServiceEvent] PRIMARY KEY CLUSTERED 
(
	[NotificationServiceEventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationType](
	[NotificationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[NotificationTypeName] [nvarchar](100) NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.NotificationType] PRIMARY KEY CLUSTERED 
(
	[NotificationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OSHACaseClassification]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OSHACaseClassification](
	[OSHACaseClassificationId] [int] IDENTITY(1,1) NOT NULL,
	[OSHACaseClassificationName] [nvarchar](max) NOT NULL,
	[OSHACaseClassificationDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.OSHACaseClassification] PRIMARY KEY CLUSTERED 
(
	[OSHACaseClassificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OSHAInjuryClassification]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OSHAInjuryClassification](
	[OSHAInjuryClassificationId] [int] IDENTITY(1,1) NOT NULL,
	[OSHAInjuryClassificationName] [nvarchar](max) NOT NULL,
	[OSHAInjuryClassificationDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.OSHAInjuryClassification] PRIMARY KEY CLUSTERED 
(
	[OSHAInjuryClassificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PassswordResetCode]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PassswordResetCode](
	[PassswordResetCodeId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[ResetCode] [nvarchar](max) NULL,
	[ActivationCode] [uniqueidentifier] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PassswordResetCode] PRIMARY KEY CLUSTERED 
(
	[PassswordResetCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].['PAY INFO$']    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['PAY INFO$'](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[RATE] [float] NULL,
	[FREQUENCY OF RATE _(HOURLY, DAILY, WEEKLY, BIWEEKLY, SEMI-MONTHL] [nvarchar](255) NULL,
	[EFFECTIVE DATE] [nvarchar](255) NULL,
	[COMMISSION RATE_(HOURLY, DAILY, WEEKLY, BIWEEKLY, SEMI-MONTHLY, ] [nvarchar](255) NULL,
	[PAY FREQUENCY] [nvarchar](255) NULL,
	[PAY SCALE] [nvarchar](255) NULL,
	[PAY TYPE _(HOURLY, SALARIED, HOURLY PLUS COMMISION, SALARY PLUS ] [nvarchar](255) NULL,
	[EEO CATEGORY] [float] NULL,
	[WORKERS CLASS CODE (FONDO)] [float] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayBank]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayBank](
	[PayBankId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NULL,
	[RoutingNumber] [nvarchar](25) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayBank] PRIMARY KEY CLUSTERED 
(
	[PayBankId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayFrequency]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayFrequency](
	[PayFrequencyId] [int] IDENTITY(1,1) NOT NULL,
	[PayFrequencyName] [nvarchar](50) NOT NULL,
	[PayFrequencyDescription] [nvarchar](200) NULL,
	[HourlyMultiplier] [decimal](18, 2) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayFrequency] PRIMARY KEY CLUSTERED 
(
	[PayFrequencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayInformationHistory]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayInformationHistory](
	[PayInformationHistoryId] [int] IDENTITY(1,1) NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[EEOCategoryId] [int] NULL,
	[PayTypeId] [int] NOT NULL,
	[RateAmount] [decimal](18, 5) NOT NULL,
	[RateFrequencyId] [int] NOT NULL,
	[CommRateAmount] [decimal](18, 5) NULL,
	[CommRateFrequencyId] [int] NULL,
	[PayFrequencyId] [int] NOT NULL,
	[PeriodHours] [decimal](18, 2) NULL,
	[PeriodGrossPay] [decimal](18, 5) NOT NULL,
	[YearlyGrossPay] [decimal](18, 5) NOT NULL,
	[YearlyCommBasePay] [decimal](18, 5) NULL,
	[YearlyBaseNCommPay] [decimal](18, 5) NULL,
	[ChangeReason] [nvarchar](200) NULL,
	[ApprovedDate] [datetime] NULL,
	[docName] [nvarchar](50) NULL,
	[docExtension] [nvarchar](10) NULL,
	[docFile] [image] NULL,
	[WCClassCodeId] [int] NULL,
	[PayScaleId] [int] NULL,
	[EmploymentId] [int] NOT NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayInformationHistory] PRIMARY KEY CLUSTERED 
(
	[PayInformationHistoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayInformationHistoryAuthorizer]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayInformationHistoryAuthorizer](
	[PayInformationHistoryAuthorizerId] [int] IDENTITY(1,1) NOT NULL,
	[AuthorizeById] [int] NULL,
	[PayInformationHistoryId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayInformationHistoryAuthorizer] PRIMARY KEY CLUSTERED 
(
	[PayInformationHistoryAuthorizerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayMethodType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayMethodType](
	[PayMethodTypeId] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayMethodType] PRIMARY KEY CLUSTERED 
(
	[PayMethodTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayRateMultiplier]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayRateMultiplier](
	[PayRateMultiplierId] [int] IDENTITY(1,1) NOT NULL,
	[PayRateMultiplierName] [nvarchar](150) NOT NULL,
	[PayRateMultiplierDescription] [nvarchar](150) NULL,
	[PayRateMultiplierValue] [decimal](18, 2) NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayRateMultiplier] PRIMARY KEY CLUSTERED 
(
	[PayRateMultiplierId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payroll]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payroll](
	[PayrollId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollBatchId] [uniqueidentifier] NOT NULL,
	[PayrollName] [nvarchar](50) NULL,
	[PayDate] [datetime] NULL,
	[PayrollTypeId] [int] NULL,
	[PayrollStatusId] [int] NULL,
	[PayWeekNumber] [int] NULL,
	[PayrollStartDate] [datetime] NULL,
	[PayrollEndDate] [datetime] NULL,
	[ClosedById] [int] NULL,
	[ClosedDate] [datetime] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Payroll] PRIMARY KEY CLUSTERED 
(
	[PayrollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollEditType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollEditType](
	[PayrollEditTypeId] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayrollEditType] PRIMARY KEY CLUSTERED 
(
	[PayrollEditTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollRule]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollRule](
	[PayrollRuleId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[NoOfPunchVal] [int] NULL,
	[PayFrequencyId] [int] NULL,
	[PayWeekStartDate] [datetime] NULL,
	[TimeSheetStartDate] [datetime] NULL,
	[IsCustomSchedule] [bit] NULL,
	[IsAssignedWork] [bit] NULL,
	[AssignedDailyHour] [float] NULL,
	[ScheduledWeeklyHour] [float] NULL,
	[IsAllowBreak] [bit] NULL,
	[BreakTypeVal] [int] NULL,
	[BreakLengthMinute] [int] NULL,
	[BreakRoundingMinute] [int] NULL,
	[IsShortBreakException] [bit] NULL,
	[ShortBreakExceptionMinute] [int] NULL,
	[IsLongBreakException] [bit] NULL,
	[LongBreakExceptionMinute] [int] NULL,
	[RoundingMethodTypeVal] [int] NULL,
	[IsRoundIn] [bit] NULL,
	[RoundInEarlyMinute] [int] NULL,
	[RoundInLateMinute] [int] NULL,
	[IsRoundOut] [bit] NULL,
	[RoundOutEarlyMinute] [int] NULL,
	[RoundOutLateMinute] [int] NULL,
	[PunchRoundingPeriodVal] [int] NULL,
	[IsEarlyInException] [bit] NULL,
	[EarlyInExceptionMinute] [int] NULL,
	[IsLateInException] [bit] NULL,
	[LateInExceptionMinute] [int] NULL,
	[IsEarlyOutException] [bit] NULL,
	[EarlyOutExceptionMinute] [int] NULL,
	[IsLateOutException] [bit] NULL,
	[LateOutExceptionMinute] [int] NULL,
	[IsRoundMealToSchedule] [bit] NULL,
	[MealEarlyRoundMinute] [int] NULL,
	[MealLateRoundMinute] [int] NULL,
	[IsRoundToEndOfMealPeriod] [bit] NULL,
	[IsRoundMealToQuarter] [bit] NULL,
	[IsEarlyInMealException] [bit] NULL,
	[EarlyInMealExceptionMinute] [int] NULL,
	[IsLateInMealException] [bit] NULL,
	[LateInMealExceptionMinute] [int] NULL,
	[IsEarlyOutMealException] [bit] NULL,
	[EarlyOutMealExceptionMinute] [int] NULL,
	[IsLateOutMealException] [bit] NULL,
	[LateOutMealExceptionMinute] [int] NULL,
	[IsShortMealException] [bit] NULL,
	[ShortMealExceptionMinute] [int] NULL,
	[IsLongMealException] [bit] NULL,
	[LongMealExceptionMinute] [int] NULL,
	[IsUse6HourMinimum] [bit] NULL,
	[ScheduledPrimaryMealHour] [float] NULL,
	[ScheduledSecondaryMealHour] [float] NULL,
	[IsComputeLateBreakPenalty] [bit] NULL,
	[LateBreakPenaltyHour] [float] NULL,
	[IsShortLunchMealPenalty] [bit] NULL,
	[SecondaryMealWaiverVal] [int] NULL,
	[SecondMealWaiverHour] [float] NULL,
	[IsPrMeal30MinuteWaiver] [bit] NULL,
	[DailyScheduledHour] [float] NULL,
	[WeeklyScheduledHour] [float] NULL,
	[IsNoOvertime] [bit] NULL,
	[LawDailyRegularHour] [float] NULL,
	[T24HourLawTypeVal] [int] NULL,
	[IsUseLawWeeklyHour] [bit] NULL,
	[LawWeeklyRegularHour] [float] NULL,
	[IsUseSeventhDayLaw] [bit] NULL,
	[SemiMonthlyTypeVal] [int] NULL,
	[SemiMonthlyHour] [float] NULL,
	[HourRoundingSchemeVal] [int] NULL,
	[LateRoundingSchemeVal] [int] NULL,
	[ScheduledOTLawTypeVal] [int] NULL,
	[ScheduledOTAppTransId] [int] NULL,
	[ScheduledOTUnAppTransId] [int] NULL,
	[DailyOTCompVal] [int] NULL,
	[DailyOTAppTransId] [int] NULL,
	[DailyOTUnAppTransId] [int] NULL,
	[T24HrsOTCompVal] [int] NULL,
	[T24HrsOTAppTransId] [int] NULL,
	[T24HrsOTUnAppTransId] [int] NULL,
	[WeeklyOTCompVal] [int] NULL,
	[WeeklyOTAppTransId] [int] NULL,
	[WeeklyOTUnAppTransId] [int] NULL,
	[MealPenaltyLawTypeVal] [int] NULL,
	[MealPenaltyAppTransId] [int] NULL,
	[MealPenaltyUnAppTransId] [int] NULL,
	[SeventhDayComputationVal] [int] NULL,
	[ShiftDifferentialId] [int] NULL,
	[ShiftDifferentialCount] [int] NULL,
	[ShiftDifferential1StartTime] [datetime] NULL,
	[ShiftDifferential1EndTime] [datetime] NULL,
	[ShiftDifferential1Name] [nvarchar](50) NULL,
	[ShiftDifferential1Code] [nvarchar](15) NULL,
	[ShiftDifferential2StartTime] [datetime] NULL,
	[ShiftDifferential2EndTime] [datetime] NULL,
	[ShiftDifferential2Name] [nvarchar](50) NULL,
	[ShiftDifferential2Code] [nvarchar](15) NULL,
	[IsPaidMeal] [bit] NULL,
	[PaidMealHour] [float] NULL,
	[PaidMealMinimumHour] [float] NULL,
	[IsDeductMeal] [bit] NULL,
	[DeductMealHour] [float] NULL,
	[DeductMinimumHour] [float] NULL,
	[IsDeductSecondaryMeal] [bit] NULL,
	[DeductSecondaryMealHour] [float] NULL,
	[DeductSecondaryMealMinimumHour] [float] NULL,
	[SundayOTVal] [int] NULL,
	[MondayOTVal] [int] NULL,
	[TuesdayOTVal] [int] NULL,
	[WednesdayOTVal] [int] NULL,
	[ThursdayOTVal] [int] NULL,
	[FridayOTVal] [int] NULL,
	[SaturdayOTVal] [int] NULL,
	[IsRoundToSchedule] [bit] NULL,
	[RoundAfterHour] [float] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayrollRuleId] PRIMARY KEY CLUSTERED 
(
	[PayrollRuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollRuleFieldListValue]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollRuleFieldListValue](
	[PayrollRuleFieldListValueId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollRuleListTypeFieldId] [int] NULL,
	[Value] [int] NULL,
	[Name] [nvarchar](max) NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayrollRuleFieldListValue] PRIMARY KEY CLUSTERED 
(
	[PayrollRuleFieldListValueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollRuleListTypeField]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollRuleListTypeField](
	[PayrollRuleListTypeFieldId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayrollRuleListTypeField] PRIMARY KEY CLUSTERED 
(
	[PayrollRuleListTypeFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollStatus]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollStatus](
	[PayrollStatusId] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayrollStatus] PRIMARY KEY CLUSTERED 
(
	[PayrollStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollType](
	[PayrollTypeId] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayrollType] PRIMARY KEY CLUSTERED 
(
	[PayrollTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayScale]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayScale](
	[PayScaleId] [int] IDENTITY(1,1) NOT NULL,
	[PayScaleName] [nvarchar](50) NOT NULL,
	[RateFrequencyId] [int] NOT NULL,
	[LevelCount] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayScale] PRIMARY KEY CLUSTERED 
(
	[PayScaleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayScaleLevel]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayScaleLevel](
	[PayScaleLevelId] [int] IDENTITY(1,1) NOT NULL,
	[PayScaleId] [int] NOT NULL,
	[PayScaleLevelRate] [decimal](18, 2) NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayScaleLevel] PRIMARY KEY CLUSTERED 
(
	[PayScaleLevelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayType]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayType](
	[PayTypeId] [int] IDENTITY(1,1) NOT NULL,
	[PayTypeName] [nvarchar](50) NOT NULL,
	[PayTypeDescription] [nvarchar](200) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PayType] PRIMARY KEY CLUSTERED 
(
	[PayTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PerformanceDescription]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PerformanceDescription](
	[PerformanceDescriptionId] [int] IDENTITY(1,1) NOT NULL,
	[PerformanceDescriptionName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PerformanceDescription] PRIMARY KEY CLUSTERED 
(
	[PerformanceDescriptionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PerformanceResult]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PerformanceResult](
	[PerformanceResultId] [int] IDENTITY(1,1) NOT NULL,
	[PerformanceResultName] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PerformanceResult] PRIMARY KEY CLUSTERED 
(
	[PerformanceResultId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PeriodEntry]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PeriodEntry](
	[PeriodEntryId] [int] IDENTITY(1,1) NOT NULL,
	[PeriodEntryName] [nvarchar](max) NOT NULL,
	[PeriodEntryDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PeriodEntry] PRIMARY KEY CLUSTERED 
(
	[PeriodEntryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Position]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Position](
	[PositionId] [int] IDENTITY(1,1) NOT NULL,
	[PositionName] [varchar](50) NOT NULL,
	[PositionDescription] [varchar](200) NULL,
	[PositionCode] [varchar](50) NULL,
	[DefaultPayScaleId] [int] NULL,
	[DefaultEEOCategoryId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Position] PRIMARY KEY CLUSTERED 
(
	[PositionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PositionAppraisalTemplate]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PositionAppraisalTemplate](
	[PositionCAppraisalTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[AppraisalTemplateId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PositionAppraisalTemplate] PRIMARY KEY CLUSTERED 
(
	[PositionCAppraisalTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PositionCredential]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PositionCredential](
	[PositionCredentialId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[CredentialId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[IsRequired] [bit] NULL,
 CONSTRAINT [PK_dbo.PositionCredential] PRIMARY KEY CLUSTERED 
(
	[PositionCredentialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PositionQuestion]    Script Date: 10/18/2024 11:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PositionQuestion](
	[PositionQuestionId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[ApplicantInterviewQuestionId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PositionQuestion] PRIMARY KEY CLUSTERED 
(
	[PositionQuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PositionTraining]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PositionTraining](
	[PositionTrainingId] [int] IDENTITY(1,1) NOT NULL,
	[PositionId] [int] NOT NULL,
	[TrainingId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PositionTraining] PRIMARY KEY CLUSTERED 
(
	[PositionTrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PrimaryTransaction]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PrimaryTransaction](
	[PrimaryTransactionId] [int] IDENTITY(1,1) NOT NULL,
	[PrimaryTransactionName] [nvarchar](150) NOT NULL,
	[PrimaryTransactionDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.PrimaryTransaction] PRIMARY KEY CLUSTERED 
(
	[PrimaryTransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Privilege]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Privilege](
	[PrivilegeId] [int] IDENTITY(1,1) NOT NULL,
	[PrivilegeName] [nvarchar](100) NOT NULL,
	[Code] [nvarchar](20) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Privilege] PRIMARY KEY CLUSTERED 
(
	[PrivilegeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProcessCode]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProcessCode](
	[ProcessCodeId] [int] IDENTITY(1,1) NOT NULL,
	[ProcessCodeName] [nvarchar](150) NOT NULL,
	[ProcessCodeDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ProcessCode] PRIMARY KEY CLUSTERED 
(
	[ProcessCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RateFrequency]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RateFrequency](
	[RateFrequencyId] [int] IDENTITY(1,1) NOT NULL,
	[RateFrequencyName] [nvarchar](50) NOT NULL,
	[RateFrequencyDescription] [nvarchar](200) NULL,
	[HourlyMultiplier] [decimal](18, 2) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.RateFrequency] PRIMARY KEY CLUSTERED 
(
	[RateFrequencyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RatingLevel]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RatingLevel](
	[RatingLevelId] [int] IDENTITY(1,1) NOT NULL,
	[RatingLevelName] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.RatingLevel] PRIMARY KEY CLUSTERED 
(
	[RatingLevelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Relationship]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Relationship](
	[RelationshipId] [int] IDENTITY(1,1) NOT NULL,
	[RelationshipName] [nvarchar](100) NOT NULL,
	[RelationshipDescription] [nvarchar](100) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Relationship] PRIMARY KEY CLUSTERED 
(
	[RelationshipId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReportCriteriaTemplate]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportCriteriaTemplate](
	[ReportCriteriaTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[ReportId] [int] NULL,
	[ReportCriteriaTemplateName] [nvarchar](50) NOT NULL,
	[CriteriaType] [int] NULL,
	[FromDate] [datetime] NULL,
	[ToDate] [datetime] NULL,
	[SuperviorId] [int] NULL,
	[EmployeeSelectionIds] [nvarchar](max) NULL,
	[DepartmentSelectionIds] [nvarchar](max) NULL,
	[SubDepartmentSelectionIds] [nvarchar](max) NULL,
	[EmployeeTypeSelectionIds] [nvarchar](max) NULL,
	[EmploymentTypeSelectionIds] [nvarchar](max) NULL,
	[PositionSelectionIds] [nvarchar](max) NULL,
	[StatusSelectionIds] [nvarchar](max) NULL,
	[DegreeSelectionIds] [nvarchar](max) NULL,
	[TrainingSelectionIds] [nvarchar](max) NULL,
	[CredentialSelectionIds] [nvarchar](max) NULL,
	[CustomFieldSelectionIds] [nvarchar](max) NULL,
	[BenefitSelectionIds] [nvarchar](max) NULL,
	[ActionTypeSelectionIds] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.ReportCriteriaTemplate] PRIMARY KEY CLUSTERED 
(
	[ReportCriteriaTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](200) NULL,
	[RoleTypeId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Role] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleFormPrivilege]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleFormPrivilege](
	[RolePrivilegeId] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NULL,
	[PrivilegeId] [int] NULL,
	[FormId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.RoleFormPrivilege] PRIMARY KEY CLUSTERED 
(
	[RolePrivilegeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleInterfaceControlPrivilege]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleInterfaceControlPrivilege](
	[RoleInterfacePrivilegeId] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NULL,
	[PrivilegeId] [int] NULL,
	[InterfaceControlFormId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.RoleInterfaceControlPrivilege] PRIMARY KEY CLUSTERED 
(
	[RoleInterfacePrivilegeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleType](
	[RoleTypeId] [int] IDENTITY(1,1) NOT NULL,
	[RoleTypeName] [nvarchar](100) NOT NULL,
	[CompanyId] [int] NOT NULL,
	[ClientId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.RoleType] PRIMARY KEY CLUSTERED 
(
	[RoleTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleTypeFormPrivilege]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleTypeFormPrivilege](
	[RoleTypeFormPrivilegeId] [int] IDENTITY(1,1) NOT NULL,
	[RoleTypeId] [int] NULL,
	[PrivilegeId] [int] NULL,
	[FormId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.RoleTypeFormPrivilege] PRIMARY KEY CLUSTERED 
(
	[RoleTypeFormPrivilegeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SelfServiceEmployeeCredential]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SelfServiceEmployeeCredential](
	[SelfServiceEmployeeCredentialId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeCredentialId] [int] NULL,
	[EmployeeCredentialName] [nvarchar](max) NULL,
	[EmployeeCredentialDescription] [nvarchar](200) NULL,
	[IssueDate] [datetime] NOT NULL,
	[ExpirationDate] [datetime] NULL,
	[Note] [nvarchar](200) NULL,
	[DocumentName] [nvarchar](500) NULL,
	[OriginalDocumentName] [nvarchar](250) NULL,
	[DocumentPath] [nvarchar](500) NULL,
	[DocumentFile] [image] NULL,
	[CredentialId] [int] NOT NULL,
	[ExpirationDateRequired] [int] NULL,
	[IsRequired] [bit] NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[CredentialTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.SelfServiceEmployeeCredential] PRIMARY KEY CLUSTERED 
(
	[SelfServiceEmployeeCredentialId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SelfServiceEmployeeDocument]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SelfServiceEmployeeDocument](
	[SelfServiceEmployeeDocumentId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeDocumentId] [int] NULL,
	[DocumentId] [int] NOT NULL,
	[DocumentName] [nvarchar](250) NOT NULL,
	[OriginalDocumentName] [nvarchar](250) NULL,
	[DocumentPath] [nvarchar](250) NULL,
	[DocumentNote] [nvarchar](250) NULL,
	[ExpirationDate] [datetime] NULL,
	[UserInformationId] [int] NOT NULL,
	[ChangeRequestStatusId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SelfServiceEmployeeDocument] PRIMARY KEY CLUSTERED 
(
	[SelfServiceEmployeeDocumentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SenderEmailConfiguration]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SenderEmailConfiguration](
	[SenderEmailConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[MailProvider] [nvarchar](250) NOT NULL,
	[HostName] [nvarchar](250) NOT NULL,
	[ProviderAccount] [nvarchar](1000) NOT NULL,
	[SenderName] [nvarchar](1000) NOT NULL,
	[Environment] [nvarchar](1000) NULL,
	[Port] [int] NULL,
	[EnableSsl] [bit] NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[FromEmail] [nvarchar](255) NOT NULL,
	[SampleEmail] [nvarchar](1000) NULL,
	[UseFixedForm] [bit] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SenderEmailConfiguration] PRIMARY KEY CLUSTERED 
(
	[SenderEmailConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SickAccrualType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SickAccrualType](
	[SickAccrualTypeId] [int] IDENTITY(1,1) NOT NULL,
	[SickAccrualTypeName] [nvarchar](150) NOT NULL,
	[SickAccrualTypeDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SickAccrualType] PRIMARY KEY CLUSTERED 
(
	[SickAccrualTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[State]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[State](
	[StateId] [int] IDENTITY(1,1) NOT NULL,
	[StateCode] [varchar](20) NULL,
	[StateName] [varchar](200) NOT NULL,
	[StateDescription] [varchar](200) NULL,
	[CountryId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.State] PRIMARY KEY CLUSTERED 
(
	[StateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SubDepartment]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubDepartment](
	[SubDepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[SubDepartmentName] [varchar](50) NOT NULL,
	[SubDepartmentDescription] [varchar](200) NULL,
	[USECFSEAssignment] [bit] NOT NULL,
	[CFSECodeId] [int] NULL,
	[CFSECompanyPercent] [decimal](18, 5) NULL,
	[DepartmentId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SubDepartment] PRIMARY KEY CLUSTERED 
(
	[SubDepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupervisorCompany]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupervisorCompany](
	[SupervisorCompanyId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyId] [int] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SupervisorCompany] PRIMARY KEY CLUSTERED 
(
	[SupervisorCompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupervisorDepartment]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupervisorDepartment](
	[SupervisorDepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentId] [int] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SupervisorDepartment] PRIMARY KEY CLUSTERED 
(
	[SupervisorDepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupervisorEmployeeType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupervisorEmployeeType](
	[SupervisorEmployeeTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeTypeId] [int] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SupervisorEmployeeType] PRIMARY KEY CLUSTERED 
(
	[SupervisorEmployeeTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupervisorSubDepartment]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupervisorSubDepartment](
	[SupervisorSubDepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[SubDepartmentId] [int] NULL,
	[UserInformationId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.SupervisorSubDepartment] PRIMARY KEY CLUSTERED 
(
	[SupervisorSubDepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TerminationEligibility]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TerminationEligibility](
	[TerminationEligibilityId] [int] IDENTITY(1,1) NOT NULL,
	[TerminationEligibilityName] [nvarchar](20) NOT NULL,
	[TerminationEligibilityDescription] [nvarchar](50) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.TerminationEligibility] PRIMARY KEY CLUSTERED 
(
	[TerminationEligibilityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TerminationReason]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TerminationReason](
	[TerminationReasonId] [int] IDENTITY(1,1) NOT NULL,
	[TerminationReasonName] [nvarchar](200) NOT NULL,
	[TerminationReasonDescription] [nvarchar](200) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.TerminationReason] PRIMARY KEY CLUSTERED 
(
	[TerminationReasonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TerminationType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TerminationType](
	[TerminationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[TerminationTypeName] [nvarchar](20) NOT NULL,
	[TerminationTypeDescription] [nvarchar](50) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.TerminationType] PRIMARY KEY CLUSTERED 
(
	[TerminationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TimeOffRequestStatus]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TimeOffRequestStatus](
	[TimeOffRequestStatusId] [int] IDENTITY(1,1) NOT NULL,
	[StatusName] [nvarchar](500) NOT NULL,
	[Description] [nvarchar](1000) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.TimeOffRequestStatus] PRIMARY KEY CLUSTERED 
(
	[TimeOffRequestStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Training]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Training](
	[TrainingId] [int] IDENTITY(1,1) NOT NULL,
	[TrainingName] [nvarchar](max) NOT NULL,
	[TrainingDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Training] PRIMARY KEY CLUSTERED 
(
	[TrainingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TRAINING$]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TRAINING$](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[TARINING NAME] [nvarchar](255) NULL,
	[JOB SPECIFIC YES/NO] [nvarchar](255) NULL,
	[MANDATORY YES/NO] [nvarchar](255) NULL,
	[ EXPIRY DATE] [nvarchar](255) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TrainingType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TrainingType](
	[TrainingTypeId] [int] IDENTITY(1,1) NOT NULL,
	[TrainingTypeName] [nvarchar](150) NOT NULL,
	[TrainingTypeDescription] [nvarchar](150) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.TrainingType] PRIMARY KEY CLUSTERED 
(
	[TrainingTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transaction]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transaction](
	[TransactionId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Code] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[ProcessCodeId] [int] NOT NULL,
	[IsAbsent] [bit] NOT NULL,
	[AttendanceCategoryId] [int] NOT NULL,
	[PrimaryTransactionId] [int] NOT NULL,
	[AccrualTypeId] [int] NOT NULL,
	[AccrualImportName] [nvarchar](max) NULL,
	[AttendanceRevision] [bit] NOT NULL,
	[AttendanceRevisionLetter] [bit] NOT NULL,
	[TardinessRevision] [bit] NOT NULL,
	[TardinessRevisionLetter] [bit] NOT NULL,
	[PayRateMultiplierId] [int] NOT NULL,
	[VacationAccrualTypeId] [int] NOT NULL,
	[CompensationAccrualTypeId] [int] NULL,
	[SickAccrualTypeId] [int] NULL,
	[AdditionalPayAmount] [nvarchar](max) NULL,
	[IsMoneyTrans] [bit] NOT NULL,
	[IsMoneyAmountFixed] [bit] NOT NULL,
	[MoneyAmount] [decimal](18, 2) NOT NULL,
	[CompforCompensationAccrual] [nvarchar](max) NULL,
	[PayRateOffset] [decimal](18, 2) NOT NULL,
	[PayRateTransaction] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.TransactionConfiguration] PRIMARY KEY CLUSTERED 
(
	[TransactionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserActivityLog]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserActivityLog](
	[UserActivityLog] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[IPAddress] [nvarchar](150) NULL,
	[BrowserInformation] [nvarchar](max) NULL,
	[DeviceInformation] [nvarchar](max) NULL,
	[OsInformation] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserActivityLog] PRIMARY KEY CLUSTERED 
(
	[UserActivityLog] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserChatAttachment]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserChatAttachment](
	[UserChatAttachmentId] [int] NOT NULL,
	[Url] [nvarchar](max) NULL,
	[Id] [nvarchar](max) NULL,
	[RoomKey] [int] NOT NULL,
	[OwnerKey] [int] NOT NULL,
	[When] [datetimeoffset](7) NOT NULL,
	[FileName] [nvarchar](max) NULL,
	[ContentType] [nvarchar](max) NULL,
	[Size] [bigint] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserContactInformation]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserContactInformation](
	[UserContactInformationId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[LoginEmail] [nvarchar](50) NULL,
	[HomeAddress1] [nvarchar](50) NULL,
	[HomeAddress2] [nvarchar](50) NULL,
	[HomeCityId] [int] NULL,
	[HomeStateId] [int] NULL,
	[HomeCountryId] [int] NULL,
	[HomeZipCode] [nvarchar](10) NULL,
	[MailingAddress1] [nvarchar](50) NULL,
	[MailingAddress2] [nvarchar](50) NULL,
	[MailingCityId] [int] NULL,
	[MailingStateId] [int] NULL,
	[MailingCountryId] [int] NULL,
	[MailingZipCode] [nvarchar](10) NULL,
	[HomeNumber] [nvarchar](20) NULL,
	[CelNumber] [nvarchar](20) NULL,
	[FaxNumber] [nvarchar](20) NULL,
	[OtherNumber] [nvarchar](20) NULL,
	[WorkEmail] [nvarchar](50) NULL,
	[PersonalEmail] [nvarchar](50) NULL,
	[OtherEmail] [nvarchar](50) NULL,
	[WorkNumber] [nvarchar](20) NULL,
	[WorkExtension] [nvarchar](10) NULL,
	[IsSameHomeAddress] [bit] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[NotificationEmail] [nvarchar](50) NULL,
 CONSTRAINT [PK_dbo.UserContactInformation] PRIMARY KEY CLUSTERED 
(
	[UserContactInformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserEmployeeGroup]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserEmployeeGroup](
	[UserEmployeeGroupId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeGroupId] [int] NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserEmployeeGroup] PRIMARY KEY CLUSTERED 
(
	[UserEmployeeGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserInformation]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInformation](
	[UserInformationId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NULL,
	[IdNumber] [nvarchar](20) NULL,
	[SystemId] [nvarchar](20) NULL,
	[FirstName] [nvarchar](30) NULL,
	[MiddleInitial] [nvarchar](2) NULL,
	[FirstLastName] [nvarchar](30) NULL,
	[SecondLastName] [nvarchar](30) NULL,
	[ShortFullName] [nvarchar](50) NULL,
	[DepartmentId] [int] NULL,
	[SubDepartmentId] [int] NULL,
	[PositionId] [int] NULL,
	[EmployeeTypeID] [int] NULL,
	[EmploymentStatusId] [int] NULL,
	[DefaultJobCodeId] [int] NULL,
	[EthnicityId] [int] NULL,
	[DisabilityId] [int] NULL,
	[EmployeeNote] [nvarchar](50) NULL,
	[GenderId] [int] NULL,
	[BirthDate] [datetime] NULL,
	[BirthPlace] [nvarchar](50) NULL,
	[MaritalStatusId] [int] NULL,
	[SSNEncrypted] [nvarchar](512) NULL,
	[SSNEnd] [nvarchar](max) NULL,
	[PictureFilePath] [nvarchar](512) NULL,
	[ResumeFilePath] [nvarchar](512) NULL,
	[PasswordHash] [nvarchar](512) NULL,
	[CreatedBy] [int] NULL,
	[EmployeeStatusId] [int] NULL,
	[EmployeeStatusDate] [datetime] NULL,
	[AspNetUserId] [nvarchar](128) NULL,
	[RefUserInformationId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[IsRotatingSchedule] [bit] NULL,
	[BaseScheduleId] [int] NULL,
	[PayMethodTypeId] [int] NULL,
	[HasAllCompany] [bit] NULL,
 CONSTRAINT [PK_dbo.UserInformation] PRIMARY KEY CLUSTERED 
(
	[UserInformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserInformationActivation]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInformationActivation](
	[UserInformationActivationId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[ActivationCode] [uniqueidentifier] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserInformationActivation] PRIMARY KEY CLUSTERED 
(
	[UserInformationActivationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserInformationRole]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInformationRole](
	[UserRoleID] [int] IDENTITY(1,1) NOT NULL,
	[RoleId] [int] NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserInformationRole] PRIMARY KEY CLUSTERED 
(
	[UserRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserMenu]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserMenu](
	[LinkId] [int] IDENTITY(1,1) NOT NULL,
	[ParentLinkId] [int] NULL,
	[FormId] [int] NULL,
	[UserInterfaceId] [int] NULL,
	[Weight] [int] NULL,
	[Title] [nvarchar](100) NULL,
	[Alt] [nvarchar](100) NULL,
	[Anchor] [nvarchar](100) NULL,
	[AnchorClass] [nvarchar](100) NULL,
	[Description] [nvarchar](100) NULL,
	[CompanyId] [int] NULL,
	[InterfaceControlId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserMenu] PRIMARY KEY CLUSTERED 
(
	[LinkId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSessionLog]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSessionLog](
	[UserSessionLogId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[IPAddress] [nvarchar](150) NULL,
	[BrowserInformation] [nvarchar](max) NULL,
	[DeviceInformation] [nvarchar](max) NULL,
	[OsInformation] [nvarchar](max) NULL,
	[Location] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserSessionLog] PRIMARY KEY CLUSTERED 
(
	[UserSessionLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSessionLogDetail]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSessionLogDetail](
	[UserSessionLogDetailId] [int] IDENTITY(1,1) NOT NULL,
	[UserSessionLogId] [int] NOT NULL,
	[ControllerName] [nvarchar](150) NULL,
	[ActionName] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserSessionLogDetail] PRIMARY KEY CLUSTERED 
(
	[UserSessionLogDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSessionLogEvent]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSessionLogEvent](
	[UserSessionLogEventId] [int] IDENTITY(1,1) NOT NULL,
	[LogListing] [bit] NOT NULL,
	[LogView] [bit] NOT NULL,
	[LogAddOpen] [bit] NOT NULL,
	[LogAddSave] [bit] NOT NULL,
	[LogEditOpen] [bit] NOT NULL,
	[LogEditSave] [bit] NOT NULL,
	[LogDeleteOpen] [bit] NOT NULL,
	[LogDeleteSave] [bit] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.UserSessionLogEvent] PRIMARY KEY CLUSTERED 
(
	[UserSessionLogEventId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VacationAccrualType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VacationAccrualType](
	[VacationAccrualTypeId] [int] IDENTITY(1,1) NOT NULL,
	[VacationAccrualTypeName] [nvarchar](150) NOT NULL,
	[VacationAccrualTypeDescription] [nvarchar](150) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.VacationAccrualType] PRIMARY KEY CLUSTERED 
(
	[VacationAccrualTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].['VETERAN STATUS$']    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['VETERAN STATUS$'](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[DESCRIPTION] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VeteranStatus]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VeteranStatus](
	[VeteranStatusId] [int] IDENTITY(1,1) NOT NULL,
	[VeteranStatusName] [nvarchar](500) NOT NULL,
	[VeteranStatusDescription] [nvarchar](1000) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.VeteranStatus] PRIMARY KEY CLUSTERED 
(
	[VeteranStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WCClassCode]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WCClassCode](
	[WCClassCodeId] [int] IDENTITY(1,1) NOT NULL,
	[ClassName] [nvarchar](200) NOT NULL,
	[ClassCode] [nvarchar](50) NOT NULL,
	[ClassDescription] [nvarchar](1000) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WCClassCode] PRIMARY KEY CLUSTERED 
(
	[WCClassCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WebPunchConfiguration]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WebPunchConfiguration](
	[WebPunchConfigurationId] [int] IDENTITY(1,1) NOT NULL,
	[PunchServiceUrl] [nvarchar](1000) NULL,
	[PunchServiceCompanyId] [int] NULL,
	[PunchServiceCompanyPassword] [nvarchar](500) NULL,
	[UseGPSCoordinates] [bit] NULL,
	[UseJobCode] [bit] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[APIKey] [varchar](500) NULL,
 CONSTRAINT [PK_dbo.WebPunchConfiguration] PRIMARY KEY CLUSTERED 
(
	[WebPunchConfigurationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Withholding401K]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Withholding401K](
	[Withholding401KId] [int] IDENTITY(1,1) NOT NULL,
	[Withholding401KName] [nvarchar](max) NOT NULL,
	[Withholding401KDescription] [nvarchar](max) NULL,
	[CompanyWithholdingId] [int] NOT NULL,
	[EEMaxYearlyAmount] [decimal](18, 2) NOT NULL,
	[ERMaxYearlyAmount] [decimal](18, 2) NOT NULL,
	[UseERLimitPercent] [int] NOT NULL,
	[ERMatchPercent] [decimal](18, 2) NOT NULL,
	[ERPeriodMaxPercent] [decimal](18, 2) NOT NULL,
	[401K_1165eStTaxExemptId] [int] NOT NULL,
	[401KTypeId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Withholding401K] PRIMARY KEY CLUSTERED 
(
	[Withholding401KId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Withholding401KType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Withholding401KType](
	[Withholding401KTypeId] [int] IDENTITY(1,1) NOT NULL,
	[Withholding401KTypeName] [nvarchar](max) NOT NULL,
	[Withholding401KTypeDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.Withholding401KType] PRIMARY KEY CLUSTERED 
(
	[Withholding401KTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WithholdingTaxType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WithholdingTaxType](
	[WithholdingTaxTypeId] [int] IDENTITY(1,1) NOT NULL,
	[WithholdingTaxTypeName] [nvarchar](max) NOT NULL,
	[WithholdingTaxTypeDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WithholdingTaxType] PRIMARY KEY CLUSTERED 
(
	[WithholdingTaxTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WitholdingComputationType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WitholdingComputationType](
	[WitholdingComputationTypeId] [int] IDENTITY(1,1) NOT NULL,
	[WitholdingComputationTypeName] [nvarchar](max) NOT NULL,
	[WitholdingComputationTypeDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WitholdingComputationType] PRIMARY KEY CLUSTERED 
(
	[WitholdingComputationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WitholdingPrePostType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WitholdingPrePostType](
	[WitholdingPrePostTypeId] [int] IDENTITY(1,1) NOT NULL,
	[WitholdingPrePostTypeName] [nvarchar](max) NOT NULL,
	[WitholdingPrePostTypeDescription] [nvarchar](max) NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WitholdingPrePostType] PRIMARY KEY CLUSTERED 
(
	[WitholdingPrePostTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Workflow]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Workflow](
	[WorkflowId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowName] [nvarchar](max) NOT NULL,
	[IsZeroLevel] [bit] NOT NULL,
	[WorkflowDescription] [nvarchar](max) NULL,
	[ClosingNotificationId] [int] NOT NULL,
	[ClosingNotificationMessageId] [int] NOT NULL,
	[ReminderNotificationMessageId] [int] NULL,
	[CancelNotificationMessageId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
	[WorkflowTypeId] [int] NULL,
 CONSTRAINT [PK_dbo.Workflow] PRIMARY KEY CLUSTERED 
(
	[WorkflowId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowActionType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowActionType](
	[WorkflowActionTypeId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowActionTypeName] [nvarchar](max) NULL,
	[WorkflowActionTypeDescription] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowActionType] PRIMARY KEY CLUSTERED 
(
	[WorkflowActionTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowLevel]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowLevel](
	[WorkflowLevelId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowLevelName] [nvarchar](max) NOT NULL,
	[WorkflowId] [int] NOT NULL,
	[WorkflowLevelTypeId] [int] NOT NULL,
	[NotificationMessageId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowLevel] PRIMARY KEY CLUSTERED 
(
	[WorkflowLevelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowLevelGroup]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowLevelGroup](
	[WorkflowLevelGroupId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeGroupId] [int] NOT NULL,
	[WorkflowLevelId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowLevelGroup] PRIMARY KEY CLUSTERED 
(
	[WorkflowLevelGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowLevelType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowLevelType](
	[WorkflowLevelTypeId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowLevelTypeName] [nvarchar](max) NULL,
	[WorkflowLevelTypeDescription] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowLevelType] PRIMARY KEY CLUSTERED 
(
	[WorkflowLevelTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowTrigger]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTrigger](
	[WorkflowTriggerId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowTriggerName] [nvarchar](max) NULL,
	[WorkflowTriggerDescription] [nvarchar](max) NULL,
	[WorkflowId] [int] NOT NULL,
	[WorkflowTriggerTypeId] [int] NOT NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowTrigger] PRIMARY KEY CLUSTERED 
(
	[WorkflowTriggerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowTriggerRequest]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTriggerRequest](
	[WorkflowTriggerRequestId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowTriggerId] [int] NOT NULL,
	[ChangeRequestAddressId] [int] NULL,
	[ChangeRequestEmergencyContactId] [int] NULL,
	[SelfServiceEmployeeDocumentId] [int] NULL,
	[SelfServiceEmployeeCredentialId] [int] NULL,
	[EmployeeTimeOffRequestId] [int] NULL,
	[ChangeRequestEmailNumbersId] [int] NULL,
	[ChangeRequestEmployeeDependentId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowTriggerRequest] PRIMARY KEY CLUSTERED 
(
	[WorkflowTriggerRequestId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowTriggerRequestDetail]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTriggerRequestDetail](
	[WorkflowTriggerRequestDetailId] [int] IDENTITY(1,1) NOT NULL,
	[ActionRemarks] [nvarchar](max) NULL,
	[WorkflowLevelId] [int] NULL,
	[WorkflowTriggerRequestId] [int] NOT NULL,
	[WorkflowActionTypeId] [int] NOT NULL,
	[ActionById] [int] NULL,
	[ActionDate] [datetime] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowTriggerRequestDetail] PRIMARY KEY CLUSTERED 
(
	[WorkflowTriggerRequestDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowTriggerRequestDetail_20221117]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTriggerRequestDetail_20221117](
	[WorkflowTriggerRequestDetailId] [int] IDENTITY(1,1) NOT NULL,
	[ActionRemarks] [nvarchar](max) NULL,
	[WorkflowLevelId] [int] NULL,
	[WorkflowTriggerRequestId] [int] NOT NULL,
	[WorkflowActionTypeId] [int] NOT NULL,
	[ActionById] [int] NULL,
	[ActionDate] [datetime] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowTriggerRequestDetailEmail]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTriggerRequestDetailEmail](
	[WorkflowTriggerRequestDetailEmailId] [int] IDENTITY(1,1) NOT NULL,
	[SenderAddress] [nvarchar](max) NULL,
	[ToAddress] [nvarchar](max) NULL,
	[CcAddress] [nvarchar](max) NULL,
	[BccAddress] [nvarchar](max) NULL,
	[WorkflowTriggerRequestDetailId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowTriggerRequestDetailEmail] PRIMARY KEY CLUSTERED 
(
	[WorkflowTriggerRequestDetailEmailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowTriggerRequestDetailEmail_20221117]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTriggerRequestDetailEmail_20221117](
	[WorkflowTriggerRequestDetailEmailId] [int] IDENTITY(1,1) NOT NULL,
	[SenderAddress] [nvarchar](max) NULL,
	[ToAddress] [nvarchar](max) NULL,
	[CcAddress] [nvarchar](max) NULL,
	[BccAddress] [nvarchar](max) NULL,
	[WorkflowTriggerRequestDetailId] [int] NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowTriggerType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowTriggerType](
	[WorkflowTriggerTypeId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowTriggerTypeName] [nvarchar](max) NULL,
	[WorkflowTriggerTypeDescription] [nvarchar](max) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_dbo.WorkflowTriggerType] PRIMARY KEY CLUSTERED 
(
	[WorkflowTriggerTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[WorkflowType]    Script Date: 10/18/2024 11:15:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WorkflowType](
	[WorkflowTypeId] [int] IDENTITY(1,1) NOT NULL,
	[WorkflowTypeName] [nvarchar](100) NOT NULL,
	[WorkflowTypeDescription] [nvarchar](100) NULL,
	[CompanyId] [int] NULL,
	[ClientId] [int] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[DataEntryStatus] [int] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[Old_Id] [int] NULL,
 CONSTRAINT [PK_WorkflowType] PRIMARY KEY CLUSTERED 
(
	[WorkflowTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  DEFAULT ((0)) FOR [ChangePassword]
GO
ALTER TABLE [dbo].[CompanyCompensation] ADD  CONSTRAINT [DF__CompanyCo__IsCov__1C9228E4]  DEFAULT ((0)) FOR [IsCovidCompensation]
GO
ALTER TABLE [dbo].[CompanyCompensation] ADD  CONSTRAINT [DF__CompanyCo__IsFIC__1D864D1D]  DEFAULT ((0)) FOR [IsFICASSCCExempt]
GO
ALTER TABLE [dbo].[CompanyCompensation] ADD  CONSTRAINT [DF__CompanyCo__GLLoo__1E7A7156]  DEFAULT ((0)) FOR [GLLookupField]
GO
ALTER TABLE [dbo].[UserChatAttachment] ADD  CONSTRAINT [DF_UserChatAttachment_Size]  DEFAULT ((0)) FOR [Size]
GO
ALTER TABLE [dbo].[AccrualRule]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AccrualRule_dbo.AccrualType_AccrualTypeId] FOREIGN KEY([AccrualTypeId])
REFERENCES [dbo].[AccrualType] ([AccrualTypeId])
GO
ALTER TABLE [dbo].[AccrualRule] CHECK CONSTRAINT [FK_dbo.AccrualRule_dbo.AccrualType_AccrualTypeId]
GO
ALTER TABLE [dbo].[AccrualRuleTier]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AccrualRuleTier_dbo.AccrualRule_AccrualRuleId] FOREIGN KEY([AccrualRuleId])
REFERENCES [dbo].[AccrualRule] ([AccrualRuleId])
GO
ALTER TABLE [dbo].[AccrualRuleTier] CHECK CONSTRAINT [FK_dbo.AccrualRuleTier_dbo.AccrualRule_AccrualRuleId]
GO
ALTER TABLE [dbo].[AccrualRuleWorkedHoursTier]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AccrualRuleWorkedHoursTier_dbo.AccrualRuleTier_AccrualRuleTierId] FOREIGN KEY([AccrualRuleTierId])
REFERENCES [dbo].[AccrualRuleTier] ([AccrualRuleTierId])
GO
ALTER TABLE [dbo].[AccrualRuleWorkedHoursTier] CHECK CONSTRAINT [FK_dbo.AccrualRuleWorkedHoursTier_dbo.AccrualRuleTier_AccrualRuleTierId]
GO
ALTER TABLE [dbo].[ApplicantAction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantAction_dbo.ActionType_ActionTypeId] FOREIGN KEY([ActionTypeId])
REFERENCES [dbo].[ActionType] ([ActionTypeId])
GO
ALTER TABLE [dbo].[ApplicantAction] CHECK CONSTRAINT [FK_dbo.ApplicantAction_dbo.ActionType_ActionTypeId]
GO
ALTER TABLE [dbo].[ApplicantAction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantAction_dbo.UserInformation_ApprovedById] FOREIGN KEY([ApprovedById])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ApplicantAction] CHECK CONSTRAINT [FK_dbo.ApplicantAction_dbo.UserInformation_ApprovedById]
GO
ALTER TABLE [dbo].[ApplicantApplication]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantApplication_dbo.ApplicantReferenceSource_ApplicantReferenceSourceId] FOREIGN KEY([ApplicantReferenceSourceId])
REFERENCES [dbo].[ApplicantReferenceSource] ([ApplicantReferenceSourceId])
GO
ALTER TABLE [dbo].[ApplicantApplication] CHECK CONSTRAINT [FK_dbo.ApplicantApplication_dbo.ApplicantReferenceSource_ApplicantReferenceSourceId]
GO
ALTER TABLE [dbo].[ApplicantApplication]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantApplication_dbo.ApplicantReferenceType_ApplicantReferenceTypeId] FOREIGN KEY([ApplicantReferenceTypeId])
REFERENCES [dbo].[ApplicantReferenceType] ([ApplicantReferenceTypeId])
GO
ALTER TABLE [dbo].[ApplicantApplication] CHECK CONSTRAINT [FK_dbo.ApplicantApplication_dbo.ApplicantReferenceType_ApplicantReferenceTypeId]
GO
ALTER TABLE [dbo].[ApplicantApplication]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantApplication_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[ApplicantApplication] CHECK CONSTRAINT [FK_dbo.ApplicantApplication_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[ApplicantApplication]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantApplication_dbo.RateFrequency_RateFrequencyId] FOREIGN KEY([RateFrequencyId])
REFERENCES [dbo].[RateFrequency] ([RateFrequencyId])
GO
ALTER TABLE [dbo].[ApplicantApplication] CHECK CONSTRAINT [FK_dbo.ApplicantApplication_dbo.RateFrequency_RateFrequencyId]
GO
ALTER TABLE [dbo].[ApplicantContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.ApplicantInformation_ApplicantInformationId] FOREIGN KEY([ApplicantInformationId])
REFERENCES [dbo].[ApplicantInformation] ([ApplicantInformationId])
GO
ALTER TABLE [dbo].[ApplicantContactInformation] CHECK CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.ApplicantInformation_ApplicantInformationId]
GO
ALTER TABLE [dbo].[ApplicantContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.City_HomeCityId] FOREIGN KEY([HomeCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[ApplicantContactInformation] CHECK CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.City_HomeCityId]
GO
ALTER TABLE [dbo].[ApplicantContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.City_MailingCityId] FOREIGN KEY([MailingCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[ApplicantContactInformation] CHECK CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.City_MailingCityId]
GO
ALTER TABLE [dbo].[ApplicantContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.Country_HomeCountryId] FOREIGN KEY([HomeCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[ApplicantContactInformation] CHECK CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.Country_HomeCountryId]
GO
ALTER TABLE [dbo].[ApplicantContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.Country_MailingCountryId] FOREIGN KEY([MailingCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[ApplicantContactInformation] CHECK CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.Country_MailingCountryId]
GO
ALTER TABLE [dbo].[ApplicantContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.State_HomeStateId] FOREIGN KEY([HomeStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[ApplicantContactInformation] CHECK CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.State_HomeStateId]
GO
ALTER TABLE [dbo].[ApplicantContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.State_MailingStateId] FOREIGN KEY([MailingStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[ApplicantContactInformation] CHECK CONSTRAINT [FK_dbo.ApplicantContactInformation_dbo.State_MailingStateId]
GO
ALTER TABLE [dbo].[ApplicantCustomField]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantCustomField_dbo.ApplicantInformation_ApplicantInformationId] FOREIGN KEY([ApplicantInformationId])
REFERENCES [dbo].[ApplicantInformation] ([ApplicantInformationId])
GO
ALTER TABLE [dbo].[ApplicantCustomField] CHECK CONSTRAINT [FK_dbo.ApplicantCustomField_dbo.ApplicantInformation_ApplicantInformationId]
GO
ALTER TABLE [dbo].[ApplicantCustomField]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantCustomField_dbo.CustomField_CustomFieldId] FOREIGN KEY([CustomFieldId])
REFERENCES [dbo].[CustomField] ([CustomFieldId])
GO
ALTER TABLE [dbo].[ApplicantCustomField] CHECK CONSTRAINT [FK_dbo.ApplicantCustomField_dbo.CustomField_CustomFieldId]
GO
ALTER TABLE [dbo].[ApplicantDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantDocument_dbo.ApplicantInformation_ApplicantInformationId] FOREIGN KEY([ApplicantInformationId])
REFERENCES [dbo].[ApplicantInformation] ([ApplicantInformationId])
GO
ALTER TABLE [dbo].[ApplicantDocument] CHECK CONSTRAINT [FK_dbo.ApplicantDocument_dbo.ApplicantInformation_ApplicantInformationId]
GO
ALTER TABLE [dbo].[ApplicantDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantDocument_dbo.Document_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[Document] ([DocumentId])
GO
ALTER TABLE [dbo].[ApplicantDocument] CHECK CONSTRAINT [FK_dbo.ApplicantDocument_dbo.Document_DocumentId]
GO
ALTER TABLE [dbo].[ApplicantEducation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantEducation_dbo.Degree_DegreeId] FOREIGN KEY([DegreeId])
REFERENCES [dbo].[Degree] ([DegreeId])
GO
ALTER TABLE [dbo].[ApplicantEducation] CHECK CONSTRAINT [FK_dbo.ApplicantEducation_dbo.Degree_DegreeId]
GO
ALTER TABLE [dbo].[ApplicantEmployment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantCompany_ApplicantCompanyId] FOREIGN KEY([ApplicantCompanyId])
REFERENCES [dbo].[ApplicantCompany] ([ApplicantCompanyId])
GO
ALTER TABLE [dbo].[ApplicantEmployment] CHECK CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantCompany_ApplicantCompanyId]
GO
ALTER TABLE [dbo].[ApplicantEmployment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantExitType_ApplicantExitTypeId] FOREIGN KEY([ApplicantExitTypeId])
REFERENCES [dbo].[ApplicantExitType] ([ApplicantExitTypeId])
GO
ALTER TABLE [dbo].[ApplicantEmployment] CHECK CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantExitType_ApplicantExitTypeId]
GO
ALTER TABLE [dbo].[ApplicantEmployment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantPosition_ApplicantPositionId] FOREIGN KEY([ApplicantPositionId])
REFERENCES [dbo].[ApplicantPosition] ([ApplicantPositionId])
GO
ALTER TABLE [dbo].[ApplicantEmployment] CHECK CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.ApplicantPosition_ApplicantPositionId]
GO
ALTER TABLE [dbo].[ApplicantEmployment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.RateFrequency_RateFrequencyId] FOREIGN KEY([RateFrequencyId])
REFERENCES [dbo].[RateFrequency] ([RateFrequencyId])
GO
ALTER TABLE [dbo].[ApplicantEmployment] CHECK CONSTRAINT [FK_dbo.ApplicantEmployment_dbo.RateFrequency_RateFrequencyId]
GO
ALTER TABLE [dbo].[ApplicantEmploymentType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantEmploymentType_dbo.EmployeeType_EmployeeTypeId] FOREIGN KEY([EmployeeTypeId])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeId])
GO
ALTER TABLE [dbo].[ApplicantEmploymentType] CHECK CONSTRAINT [FK_dbo.ApplicantEmploymentType_dbo.EmployeeType_EmployeeTypeId]
GO
ALTER TABLE [dbo].[ApplicantInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInformation_dbo.ApplicantStatus_ApplicantStatusId] FOREIGN KEY([ApplicantStatusId])
REFERENCES [dbo].[ApplicantStatus] ([ApplicantStatusId])
GO
ALTER TABLE [dbo].[ApplicantInformation] CHECK CONSTRAINT [FK_dbo.ApplicantInformation_dbo.ApplicantStatus_ApplicantStatusId]
GO
ALTER TABLE [dbo].[ApplicantInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[ApplicantInformation] CHECK CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[ApplicantInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[ApplicantInformation] CHECK CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[ApplicantInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Gender_GenderId] FOREIGN KEY([GenderId])
REFERENCES [dbo].[Gender] ([GenderId])
GO
ALTER TABLE [dbo].[ApplicantInformation] CHECK CONSTRAINT [FK_dbo.ApplicantInformation_dbo.Gender_GenderId]
GO
ALTER TABLE [dbo].[ApplicantInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInformation_dbo.JobPostingDetail_JobPostingDetailId] FOREIGN KEY([JobPostingDetailId])
REFERENCES [dbo].[JobPostingDetail] ([JobPostingDetailId])
GO
ALTER TABLE [dbo].[ApplicantInformation] CHECK CONSTRAINT [FK_dbo.ApplicantInformation_dbo.JobPostingDetail_JobPostingDetailId]
GO
ALTER TABLE [dbo].[ApplicantInterview]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInterview_dbo.ApplicantInterviewAnswer_ApplicantInterviewAnswerId] FOREIGN KEY([ApplicantInterviewAnswerId])
REFERENCES [dbo].[ApplicantInterviewAnswer] ([ApplicantInterviewAnswerId])
GO
ALTER TABLE [dbo].[ApplicantInterview] CHECK CONSTRAINT [FK_dbo.ApplicantInterview_dbo.ApplicantInterviewAnswer_ApplicantInterviewAnswerId]
GO
ALTER TABLE [dbo].[ApplicantInterview]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ApplicantInterview_dbo.ApplicantInterviewQuestion_ApplicantInterviewQuestionId] FOREIGN KEY([ApplicantInterviewQuestionId])
REFERENCES [dbo].[ApplicantInterviewQuestion] ([ApplicantInterviewQuestionId])
GO
ALTER TABLE [dbo].[ApplicantInterview] CHECK CONSTRAINT [FK_dbo.ApplicantInterview_dbo.ApplicantInterviewQuestion_ApplicantInterviewQuestionId]
GO
ALTER TABLE [dbo].[AppraisalGoal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalGoal_dbo.AppraisalRatingScale_AppraisalRatingScaleId] FOREIGN KEY([AppraisalRatingScaleId])
REFERENCES [dbo].[AppraisalRatingScale] ([AppraisalRatingScaleId])
GO
ALTER TABLE [dbo].[AppraisalGoal] CHECK CONSTRAINT [FK_dbo.AppraisalGoal_dbo.AppraisalRatingScale_AppraisalRatingScaleId]
GO
ALTER TABLE [dbo].[AppraisalRatingScaleDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalRatingScaleDetail_dbo.AppraisalRatingScale_AppraisalRatingScaleId] FOREIGN KEY([AppraisalRatingScaleId])
REFERENCES [dbo].[AppraisalRatingScale] ([AppraisalRatingScaleId])
GO
ALTER TABLE [dbo].[AppraisalRatingScaleDetail] CHECK CONSTRAINT [FK_dbo.AppraisalRatingScaleDetail_dbo.AppraisalRatingScale_AppraisalRatingScaleId]
GO
ALTER TABLE [dbo].[AppraisalRatingScaleDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalRatingScaleDetail_dbo.RatingLevel_RatingLevelId] FOREIGN KEY([RatingLevelId])
REFERENCES [dbo].[RatingLevel] ([RatingLevelId])
GO
ALTER TABLE [dbo].[AppraisalRatingScaleDetail] CHECK CONSTRAINT [FK_dbo.AppraisalRatingScaleDetail_dbo.RatingLevel_RatingLevelId]
GO
ALTER TABLE [dbo].[AppraisalSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalSkill_dbo.AppraisalRatingScale_AppraisalRatingScaleId] FOREIGN KEY([AppraisalRatingScaleId])
REFERENCES [dbo].[AppraisalRatingScale] ([AppraisalRatingScaleId])
GO
ALTER TABLE [dbo].[AppraisalSkill] CHECK CONSTRAINT [FK_dbo.AppraisalSkill_dbo.AppraisalRatingScale_AppraisalRatingScaleId]
GO
ALTER TABLE [dbo].[AppraisalTemplateGoal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalTemplateGoal_dbo.AppraisalGoal_AppraisalGoalId] FOREIGN KEY([AppraisalGoalId])
REFERENCES [dbo].[AppraisalGoal] ([AppraisalGoalId])
GO
ALTER TABLE [dbo].[AppraisalTemplateGoal] CHECK CONSTRAINT [FK_dbo.AppraisalTemplateGoal_dbo.AppraisalGoal_AppraisalGoalId]
GO
ALTER TABLE [dbo].[AppraisalTemplateGoal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalTemplateGoal_dbo.AppraisalTemplate_AppraisalTemplateId] FOREIGN KEY([AppraisalTemplateId])
REFERENCES [dbo].[AppraisalTemplate] ([AppraisalTemplateId])
GO
ALTER TABLE [dbo].[AppraisalTemplateGoal] CHECK CONSTRAINT [FK_dbo.AppraisalTemplateGoal_dbo.AppraisalTemplate_AppraisalTemplateId]
GO
ALTER TABLE [dbo].[AppraisalTemplateSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalTemplateSkill_dbo.AppraisalSkill_AppraisalSkillId] FOREIGN KEY([AppraisalSkillId])
REFERENCES [dbo].[AppraisalSkill] ([AppraisalSkillId])
GO
ALTER TABLE [dbo].[AppraisalTemplateSkill] CHECK CONSTRAINT [FK_dbo.AppraisalTemplateSkill_dbo.AppraisalSkill_AppraisalSkillId]
GO
ALTER TABLE [dbo].[AppraisalTemplateSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AppraisalTemplateSkill_dbo.AppraisalTemplate_AppraisalTemplateId] FOREIGN KEY([AppraisalTemplateId])
REFERENCES [dbo].[AppraisalTemplate] ([AppraisalTemplateId])
GO
ALTER TABLE [dbo].[AppraisalTemplateSkill] CHECK CONSTRAINT [FK_dbo.AppraisalTemplateSkill_dbo.AppraisalTemplate_AppraisalTemplateId]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_AspNetUsers_Id] FOREIGN KEY([AspNetUsers_Id])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_AspNetUsers_Id]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [dbo].[AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [dbo].[AspNetUsersAspNetRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUsersAspNetRoles_dbo.AspNetRoles_AspNetRoles_Id] FOREIGN KEY([AspNetRoles_Id])
REFERENCES [dbo].[AspNetRoles] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsersAspNetRoles] CHECK CONSTRAINT [FK_dbo.AspNetUsersAspNetRoles_dbo.AspNetRoles_AspNetRoles_Id]
GO
ALTER TABLE [dbo].[AspNetUsersAspNetRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUsersAspNetRoles_dbo.AspNetUsers_AspNetUsers_Id] FOREIGN KEY([AspNetUsers_Id])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUsersAspNetRoles] CHECK CONSTRAINT [FK_dbo.AspNetUsersAspNetRoles_dbo.AspNetUsers_AspNetUsers_Id]
GO
ALTER TABLE [dbo].[AuditLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditLog_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[AuditLog] CHECK CONSTRAINT [FK_dbo.AuditLog_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[AuditLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditLog_dbo.UserSessionLogDetail_UserSessionLogDetailId] FOREIGN KEY([UserSessionLogDetailId])
REFERENCES [dbo].[UserSessionLogDetail] ([UserSessionLogDetailId])
GO
ALTER TABLE [dbo].[AuditLog] CHECK CONSTRAINT [FK_dbo.AuditLog_dbo.UserSessionLogDetail_UserSessionLogDetailId]
GO
ALTER TABLE [dbo].[AuditLogDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AuditLogDetail_dbo.AuditLog_AuditLogId] FOREIGN KEY([AuditLogId])
REFERENCES [dbo].[AuditLog] ([AuditLogId])
GO
ALTER TABLE [dbo].[AuditLogDetail] CHECK CONSTRAINT [FK_dbo.AuditLogDetail_dbo.AuditLog_AuditLogId]
GO
ALTER TABLE [dbo].[Certification]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Certification_dbo.CertificationType_CertificationTypeId] FOREIGN KEY([CertificationTypeId])
REFERENCES [dbo].[CertificationType] ([CertificationTypeId])
GO
ALTER TABLE [dbo].[Certification] CHECK CONSTRAINT [FK_dbo.Certification_dbo.CertificationType_CertificationTypeId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.City_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.City_CityId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.City_NewCityId] FOREIGN KEY([NewCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.City_NewCityId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.Country_CountryId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.Country_NewCountryId] FOREIGN KEY([NewCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.Country_NewCountryId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.State_NewStateId] FOREIGN KEY([NewStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.State_NewStateId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.State_StateId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.UserContactInformation_UserContactInformationId] FOREIGN KEY([UserContactInformationId])
REFERENCES [dbo].[UserContactInformation] ([UserContactInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.UserContactInformation_UserContactInformationId]
GO
ALTER TABLE [dbo].[ChangeRequestAddress]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestAddress] CHECK CONSTRAINT [FK_dbo.ChangeRequestAddress_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.UserContactInformation_UserContactInformationId] FOREIGN KEY([UserContactInformationId])
REFERENCES [dbo].[UserContactInformation] ([UserContactInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.UserContactInformation_UserContactInformationId]
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestEmailNumbers] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmailNumbers_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.EmergencyContact_EmergencyContactId] FOREIGN KEY([EmergencyContactId])
REFERENCES [dbo].[EmergencyContact] ([EmergencyContactId])
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.EmergencyContact_EmergencyContactId]
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.Relationship_NewRelationshipId] FOREIGN KEY([NewRelationshipId])
REFERENCES [dbo].[Relationship] ([RelationshipId])
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.Relationship_NewRelationshipId]
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.Relationship_RelationshipId] FOREIGN KEY([RelationshipId])
REFERENCES [dbo].[Relationship] ([RelationshipId])
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.Relationship_RelationshipId]
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestEmergencyContact] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmergencyContact_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.DependentStatus_DependentStatusId] FOREIGN KEY([DependentStatusId])
REFERENCES [dbo].[DependentStatus] ([DependentStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.DependentStatus_DependentStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.DependentStatus_NewDependentStatusId] FOREIGN KEY([NewDependentStatusId])
REFERENCES [dbo].[DependentStatus] ([DependentStatusId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.DependentStatus_NewDependentStatusId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.EmployeeDependent_EmployeeDependentId] FOREIGN KEY([EmployeeDependentId])
REFERENCES [dbo].[EmployeeDependent] ([EmployeeDependentId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.EmployeeDependent_EmployeeDependentId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Gender_GenderId] FOREIGN KEY([GenderId])
REFERENCES [dbo].[Gender] ([GenderId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Gender_GenderId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Gender_NewGenderId] FOREIGN KEY([NewGenderId])
REFERENCES [dbo].[Gender] ([GenderId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Gender_NewGenderId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Relationship_NewRelationshipId] FOREIGN KEY([NewRelationshipId])
REFERENCES [dbo].[Relationship] ([RelationshipId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Relationship_NewRelationshipId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Relationship_RelationshipId] FOREIGN KEY([RelationshipId])
REFERENCES [dbo].[Relationship] ([RelationshipId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.Relationship_RelationshipId]
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ChangeRequestEmployeeDependent] CHECK CONSTRAINT [FK_dbo.ChangeRequestEmployeeDependent_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[ChatConversation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChatConversation_dbo.UserInformation_ChatInitiatedById] FOREIGN KEY([ChatInitiatedById])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ChatConversation] CHECK CONSTRAINT [FK_dbo.ChatConversation_dbo.UserInformation_ChatInitiatedById]
GO
ALTER TABLE [dbo].[ChatConversationParticipant]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChatConversationParticipant_dbo.ChatConversation_ChatConversationId] FOREIGN KEY([ChatConversationId])
REFERENCES [dbo].[ChatConversation] ([ChatConversationId])
GO
ALTER TABLE [dbo].[ChatConversationParticipant] CHECK CONSTRAINT [FK_dbo.ChatConversationParticipant_dbo.ChatConversation_ChatConversationId]
GO
ALTER TABLE [dbo].[ChatConversationParticipant]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChatConversationParticipant_dbo.UserInformation_ParticipantId] FOREIGN KEY([ParticipantId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[ChatConversationParticipant] CHECK CONSTRAINT [FK_dbo.ChatConversationParticipant_dbo.UserInformation_ParticipantId]
GO
ALTER TABLE [dbo].[ChatMessage]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChatMessage_dbo.ChatConversation_ChatConversationId] FOREIGN KEY([ChatConversationId])
REFERENCES [dbo].[ChatConversation] ([ChatConversationId])
GO
ALTER TABLE [dbo].[ChatMessage] CHECK CONSTRAINT [FK_dbo.ChatMessage_dbo.ChatConversation_ChatConversationId]
GO
ALTER TABLE [dbo].[ChatMessage]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ChatMessage_dbo.ChatConversationParticipant_ChatConversationParticipantId] FOREIGN KEY([ChatConversationParticipantId])
REFERENCES [dbo].[ChatConversationParticipant] ([ChatConversationParticipantId])
GO
ALTER TABLE [dbo].[ChatMessage] CHECK CONSTRAINT [FK_dbo.ChatMessage_dbo.ChatConversationParticipant_ChatConversationParticipantId]
GO
ALTER TABLE [dbo].[City]  WITH CHECK ADD  CONSTRAINT [FK_dbo.City_dbo.State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[City] CHECK CONSTRAINT [FK_dbo.City_dbo.State_StateId]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.City_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.City_CityId]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.City_PayrollCityId] FOREIGN KEY([PayrollCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.City_PayrollCityId]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.Country_CountryId]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.Country_PayrollCountryId] FOREIGN KEY([PayrollCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.Country_PayrollCountryId]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.State_PayrollStateId] FOREIGN KEY([PayrollStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.State_PayrollStateId]
GO
ALTER TABLE [dbo].[Client]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Client_dbo.State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [FK_dbo.Client_dbo.State_StateId]
GO
ALTER TABLE [dbo].[Company]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Company_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [FK_dbo.Company_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[CompanyCompensation]  WITH CHECK ADD  CONSTRAINT [FK_CompanyCompensation_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[CompanyCompensation] CHECK CONSTRAINT [FK_CompanyCompensation_Company]
GO
ALTER TABLE [dbo].[CompanyCompensation]  WITH CHECK ADD  CONSTRAINT [FK_CompanyCompensation_CompensationComputationType] FOREIGN KEY([ComputationTypeId])
REFERENCES [dbo].[CompensationComputationType] ([CompensationComputationTypeId])
GO
ALTER TABLE [dbo].[CompanyCompensation] CHECK CONSTRAINT [FK_CompanyCompensation_CompensationComputationType]
GO
ALTER TABLE [dbo].[CompanyCompensation]  WITH CHECK ADD  CONSTRAINT [FK_CompanyCompensation_CompensationType] FOREIGN KEY([CompensationTypeId])
REFERENCES [dbo].[CompensationType] ([CompensationTypeId])
GO
ALTER TABLE [dbo].[CompanyCompensation] CHECK CONSTRAINT [FK_CompanyCompensation_CompensationType]
GO
ALTER TABLE [dbo].[CompanyCompensation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyCompensation_dbo.CompensationImportType_ImportTypeId] FOREIGN KEY([ImportTypeId])
REFERENCES [dbo].[CompensationImportType] ([CompensationImportTypeId])
GO
ALTER TABLE [dbo].[CompanyCompensation] CHECK CONSTRAINT [FK_dbo.CompanyCompensation_dbo.CompensationImportType_ImportTypeId]
GO
ALTER TABLE [dbo].[CompanyCompensation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyCompensation_dbo.CompensationType_CompensationTypeId] FOREIGN KEY([CompensationTypeId])
REFERENCES [dbo].[CompensationType] ([CompensationTypeId])
GO
ALTER TABLE [dbo].[CompanyCompensation] CHECK CONSTRAINT [FK_dbo.CompanyCompensation_dbo.CompensationType_CompensationTypeId]
GO
ALTER TABLE [dbo].[CompanyCompensationPRPayExport]  WITH CHECK ADD  CONSTRAINT [FK_CompanyCompensationPRPayExport_CompanyCompensation] FOREIGN KEY([CompanyCompensationId])
REFERENCES [dbo].[CompanyCompensation] ([CompanyCompensationId])
GO
ALTER TABLE [dbo].[CompanyCompensationPRPayExport] CHECK CONSTRAINT [FK_CompanyCompensationPRPayExport_CompanyCompensation]
GO
ALTER TABLE [dbo].[CompanyCompensationPRPayExport]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyCompensationPRPayExport_dbo.CompanyCompensation_CompanyCompensationPRPayExportId] FOREIGN KEY([CompanyCompensationPRPayExportId])
REFERENCES [dbo].[CompanyCompensation] ([CompanyCompensationId])
GO
ALTER TABLE [dbo].[CompanyCompensationPRPayExport] CHECK CONSTRAINT [FK_dbo.CompanyCompensationPRPayExport_dbo.CompanyCompensation_CompanyCompensationPRPayExportId]
GO
ALTER TABLE [dbo].[CompanyDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyDocument_dbo.UserInformation_DocumentUserId] FOREIGN KEY([DocumentUserId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[CompanyDocument] CHECK CONSTRAINT [FK_dbo.CompanyDocument_dbo.UserInformation_DocumentUserId]
GO
ALTER TABLE [dbo].[CompanyEmployeeTab]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[CompanyEmployeeTab] CHECK CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[CompanyEmployeeTab]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[CompanyEmployeeTab] CHECK CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[CompanyEmployeeTab]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Form_FormId] FOREIGN KEY([FormId])
REFERENCES [dbo].[Form] ([FormId])
GO
ALTER TABLE [dbo].[CompanyEmployeeTab] CHECK CONSTRAINT [FK_dbo.CompanyEmployeeTab_dbo.Form_FormId]
GO
ALTER TABLE [dbo].[CompanyWithholding]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyWithholding_dbo.GLAccount_GLAccountId] FOREIGN KEY([GLAccountId])
REFERENCES [dbo].[GLAccount] ([GLAccountId])
GO
ALTER TABLE [dbo].[CompanyWithholding] CHECK CONSTRAINT [FK_dbo.CompanyWithholding_dbo.GLAccount_GLAccountId]
GO
ALTER TABLE [dbo].[CompanyWithholding]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyWithholding_dbo.WitholdingComputationType_WitholdingComputationTypeId] FOREIGN KEY([WitholdingComputationTypeId])
REFERENCES [dbo].[WitholdingComputationType] ([WitholdingComputationTypeId])
GO
ALTER TABLE [dbo].[CompanyWithholding] CHECK CONSTRAINT [FK_dbo.CompanyWithholding_dbo.WitholdingComputationType_WitholdingComputationTypeId]
GO
ALTER TABLE [dbo].[CompanyWithholding]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyWithholding_dbo.WitholdingPrePostType_WitholdingPrePostTypeId] FOREIGN KEY([WitholdingPrePostTypeId])
REFERENCES [dbo].[WitholdingPrePostType] ([WitholdingPrePostTypeId])
GO
ALTER TABLE [dbo].[CompanyWithholding] CHECK CONSTRAINT [FK_dbo.CompanyWithholding_dbo.WitholdingPrePostType_WitholdingPrePostTypeId]
GO
ALTER TABLE [dbo].[CompanyWithholdingPRPayExport]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompanyWithholdingPRPayExport_dbo.CompanyWithholding_CompanyWithholdingPRPayExportId] FOREIGN KEY([CompanyWithholdingPRPayExportId])
REFERENCES [dbo].[CompanyWithholding] ([CompanyWithholdingId])
GO
ALTER TABLE [dbo].[CompanyWithholdingPRPayExport] CHECK CONSTRAINT [FK_dbo.CompanyWithholdingPRPayExport_dbo.CompanyWithholding_CompanyWithholdingPRPayExportId]
GO
ALTER TABLE [dbo].[CompensationTransaction]  WITH CHECK ADD  CONSTRAINT [FK_CompensationTransaction_CompanyCompensation] FOREIGN KEY([CompanyCompensationId])
REFERENCES [dbo].[CompanyCompensation] ([CompanyCompensationId])
GO
ALTER TABLE [dbo].[CompensationTransaction] CHECK CONSTRAINT [FK_CompensationTransaction_CompanyCompensation]
GO
ALTER TABLE [dbo].[CompensationTransaction]  WITH CHECK ADD  CONSTRAINT [FK_CompensationTransaction_TransactionConfiguration] FOREIGN KEY([TransactionId])
REFERENCES [dbo].[Transaction] ([TransactionId])
GO
ALTER TABLE [dbo].[CompensationTransaction] CHECK CONSTRAINT [FK_CompensationTransaction_TransactionConfiguration]
GO
ALTER TABLE [dbo].[CompensationTransaction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompensationTransaction_dbo.CompanyCompensation_CompanyCompensationId] FOREIGN KEY([CompanyCompensationId])
REFERENCES [dbo].[CompanyCompensation] ([CompanyCompensationId])
GO
ALTER TABLE [dbo].[CompensationTransaction] CHECK CONSTRAINT [FK_dbo.CompensationTransaction_dbo.CompanyCompensation_CompanyCompensationId]
GO
ALTER TABLE [dbo].[CompensationTransaction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CompensationTransaction_dbo.TransactionConfiguration_TransactionConfigurationId] FOREIGN KEY([TransactionId])
REFERENCES [dbo].[Transaction] ([TransactionId])
GO
ALTER TABLE [dbo].[CompensationTransaction] CHECK CONSTRAINT [FK_dbo.CompensationTransaction_dbo.TransactionConfiguration_TransactionConfigurationId]
GO
ALTER TABLE [dbo].[Credential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Credential_dbo.NotificationSchedule_NotificationScheduleId] FOREIGN KEY([NotificationScheduleId])
REFERENCES [dbo].[NotificationSchedule] ([NotificationScheduleId])
GO
ALTER TABLE [dbo].[Credential] CHECK CONSTRAINT [FK_dbo.Credential_dbo.NotificationSchedule_NotificationScheduleId]
GO
ALTER TABLE [dbo].[CustomField]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CustomField_dbo.DocumentRequiredBy_DocumentRequiredById] FOREIGN KEY([DocumentRequiredById])
REFERENCES [dbo].[DocumentRequiredBy] ([DocumentRequiredById])
GO
ALTER TABLE [dbo].[CustomField] CHECK CONSTRAINT [FK_dbo.CustomField_dbo.DocumentRequiredBy_DocumentRequiredById]
GO
ALTER TABLE [dbo].[CustomField]  WITH CHECK ADD  CONSTRAINT [FK_dbo.CustomField_dbo.NotificationSchedule_NotificationScheduleId] FOREIGN KEY([NotificationScheduleId])
REFERENCES [dbo].[NotificationSchedule] ([NotificationScheduleId])
GO
ALTER TABLE [dbo].[CustomField] CHECK CONSTRAINT [FK_dbo.CustomField_dbo.NotificationSchedule_NotificationScheduleId]
GO
ALTER TABLE [dbo].[DataMigrationLogDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.DataMigrationLogDetail_dbo.DataMigrationLog_DataMigrationLogId] FOREIGN KEY([DataMigrationLogId])
REFERENCES [dbo].[DataMigrationLog] ([DataMigrationLogId])
GO
ALTER TABLE [dbo].[DataMigrationLogDetail] CHECK CONSTRAINT [FK_dbo.DataMigrationLogDetail_dbo.DataMigrationLog_DataMigrationLogId]
GO
ALTER TABLE [dbo].[DentalInsuranceCobraHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.DentalInsuranceCobraHistory_dbo.CobraPaymentStatus_CobraPaymentStatusId] FOREIGN KEY([CobraPaymentStatusId])
REFERENCES [dbo].[CobraPaymentStatus] ([CobraPaymentStatusId])
GO
ALTER TABLE [dbo].[DentalInsuranceCobraHistory] CHECK CONSTRAINT [FK_dbo.DentalInsuranceCobraHistory_dbo.CobraPaymentStatus_CobraPaymentStatusId]
GO
ALTER TABLE [dbo].[DentalInsuranceCobraHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.DentalInsuranceCobraHistory_dbo.EmployeeDentalInsurance_EmployeeDentalInsuranceId] FOREIGN KEY([EmployeeDentalInsuranceId])
REFERENCES [dbo].[EmployeeDentalInsurance] ([EmployeeDentalInsuranceId])
GO
ALTER TABLE [dbo].[DentalInsuranceCobraHistory] CHECK CONSTRAINT [FK_dbo.DentalInsuranceCobraHistory_dbo.EmployeeDentalInsurance_EmployeeDentalInsuranceId]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Department_dbo.CFSECode_CFSECodeId] FOREIGN KEY([CFSECodeId])
REFERENCES [dbo].[CFSECode] ([CFSECodeId])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_dbo.Department_dbo.CFSECode_CFSECodeId]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Department_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_dbo.Department_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Department_dbo.JobCertificationSignee_JobCertificationSigneeId] FOREIGN KEY([JobCertificationSigneeId])
REFERENCES [dbo].[JobCertificationSignee] ([JobCertificationSigneeId])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_dbo.Department_dbo.JobCertificationSignee_JobCertificationSigneeId]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Department_dbo.JobCertificationTemplate_JobCertificationTemplateId] FOREIGN KEY([JobCertificationTemplateId])
REFERENCES [dbo].[JobCertificationTemplate] ([JobCertificationTemplateId])
GO
ALTER TABLE [dbo].[Department] CHECK CONSTRAINT [FK_dbo.Department_dbo.JobCertificationTemplate_JobCertificationTemplateId]
GO
ALTER TABLE [dbo].[Document]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Document_dbo.NotificationSchedule_NotificationScheduleId] FOREIGN KEY([NotificationScheduleId])
REFERENCES [dbo].[NotificationSchedule] ([NotificationScheduleId])
GO
ALTER TABLE [dbo].[Document] CHECK CONSTRAINT [FK_dbo.Document_dbo.NotificationSchedule_NotificationScheduleId]
GO
ALTER TABLE [dbo].[EmailTemplate]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmailTemplate_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[EmailTemplate] CHECK CONSTRAINT [FK_dbo.EmailTemplate_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[EmailTemplate]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmailTemplate_dbo.EmailType_EmailTypeId] FOREIGN KEY([EmailTypeId])
REFERENCES [dbo].[EmailType] ([EmailTypeId])
GO
ALTER TABLE [dbo].[EmailTemplate] CHECK CONSTRAINT [FK_dbo.EmailTemplate_dbo.EmailType_EmailTypeId]
GO
ALTER TABLE [dbo].[EmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmergencyContact_dbo.Relationship_RelationshipId] FOREIGN KEY([RelationshipId])
REFERENCES [dbo].[Relationship] ([RelationshipId])
GO
ALTER TABLE [dbo].[EmergencyContact] CHECK CONSTRAINT [FK_dbo.EmergencyContact_dbo.Relationship_RelationshipId]
GO
ALTER TABLE [dbo].[EmergencyContact]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmergencyContact_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmergencyContact] CHECK CONSTRAINT [FK_dbo.EmergencyContact_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[EmployeeAction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAction_dbo.ActionType_ActionTypeId] FOREIGN KEY([ActionTypeId])
REFERENCES [dbo].[ActionType] ([ActionTypeId])
GO
ALTER TABLE [dbo].[EmployeeAction] CHECK CONSTRAINT [FK_dbo.EmployeeAction_dbo.ActionType_ActionTypeId]
GO
ALTER TABLE [dbo].[EmployeeAction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAction_dbo.UserInformation_ApprovedById] FOREIGN KEY([ApprovedById])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeAction] CHECK CONSTRAINT [FK_dbo.EmployeeAction_dbo.UserInformation_ApprovedById]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.AppraisalResult_AppraisalResultId] FOREIGN KEY([AppraisalResultId])
REFERENCES [dbo].[AppraisalResult] ([AppraisalResultId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.AppraisalResult_AppraisalResultId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.AppraisalTemplate_AppraisalTemplateId] FOREIGN KEY([AppraisalTemplateId])
REFERENCES [dbo].[AppraisalTemplate] ([AppraisalTemplateId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.AppraisalTemplate_AppraisalTemplateId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Department_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Department_DepartmentId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.EmployeeType_EmployeeTypeId] FOREIGN KEY([EmployeeTypeId])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.EmployeeType_EmployeeTypeId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[EmployeeAppraisal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.SubDepartment_SubDepartmentId] FOREIGN KEY([SubDepartmentId])
REFERENCES [dbo].[SubDepartment] ([SubDepartmentId])
GO
ALTER TABLE [dbo].[EmployeeAppraisal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisal_dbo.SubDepartment_SubDepartmentId]
GO
ALTER TABLE [dbo].[EmployeeAppraisalDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisalDocument_dbo.EmployeeAppraisal_EmployeeAppraisalId] FOREIGN KEY([EmployeeAppraisalId])
REFERENCES [dbo].[EmployeeAppraisal] ([EmployeeAppraisalId])
GO
ALTER TABLE [dbo].[EmployeeAppraisalDocument] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisalDocument_dbo.EmployeeAppraisal_EmployeeAppraisalId]
GO
ALTER TABLE [dbo].[EmployeeAppraisalGoal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisalGoal_dbo.AppraisalGoal_AppraisalGoalId] FOREIGN KEY([AppraisalGoalId])
REFERENCES [dbo].[AppraisalGoal] ([AppraisalGoalId])
GO
ALTER TABLE [dbo].[EmployeeAppraisalGoal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisalGoal_dbo.AppraisalGoal_AppraisalGoalId]
GO
ALTER TABLE [dbo].[EmployeeAppraisalGoal]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisalGoal_dbo.EmployeeAppraisal_EmployeeAppraisalId] FOREIGN KEY([EmployeeAppraisalId])
REFERENCES [dbo].[EmployeeAppraisal] ([EmployeeAppraisalId])
GO
ALTER TABLE [dbo].[EmployeeAppraisalGoal] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisalGoal_dbo.EmployeeAppraisal_EmployeeAppraisalId]
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.AppraisalRatingScaleDetail_AppraisalRatingScaleDetailId] FOREIGN KEY([AppraisalRatingScaleDetailId])
REFERENCES [dbo].[AppraisalRatingScaleDetail] ([AppraisalRatingScaleDetailId])
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.AppraisalRatingScaleDetail_AppraisalRatingScaleDetailId]
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.AppraisalSkill_AppraisalSkillId] FOREIGN KEY([AppraisalSkillId])
REFERENCES [dbo].[AppraisalSkill] ([AppraisalSkillId])
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.AppraisalSkill_AppraisalSkillId]
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.EmployeeAppraisal_EmployeeAppraisalId] FOREIGN KEY([EmployeeAppraisalId])
REFERENCES [dbo].[EmployeeAppraisal] ([EmployeeAppraisalId])
GO
ALTER TABLE [dbo].[EmployeeAppraisalSkill] CHECK CONSTRAINT [FK_dbo.EmployeeAppraisalSkill_dbo.EmployeeAppraisal_EmployeeAppraisalId]
GO
ALTER TABLE [dbo].[EmployeeBenefitEnlisted]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeBenefitEnlisted_dbo.Benefit_BenefitId] FOREIGN KEY([BenefitId])
REFERENCES [dbo].[Benefit] ([BenefitId])
GO
ALTER TABLE [dbo].[EmployeeBenefitEnlisted] CHECK CONSTRAINT [FK_dbo.EmployeeBenefitEnlisted_dbo.Benefit_BenefitId]
GO
ALTER TABLE [dbo].[EmployeeBenefitHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeBenefitHistory_dbo.Benefit_BenefitId] FOREIGN KEY([BenefitId])
REFERENCES [dbo].[Benefit] ([BenefitId])
GO
ALTER TABLE [dbo].[EmployeeBenefitHistory] CHECK CONSTRAINT [FK_dbo.EmployeeBenefitHistory_dbo.Benefit_BenefitId]
GO
ALTER TABLE [dbo].[EmployeeBenefitHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeBenefitHistory_dbo.PayFrequency_PayFrequencyId] FOREIGN KEY([PayFrequencyId])
REFERENCES [dbo].[PayFrequency] ([PayFrequencyId])
GO
ALTER TABLE [dbo].[EmployeeBenefitHistory] CHECK CONSTRAINT [FK_dbo.EmployeeBenefitHistory_dbo.PayFrequency_PayFrequencyId]
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.Company_FromCompanyId] FOREIGN KEY([FromCompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer] CHECK CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.Company_FromCompanyId]
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.Company_ToCompanyId] FOREIGN KEY([ToCompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer] CHECK CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.Company_ToCompanyId]
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.UserInformation_FromUserInformationId] FOREIGN KEY([FromUserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer] CHECK CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.UserInformation_FromUserInformationId]
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.UserInformation_ToUserInformationId] FOREIGN KEY([ToUserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeCompanyTransfer] CHECK CONSTRAINT [FK_dbo.EmployeeCompanyTransfer_dbo.UserInformation_ToUserInformationId]
GO
ALTER TABLE [dbo].[EmployeeCompensation]  WITH CHECK ADD  CONSTRAINT [FK_CompanyCompensation_PeriodEntry] FOREIGN KEY([PeriodEntryId])
REFERENCES [dbo].[CompensationPeriodEntry] ([CompensationPeriodEntryId])
GO
ALTER TABLE [dbo].[EmployeeCompensation] CHECK CONSTRAINT [FK_CompanyCompensation_PeriodEntry]
GO
ALTER TABLE [dbo].[EmployeeCompensation]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeCompensation_CompanyCompensation] FOREIGN KEY([CompanyCompensationId])
REFERENCES [dbo].[CompanyCompensation] ([CompanyCompensationId])
GO
ALTER TABLE [dbo].[EmployeeCompensation] CHECK CONSTRAINT [FK_EmployeeCompensation_CompanyCompensation]
GO
ALTER TABLE [dbo].[EmployeeCompensation]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeCompensation_GLAccount] FOREIGN KEY([GLAccountId])
REFERENCES [dbo].[GLAccount] ([GLAccountId])
GO
ALTER TABLE [dbo].[EmployeeCompensation] CHECK CONSTRAINT [FK_EmployeeCompensation_GLAccount]
GO
ALTER TABLE [dbo].[EmployeeContribution]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeContribution_CompanyContribution] FOREIGN KEY([CompanyContributionId])
REFERENCES [dbo].[CompanyContribution] ([CompanyContributionId])
GO
ALTER TABLE [dbo].[EmployeeContribution] CHECK CONSTRAINT [FK_EmployeeContribution_CompanyContribution]
GO
ALTER TABLE [dbo].[EmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCredential_dbo.Credential_CredentialId] FOREIGN KEY([CredentialId])
REFERENCES [dbo].[Credential] ([CredentialId])
GO
ALTER TABLE [dbo].[EmployeeCredential] CHECK CONSTRAINT [FK_dbo.EmployeeCredential_dbo.Credential_CredentialId]
GO
ALTER TABLE [dbo].[EmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCredential_dbo.CredentialType_CredentialTypeId] FOREIGN KEY([CredentialTypeId])
REFERENCES [dbo].[CredentialType] ([CredentialTypeId])
GO
ALTER TABLE [dbo].[EmployeeCredential] CHECK CONSTRAINT [FK_dbo.EmployeeCredential_dbo.CredentialType_CredentialTypeId]
GO
ALTER TABLE [dbo].[EmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCredential_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeCredential] CHECK CONSTRAINT [FK_dbo.EmployeeCredential_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[EmployeeCustomField]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCustomField_dbo.CustomField_CustomFieldId] FOREIGN KEY([CustomFieldId])
REFERENCES [dbo].[CustomField] ([CustomFieldId])
GO
ALTER TABLE [dbo].[EmployeeCustomField] CHECK CONSTRAINT [FK_dbo.EmployeeCustomField_dbo.CustomField_CustomFieldId]
GO
ALTER TABLE [dbo].[EmployeeCustomField]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeCustomField_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeCustomField] CHECK CONSTRAINT [FK_dbo.EmployeeCustomField_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.CobraStatus_CobraStatusId] FOREIGN KEY([CobraStatusId])
REFERENCES [dbo].[CobraStatus] ([CobraStatusId])
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.CobraStatus_CobraStatusId]
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceCoverage_InsuranceCoverageId] FOREIGN KEY([InsuranceCoverageId])
REFERENCES [dbo].[InsuranceCoverage] ([InsuranceCoverageId])
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceCoverage_InsuranceCoverageId]
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceStatus_InsuranceStatusId] FOREIGN KEY([InsuranceStatusId])
REFERENCES [dbo].[InsuranceStatus] ([InsuranceStatusId])
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceStatus_InsuranceStatusId]
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceType_InsuranceTypeId] FOREIGN KEY([InsuranceTypeId])
REFERENCES [dbo].[InsuranceType] ([InsuranceTypeId])
GO
ALTER TABLE [dbo].[EmployeeDentalInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeDentalInsurance_dbo.InsuranceType_InsuranceTypeId]
GO
ALTER TABLE [dbo].[EmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDependent_dbo.DependentStatus_DependentStatusId] FOREIGN KEY([DependentStatusId])
REFERENCES [dbo].[DependentStatus] ([DependentStatusId])
GO
ALTER TABLE [dbo].[EmployeeDependent] CHECK CONSTRAINT [FK_dbo.EmployeeDependent_dbo.DependentStatus_DependentStatusId]
GO
ALTER TABLE [dbo].[EmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDependent_dbo.Gender_GenderId] FOREIGN KEY([GenderId])
REFERENCES [dbo].[Gender] ([GenderId])
GO
ALTER TABLE [dbo].[EmployeeDependent] CHECK CONSTRAINT [FK_dbo.EmployeeDependent_dbo.Gender_GenderId]
GO
ALTER TABLE [dbo].[EmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDependent_dbo.Relationship_RelationshipId] FOREIGN KEY([RelationshipId])
REFERENCES [dbo].[Relationship] ([RelationshipId])
GO
ALTER TABLE [dbo].[EmployeeDependent] CHECK CONSTRAINT [FK_dbo.EmployeeDependent_dbo.Relationship_RelationshipId]
GO
ALTER TABLE [dbo].[EmployeeDependent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDependent_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeDependent] CHECK CONSTRAINT [FK_dbo.EmployeeDependent_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[EmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDocument_dbo.Document_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[Document] ([DocumentId])
GO
ALTER TABLE [dbo].[EmployeeDocument] CHECK CONSTRAINT [FK_dbo.EmployeeDocument_dbo.Document_DocumentId]
GO
ALTER TABLE [dbo].[EmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeDocument_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeDocument] CHECK CONSTRAINT [FK_dbo.EmployeeDocument_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[EmployeeEducation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeEducation_dbo.Degree_DegreeId] FOREIGN KEY([DegreeId])
REFERENCES [dbo].[Degree] ([DegreeId])
GO
ALTER TABLE [dbo].[EmployeeEducation] CHECK CONSTRAINT [FK_dbo.EmployeeEducation_dbo.Degree_DegreeId]
GO
ALTER TABLE [dbo].[EmployeeEducation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeEducation_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeEducation] CHECK CONSTRAINT [FK_dbo.EmployeeEducation_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[EmployeeEmployeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeEmployeeGroup_EmployeeGroup] FOREIGN KEY([EmployeeGroupId])
REFERENCES [dbo].[EmployeeGroup] ([EmployeeGroupId])
GO
ALTER TABLE [dbo].[EmployeeEmployeeGroup] CHECK CONSTRAINT [FK_EmployeeEmployeeGroup_EmployeeGroup]
GO
ALTER TABLE [dbo].[EmployeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeGroup_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[EmployeeGroup] CHECK CONSTRAINT [FK_dbo.EmployeeGroup_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[EmployeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeGroup_dbo.EmployeeGroupType_EmployeeGroupTypeId] FOREIGN KEY([EmployeeGroupTypeId])
REFERENCES [dbo].[EmployeeGroupType] ([EmployeeGroupTypeId])
GO
ALTER TABLE [dbo].[EmployeeGroup] CHECK CONSTRAINT [FK_dbo.EmployeeGroup_dbo.EmployeeGroupType_EmployeeGroupTypeId]
GO
ALTER TABLE [dbo].[EmployeeHealthInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeHealthInsurance_dbo.CobraStatus_CobraStatusId] FOREIGN KEY([CobraStatusId])
REFERENCES [dbo].[CobraStatus] ([CobraStatusId])
GO
ALTER TABLE [dbo].[EmployeeHealthInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeHealthInsurance_dbo.CobraStatus_CobraStatusId]
GO
ALTER TABLE [dbo].[EmployeeHealthInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeHealthInsurance_dbo.InsuranceCoverage_InsuranceCoverageId] FOREIGN KEY([InsuranceCoverageId])
REFERENCES [dbo].[InsuranceCoverage] ([InsuranceCoverageId])
GO
ALTER TABLE [dbo].[EmployeeHealthInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeHealthInsurance_dbo.InsuranceCoverage_InsuranceCoverageId]
GO
ALTER TABLE [dbo].[EmployeeHealthInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeHealthInsurance_dbo.InsuranceStatus_InsuranceStatusId] FOREIGN KEY([InsuranceStatusId])
REFERENCES [dbo].[InsuranceStatus] ([InsuranceStatusId])
GO
ALTER TABLE [dbo].[EmployeeHealthInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeHealthInsurance_dbo.InsuranceStatus_InsuranceStatusId]
GO
ALTER TABLE [dbo].[EmployeeHealthInsurance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeHealthInsurance_dbo.InsuranceType_InsuranceTypeId] FOREIGN KEY([InsuranceTypeId])
REFERENCES [dbo].[InsuranceType] ([InsuranceTypeId])
GO
ALTER TABLE [dbo].[EmployeeHealthInsurance] CHECK CONSTRAINT [FK_dbo.EmployeeHealthInsurance_dbo.InsuranceType_InsuranceTypeId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentArea_IncidentAreaId] FOREIGN KEY([IncidentAreaId])
REFERENCES [dbo].[IncidentArea] ([IncidentAreaId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentArea_IncidentAreaId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentBodyPart_IncidentBodyPartId] FOREIGN KEY([IncidentBodyPartId])
REFERENCES [dbo].[IncidentBodyPart] ([IncidentBodyPartId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentBodyPart_IncidentBodyPartId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentInjuryDescription_IncidentInjuryDescriptionId] FOREIGN KEY([IncidentInjuryDescriptionId])
REFERENCES [dbo].[IncidentInjuryDescription] ([IncidentInjuryDescriptionId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentInjuryDescription_IncidentInjuryDescriptionId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentInjurySource_IncidentInjurySourceId] FOREIGN KEY([IncidentInjurySourceId])
REFERENCES [dbo].[IncidentInjurySource] ([IncidentInjurySourceId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentInjurySource_IncidentInjurySourceId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentTreatmentFacility_IncidentTreatmentFacilityId] FOREIGN KEY([IncidentTreatmentFacilityId])
REFERENCES [dbo].[IncidentTreatmentFacility] ([IncidentTreatmentFacilityId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentTreatmentFacility_IncidentTreatmentFacilityId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentType_IncidentTypeId] FOREIGN KEY([IncidentTypeId])
REFERENCES [dbo].[IncidentType] ([IncidentTypeId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.IncidentType_IncidentTypeId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.OSHACaseClassification_OSHACaseClassificationId] FOREIGN KEY([OSHACaseClassificationId])
REFERENCES [dbo].[OSHACaseClassification] ([OSHACaseClassificationId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.OSHACaseClassification_OSHACaseClassificationId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.OSHAInjuryClassification_OSHAInjuryClassificationId] FOREIGN KEY([OSHAInjuryClassificationId])
REFERENCES [dbo].[OSHAInjuryClassification] ([OSHAInjuryClassificationId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.OSHAInjuryClassification_OSHAInjuryClassificationId]
GO
ALTER TABLE [dbo].[EmployeeIncident]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeIncident_dbo.UserInformation_CompletedById] FOREIGN KEY([CompletedById])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeIncident] CHECK CONSTRAINT [FK_dbo.EmployeeIncident_dbo.UserInformation_CompletedById]
GO
ALTER TABLE [dbo].[EmployeeNotification]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeNotification_dbo.EmployeeNotificationType_EmployeeNotificationTypeId] FOREIGN KEY([EmployeeNotificationTypeId])
REFERENCES [dbo].[EmployeeNotificationType] ([EmployeeNotificationTypeId])
GO
ALTER TABLE [dbo].[EmployeeNotification] CHECK CONSTRAINT [FK_dbo.EmployeeNotification_dbo.EmployeeNotificationType_EmployeeNotificationTypeId]
GO
ALTER TABLE [dbo].[EmployeeNotification]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeNotification_dbo.NotificationSchedule_NotificationScheduleId] FOREIGN KEY([NotificationScheduleId])
REFERENCES [dbo].[NotificationSchedule] ([NotificationScheduleId])
GO
ALTER TABLE [dbo].[EmployeeNotification] CHECK CONSTRAINT [FK_dbo.EmployeeNotification_dbo.NotificationSchedule_NotificationScheduleId]
GO
ALTER TABLE [dbo].[EmployeePayroll]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayroll_EmployeePayrollStatus] FOREIGN KEY([EmployeePayrollStatusId])
REFERENCES [dbo].[EmployeePayrollStatus] ([EmployeePayrollStatusId])
GO
ALTER TABLE [dbo].[EmployeePayroll] CHECK CONSTRAINT [FK_EmployeePayroll_EmployeePayrollStatus]
GO
ALTER TABLE [dbo].[EmployeePayroll]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayroll_Payroll] FOREIGN KEY([PayrollId])
REFERENCES [dbo].[Payroll] ([PayrollId])
GO
ALTER TABLE [dbo].[EmployeePayroll] CHECK CONSTRAINT [FK_EmployeePayroll_Payroll]
GO
ALTER TABLE [dbo].[EmployeePayroll]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayroll_UserInformation] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeePayroll] CHECK CONSTRAINT [FK_EmployeePayroll_UserInformation]
GO
ALTER TABLE [dbo].[EmployeePayrollCheck]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayCheck_Payroll] FOREIGN KEY([PayrollId])
REFERENCES [dbo].[Payroll] ([PayrollId])
GO
ALTER TABLE [dbo].[EmployeePayrollCheck] CHECK CONSTRAINT [FK_EmployeePayCheck_Payroll]
GO
ALTER TABLE [dbo].[EmployeePayrollCheck]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayCheck_UserInformation] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeePayrollCheck] CHECK CONSTRAINT [FK_EmployeePayCheck_UserInformation]
GO
ALTER TABLE [dbo].[EmployeePayrollCompensation]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollCompensation_CompanyCompensation] FOREIGN KEY([CompanyCompensationId])
REFERENCES [dbo].[CompanyCompensation] ([CompanyCompensationId])
GO
ALTER TABLE [dbo].[EmployeePayrollCompensation] CHECK CONSTRAINT [FK_EmployeePayrollCompensation_CompanyCompensation]
GO
ALTER TABLE [dbo].[EmployeePayrollCompensation]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollCompensation_Payroll] FOREIGN KEY([PayrollId])
REFERENCES [dbo].[Payroll] ([PayrollId])
GO
ALTER TABLE [dbo].[EmployeePayrollCompensation] CHECK CONSTRAINT [FK_EmployeePayrollCompensation_Payroll]
GO
ALTER TABLE [dbo].[EmployeePayrollCompensation]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollCompensation_UserInformation] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeePayrollCompensation] CHECK CONSTRAINT [FK_EmployeePayrollCompensation_UserInformation]
GO
ALTER TABLE [dbo].[EmployeePayrollCompensationManual]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollCompensationManual_CompanyCompensation] FOREIGN KEY([CompanyCompensationId])
REFERENCES [dbo].[CompanyCompensation] ([CompanyCompensationId])
GO
ALTER TABLE [dbo].[EmployeePayrollCompensationManual] CHECK CONSTRAINT [FK_EmployeePayrollCompensationManual_CompanyCompensation]
GO
ALTER TABLE [dbo].[EmployeePayrollCompensationManual]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollCompensationManual_Payroll] FOREIGN KEY([PayrollId])
REFERENCES [dbo].[Payroll] ([PayrollId])
GO
ALTER TABLE [dbo].[EmployeePayrollCompensationManual] CHECK CONSTRAINT [FK_EmployeePayrollCompensationManual_Payroll]
GO
ALTER TABLE [dbo].[EmployeePayrollCompensationManual]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollCompensationManual_UserInformation] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeePayrollCompensationManual] CHECK CONSTRAINT [FK_EmployeePayrollCompensationManual_UserInformation]
GO
ALTER TABLE [dbo].[EmployeePayrollContribution]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollContribution_CompanyContribution] FOREIGN KEY([CompanyContributionId])
REFERENCES [dbo].[CompanyContribution] ([CompanyContributionId])
GO
ALTER TABLE [dbo].[EmployeePayrollContribution] CHECK CONSTRAINT [FK_EmployeePayrollContribution_CompanyContribution]
GO
ALTER TABLE [dbo].[EmployeePayrollContribution]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollContribution_Payroll] FOREIGN KEY([PayrollId])
REFERENCES [dbo].[Payroll] ([PayrollId])
GO
ALTER TABLE [dbo].[EmployeePayrollContribution] CHECK CONSTRAINT [FK_EmployeePayrollContribution_Payroll]
GO
ALTER TABLE [dbo].[EmployeePayrollContribution]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollContribution_UserInformation] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeePayrollContribution] CHECK CONSTRAINT [FK_EmployeePayrollContribution_UserInformation]
GO
ALTER TABLE [dbo].[EmployeePayrollTransaction]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollTransaction_Payroll] FOREIGN KEY([PayrollId])
REFERENCES [dbo].[Payroll] ([PayrollId])
GO
ALTER TABLE [dbo].[EmployeePayrollTransaction] CHECK CONSTRAINT [FK_EmployeePayrollTransaction_Payroll]
GO
ALTER TABLE [dbo].[EmployeePayrollTransaction]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollTransaction_Transaction] FOREIGN KEY([TransactionId])
REFERENCES [dbo].[Transaction] ([TransactionId])
GO
ALTER TABLE [dbo].[EmployeePayrollTransaction] CHECK CONSTRAINT [FK_EmployeePayrollTransaction_Transaction]
GO
ALTER TABLE [dbo].[EmployeePayrollTransaction]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollTransaction_UserInformation] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeePayrollTransaction] CHECK CONSTRAINT [FK_EmployeePayrollTransaction_UserInformation]
GO
ALTER TABLE [dbo].[EmployeePayrollWithholding]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollWithholding_CompanyWithholding] FOREIGN KEY([CompanyWithholdingId])
REFERENCES [dbo].[CompanyWithholding] ([CompanyWithholdingId])
GO
ALTER TABLE [dbo].[EmployeePayrollWithholding] CHECK CONSTRAINT [FK_EmployeePayrollWithholding_CompanyWithholding]
GO
ALTER TABLE [dbo].[EmployeePayrollWithholding]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollWithholding_Payroll] FOREIGN KEY([PayrollId])
REFERENCES [dbo].[Payroll] ([PayrollId])
GO
ALTER TABLE [dbo].[EmployeePayrollWithholding] CHECK CONSTRAINT [FK_EmployeePayrollWithholding_Payroll]
GO
ALTER TABLE [dbo].[EmployeePayrollWithholding]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollWithholding_UserInformation] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeePayrollWithholding] CHECK CONSTRAINT [FK_EmployeePayrollWithholding_UserInformation]
GO
ALTER TABLE [dbo].[EmployeePayrollWithholdingManual]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollWithholdingManual_CompanyWithholding] FOREIGN KEY([CompanyWithholdingId])
REFERENCES [dbo].[CompanyWithholding] ([CompanyWithholdingId])
GO
ALTER TABLE [dbo].[EmployeePayrollWithholdingManual] CHECK CONSTRAINT [FK_EmployeePayrollWithholdingManual_CompanyWithholding]
GO
ALTER TABLE [dbo].[EmployeePayrollWithholdingManual]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollWithholdingManual_Payroll] FOREIGN KEY([PayrollId])
REFERENCES [dbo].[Payroll] ([PayrollId])
GO
ALTER TABLE [dbo].[EmployeePayrollWithholdingManual] CHECK CONSTRAINT [FK_EmployeePayrollWithholdingManual_Payroll]
GO
ALTER TABLE [dbo].[EmployeePayrollWithholdingManual]  WITH CHECK ADD  CONSTRAINT [FK_EmployeePayrollWithholdingManual_UserInformation] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeePayrollWithholdingManual] CHECK CONSTRAINT [FK_EmployeePayrollWithholdingManual_UserInformation]
GO
ALTER TABLE [dbo].[EmployeePerformance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeePerformance_dbo.ActionTaken_ActionTakenId] FOREIGN KEY([ActionTakenId])
REFERENCES [dbo].[ActionTaken] ([ActionTakenId])
GO
ALTER TABLE [dbo].[EmployeePerformance] CHECK CONSTRAINT [FK_dbo.EmployeePerformance_dbo.ActionTaken_ActionTakenId]
GO
ALTER TABLE [dbo].[EmployeePerformance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeePerformance_dbo.PerformanceDescription_PerformanceDescriptionId] FOREIGN KEY([PerformanceDescriptionId])
REFERENCES [dbo].[PerformanceDescription] ([PerformanceDescriptionId])
GO
ALTER TABLE [dbo].[EmployeePerformance] CHECK CONSTRAINT [FK_dbo.EmployeePerformance_dbo.PerformanceDescription_PerformanceDescriptionId]
GO
ALTER TABLE [dbo].[EmployeePerformance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeePerformance_dbo.PerformanceResult_PerformanceResultId] FOREIGN KEY([PerformanceResultId])
REFERENCES [dbo].[PerformanceResult] ([PerformanceResultId])
GO
ALTER TABLE [dbo].[EmployeePerformance] CHECK CONSTRAINT [FK_dbo.EmployeePerformance_dbo.PerformanceResult_PerformanceResultId]
GO
ALTER TABLE [dbo].[EmployeePerformance]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeePerformance_dbo.UserInformation_SupervisorId] FOREIGN KEY([SupervisorId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeePerformance] CHECK CONSTRAINT [FK_dbo.EmployeePerformance_dbo.UserInformation_SupervisorId]
GO
ALTER TABLE [dbo].[EmployeeSupervisor]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeSupervisor_dbo.UserInformation_EmployeeUserId] FOREIGN KEY([EmployeeUserId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeSupervisor] CHECK CONSTRAINT [FK_dbo.EmployeeSupervisor_dbo.UserInformation_EmployeeUserId]
GO
ALTER TABLE [dbo].[EmployeeSupervisor]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeSupervisor_dbo.UserInformation_SupervisorUserId] FOREIGN KEY([SupervisorUserId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeSupervisor] CHECK CONSTRAINT [FK_dbo.EmployeeSupervisor_dbo.UserInformation_SupervisorUserId]
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeTimeOffRequest_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequest] CHECK CONSTRAINT [FK_dbo.EmployeeTimeOffRequest_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeTimeOffRequest_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequest] CHECK CONSTRAINT [FK_dbo.EmployeeTimeOffRequest_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequestDocument]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeTimeOffRequestDocument_EmployeeTimeOffRequest] FOREIGN KEY([EmployeeTimeOffRequestId])
REFERENCES [dbo].[EmployeeTimeOffRequest] ([EmployeeTimeOffRequestId])
GO
ALTER TABLE [dbo].[EmployeeTimeOffRequestDocument] CHECK CONSTRAINT [FK_EmployeeTimeOffRequestDocument_EmployeeTimeOffRequest]
GO
ALTER TABLE [dbo].[EmployeeTraining]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeTraining_dbo.Training_TrainingId] FOREIGN KEY([TrainingId])
REFERENCES [dbo].[Training] ([TrainingId])
GO
ALTER TABLE [dbo].[EmployeeTraining] CHECK CONSTRAINT [FK_dbo.EmployeeTraining_dbo.Training_TrainingId]
GO
ALTER TABLE [dbo].[EmployeeTraining]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeTraining_dbo.TrainingType_TrainingTypeId] FOREIGN KEY([TrainingTypeId])
REFERENCES [dbo].[TrainingType] ([TrainingTypeId])
GO
ALTER TABLE [dbo].[EmployeeTraining] CHECK CONSTRAINT [FK_dbo.EmployeeTraining_dbo.TrainingType_TrainingTypeId]
GO
ALTER TABLE [dbo].[EmployeeTraining]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeTraining_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeTraining] CHECK CONSTRAINT [FK_dbo.EmployeeTraining_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[EmployeeVeteranStatus]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeVeteranStatus_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmployeeVeteranStatus] CHECK CONSTRAINT [FK_dbo.EmployeeVeteranStatus_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[EmployeeVeteranStatus]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmployeeVeteranStatus_dbo.VeteranStatus_VeteranStatusId] FOREIGN KEY([VeteranStatusId])
REFERENCES [dbo].[VeteranStatus] ([VeteranStatusId])
GO
ALTER TABLE [dbo].[EmployeeVeteranStatus] CHECK CONSTRAINT [FK_dbo.EmployeeVeteranStatus_dbo.VeteranStatus_VeteranStatusId]
GO
ALTER TABLE [dbo].[Employment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Employment_dbo.EmploymentStatus_EmploymentStatusId] FOREIGN KEY([EmploymentStatusId])
REFERENCES [dbo].[EmploymentStatus] ([EmploymentStatusId])
GO
ALTER TABLE [dbo].[Employment] CHECK CONSTRAINT [FK_dbo.Employment_dbo.EmploymentStatus_EmploymentStatusId]
GO
ALTER TABLE [dbo].[Employment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Employment_dbo.TerminationEligibility_TerminationEligibilityId] FOREIGN KEY([TerminationEligibilityId])
REFERENCES [dbo].[TerminationEligibility] ([TerminationEligibilityId])
GO
ALTER TABLE [dbo].[Employment] CHECK CONSTRAINT [FK_dbo.Employment_dbo.TerminationEligibility_TerminationEligibilityId]
GO
ALTER TABLE [dbo].[Employment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Employment_dbo.TerminationReason_TerminationReasonId] FOREIGN KEY([TerminationReasonId])
REFERENCES [dbo].[TerminationReason] ([TerminationReasonId])
GO
ALTER TABLE [dbo].[Employment] CHECK CONSTRAINT [FK_dbo.Employment_dbo.TerminationReason_TerminationReasonId]
GO
ALTER TABLE [dbo].[Employment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Employment_dbo.TerminationType_TerminationTypeId] FOREIGN KEY([TerminationTypeId])
REFERENCES [dbo].[TerminationType] ([TerminationTypeId])
GO
ALTER TABLE [dbo].[Employment] CHECK CONSTRAINT [FK_dbo.Employment_dbo.TerminationType_TerminationTypeId]
GO
ALTER TABLE [dbo].[Employment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Employment_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[Employment] CHECK CONSTRAINT [FK_dbo.Employment_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Department_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Department_DepartmentId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.EmployeeType_EmployeeTypeId] FOREIGN KEY([EmployeeTypeId])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.EmployeeType_EmployeeTypeId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Employment_EmploymentId] FOREIGN KEY([EmploymentId])
REFERENCES [dbo].[Employment] ([EmploymentId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Employment_EmploymentId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.EmploymentType_EmploymentTypeId] FOREIGN KEY([EmploymentTypeId])
REFERENCES [dbo].[EmploymentType] ([EmploymentTypeId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.EmploymentType_EmploymentTypeId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.SubDepartment_SubDepartmentId] FOREIGN KEY([SubDepartmentId])
REFERENCES [dbo].[SubDepartment] ([SubDepartmentId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.SubDepartment_SubDepartmentId]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.UserInformation_UserInformation_Id] FOREIGN KEY([UserInformation_Id])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.UserInformation_UserInformation_Id]
GO
ALTER TABLE [dbo].[EmploymentHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistory_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[EmploymentHistory] CHECK CONSTRAINT [FK_dbo.EmploymentHistory_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[EmploymentHistoryAuthorizer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentHistoryAuthorizer_dbo.EmploymentHistory_EmploymentHistoryId] FOREIGN KEY([EmploymentHistoryId])
REFERENCES [dbo].[EmploymentHistory] ([EmploymentHistoryId])
GO
ALTER TABLE [dbo].[EmploymentHistoryAuthorizer] CHECK CONSTRAINT [FK_dbo.EmploymentHistoryAuthorizer_dbo.EmploymentHistory_EmploymentHistoryId]
GO
ALTER TABLE [dbo].[EmploymentStatus]  WITH CHECK ADD  CONSTRAINT [FK_dbo.EmploymentStatus_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[EmploymentStatus] CHECK CONSTRAINT [FK_dbo.EmploymentStatus_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[Form]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Form_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[Form] CHECK CONSTRAINT [FK_dbo.Form_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[Form]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Form_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[Form] CHECK CONSTRAINT [FK_dbo.Form_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[Form]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Form_dbo.Module_ModuleId] FOREIGN KEY([ModuleId])
REFERENCES [dbo].[Module] ([ModuleId])
GO
ALTER TABLE [dbo].[Form] CHECK CONSTRAINT [FK_dbo.Form_dbo.Module_ModuleId]
GO
ALTER TABLE [dbo].[GLAccount]  WITH CHECK ADD  CONSTRAINT [FK_dbo.GLAccount_dbo.GLAccountType_GLAccountTypeId] FOREIGN KEY([GLAccountTypeId])
REFERENCES [dbo].[GLAccountType] ([GLAccountTypeId])
GO
ALTER TABLE [dbo].[GLAccount] CHECK CONSTRAINT [FK_dbo.GLAccount_dbo.GLAccountType_GLAccountTypeId]
GO
ALTER TABLE [dbo].[HealthInsuranceCobraHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.HealthInsuranceCobraHistory_dbo.CobraPaymentStatus_CobraPaymentStatusId] FOREIGN KEY([CobraPaymentStatusId])
REFERENCES [dbo].[CobraPaymentStatus] ([CobraPaymentStatusId])
GO
ALTER TABLE [dbo].[HealthInsuranceCobraHistory] CHECK CONSTRAINT [FK_dbo.HealthInsuranceCobraHistory_dbo.CobraPaymentStatus_CobraPaymentStatusId]
GO
ALTER TABLE [dbo].[HealthInsuranceCobraHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.HealthInsuranceCobraHistory_dbo.EmployeeHealthInsurance_EmployeeHealthInsuranceId] FOREIGN KEY([EmployeeHealthInsuranceId])
REFERENCES [dbo].[EmployeeHealthInsurance] ([EmployeeHealthInsuranceId])
GO
ALTER TABLE [dbo].[HealthInsuranceCobraHistory] CHECK CONSTRAINT [FK_dbo.HealthInsuranceCobraHistory_dbo.EmployeeHealthInsurance_EmployeeHealthInsuranceId]
GO
ALTER TABLE [dbo].[IncidentTreatmentFacility]  WITH CHECK ADD  CONSTRAINT [FK_dbo.IncidentTreatmentFacility_dbo.City_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[IncidentTreatmentFacility] CHECK CONSTRAINT [FK_dbo.IncidentTreatmentFacility_dbo.City_CityId]
GO
ALTER TABLE [dbo].[IncidentTreatmentFacility]  WITH CHECK ADD  CONSTRAINT [FK_dbo.IncidentTreatmentFacility_dbo.State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[IncidentTreatmentFacility] CHECK CONSTRAINT [FK_dbo.IncidentTreatmentFacility_dbo.State_StateId]
GO
ALTER TABLE [dbo].[InterfaceControl]  WITH CHECK ADD  CONSTRAINT [FK_dbo.InterfaceControl_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[InterfaceControl] CHECK CONSTRAINT [FK_dbo.InterfaceControl_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[InterfaceControl]  WITH CHECK ADD  CONSTRAINT [FK_dbo.InterfaceControl_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[InterfaceControl] CHECK CONSTRAINT [FK_dbo.InterfaceControl_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[InterfaceControlForm]  WITH CHECK ADD  CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[InterfaceControlForm] CHECK CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[InterfaceControlForm]  WITH CHECK ADD  CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[InterfaceControlForm] CHECK CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[InterfaceControlForm]  WITH CHECK ADD  CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.Form_FormId] FOREIGN KEY([FormId])
REFERENCES [dbo].[Form] ([FormId])
GO
ALTER TABLE [dbo].[InterfaceControlForm] CHECK CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.Form_FormId]
GO
ALTER TABLE [dbo].[InterfaceControlForm]  WITH CHECK ADD  CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.InterfaceControl_InterfaceControlId] FOREIGN KEY([InterfaceControlId])
REFERENCES [dbo].[InterfaceControl] ([InterfaceControlId])
GO
ALTER TABLE [dbo].[InterfaceControlForm] CHECK CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.InterfaceControl_InterfaceControlId]
GO
ALTER TABLE [dbo].[InterfaceControlForm]  WITH CHECK ADD  CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.Module_ModuleId] FOREIGN KEY([ModuleId])
REFERENCES [dbo].[Module] ([ModuleId])
GO
ALTER TABLE [dbo].[InterfaceControlForm] CHECK CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.Module_ModuleId]
GO
ALTER TABLE [dbo].[InterfaceControlForm]  WITH CHECK ADD  CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.Privilege_PrivilegeId] FOREIGN KEY([PrivilegeId])
REFERENCES [dbo].[Privilege] ([PrivilegeId])
GO
ALTER TABLE [dbo].[InterfaceControlForm] CHECK CONSTRAINT [FK_dbo.InterfaceControlForm_dbo.Privilege_PrivilegeId]
GO
ALTER TABLE [dbo].[JobCode]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobCode_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[JobCode] CHECK CONSTRAINT [FK_dbo.JobCode_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[JobPostingDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Department_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[JobPostingDetail] CHECK CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Department_DepartmentId]
GO
ALTER TABLE [dbo].[JobPostingDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingDetail_dbo.EmploymentType_EmploymentTypeId] FOREIGN KEY([EmploymentTypeId])
REFERENCES [dbo].[EmploymentType] ([EmploymentTypeId])
GO
ALTER TABLE [dbo].[JobPostingDetail] CHECK CONSTRAINT [FK_dbo.JobPostingDetail_dbo.EmploymentType_EmploymentTypeId]
GO
ALTER TABLE [dbo].[JobPostingDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingDetail_dbo.JobPostingStatus_JobPostingStatusId] FOREIGN KEY([JobPostingStatusId])
REFERENCES [dbo].[JobPostingStatus] ([JobPostingStatusId])
GO
ALTER TABLE [dbo].[JobPostingDetail] CHECK CONSTRAINT [FK_dbo.JobPostingDetail_dbo.JobPostingStatus_JobPostingStatusId]
GO
ALTER TABLE [dbo].[JobPostingDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO
ALTER TABLE [dbo].[JobPostingDetail] CHECK CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[JobPostingDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[JobPostingDetail] CHECK CONSTRAINT [FK_dbo.JobPostingDetail_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[JobPostingLocation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingLocation_dbo.JobPostingDetail] FOREIGN KEY([JobPostingDetailId])
REFERENCES [dbo].[JobPostingDetail] ([JobPostingDetailId])
GO
ALTER TABLE [dbo].[JobPostingLocation] CHECK CONSTRAINT [FK_dbo.JobPostingLocation_dbo.JobPostingDetail]
GO
ALTER TABLE [dbo].[JobPostingLocation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.JobPostingLocation_dbo.Location_LocationId] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Location] ([LocationId])
GO
ALTER TABLE [dbo].[JobPostingLocation] CHECK CONSTRAINT [FK_dbo.JobPostingLocation_dbo.Location_LocationId]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Location_dbo.City_CityId] FOREIGN KEY([LocationCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_dbo.Location_dbo.City_CityId]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Location_dbo.Country_CountryId] FOREIGN KEY([LocationCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_dbo.Location_dbo.Country_CountryId]
GO
ALTER TABLE [dbo].[Location]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Location_dbo.State_StateId] FOREIGN KEY([LocationStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[Location] CHECK CONSTRAINT [FK_dbo.Location_dbo.State_StateId]
GO
ALTER TABLE [dbo].[Module]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Module_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[Module] CHECK CONSTRAINT [FK_dbo.Module_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[Module]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Module_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[Module] CHECK CONSTRAINT [FK_dbo.Module_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[Module]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Module_dbo.Module_ParentModuleId] FOREIGN KEY([ParentModuleId])
REFERENCES [dbo].[Module] ([ModuleId])
GO
ALTER TABLE [dbo].[Module] CHECK CONSTRAINT [FK_dbo.Module_dbo.Module_ParentModuleId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.ChangeRequestAddress_ChangeRequestAddressId] FOREIGN KEY([ChangeRequestAddressId])
REFERENCES [dbo].[ChangeRequestAddress] ([ChangeRequestAddressId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.ChangeRequestAddress_ChangeRequestAddressId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeAction_EmployeeActionId] FOREIGN KEY([EmployeeActionId])
REFERENCES [dbo].[EmployeeAction] ([EmployeeActionId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeAction_EmployeeActionId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeBenefitHistory_EmployeeBenefitHistoryId] FOREIGN KEY([EmployeeBenefitHistoryId])
REFERENCES [dbo].[EmployeeBenefitHistory] ([EmployeeBenefitHistoryId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeBenefitHistory_EmployeeBenefitHistoryId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeCredential_EmployeeCredentialId] FOREIGN KEY([EmployeeCredentialId])
REFERENCES [dbo].[EmployeeCredential] ([EmployeeCredentialId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeCredential_EmployeeCredentialId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeCustomField_EmployeeCustomFieldId] FOREIGN KEY([EmployeeCustomFieldId])
REFERENCES [dbo].[EmployeeCustomField] ([EmployeeCustomFieldId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeCustomField_EmployeeCustomFieldId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeDentalInsurance_EmployeeDentalInsuranceId] FOREIGN KEY([EmployeeDentalInsuranceId])
REFERENCES [dbo].[EmployeeDentalInsurance] ([EmployeeDentalInsuranceId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeDentalInsurance_EmployeeDentalInsuranceId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeDocument_EmployeeDocumentId] FOREIGN KEY([EmployeeDocumentId])
REFERENCES [dbo].[EmployeeDocument] ([EmployeeDocumentId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeDocument_EmployeeDocumentId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeHealthInsurance_EmployeeHealthInsuranceId] FOREIGN KEY([EmployeeHealthInsuranceId])
REFERENCES [dbo].[EmployeeHealthInsurance] ([EmployeeHealthInsuranceId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeHealthInsurance_EmployeeHealthInsuranceId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeePerformance_EmployeePerformanceId] FOREIGN KEY([EmployeePerformanceId])
REFERENCES [dbo].[EmployeePerformance] ([EmployeePerformanceId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeePerformance_EmployeePerformanceId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeTraining_EmployeeTrainingId] FOREIGN KEY([EmployeeTrainingId])
REFERENCES [dbo].[EmployeeTraining] ([EmployeeTrainingId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.EmployeeTraining_EmployeeTrainingId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.Employment_EmploymentId] FOREIGN KEY([EmploymentId])
REFERENCES [dbo].[Employment] ([EmploymentId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.Employment_EmploymentId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.NotificationScheduleDetail_NotificationScheduleDetailId] FOREIGN KEY([NotificationScheduleDetailId])
REFERENCES [dbo].[NotificationScheduleDetail] ([NotificationScheduleDetailId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.NotificationScheduleDetail_NotificationScheduleDetailId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.NotificationType_NotificationTypeId] FOREIGN KEY([NotificationTypeId])
REFERENCES [dbo].[NotificationType] ([NotificationTypeId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.NotificationType_NotificationTypeId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.UserInformation_ReferredUserInformationId] FOREIGN KEY([ReferredUserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.UserInformation_ReferredUserInformationId]
GO
ALTER TABLE [dbo].[NotificationLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLog_dbo.UserInformationActivation_UserInformationActivationId] FOREIGN KEY([UserInformationActivationId])
REFERENCES [dbo].[UserInformationActivation] ([UserInformationActivationId])
GO
ALTER TABLE [dbo].[NotificationLog] CHECK CONSTRAINT [FK_dbo.NotificationLog_dbo.UserInformationActivation_UserInformationActivationId]
GO
ALTER TABLE [dbo].[NotificationLogEmail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLogEmail_dbo.NotificationLog_NotificationLogId] FOREIGN KEY([NotificationLogId])
REFERENCES [dbo].[NotificationLog] ([NotificationLogId])
GO
ALTER TABLE [dbo].[NotificationLogEmail] CHECK CONSTRAINT [FK_dbo.NotificationLogEmail_dbo.NotificationLog_NotificationLogId]
GO
ALTER TABLE [dbo].[NotificationLogMessageReadBy]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLogMessageReadBy_dbo.NotificationLog_NotificationLogId] FOREIGN KEY([NotificationLogId])
REFERENCES [dbo].[NotificationLog] ([NotificationLogId])
GO
ALTER TABLE [dbo].[NotificationLogMessageReadBy] CHECK CONSTRAINT [FK_dbo.NotificationLogMessageReadBy_dbo.NotificationLog_NotificationLogId]
GO
ALTER TABLE [dbo].[NotificationLogMessageReadBy]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationLogMessageReadBy_dbo.UserInformation_ReadById] FOREIGN KEY([ReadById])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[NotificationLogMessageReadBy] CHECK CONSTRAINT [FK_dbo.NotificationLogMessageReadBy_dbo.UserInformation_ReadById]
GO
ALTER TABLE [dbo].[NotificationScheduleDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationScheduleDetail_dbo.NotificationMessage_NotificationMessageId] FOREIGN KEY([NotificationMessageId])
REFERENCES [dbo].[NotificationMessage] ([NotificationMessageId])
GO
ALTER TABLE [dbo].[NotificationScheduleDetail] CHECK CONSTRAINT [FK_dbo.NotificationScheduleDetail_dbo.NotificationMessage_NotificationMessageId]
GO
ALTER TABLE [dbo].[NotificationScheduleDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationScheduleDetail_dbo.NotificationSchedule_NotificationScheduleId] FOREIGN KEY([NotificationScheduleId])
REFERENCES [dbo].[NotificationSchedule] ([NotificationScheduleId])
GO
ALTER TABLE [dbo].[NotificationScheduleDetail] CHECK CONSTRAINT [FK_dbo.NotificationScheduleDetail_dbo.NotificationSchedule_NotificationScheduleId]
GO
ALTER TABLE [dbo].[NotificationScheduleEmployeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationScheduleEmployeeGroup_dbo.EmployeeGroup_EmployeeGroupId] FOREIGN KEY([EmployeeGroupId])
REFERENCES [dbo].[EmployeeGroup] ([EmployeeGroupId])
GO
ALTER TABLE [dbo].[NotificationScheduleEmployeeGroup] CHECK CONSTRAINT [FK_dbo.NotificationScheduleEmployeeGroup_dbo.EmployeeGroup_EmployeeGroupId]
GO
ALTER TABLE [dbo].[NotificationScheduleEmployeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.NotificationScheduleEmployeeGroup_dbo.NotificationScheduleDetail_NotificationScheduleDetailId] FOREIGN KEY([NotificationScheduleDetailId])
REFERENCES [dbo].[NotificationScheduleDetail] ([NotificationScheduleDetailId])
GO
ALTER TABLE [dbo].[NotificationScheduleEmployeeGroup] CHECK CONSTRAINT [FK_dbo.NotificationScheduleEmployeeGroup_dbo.NotificationScheduleDetail_NotificationScheduleDetailId]
GO
ALTER TABLE [dbo].[PassswordResetCode]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PassswordResetCode_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[PassswordResetCode] CHECK CONSTRAINT [FK_dbo.PassswordResetCode_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.EEOCategory_EEOCategoryId] FOREIGN KEY([EEOCategoryId])
REFERENCES [dbo].[EEOCategory] ([EEOCategoryId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.EEOCategory_EEOCategoryId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.Employment_EmploymentId] FOREIGN KEY([EmploymentId])
REFERENCES [dbo].[Employment] ([EmploymentId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.Employment_EmploymentId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayFrequency_PayFrequencyId] FOREIGN KEY([PayFrequencyId])
REFERENCES [dbo].[PayFrequency] ([PayFrequencyId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayFrequency_PayFrequencyId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayScale_PayScaleId] FOREIGN KEY([PayScaleId])
REFERENCES [dbo].[PayScale] ([PayScaleId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayScale_PayScaleId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayType_PayTypeId] FOREIGN KEY([PayTypeId])
REFERENCES [dbo].[PayType] ([PayTypeId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.PayType_PayTypeId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.RateFrequency_CommRateFrequencyId] FOREIGN KEY([CommRateFrequencyId])
REFERENCES [dbo].[RateFrequency] ([RateFrequencyId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.RateFrequency_CommRateFrequencyId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.RateFrequency_RateFrequencyId] FOREIGN KEY([RateFrequencyId])
REFERENCES [dbo].[RateFrequency] ([RateFrequencyId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.RateFrequency_RateFrequencyId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[PayInformationHistory]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistory_dbo.WCClassCode_WCClassCodeId] FOREIGN KEY([WCClassCodeId])
REFERENCES [dbo].[WCClassCode] ([WCClassCodeId])
GO
ALTER TABLE [dbo].[PayInformationHistory] CHECK CONSTRAINT [FK_dbo.PayInformationHistory_dbo.WCClassCode_WCClassCodeId]
GO
ALTER TABLE [dbo].[PayInformationHistoryAuthorizer]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayInformationHistoryAuthorizer_dbo.PayInformationHistory_PayInformationHistoryId] FOREIGN KEY([PayInformationHistoryId])
REFERENCES [dbo].[PayInformationHistory] ([PayInformationHistoryId])
GO
ALTER TABLE [dbo].[PayInformationHistoryAuthorizer] CHECK CONSTRAINT [FK_dbo.PayInformationHistoryAuthorizer_dbo.PayInformationHistory_PayInformationHistoryId]
GO
ALTER TABLE [dbo].[Payroll]  WITH CHECK ADD  CONSTRAINT [FK_Payroll_PayrollStatus] FOREIGN KEY([PayrollStatusId])
REFERENCES [dbo].[PayrollStatus] ([PayrollStatusId])
GO
ALTER TABLE [dbo].[Payroll] CHECK CONSTRAINT [FK_Payroll_PayrollStatus]
GO
ALTER TABLE [dbo].[Payroll]  WITH CHECK ADD  CONSTRAINT [FK_Payroll_PayrollType] FOREIGN KEY([PayrollTypeId])
REFERENCES [dbo].[PayrollType] ([PayrollTypeId])
GO
ALTER TABLE [dbo].[Payroll] CHECK CONSTRAINT [FK_Payroll_PayrollType]
GO
ALTER TABLE [dbo].[PayScale]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayScale_dbo.RateFrequency_RateFrequencyId] FOREIGN KEY([RateFrequencyId])
REFERENCES [dbo].[RateFrequency] ([RateFrequencyId])
GO
ALTER TABLE [dbo].[PayScale] CHECK CONSTRAINT [FK_dbo.PayScale_dbo.RateFrequency_RateFrequencyId]
GO
ALTER TABLE [dbo].[PayScaleLevel]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PayScaleLevel_dbo.PayScale_PayScaleId] FOREIGN KEY([PayScaleId])
REFERENCES [dbo].[PayScale] ([PayScaleId])
GO
ALTER TABLE [dbo].[PayScaleLevel] CHECK CONSTRAINT [FK_dbo.PayScaleLevel_dbo.PayScale_PayScaleId]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Position_dbo.EEOCategory_DefaultEEOCategoryId] FOREIGN KEY([DefaultEEOCategoryId])
REFERENCES [dbo].[EEOCategory] ([EEOCategoryId])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [FK_dbo.Position_dbo.EEOCategory_DefaultEEOCategoryId]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Position_dbo.PayScale_DefaultPayScaleId] FOREIGN KEY([DefaultPayScaleId])
REFERENCES [dbo].[PayScale] ([PayScaleId])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [FK_dbo.Position_dbo.PayScale_DefaultPayScaleId]
GO
ALTER TABLE [dbo].[PositionAppraisalTemplate]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionAppraisalTemplate_dbo.AppraisalTemplate_AppraisalTemplateId] FOREIGN KEY([AppraisalTemplateId])
REFERENCES [dbo].[AppraisalTemplate] ([AppraisalTemplateId])
GO
ALTER TABLE [dbo].[PositionAppraisalTemplate] CHECK CONSTRAINT [FK_dbo.PositionAppraisalTemplate_dbo.AppraisalTemplate_AppraisalTemplateId]
GO
ALTER TABLE [dbo].[PositionAppraisalTemplate]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionAppraisalTemplate_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[PositionAppraisalTemplate] CHECK CONSTRAINT [FK_dbo.PositionAppraisalTemplate_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[PositionCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionCredential_dbo.Credential_CredentialId] FOREIGN KEY([CredentialId])
REFERENCES [dbo].[Credential] ([CredentialId])
GO
ALTER TABLE [dbo].[PositionCredential] CHECK CONSTRAINT [FK_dbo.PositionCredential_dbo.Credential_CredentialId]
GO
ALTER TABLE [dbo].[PositionCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionCredential_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[PositionCredential] CHECK CONSTRAINT [FK_dbo.PositionCredential_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[PositionQuestion]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionQuestion_dbo.ApplicantInterviewQuestion_ApplicantInterviewQuestionId] FOREIGN KEY([ApplicantInterviewQuestionId])
REFERENCES [dbo].[ApplicantInterviewQuestion] ([ApplicantInterviewQuestionId])
GO
ALTER TABLE [dbo].[PositionQuestion] CHECK CONSTRAINT [FK_dbo.PositionQuestion_dbo.ApplicantInterviewQuestion_ApplicantInterviewQuestionId]
GO
ALTER TABLE [dbo].[PositionQuestion]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionQuestion_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[PositionQuestion] CHECK CONSTRAINT [FK_dbo.PositionQuestion_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[PositionTraining]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionTraining_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[PositionTraining] CHECK CONSTRAINT [FK_dbo.PositionTraining_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[PositionTraining]  WITH CHECK ADD  CONSTRAINT [FK_dbo.PositionTraining_dbo.Training_TrainingId] FOREIGN KEY([TrainingId])
REFERENCES [dbo].[Training] ([TrainingId])
GO
ALTER TABLE [dbo].[PositionTraining] CHECK CONSTRAINT [FK_dbo.PositionTraining_dbo.Training_TrainingId]
GO
ALTER TABLE [dbo].[Privilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Privilege_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[Privilege] CHECK CONSTRAINT [FK_dbo.Privilege_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[Privilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Privilege_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[Privilege] CHECK CONSTRAINT [FK_dbo.Privilege_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[Role]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Role_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[Role] CHECK CONSTRAINT [FK_dbo.Role_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[Role]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Role_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[Role] CHECK CONSTRAINT [FK_dbo.Role_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[Role]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Role_dbo.RoleType_RoleTypeId] FOREIGN KEY([RoleTypeId])
REFERENCES [dbo].[RoleType] ([RoleTypeId])
GO
ALTER TABLE [dbo].[Role] CHECK CONSTRAINT [FK_dbo.Role_dbo.RoleType_RoleTypeId]
GO
ALTER TABLE [dbo].[RoleFormPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleFormPrivilege_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[RoleFormPrivilege] CHECK CONSTRAINT [FK_dbo.RoleFormPrivilege_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[RoleFormPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleFormPrivilege_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[RoleFormPrivilege] CHECK CONSTRAINT [FK_dbo.RoleFormPrivilege_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[RoleFormPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleFormPrivilege_dbo.Form_FormId] FOREIGN KEY([FormId])
REFERENCES [dbo].[Form] ([FormId])
GO
ALTER TABLE [dbo].[RoleFormPrivilege] CHECK CONSTRAINT [FK_dbo.RoleFormPrivilege_dbo.Form_FormId]
GO
ALTER TABLE [dbo].[RoleFormPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleFormPrivilege_dbo.Privilege_PrivilegeId] FOREIGN KEY([PrivilegeId])
REFERENCES [dbo].[Privilege] ([PrivilegeId])
GO
ALTER TABLE [dbo].[RoleFormPrivilege] CHECK CONSTRAINT [FK_dbo.RoleFormPrivilege_dbo.Privilege_PrivilegeId]
GO
ALTER TABLE [dbo].[RoleFormPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleFormPrivilege_dbo.Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleId])
GO
ALTER TABLE [dbo].[RoleFormPrivilege] CHECK CONSTRAINT [FK_dbo.RoleFormPrivilege_dbo.Role_RoleId]
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege] CHECK CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege] CHECK CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.InterfaceControlForm_InterfaceControlFormId] FOREIGN KEY([InterfaceControlFormId])
REFERENCES [dbo].[InterfaceControlForm] ([InterfaceControlFormId])
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege] CHECK CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.InterfaceControlForm_InterfaceControlFormId]
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Privilege_PrivilegeId] FOREIGN KEY([PrivilegeId])
REFERENCES [dbo].[Privilege] ([PrivilegeId])
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege] CHECK CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Privilege_PrivilegeId]
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleId])
GO
ALTER TABLE [dbo].[RoleInterfaceControlPrivilege] CHECK CONSTRAINT [FK_dbo.RoleInterfaceControlPrivilege_dbo.Role_RoleId]
GO
ALTER TABLE [dbo].[RoleType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleType_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[RoleType] CHECK CONSTRAINT [FK_dbo.RoleType_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[RoleType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleType_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[RoleType] CHECK CONSTRAINT [FK_dbo.RoleType_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[RoleTypeFormPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleTypeFormPrivilege_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[RoleTypeFormPrivilege] CHECK CONSTRAINT [FK_dbo.RoleTypeFormPrivilege_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[RoleTypeFormPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleTypeFormPrivilege_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[RoleTypeFormPrivilege] CHECK CONSTRAINT [FK_dbo.RoleTypeFormPrivilege_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[RoleTypeFormPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleTypeFormPrivilege_dbo.Form_FormId] FOREIGN KEY([FormId])
REFERENCES [dbo].[Form] ([FormId])
GO
ALTER TABLE [dbo].[RoleTypeFormPrivilege] CHECK CONSTRAINT [FK_dbo.RoleTypeFormPrivilege_dbo.Form_FormId]
GO
ALTER TABLE [dbo].[RoleTypeFormPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleTypeFormPrivilege_dbo.Privilege_PrivilegeId] FOREIGN KEY([PrivilegeId])
REFERENCES [dbo].[Privilege] ([PrivilegeId])
GO
ALTER TABLE [dbo].[RoleTypeFormPrivilege] CHECK CONSTRAINT [FK_dbo.RoleTypeFormPrivilege_dbo.Privilege_PrivilegeId]
GO
ALTER TABLE [dbo].[RoleTypeFormPrivilege]  WITH CHECK ADD  CONSTRAINT [FK_dbo.RoleTypeFormPrivilege_dbo.RoleType_RoleTypeId] FOREIGN KEY([RoleTypeId])
REFERENCES [dbo].[RoleType] ([RoleTypeId])
GO
ALTER TABLE [dbo].[RoleTypeFormPrivilege] CHECK CONSTRAINT [FK_dbo.RoleTypeFormPrivilege_dbo.RoleType_RoleTypeId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.Credential_CredentialId] FOREIGN KEY([CredentialId])
REFERENCES [dbo].[Credential] ([CredentialId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.Credential_CredentialId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.EmployeeCredential_EmployeeCredentialId] FOREIGN KEY([EmployeeCredentialId])
REFERENCES [dbo].[EmployeeCredential] ([EmployeeCredentialId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.EmployeeCredential_EmployeeCredentialId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeCredential] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeCredential_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.ChangeRequestStatus_ChangeRequestStatusId] FOREIGN KEY([ChangeRequestStatusId])
REFERENCES [dbo].[ChangeRequestStatus] ([ChangeRequestStatusId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.ChangeRequestStatus_ChangeRequestStatusId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.Document_DocumentId] FOREIGN KEY([DocumentId])
REFERENCES [dbo].[Document] ([DocumentId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.Document_DocumentId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.EmployeeDocument_EmployeeDocumentId] FOREIGN KEY([EmployeeDocumentId])
REFERENCES [dbo].[EmployeeDocument] ([EmployeeDocumentId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.EmployeeDocument_EmployeeDocumentId]
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[SelfServiceEmployeeDocument] CHECK CONSTRAINT [FK_dbo.SelfServiceEmployeeDocument_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[State]  WITH CHECK ADD  CONSTRAINT [FK_dbo.State_dbo.Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[State] CHECK CONSTRAINT [FK_dbo.State_dbo.Country_CountryId]
GO
ALTER TABLE [dbo].[SubDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SubDepartment_dbo.CFSECode_CFSECodeId] FOREIGN KEY([CFSECodeId])
REFERENCES [dbo].[CFSECode] ([CFSECodeId])
GO
ALTER TABLE [dbo].[SubDepartment] CHECK CONSTRAINT [FK_dbo.SubDepartment_dbo.CFSECode_CFSECodeId]
GO
ALTER TABLE [dbo].[SubDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SubDepartment_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[SubDepartment] CHECK CONSTRAINT [FK_dbo.SubDepartment_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[SubDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SubDepartment_dbo.Department_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[SubDepartment] CHECK CONSTRAINT [FK_dbo.SubDepartment_dbo.Department_DepartmentId]
GO
ALTER TABLE [dbo].[SupervisorCompany]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorCompany_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[SupervisorCompany] CHECK CONSTRAINT [FK_dbo.SupervisorCompany_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[SupervisorCompany]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorCompany_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[SupervisorCompany] CHECK CONSTRAINT [FK_dbo.SupervisorCompany_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[SupervisorDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorDepartment_dbo.Department_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[SupervisorDepartment] CHECK CONSTRAINT [FK_dbo.SupervisorDepartment_dbo.Department_DepartmentId]
GO
ALTER TABLE [dbo].[SupervisorDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorDepartment_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[SupervisorDepartment] CHECK CONSTRAINT [FK_dbo.SupervisorDepartment_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[SupervisorEmployeeType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorEmployeeType_dbo.EmployeeType_EmployeeTypeId] FOREIGN KEY([EmployeeTypeId])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeId])
GO
ALTER TABLE [dbo].[SupervisorEmployeeType] CHECK CONSTRAINT [FK_dbo.SupervisorEmployeeType_dbo.EmployeeType_EmployeeTypeId]
GO
ALTER TABLE [dbo].[SupervisorEmployeeType]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorEmployeeType_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[SupervisorEmployeeType] CHECK CONSTRAINT [FK_dbo.SupervisorEmployeeType_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[SupervisorSubDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorSubDepartment_dbo.SubDepartment_SubDepartmentId] FOREIGN KEY([SubDepartmentId])
REFERENCES [dbo].[SubDepartment] ([SubDepartmentId])
GO
ALTER TABLE [dbo].[SupervisorSubDepartment] CHECK CONSTRAINT [FK_dbo.SupervisorSubDepartment_dbo.SubDepartment_SubDepartmentId]
GO
ALTER TABLE [dbo].[SupervisorSubDepartment]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SupervisorSubDepartment_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[SupervisorSubDepartment] CHECK CONSTRAINT [FK_dbo.SupervisorSubDepartment_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.AccrualType_AccrualTypeId] FOREIGN KEY([AccrualTypeId])
REFERENCES [dbo].[AccrualType] ([AccrualTypeId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.AccrualType_AccrualTypeId]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.CompensationAccrualType_CompensationAccrualTypeId] FOREIGN KEY([CompensationAccrualTypeId])
REFERENCES [dbo].[CompensationAccrualType] ([CompensationAccrualTypeId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.CompensationAccrualType_CompensationAccrualTypeId]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.PayRateMultiplier_PayRateMultiplierId] FOREIGN KEY([PayRateMultiplierId])
REFERENCES [dbo].[PayRateMultiplier] ([PayRateMultiplierId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.PayRateMultiplier_PayRateMultiplierId]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.PrimaryTransaction_PrimaryTransactionId] FOREIGN KEY([PrimaryTransactionId])
REFERENCES [dbo].[PrimaryTransaction] ([PrimaryTransactionId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.PrimaryTransaction_PrimaryTransactionId]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.ProcessCode_ProcessCodeId] FOREIGN KEY([ProcessCodeId])
REFERENCES [dbo].[ProcessCode] ([ProcessCodeId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.ProcessCode_ProcessCodeId]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.SickAccrualType_SickAccrualTypeId] FOREIGN KEY([SickAccrualTypeId])
REFERENCES [dbo].[SickAccrualType] ([SickAccrualTypeId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.SickAccrualType_SickAccrualTypeId]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.VacationAccrualType_VacationAccrualTypeId] FOREIGN KEY([VacationAccrualTypeId])
REFERENCES [dbo].[VacationAccrualType] ([VacationAccrualTypeId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_dbo.TransactionConfiguration_dbo.VacationAccrualType_VacationAccrualTypeId]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_TransactionConfiguration_AccrualType] FOREIGN KEY([AccrualTypeId])
REFERENCES [dbo].[AccrualType] ([AccrualTypeId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_TransactionConfiguration_AccrualType]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_TransactionConfiguration_CompensationAccrualType] FOREIGN KEY([CompensationAccrualTypeId])
REFERENCES [dbo].[CompensationAccrualType] ([CompensationAccrualTypeId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_TransactionConfiguration_CompensationAccrualType]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_TransactionConfiguration_PayRateMultiplier] FOREIGN KEY([PayRateMultiplierId])
REFERENCES [dbo].[PayRateMultiplier] ([PayRateMultiplierId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_TransactionConfiguration_PayRateMultiplier]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_TransactionConfiguration_PayRateMultiplier1] FOREIGN KEY([PayRateMultiplierId])
REFERENCES [dbo].[PayRateMultiplier] ([PayRateMultiplierId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_TransactionConfiguration_PayRateMultiplier1]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_TransactionConfiguration_PrimaryTransaction] FOREIGN KEY([PrimaryTransactionId])
REFERENCES [dbo].[PrimaryTransaction] ([PrimaryTransactionId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_TransactionConfiguration_PrimaryTransaction]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_TransactionConfiguration_ProcessCode] FOREIGN KEY([ProcessCodeId])
REFERENCES [dbo].[ProcessCode] ([ProcessCodeId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_TransactionConfiguration_ProcessCode]
GO
ALTER TABLE [dbo].[Transaction]  WITH CHECK ADD  CONSTRAINT [FK_TransactionConfiguration_SickAccrualType] FOREIGN KEY([SickAccrualTypeId])
REFERENCES [dbo].[SickAccrualType] ([SickAccrualTypeId])
GO
ALTER TABLE [dbo].[Transaction] CHECK CONSTRAINT [FK_TransactionConfiguration_SickAccrualType]
GO
ALTER TABLE [dbo].[UserActivityLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserActivityLog_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[UserActivityLog] CHECK CONSTRAINT [FK_dbo.UserActivityLog_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.City_HomeCityId] FOREIGN KEY([HomeCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.City_HomeCityId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.City_MailingCityId] FOREIGN KEY([MailingCityId])
REFERENCES [dbo].[City] ([CityId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.City_MailingCityId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.Country_HomeCountryId] FOREIGN KEY([HomeCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.Country_HomeCountryId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.Country_MailingCountryId] FOREIGN KEY([MailingCountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.Country_MailingCountryId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.State_HomeStateId] FOREIGN KEY([HomeStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.State_HomeStateId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.State_MailingStateId] FOREIGN KEY([MailingStateId])
REFERENCES [dbo].[State] ([StateId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.State_MailingStateId]
GO
ALTER TABLE [dbo].[UserContactInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserContactInformation_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[UserContactInformation] CHECK CONSTRAINT [FK_dbo.UserContactInformation_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[UserEmployeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserEmployeeGroup_dbo.EmployeeGroup_EmployeeGroupId] FOREIGN KEY([EmployeeGroupId])
REFERENCES [dbo].[EmployeeGroup] ([EmployeeGroupId])
GO
ALTER TABLE [dbo].[UserEmployeeGroup] CHECK CONSTRAINT [FK_dbo.UserEmployeeGroup_dbo.EmployeeGroup_EmployeeGroupId]
GO
ALTER TABLE [dbo].[UserEmployeeGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserEmployeeGroup_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[UserEmployeeGroup] CHECK CONSTRAINT [FK_dbo.UserEmployeeGroup_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.BaseSchedule_BaseScheduleId] FOREIGN KEY([BaseScheduleId])
REFERENCES [dbo].[BaseSchedule] ([BaseScheduleId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.BaseSchedule_BaseScheduleId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Department_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([DepartmentId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Department_DepartmentId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Disability_DisabilityId] FOREIGN KEY([DisabilityId])
REFERENCES [dbo].[Disability] ([DisabilityId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Disability_DisabilityId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.EmployeeStatus_EmployeeStatusId] FOREIGN KEY([EmployeeStatusId])
REFERENCES [dbo].[EmployeeStatus] ([EmployeeStatusId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.EmployeeStatus_EmployeeStatusId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.EmployeeType_EmployeeTypeID] FOREIGN KEY([EmployeeTypeID])
REFERENCES [dbo].[EmployeeType] ([EmployeeTypeId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.EmployeeType_EmployeeTypeID]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.EmploymentStatus_EmploymentStatusId] FOREIGN KEY([EmploymentStatusId])
REFERENCES [dbo].[EmploymentStatus] ([EmploymentStatusId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.EmploymentStatus_EmploymentStatusId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Ethnicity_EthnicityId] FOREIGN KEY([EthnicityId])
REFERENCES [dbo].[Ethnicity] ([EthnicityId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Ethnicity_EthnicityId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Gender_GenderId] FOREIGN KEY([GenderId])
REFERENCES [dbo].[Gender] ([GenderId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Gender_GenderId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.JobCode_DefaultJobCodeId] FOREIGN KEY([DefaultJobCodeId])
REFERENCES [dbo].[JobCode] ([JobCodeId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.JobCode_DefaultJobCodeId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.MaritalStatus_MaritalStatusId] FOREIGN KEY([MaritalStatusId])
REFERENCES [dbo].[MaritalStatus] ([MaritalStatusId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.MaritalStatus_MaritalStatusId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.Position_PositionId] FOREIGN KEY([PositionId])
REFERENCES [dbo].[Position] ([PositionId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.Position_PositionId]
GO
ALTER TABLE [dbo].[UserInformation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformation_dbo.SubDepartment_SubDepartmentId] FOREIGN KEY([SubDepartmentId])
REFERENCES [dbo].[SubDepartment] ([SubDepartmentId])
GO
ALTER TABLE [dbo].[UserInformation] CHECK CONSTRAINT [FK_dbo.UserInformation_dbo.SubDepartment_SubDepartmentId]
GO
ALTER TABLE [dbo].[UserInformationActivation]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformationActivation_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[UserInformationActivation] CHECK CONSTRAINT [FK_dbo.UserInformationActivation_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[UserInformationRole]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformationRole_dbo.Role_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleId])
GO
ALTER TABLE [dbo].[UserInformationRole] CHECK CONSTRAINT [FK_dbo.UserInformationRole_dbo.Role_RoleId]
GO
ALTER TABLE [dbo].[UserInformationRole]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserInformationRole_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[UserInformationRole] CHECK CONSTRAINT [FK_dbo.UserInformationRole_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[UserMenu]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserMenu_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[UserMenu] CHECK CONSTRAINT [FK_dbo.UserMenu_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[UserMenu]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserMenu_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[UserMenu] CHECK CONSTRAINT [FK_dbo.UserMenu_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[UserMenu]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserMenu_dbo.Form_FormId] FOREIGN KEY([FormId])
REFERENCES [dbo].[Form] ([FormId])
GO
ALTER TABLE [dbo].[UserMenu] CHECK CONSTRAINT [FK_dbo.UserMenu_dbo.Form_FormId]
GO
ALTER TABLE [dbo].[UserMenu]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserMenu_dbo.InterfaceControl_UserInterfaceId] FOREIGN KEY([UserInterfaceId])
REFERENCES [dbo].[InterfaceControl] ([InterfaceControlId])
GO
ALTER TABLE [dbo].[UserMenu] CHECK CONSTRAINT [FK_dbo.UserMenu_dbo.InterfaceControl_UserInterfaceId]
GO
ALTER TABLE [dbo].[UserSessionLog]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserSessionLog_dbo.UserInformation_UserInformationId] FOREIGN KEY([UserInformationId])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[UserSessionLog] CHECK CONSTRAINT [FK_dbo.UserSessionLog_dbo.UserInformation_UserInformationId]
GO
ALTER TABLE [dbo].[UserSessionLogDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserSessionLogDetail_dbo.Client_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([ClientId])
GO
ALTER TABLE [dbo].[UserSessionLogDetail] CHECK CONSTRAINT [FK_dbo.UserSessionLogDetail_dbo.Client_ClientId]
GO
ALTER TABLE [dbo].[UserSessionLogDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserSessionLogDetail_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[UserSessionLogDetail] CHECK CONSTRAINT [FK_dbo.UserSessionLogDetail_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[UserSessionLogDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserSessionLogDetail_dbo.UserSessionLog_UserSessionLogId] FOREIGN KEY([UserSessionLogId])
REFERENCES [dbo].[UserSessionLog] ([UserSessionLogId])
GO
ALTER TABLE [dbo].[UserSessionLogDetail] CHECK CONSTRAINT [FK_dbo.UserSessionLogDetail_dbo.UserSessionLog_UserSessionLogId]
GO
ALTER TABLE [dbo].[UserSessionLogEvent]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserSessionLogEvent_dbo.Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([CompanyId])
GO
ALTER TABLE [dbo].[UserSessionLogEvent] CHECK CONSTRAINT [FK_dbo.UserSessionLogEvent_dbo.Company_CompanyId]
GO
ALTER TABLE [dbo].[Workflow]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Workflow_dbo.ClosingNotificationType_ClosingNotificationId] FOREIGN KEY([ClosingNotificationId])
REFERENCES [dbo].[ClosingNotificationType] ([ClosingNotificationTypeId])
GO
ALTER TABLE [dbo].[Workflow] CHECK CONSTRAINT [FK_dbo.Workflow_dbo.ClosingNotificationType_ClosingNotificationId]
GO
ALTER TABLE [dbo].[Workflow]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_CancelNotificationMessageId] FOREIGN KEY([CancelNotificationMessageId])
REFERENCES [dbo].[NotificationMessage] ([NotificationMessageId])
GO
ALTER TABLE [dbo].[Workflow] CHECK CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_CancelNotificationMessageId]
GO
ALTER TABLE [dbo].[Workflow]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_ClosingNotificationMessageId] FOREIGN KEY([ClosingNotificationMessageId])
REFERENCES [dbo].[NotificationMessage] ([NotificationMessageId])
GO
ALTER TABLE [dbo].[Workflow] CHECK CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_ClosingNotificationMessageId]
GO
ALTER TABLE [dbo].[Workflow]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_ReminderNotificationMessageId] FOREIGN KEY([ReminderNotificationMessageId])
REFERENCES [dbo].[NotificationMessage] ([NotificationMessageId])
GO
ALTER TABLE [dbo].[Workflow] CHECK CONSTRAINT [FK_dbo.Workflow_dbo.NotificationMessage_ReminderNotificationMessageId]
GO
ALTER TABLE [dbo].[WorkflowLevel]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowLevel_dbo.NotificationMessage_NotificationMessageId] FOREIGN KEY([NotificationMessageId])
REFERENCES [dbo].[NotificationMessage] ([NotificationMessageId])
GO
ALTER TABLE [dbo].[WorkflowLevel] CHECK CONSTRAINT [FK_dbo.WorkflowLevel_dbo.NotificationMessage_NotificationMessageId]
GO
ALTER TABLE [dbo].[WorkflowLevel]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowLevel_dbo.Workflow_WorkflowId] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflow] ([WorkflowId])
GO
ALTER TABLE [dbo].[WorkflowLevel] CHECK CONSTRAINT [FK_dbo.WorkflowLevel_dbo.Workflow_WorkflowId]
GO
ALTER TABLE [dbo].[WorkflowLevel]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowLevel_dbo.WorkflowLevelType_WorkflowLevelTypeId] FOREIGN KEY([WorkflowLevelTypeId])
REFERENCES [dbo].[WorkflowLevelType] ([WorkflowLevelTypeId])
GO
ALTER TABLE [dbo].[WorkflowLevel] CHECK CONSTRAINT [FK_dbo.WorkflowLevel_dbo.WorkflowLevelType_WorkflowLevelTypeId]
GO
ALTER TABLE [dbo].[WorkflowLevelGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowLevelGroup_dbo.EmployeeGroup_EmployeeGroupId] FOREIGN KEY([EmployeeGroupId])
REFERENCES [dbo].[EmployeeGroup] ([EmployeeGroupId])
GO
ALTER TABLE [dbo].[WorkflowLevelGroup] CHECK CONSTRAINT [FK_dbo.WorkflowLevelGroup_dbo.EmployeeGroup_EmployeeGroupId]
GO
ALTER TABLE [dbo].[WorkflowLevelGroup]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowLevelGroup_dbo.WorkflowLevel_WorkflowLevelId] FOREIGN KEY([WorkflowLevelId])
REFERENCES [dbo].[WorkflowLevel] ([WorkflowLevelId])
GO
ALTER TABLE [dbo].[WorkflowLevelGroup] CHECK CONSTRAINT [FK_dbo.WorkflowLevelGroup_dbo.WorkflowLevel_WorkflowLevelId]
GO
ALTER TABLE [dbo].[WorkflowTrigger]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTrigger_dbo.Workflow_WorkflowId] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflow] ([WorkflowId])
GO
ALTER TABLE [dbo].[WorkflowTrigger] CHECK CONSTRAINT [FK_dbo.WorkflowTrigger_dbo.Workflow_WorkflowId]
GO
ALTER TABLE [dbo].[WorkflowTrigger]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTrigger_dbo.WorkflowTriggerType_WorkflowTriggerTypeId] FOREIGN KEY([WorkflowTriggerTypeId])
REFERENCES [dbo].[WorkflowTriggerType] ([WorkflowTriggerTypeId])
GO
ALTER TABLE [dbo].[WorkflowTrigger] CHECK CONSTRAINT [FK_dbo.WorkflowTrigger_dbo.WorkflowTriggerType_WorkflowTriggerTypeId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestAddress_ChangeRequestAddressId] FOREIGN KEY([ChangeRequestAddressId])
REFERENCES [dbo].[ChangeRequestAddress] ([ChangeRequestAddressId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestAddress_ChangeRequestAddressId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmailNumbers_ChangeRequestEmailNumbersId] FOREIGN KEY([ChangeRequestEmailNumbersId])
REFERENCES [dbo].[ChangeRequestEmailNumbers] ([ChangeRequestEmailNumbersId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmailNumbers_ChangeRequestEmailNumbersId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmergencyContact_ChangeRequestEmergencyContactId] FOREIGN KEY([ChangeRequestEmergencyContactId])
REFERENCES [dbo].[ChangeRequestEmergencyContact] ([ChangeRequestEmergencyContactId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmergencyContact_ChangeRequestEmergencyContactId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmployeeDependent_ChangeRequestEmployeeDependentId] FOREIGN KEY([ChangeRequestEmployeeDependentId])
REFERENCES [dbo].[ChangeRequestEmployeeDependent] ([ChangeRequestEmployeeDependentId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.ChangeRequestEmployeeDependent_ChangeRequestEmployeeDependentId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.EmployeeTimeOffRequest_EmployeeTimeOffRequestId] FOREIGN KEY([EmployeeTimeOffRequestId])
REFERENCES [dbo].[EmployeeTimeOffRequest] ([EmployeeTimeOffRequestId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.EmployeeTimeOffRequest_EmployeeTimeOffRequestId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.SelfServiceEmployeeCredential_SelfServiceEmployeeCredentialId] FOREIGN KEY([SelfServiceEmployeeCredentialId])
REFERENCES [dbo].[SelfServiceEmployeeCredential] ([SelfServiceEmployeeCredentialId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.SelfServiceEmployeeCredential_SelfServiceEmployeeCredentialId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.SelfServiceEmployeeDocument_SelfServiceEmployeeDocumentId] FOREIGN KEY([SelfServiceEmployeeDocumentId])
REFERENCES [dbo].[SelfServiceEmployeeDocument] ([SelfServiceEmployeeDocumentId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.SelfServiceEmployeeDocument_SelfServiceEmployeeDocumentId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.WorkflowTrigger_WorkflowTriggerId] FOREIGN KEY([WorkflowTriggerId])
REFERENCES [dbo].[WorkflowTrigger] ([WorkflowTriggerId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequest] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequest_dbo.WorkflowTrigger_WorkflowTriggerId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.UserInformation_ActionById] FOREIGN KEY([ActionById])
REFERENCES [dbo].[UserInformation] ([UserInformationId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.UserInformation_ActionById]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowActionType_WorkflowActionTypeId] FOREIGN KEY([WorkflowActionTypeId])
REFERENCES [dbo].[WorkflowActionType] ([WorkflowActionTypeId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowActionType_WorkflowActionTypeId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowLevel_WorkflowLevelId] FOREIGN KEY([WorkflowLevelId])
REFERENCES [dbo].[WorkflowLevel] ([WorkflowLevelId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowLevel_WorkflowLevelId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowTriggerRequest_WorkflowTriggerRequestId] FOREIGN KEY([WorkflowTriggerRequestId])
REFERENCES [dbo].[WorkflowTriggerRequest] ([WorkflowTriggerRequestId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetail] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetail_dbo.WorkflowTriggerRequest_WorkflowTriggerRequestId]
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetailEmail]  WITH CHECK ADD  CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetailEmail_dbo.WorkflowTriggerRequestDetail_WorkflowTriggerRequestDetailId] FOREIGN KEY([WorkflowTriggerRequestDetailId])
REFERENCES [dbo].[WorkflowTriggerRequestDetail] ([WorkflowTriggerRequestDetailId])
GO
ALTER TABLE [dbo].[WorkflowTriggerRequestDetailEmail] CHECK CONSTRAINT [FK_dbo.WorkflowTriggerRequestDetailEmail_dbo.WorkflowTriggerRequestDetail_WorkflowTriggerRequestDetailId]
GO
