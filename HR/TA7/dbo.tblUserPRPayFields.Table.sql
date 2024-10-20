USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserPRPayFields]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserPRPayFields](
	[intUserID] [int] NOT NULL,
	[strDriversLicense] [nvarchar](50) NOT NULL,
	[strCarLicensePlate] [nvarchar](50) NOT NULL,
	[strMarbete] [nvarchar](50) NOT NULL,
	[dtMarbeteDate] [date] NULL,
	[boolShareholder] [bit] NOT NULL,
	[boolChauffeur] [bit] NOT NULL,
	[boolChauffeurSelfEmployed] [bit] NOT NULL,
	[boolAgriculturalEmployee] [bit] NOT NULL,
	[boolHouseholdEmployee] [bit] NOT NULL,
	[boolResidenteBonaFide] [bit] NOT NULL,
	[boolSinot] [bit] NOT NULL,
	[boolQualifiedPhysician] [bit] NOT NULL,
	[boolHealthProfessional] [bit] NOT NULL,
	[boolMinister] [bit] NOT NULL,
 CONSTRAINT [PK_tblUserPRPayFields] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblUserPRPayFields] ADD  DEFAULT ((0)) FOR [boolResidenteBonaFide]
GO
ALTER TABLE [dbo].[tblUserPRPayFields] ADD  DEFAULT ((0)) FOR [boolSinot]
GO
ALTER TABLE [dbo].[tblUserPRPayFields] ADD  DEFAULT ((0)) FOR [boolQualifiedPhysician]
GO
ALTER TABLE [dbo].[tblUserPRPayFields] ADD  DEFAULT ((0)) FOR [boolHealthProfessional]
GO
ALTER TABLE [dbo].[tblUserPRPayFields] ADD  DEFAULT ((0)) FOR [boolMinister]
GO
