USE [TimeAidePayrollPortal_0423]
GO
/****** Object:  Table [dbo].[AspNetRoles]    Script Date: 10/18/2024 11:20:56 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserClaims]    Script Date: 10/18/2024 11:20:56 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserLogins]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[AspNetUsers_Id] [nvarchar](128) NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUserRoles]    Script Date: 10/18/2024 11:20:56 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsers]    Script Date: 10/18/2024 11:20:56 PM ******/
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
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AspNetUsersAspNetRoles]    Script Date: 10/18/2024 11:20:56 PM ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CHOFERILTaxDepositStatus]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHOFERILTaxDepositStatus](
	[CHOFERILTaxDepositStatusId] [int] NOT NULL,
	[CHOFERILTaxDepositStatusName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_CHOFERILTaxDepositStatus] PRIMARY KEY CLUSTERED 
(
	[CHOFERILTaxDepositStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Company]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Company](
	[CompanyId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](50) NOT NULL,
	[DBServerName] [nvarchar](50) NULL,
	[DBName] [nvarchar](50) NULL,
	[DBUser] [nvarchar](25) NULL,
	[DBPassword] [nvarchar](25) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_Company] PRIMARY KEY CLUSTERED 
(
	[CompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [constr_cmpName] UNIQUE NONCLUSTERED 
(
	[CompanyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FederalTaxDepositSchedule]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FederalTaxDepositSchedule](
	[FederalTaxDepositScheduleId] [int] NOT NULL,
	[FederalTaxDepositScheduleName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_FederalTaxDepositSchedule] PRIMARY KEY CLUSTERED 
(
	[FederalTaxDepositScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FederalTaxDepositStatus]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FederalTaxDepositStatus](
	[FederalTaxDepositStatusId] [int] NOT NULL,
	[FederalTaxDepositStatusName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_FederalTaxDepositStatus] PRIMARY KEY CLUSTERED 
(
	[FederalTaxDepositStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FUTATaxDepositSchedule]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FUTATaxDepositSchedule](
	[FUTATaxDepositScheduleId] [int] NOT NULL,
	[FUTATaxDepositScheduleName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_FUTATaxDepositSchedule] PRIMARY KEY CLUSTERED 
(
	[FUTATaxDepositScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[FUTATaxDepositStatus]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FUTATaxDepositStatus](
	[FUTATaxDepositStatusId] [int] NOT NULL,
	[FUTATaxDepositStatusName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_FUTATaxDepositStatus] PRIMARY KEY CLUSTERED 
(
	[FUTATaxDepositStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HaciendaTaxDepositSchedule]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HaciendaTaxDepositSchedule](
	[HaciendaTaxDepositScheduleId] [int] NOT NULL,
	[HaciendaTaxDepositScheduleName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_HaciendaTaxDepositSchedule] PRIMARY KEY CLUSTERED 
(
	[HaciendaTaxDepositScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HaciendaTaxDepositStatus]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HaciendaTaxDepositStatus](
	[HaciendaTaxDepositStatusId] [int] NOT NULL,
	[HaciendaTaxDepositStatusName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_HaciendaTaxDepositStatus] PRIMARY KEY CLUSTERED 
(
	[HaciendaTaxDepositStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PaymentStatus]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PaymentStatus](
	[PaymentStatusId] [int] NOT NULL,
	[PaymentStatusName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_PaymentStatus] PRIMARY KEY CLUSTERED 
(
	[PaymentStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payroll]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payroll](
	[PayrollId] [int] IDENTITY(1,1) NOT NULL,
	[PayrollExternalId] [uniqueidentifier] NULL,
	[CompanyName] [nvarchar](50) NOT NULL,
	[PayrollName] [nvarchar](50) NOT NULL,
	[PayDate] [smalldatetime] NOT NULL,
	[PayrollStatusId] [int] NOT NULL,
	[Compensations] [decimal](18, 5) NOT NULL,
	[Withholdings] [decimal](18, 5) NOT NULL,
	[Contributions] [decimal](18, 5) NOT NULL,
	[PaymentStatusId] [int] NOT NULL,
	[FederalTaxDepositStatusId] [int] NULL,
	[FederalTaxDepositAmount] [decimal](18, 5) NULL,
	[FederalTaxStatusDate] [datetime] NULL,
	[HaciendaTaxDepositStatusId] [int] NULL,
	[HaciendaTaxDepositAmount] [decimal](18, 5) NULL,
	[HaciendaTaxStatusDate] [datetime] NULL,
	[PayrollTypeName] [nvarchar](50) NOT NULL,
	[TemplateTypeName] [nvarchar](50) NOT NULL,
	[CompanyPayrollSummary] [varbinary](max) NULL,
	[PaymentConfirmation] [varbinary](max) NULL,
	[FederalTaxConfirmation] [varbinary](max) NULL,
	[HaciendaTaxConfirmation] [varbinary](max) NULL,
	[ClosedBy] [int] NULL,
	[ClosedDate] [datetime] NULL,
	[DataEntryStatus] [int] NOT NULL,
	[CreatedByName] [nvarchar](50) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[FUTATaxDepositStatusId] [int] NULL,
	[FUTATaxDepositAmount] [decimal](18, 5) NULL,
	[FUTATaxStatusDate] [datetime] NULL,
	[FUTATaxConfirmation] [varbinary](max) NULL,
	[SSPayableAmount] [decimal](18, 5) NULL,
	[FUTATaxDepositDate] [datetime] NULL,
	[MedPayableAmount] [decimal](18, 5) NULL,
	[FederalTaxDepositDate] [datetime] NULL,
	[HaciendaTaxDepositDate] [datetime] NULL,
	[BatchTypeName] [nvarchar](50) NULL,
	[PayWeekNum] [nvarchar](15) NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[DirectDepositAmount] [decimal](18, 5) NULL,
	[CheckDepositAmount] [decimal](18, 5) NULL,
	[FederalTaxDepositScheduleId] [int] NULL,
	[HaciendaTaxDepositScheduleId] [int] NULL,
	[FUTATaxDepositScheduleId] [int] NULL,
	[ClosedbyName] [nvarchar](50) NULL,
	[PaymentStatusByName] [nvarchar](50) NULL,
	[PaymentStatusDate] [datetime] NULL,
	[PayrollSummaryRptName] [nvarchar](100) NULL,
	[PaymentConfirmationRptName] [nvarchar](100) NULL,
	[FederalTaxEFTPSNo] [nvarchar](50) NULL,
	[FederalTaxStatusByName] [nvarchar](50) NULL,
	[FederalTaxRptName] [nvarchar](50) NULL,
	[HaciendaTaxReceiptNo] [nvarchar](50) NULL,
	[HaciendaTaxStatusByName] [nvarchar](50) NULL,
	[HaciendaTaxRptName] [nvarchar](50) NULL,
	[FUTATaxReceiptNo] [nvarchar](50) NULL,
	[FUTATaxStatusByName] [nvarchar](50) NULL,
	[FUTATaxRptName] [nvarchar](50) NULL,
	[HaciendaPayableAmount] [decimal](18, 5) NULL,
	[FUTAPayableAmount] [decimal](18, 5) NULL,
	[MedPlusPayableAmount] [decimal](18, 5) NULL,
	[FederalTaxComments] [nvarchar](250) NULL,
	[HaciendaTaxComments] [nvarchar](250) NULL,
	[FUTATaxComments] [nvarchar](250) NULL,
 CONSTRAINT [PK_tblPayroll] PRIMARY KEY CLUSTERED 
(
	[PayrollId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollQuarterlyTax]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollQuarterlyTax](
	[PayrollQuarterlyTaxId] [int] IDENTITY(1,1) NOT NULL,
	[CompanyName] [nvarchar](50) NOT NULL,
	[Quarter] [nvarchar](15) NOT NULL,
	[QuarterStartDate] [datetime] NULL,
	[QuarterEndDate] [datetime] NULL,
	[FUTAWHAmount] [decimal](18, 5) NULL,
	[FUTATaxDepositScheduleId] [int] NULL,
	[FUTATaxDepositStatusId] [int] NULL,
	[FUTATaxDepositAmount] [decimal](18, 5) NULL,
	[FUTATaxDepositDate] [datetime] NULL,
	[FUTATaxReceiptNo] [nvarchar](50) NULL,
	[FUTATaxStatusDate] [datetime] NULL,
	[FUTATaxStatusByName] [nvarchar](50) NULL,
	[FUTATaxConfirmation] [varbinary](max) NULL,
	[FUTATaxRptName] [nvarchar](50) NULL,
	[SUTAWHAmount] [decimal](18, 5) NULL,
	[SUTATaxDepositStatusId] [int] NULL,
	[SUTATaxDepositAmount] [decimal](18, 5) NULL,
	[SUTATaxDepositDate] [datetime] NULL,
	[SUTATaxReceiptNo] [nvarchar](50) NULL,
	[SUTATaxStatusDate] [datetime] NULL,
	[SUTATaxStatusByName] [nvarchar](50) NULL,
	[SUTATaxConfirmation] [varbinary](max) NULL,
	[SUTATaxRptName] [nvarchar](50) NULL,
	[SINOTWHAmount] [decimal](18, 5) NULL,
	[SINOTTaxDepositStatusId] [int] NULL,
	[SINOTTaxDepositAmount] [decimal](18, 5) NULL,
	[SINOTTaxDepositDate] [datetime] NULL,
	[SINOTTaxReceiptNo] [nvarchar](50) NULL,
	[SINOTTaxStatusDate] [datetime] NULL,
	[SINOTTaxStatusByName] [nvarchar](50) NULL,
	[SINOTTaxConfirmation] [varbinary](max) NULL,
	[SINOTTaxRptName] [nvarchar](50) NULL,
	[CHOFERILWHAmount] [decimal](18, 5) NULL,
	[CHOFERILTaxDepositStatusId] [int] NULL,
	[CHOFERILTaxDepositAmount] [decimal](18, 5) NULL,
	[CHOFERILTaxDepositDate] [datetime] NULL,
	[CHOFERILTaxReceiptNo] [nvarchar](50) NULL,
	[CHOFERILTaxStatusDate] [datetime] NULL,
	[CHOFERILTaxStatusByName] [nvarchar](50) NULL,
	[CHOFERILTaxConfirmation] [varbinary](max) NULL,
	[CHOFERILTaxRptName] [nvarchar](50) NULL,
	[DataEntryStatus] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedByName] [nvarchar](50) NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[FUTATaxComments] [nvarchar](250) NULL,
	[SUTATaxComments] [nvarchar](250) NULL,
	[SINOTTaxComments] [nvarchar](250) NULL,
	[CHOFERILTaxComments] [nvarchar](250) NULL,
 CONSTRAINT [PK_tblPayrollQuarterlyTax] PRIMARY KEY CLUSTERED 
(
	[PayrollQuarterlyTaxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PayrollStatus]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PayrollStatus](
	[PayrollStatusId] [int] NOT NULL,
	[PayrollStatusName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_PayrollStatus] PRIMARY KEY CLUSTERED 
(
	[PayrollStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SINOTTaxDepositStatus]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SINOTTaxDepositStatus](
	[SINOTTaxDepositStatusId] [int] NOT NULL,
	[SINOTTaxDepositStatusName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_SINOTTaxDepositStatus] PRIMARY KEY CLUSTERED 
(
	[SINOTTaxDepositStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SUTATaxDepositStatus]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SUTATaxDepositStatus](
	[SUTATaxDepositStatusId] [int] NOT NULL,
	[SUTATaxDepositStatusName] [nchar](10) NULL,
	[DataEntryStatus] [int] NOT NULL,
 CONSTRAINT [PK_SUTATaxDepositStatus] PRIMARY KEY CLUSTERED 
(
	[SUTATaxDepositStatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserCompany]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserCompany](
	[UserCompanyId] [int] IDENTITY(1,1) NOT NULL,
	[UserInformationId] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[DataEntryStatus] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_UserCompany] PRIMARY KEY CLUSTERED 
(
	[UserCompanyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserInformation]    Script Date: 10/18/2024 11:20:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInformation](
	[UserInformationId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleInitial] [nvarchar](2) NULL,
	[FirstLastName] [nvarchar](50) NULL,
	[SecondLastName] [nvarchar](50) NULL,
	[LoginEmail] [nvarchar](50) NULL,
	[LoginStatus] [nvarchar](10) NULL,
	[IsAdmin] [bit] NULL,
	[DataEntryStatus] [int] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_ApplicationUser] PRIMARY KEY CLUSTERED 
(
	[UserInformationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_AspNetUsers_Id] FOREIGN KEY([AspNetUsers_Id])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_AspNetUsers_Id]
GO
ALTER TABLE [dbo].[AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_AspNetUsers_Id] FOREIGN KEY([AspNetUsers_Id])
REFERENCES [dbo].[AspNetUsers] ([Id])
GO
ALTER TABLE [dbo].[AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_AspNetUsers_Id]
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
