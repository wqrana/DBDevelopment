USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tUserInternetAccess]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tUserInternetAccess](
	[nUserID] [int] NOT NULL,
	[sLoginNames] [nvarchar](50) NULL,
	[sPwd] [nvarchar](max) NULL,
	[sPrimaryEmail] [nvarchar](50) NULL,
	[sSecondaryEmail] [nvarchar](50) NULL,
	[sValidationQuestion] [nvarchar](max) NULL,
	[sValidationAnswer] [nvarchar](50) NULL,
	[nInternetAccess] [int] NULL,
	[sSMSNumber] [nvarchar](50) NULL,
 CONSTRAINT [PK_tUserInternetAccess] PRIMARY KEY CLUSTERED 
(
	[nUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
