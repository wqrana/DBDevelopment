USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[App_Signers]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[App_Signers](
	[ClientID] [bigint] NOT NULL,
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Application_Id] [bigint] NOT NULL,
	[App_Member_Id] [bigint] NOT NULL,
	[Address1] [varchar](30) NULL,
	[Address2] [varchar](30) NULL,
	[City] [varchar](30) NULL,
	[State] [varchar](2) NULL,
	[Zip] [varchar](10) NULL,
	[Phone] [varchar](20) NULL,
	[Cell_Phone] [varchar](12) NULL,
	[Other_Phone] [varchar](12) NULL,
	[Email] [varchar](50) NULL,
	[SSN] [varchar](4) NULL,
	[No_SSN] [bit] NULL,
	[Signed_Date] [datetime2](7) NULL,
	[Other_Identifier] [int] NULL,
	[IP_Address] [varchar](20) NULL,
	[Terms_Of_Use_Accepted] [bit] NULL,
	[Confirmation_Of_Accuracy] [bit] NULL,
	[Signature] [varchar](75) NULL,
	[LastUpdatedUTC] [datetime2](7) NULL,
	[UpdatedBySync] [bit] NULL,
	[Local_ID] [int] NULL,
	[CloudIDSync] [bit] NOT NULL,
 CONSTRAINT [PK_App_Signers] PRIMARY KEY NONCLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[App_Signers] ADD  DEFAULT (getutcdate()) FOR [LastUpdatedUTC]
GO
ALTER TABLE [dbo].[App_Signers] ADD  DEFAULT ((0)) FOR [UpdatedBySync]
GO
ALTER TABLE [dbo].[App_Signers] ADD  DEFAULT ((0)) FOR [CloudIDSync]
GO
