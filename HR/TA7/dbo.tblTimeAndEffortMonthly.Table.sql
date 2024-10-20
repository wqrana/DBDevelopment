USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblTimeAndEffortMonthly]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTimeAndEffortMonthly](
	[intTAEMonthlyID] [int] IDENTITY(1,1) NOT NULL,
	[strBatchID] [nvarchar](50) NULL,
	[strBatchDescription] [nvarchar](50) NULL,
	[intUserID] [int] NOT NULL,
	[strUserName] [nvarchar](50) NOT NULL,
	[strCompensationName] [nvarchar](50) NULL,
	[decPayRate] [decimal](18, 2) NULL,
	[decHours] [decimal](18, 2) NULL,
	[intEditType] [int] NULL,
	[dtPunchDate] [date] NOT NULL,
	[decPay] [decimal](18, 2) NOT NULL,
	[strCompanyName] [nvarchar](50) NULL,
	[strCompany] [nvarchar](50) NULL,
	[strDepartment] [nvarchar](50) NULL,
	[strSubdepartment] [nvarchar](50) NULL,
	[strEmployeeType] [nvarchar](50) NULL,
	[intTAEMonthlySignatureID] [int] NOT NULL,
 CONSTRAINT [PK_tblTimeAndEffortMonthly] PRIMARY KEY CLUSTERED 
(
	[intTAEMonthlyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
