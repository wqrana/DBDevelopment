USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblEzCheckConfiguration]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEzCheckConfiguration](
	[strCompanyName] [nvarchar](50) NOT NULL,
	[strEzCheckDB] [nvarchar](150) NOT NULL,
	[intCheckType] [int] NOT NULL,
	[boolPrntCheckNoStub] [bit] NOT NULL,
	[boollPrintWithPreview] [bit] NOT NULL,
 CONSTRAINT [PK_tblEzCheckConfiguration] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
