USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblTimeAndEffortMonthlySign]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTimeAndEffortMonthlySign](
	[intTAEMonthlySignatureID] [int] IDENTITY(1,1) NOT NULL,
	[intUserID] [int] NOT NULL,
	[strUserName] [nvarchar](50) NULL,
	[intMonth] [int] NOT NULL,
	[intYear] [int] NOT NULL,
	[SignHash] [nvarchar](max) NULL,
	[SignDateTime] [datetime] NULL,
	[SignEntry] [nvarchar](200) NULL,
 CONSTRAINT [PK_tblTimeAndEffortMonthlySingnature] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC,
	[intMonth] ASC,
	[intYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
