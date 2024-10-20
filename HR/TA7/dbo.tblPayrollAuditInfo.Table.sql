USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblPayrollAuditInfo]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblPayrollAuditInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DTTimeStamp] [datetime] NULL,
	[intAdminID] [int] NOT NULL,
	[strAdminName] [nvarchar](50) NOT NULL,
	[strAdminAction] [nvarchar](50) NOT NULL,
	[strRecordAffected] [nvarchar](50) NOT NULL,
	[intUserID] [int] NULL,
	[strUserName] [nvarchar](50) NULL,
	[strFieldName] [nvarchar](50) NULL,
	[strFieldDesc] [nvarchar](50) NULL,
	[strPrevValue] [nvarchar](50) NULL,
	[strNewValue] [nvarchar](50) NULL,
	[strBatchID] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblPayrollAuditInfo] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
