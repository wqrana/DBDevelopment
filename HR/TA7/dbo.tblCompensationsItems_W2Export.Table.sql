USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCompensationsItems_W2Export]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCompensationsItems_W2Export](
	[strCompensationName] [nvarchar](50) NOT NULL,
	[boolWages] [bit] NOT NULL,
	[boolCommissions] [bit] NOT NULL,
	[boolAllowances] [bit] NOT NULL,
	[boolTips] [bit] NOT NULL,
	[boolReimbursements] [bit] NOT NULL,
	[boolExempt_Salaries] [bit] NOT NULL,
 CONSTRAINT [PK_tblCompensationsItems_W2Export] PRIMARY KEY CLUSTERED 
(
	[strCompensationName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
