USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblImportChristmasBonus]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblImportChristmasBonus](
	[intUserID] [int] NOT NULL,
	[strUserName] [nvarchar](50) NULL,
	[Bono] [decimal](18, 2) NOT NULL,
	[Incentivo] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_tblImportChristmasBonus] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
