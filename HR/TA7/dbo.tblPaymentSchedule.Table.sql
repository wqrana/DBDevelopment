USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPaymentSchedule]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPaymentSchedule](
	[strCompanyName] [nvarchar](50) NOT NULL,
	[intPaymentScheduleID] [int] NOT NULL,
	[strPaymentSchedule] [nvarchar](50) NULL,
	[strAccountNumber] [nvarchar](50) NULL,
	[intPaymentFrequency] [int] NULL,
	[intPaymentDay] [int] NULL,
 CONSTRAINT [PK_tblPaymentSchedule] PRIMARY KEY CLUSTERED 
(
	[strCompanyName] ASC,
	[intPaymentScheduleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
