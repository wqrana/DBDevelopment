USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tBultosWeekEntry]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tBultosWeekEntry](
	[nUserID] [int] NOT NULL,
	[nWeekID] [bigint] NOT NULL,
	[sUserName] [nvarchar](50) NULL,
	[dblSundayDelivery] [float] NULL,
	[dblSundayReceived] [float] NULL,
	[dblMondayDelivery] [float] NULL,
	[dblMondayReceived] [float] NULL,
	[dblTuesdayDelivery] [float] NULL,
	[dblTuesdayReceived] [float] NULL,
	[dblWednesdayDelivery] [float] NULL,
	[dblWednesdayReceived] [float] NULL,
	[dblThursdayDelivery] [float] NULL,
	[dblThursdayReceived] [float] NULL,
	[dblFridayDelivery] [float] NULL,
	[dblFridayReceived] [float] NULL,
	[dblSaturdayDelivery] [float] NULL,
	[dblSaturdayReceived] [float] NULL,
	[dblDescuentos] [float] NULL,
	[dblDeliveryTotal] [float] NULL,
	[dblReceivedTotal] [float] NULL,
	[dblWeeklyTotal] [float] NULL,
	[sNote] [nvarchar](50) NULL,
 CONSTRAINT [PK_tBultosWeekEntry] PRIMARY KEY CLUSTERED 
(
	[nUserID] ASC,
	[nWeekID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
