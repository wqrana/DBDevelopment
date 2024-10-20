USE [Live_MSA_Test_Cloud]
GO
/****** Object:  Table [dbo].[HISTORY]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HISTORY](
	[ClientID] [bigint] NOT NULL,
	[HouseholdID] [varchar](15) NOT NULL,
	[UserID] [varchar](16) NULL,
	[SchoolID] [int] NULL,
	[HistoryDate] [smalldatetime] NULL,
	[FormsDateEntered] [smalldatetime] NULL,
	[FormsChange] [bit] NULL,
	[FormsLunchType] [varchar](15) NULL,
	[NewFormsLunchType] [varchar](15) NULL,
	[POSUpdated] [bit] NULL,
	[POSDateEntered] [smalldatetime] NULL,
	[StatusChanged] [bit] NULL,
	[PreviousLunchType] [varchar](1) NULL,
	[POSLunchType] [varchar](1) NULL,
	[LettersSent] [bit] NULL,
	[LettersSentDate] [smalldatetime] NULL,
	[PollingDone] [bit] NULL,
	[PollingDate] [smalldatetime] NULL,
	[VerifResult] [varchar](20) NULL,
	[Date01] [smalldatetime] NULL,
	[Date02] [smalldatetime] NULL,
	[Date03] [smalldatetime] NULL,
	[Date04] [smalldatetime] NULL,
	[Date05] [smalldatetime] NULL,
	[Date06] [smalldatetime] NULL,
	[Date07] [smalldatetime] NULL,
	[Date08] [smalldatetime] NULL,
	[Date09] [smalldatetime] NULL,
	[Date10] [smalldatetime] NULL,
	[TextData01] [varchar](20) NULL,
	[TextData02] [varchar](20) NULL,
	[TextData03] [varchar](20) NULL,
	[TextData04] [varchar](20) NULL,
	[TextData05] [varchar](20) NULL,
	[TextData06] [varchar](20) NULL,
	[TextData07] [varchar](20) NULL,
	[TextData08] [varchar](20) NULL,
	[TextData09] [varchar](20) NULL,
	[TextData10] [varchar](20) NULL,
	[Id] [int] NOT NULL,
	[District_Id] [int] NOT NULL,
 CONSTRAINT [PK_HISTORY] PRIMARY KEY NONCLUSTERED 
(
	[ClientID] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
