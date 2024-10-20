USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[History_Customers]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[History_Customers](
	[ClientID] [bigint] NOT NULL,
	[Id] [int] NOT NULL,
	[District_Name] [varchar](30) NOT NULL,
	[Language_Name] [varchar](15) NULL,
	[Grade_Name] [varchar](15) NULL,
	[HomeRoom_Name] [varchar](10) NULL,
	[School_Name] [varchar](60) NULL,
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
	[EMail] [varchar](25) NULL,
	[FORM_Date] [smalldatetime] NULL,
	[DOB] [smalldatetime] NULL,
	[ACH] [bit] NULL,
 CONSTRAINT [PK_History_Customers] PRIMARY KEY NONCLUSTERED 
(
	[ClientID] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
