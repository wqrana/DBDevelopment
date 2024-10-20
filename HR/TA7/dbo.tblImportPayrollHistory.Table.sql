USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblImportPayrollHistory]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblImportPayrollHistory](
	[strPayrollCompany] [nvarchar](50) NOT NULL,
	[intUserID] [int] NOT NULL,
	[strUserName] [nvarchar](50) NULL,
	[dtPayDate] [smalldatetime] NOT NULL,
	[RegularWages] [decimal](18, 5) NULL,
	[Overtime] [decimal](18, 5) NULL,
	[Overtime2X] [decimal](18, 5) NULL,
	[Meal] [decimal](18, 5) NULL,
	[Refund] [decimal](18, 5) NULL,
	[Sick] [decimal](18, 5) NULL,
	[Vacation] [decimal](18, 5) NULL,
	[Holiday] [decimal](18, 5) NULL,
	[CarAllowance] [decimal](18, 5) NULL,
	[Cellular] [decimal](18, 5) NULL,
	[Incentivo] [decimal](18, 5) NULL,
	[Reembolso] [decimal](18, 5) NULL,
	[FICA_SS_EE] [decimal](18, 5) NULL,
	[FICA_MED_EE] [decimal](18, 5) NULL,
	[FICA_MED_PLUS_EE] [decimal](18, 5) NULL,
	[SINOT_EE] [decimal](18, 5) NULL,
	[CHOFERIL_EE] [decimal](18, 5) NULL,
	[PLAN_MEDICO_EE] [decimal](18, 5) NULL,
	[ST_ITAX_EE] [decimal](18, 5) NULL,
	[ADELANTO] [decimal](18, 5) NULL,
	[AFLAC] [decimal](18, 5) NULL,
	[FICA_SS_ER] [decimal](18, 5) NULL,
	[FICA_MED_ER] [decimal](18, 5) NULL,
	[FICA_MED_PLUS_ER] [decimal](18, 5) NULL,
	[SINOT_ER] [decimal](18, 5) NULL,
	[CHOFERIL_ER] [decimal](18, 5) NULL,
	[FUTA_ER] [decimal](18, 5) NULL,
	[SUTA_ER] [decimal](18, 5) NULL,
 CONSTRAINT [PK_tblImportPayrollHistory] PRIMARY KEY CLUSTERED 
(
	[strPayrollCompany] ASC,
	[intUserID] ASC,
	[dtPayDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
