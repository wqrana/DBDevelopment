USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompensationTypes]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompensationTypes](
	[intCompensationType] [int] NOT NULL,
	[strCompensationTypeName] [nvarchar](50) NOT NULL,
	[strDescriptions] [nvarchar](150) NULL,
	[boolEnabled] [bit] NULL,
 CONSTRAINT [PK_tblCompensationTypes] PRIMARY KEY CLUSTERED 
(
	[intCompensationType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
