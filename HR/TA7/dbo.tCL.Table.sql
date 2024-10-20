USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tCL]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tCL](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[A] [varbinary](1000) NULL,
	[B] [varbinary](1000) NULL,
	[C] [varbinary](1000) NULL,
	[D] [varbinary](1000) NULL,
	[E] [varbinary](1000) NULL,
	[F] [varbinary](1000) NULL,
	[G] [varbinary](1000) NULL,
	[H] [varbinary](1000) NULL,
	[I] [varbinary](1000) NULL,
 CONSTRAINT [PK_tCL] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
