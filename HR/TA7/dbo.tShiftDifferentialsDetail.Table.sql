USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tShiftDifferentialsDetail]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tShiftDifferentialsDetail](
	[intID] [int] IDENTITY(1,1) NOT NULL,
	[intShiftDifferentialID] [int] NULL,
	[intDayOfWeek] [int] NULL,
	[intTransDefID] [int] NULL,
	[strStartHour] [nvarchar](50) NULL,
	[strEndHour] [nvarchar](50) NULL,
 CONSTRAINT [PK_tShiftDifferentialsDetail] PRIMARY KEY CLUSTERED 
(
	[intID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
