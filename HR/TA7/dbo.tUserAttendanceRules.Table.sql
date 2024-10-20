USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tUserAttendanceRules]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tUserAttendanceRules](
	[nUserID] [int] NOT NULL,
	[nTardinessRulesID] [int] NULL,
	[nAttendanceRulesID] [int] NULL,
 CONSTRAINT [PK_tUserAttendanceRules] PRIMARY KEY CLUSTERED 
(
	[nUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tUserAttendanceRules] ADD  CONSTRAINT [DF_tUserAttendanceRules_nTardinessRuleID]  DEFAULT ((0)) FOR [nTardinessRulesID]
GO
ALTER TABLE [dbo].[tUserAttendanceRules] ADD  CONSTRAINT [DF_tUserAttendanceRules_nAttendanceRuleID]  DEFAULT ((0)) FOR [nAttendanceRulesID]
GO
