USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblTAEDetail]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblTAEDetail](
	[intTAEDetailID] [int] IDENTITY(1,1) NOT NULL,
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
	[intCompanyID] [int] NULL,
	[intDepartmentID] [int] NULL,
	[intSubdepartmentID] [int] NULL,
	[intEmployeeType] [int] NULL,
	[intTAESignID] [varchar](50) NOT NULL,
 CONSTRAINT [PK_tblTAEDetail] PRIMARY KEY CLUSTERED 
(
	[intTAEDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
