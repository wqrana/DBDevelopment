USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblCheckingAccounts]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblCheckingAccounts](
	[intCheckingAccountID] [int] IDENTITY(1,1) NOT NULL,
	[strCheckingAccountName] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_tblCheckingAccounts] PRIMARY KEY CLUSTERED 
(
	[intCheckingAccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
