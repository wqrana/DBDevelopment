USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblUserHaciendaParameters]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblUserHaciendaParameters](
	[intUserID] [int] NOT NULL,
	[dtEntryDate] [datetime] NOT NULL,
	[decComputedExemption] [decimal](18, 5) NULL,
	[decClaimedExemption] [decimal](18, 5) NULL,
	[decComputedAllowance] [decimal](18, 5) NULL,
	[decClaimedAllowance] [decimal](18, 5) NULL,
	[decAdditionalWithholdingPercent] [decimal](18, 5) NULL,
	[decAdditionalWithholdingAmount] [decimal](18, 5) NULL,
	[decClaimedAdditionalWithholdingPercent] [decimal](18, 5) NULL,
	[decClaimedAdditionalWithholdingAmount] [decimal](18, 5) NULL,
	[decTablesWithholdingPercent] [decimal](18, 5) NULL,
	[decTablesWithholdingSubtractAmount] [decimal](18, 5) NULL,
	[decHaciendaWithholdingPercent] [decimal](18, 5) NULL,
	[decHaciendaWithholdingSubtractAmount] [decimal](18, 5) NULL,
	[boolIs26OrUnder] [bit] NOT NULL,
 CONSTRAINT [PK_tblUserHaciendaExemptions] PRIMARY KEY CLUSTERED 
(
	[intUserID] ASC,
	[dtEntryDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblUserHaciendaParameters] ADD  DEFAULT ((0)) FOR [boolIs26OrUnder]
GO
