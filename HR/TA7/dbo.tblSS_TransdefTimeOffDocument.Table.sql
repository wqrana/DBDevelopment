USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblSS_TransdefTimeOffDocument]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblSS_TransdefTimeOffDocument](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[intTransId] [int] NOT NULL,
	[sDocumentName] [nvarchar](50) NOT NULL,
	[intDocumentType] [int] NULL,
	[intSubmissionType] [int] NULL,
	[intTimeOffDays] [int] NULL,
 CONSTRAINT [PK_tblSS_TransdefTimeOffDocument_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
