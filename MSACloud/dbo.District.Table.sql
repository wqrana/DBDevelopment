USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[District]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[District](
	[ClientID] [bigint] NOT NULL,
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[Emp_Administrator_Id] [bigint] NULL,
	[Emp_Director_Id] [bigint] NULL,
	[DistrictName] [varchar](30) NULL,
	[Address1] [varchar](30) NULL,
	[Address2] [varchar](30) NULL,
	[City] [varchar](30) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](10) NULL,
	[Phone1] [varchar](14) NULL,
	[Phone2] [varchar](14) NULL,
	[isDeleted] [bit] NOT NULL,
	[BankCity] [varchar](30) NULL,
	[BankState] [varchar](2) NULL,
	[BankZip] [varchar](10) NULL,
	[BankName] [varchar](30) NULL,
	[BankAddr1] [varchar](30) NULL,
	[BankAddr2] [varchar](30) NULL,
	[BankRoute] [varchar](15) NULL,
	[BankAccount] [varchar](15) NULL,
	[BankMICR] [varbinary](max) NULL,
	[SpecialSetup] [int] NULL,
	[Forms_Admin_Id] [bigint] NULL,
	[Forms_Director_Id] [bigint] NULL,
	[UseDistNameDirector] [bit] NULL,
	[UseDistNameAdmin] [bit] NULL,
	[Forms_Admin_Title] [varchar](60) NULL,
	[Forms_Admin_Phone] [varchar](15) NULL,
	[Forms_Dir_Title] [varchar](60) NULL,
	[Forms_Dir_Phone] [varchar](15) NULL,
	[AppUpdateDelay] [int] NULL,
	[UpdatePositiveID] [bit] NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_District] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[District] ADD  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[District] ADD  DEFAULT ((0)) FOR [SpecialSetup]
GO
ALTER TABLE [dbo].[District] ADD  DEFAULT ((0)) FOR [UseDistNameDirector]
GO
ALTER TABLE [dbo].[District] ADD  DEFAULT ((0)) FOR [UseDistNameAdmin]
GO
ALTER TABLE [dbo].[District] ADD  DEFAULT ((0)) FOR [AppUpdateDelay]
GO
ALTER TABLE [dbo].[District] ADD  DEFAULT ((0)) FOR [UpdatePositiveID]
GO
ALTER TABLE [dbo].[District] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[District] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[District] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
