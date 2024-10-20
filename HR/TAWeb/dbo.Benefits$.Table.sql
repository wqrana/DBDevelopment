USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  Table [dbo].[Benefits$]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Benefits$](
	[ID] [float] NULL,
	[NAME] [nvarchar](255) NULL,
	[BENEFIT NAME] [nvarchar](255) NULL,
	[START DATE] [datetime] NULL,
	[END DATE] [nvarchar](255) NULL,
	[AMOUNT] [nvarchar](255) NULL,
	[FREQUENCY] [nvarchar](255) NULL,
	[COMPANY CONTRIBUTION] [money] NULL,
	[EMPLOYEE CONTRIBUTION] [money] NULL,
	[TOTAL] [money] NULL
) ON [PRIMARY]
GO
