USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  Table [dbo].[tblBatch]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblBatch](
	[strBatchID] [uniqueidentifier] NOT NULL,
	[strCompanyName] [nvarchar](50) NOT NULL,
	[strBatchDescription] [nvarchar](50) NOT NULL,
	[dtBatchCreated] [datetime] NOT NULL,
	[intCreatedByID] [int] NOT NULL,
	[strCreateByName] [nvarchar](50) NOT NULL,
	[dtBatchUpdates] [datetime] NOT NULL,
	[intBatchStatus] [int] NOT NULL,
	[dtPayDate] [smalldatetime] NOT NULL,
	[intBatchType] [int] NOT NULL,
	[intTemplateID] [int] NOT NULL,
	[ClosedByUserID] [int] NULL,
	[ClosedDateTime] [datetime] NULL,
	[intPaymentStatusId] [int] NULL,
	[strPaymentStatusByName] [nvarchar](100) NULL,
	[dtPaymentStatusDate] [datetime] NULL,
	[varPaymentConfirmation] [varbinary](max) NULL,
	[strPaymentConfirmationRptName] [nvarchar](100) NULL,
	[varCompanyPayrollSummary] [varbinary](max) NULL,
	[strPayrollSummaryRptName] [nvarchar](100) NULL,
	[intFederalTaxDepositScheduleId] [int] NULL,
	[intFederalTaxDepositStatusId] [int] NULL,
	[decFederalTaxDepositAmount] [decimal](18, 5) NULL,
	[dtFederalTaxDepositDate] [datetime] NULL,
	[strFederalTaxEFTPSNo] [nvarchar](50) NULL,
	[dtFederalTaxStatusDate] [datetime] NULL,
	[strFederalTaxStatusByName] [nvarchar](50) NULL,
	[varFederalTaxConfirmation] [varbinary](max) NULL,
	[strFederalTaxRptName] [nvarchar](50) NULL,
	[intHaciendaTaxDepositScheduleId] [int] NULL,
	[intHaciendaTaxDepositStatusId] [int] NULL,
	[decHaciendaTaxDepositAmount] [decimal](18, 5) NULL,
	[dtHaciendaTaxDepositDate] [datetime] NULL,
	[strHaciendaTaxReceiptNo] [nvarchar](50) NULL,
	[dtHaciendaTaxStatusDate] [datetime] NULL,
	[strHaciendaTaxStatusByName] [nvarchar](50) NULL,
	[varHaciendaTaxConfirmation] [varbinary](max) NULL,
	[strHaciendaTaxRptName] [nvarchar](50) NULL,
	[intFUTATaxDepositScheduleId] [int] NULL,
	[intFUTATaxDepositStatusId] [int] NULL,
	[decFUTATaxDepositAmount] [decimal](18, 5) NULL,
	[dtFUTATaxDepositDate] [datetime] NULL,
	[strFUTATaxReceiptNo] [nvarchar](50) NULL,
	[dtFUTATaxStatusDate] [datetime] NULL,
	[strFUTATaxStatusByName] [nvarchar](50) NULL,
	[varFUTATaxConfirmation] [varbinary](max) NULL,
	[strFUTATaxRptName] [nvarchar](50) NULL,
	[intACHSentCount] [int] NOT NULL,
	[ACHFileName] [nvarchar](50) NULL,
 CONSTRAINT [PK_tblBatch] PRIMARY KEY CLUSTERED 
(
	[strBatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[tblBatch] ADD  DEFAULT ((0)) FOR [intBatchType]
GO
ALTER TABLE [dbo].[tblBatch] ADD  DEFAULT ((0)) FOR [intTemplateID]
GO
ALTER TABLE [dbo].[tblBatch] ADD  DEFAULT ((0)) FOR [intACHSentCount]
GO
