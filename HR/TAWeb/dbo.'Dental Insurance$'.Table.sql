USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].['Dental Insurance$']    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].['Dental Insurance$'](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[STATUS] [nvarchar](255) NULL,
	[CONTRACT ID] [float] NULL,
	[TYPE PRIMARY/SECONDARY] [nvarchar](255) NULL,
	[COVERAGE] [nvarchar](255) NULL,
	[COMPANY CONTRIBUTION] [nvarchar](255) NULL,
	[EMPLOYEE CONTRIBUTION] [nvarchar](255) NULL,
	[TOTAL] [money] NULL
) ON [PRIMARY]
GO
