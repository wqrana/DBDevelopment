USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_Batch]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  View [dbo].[viewPay_Batch]    Script Date: 1/4/2017 8:28:14 AM ******/
CREATE VIEW [dbo].[viewPay_Batch]
AS
SELECT        dbo.tblBatch.strBatchID, dbo.tblBatch.strCompanyName, dbo.tblBatch.strBatchDescription, dbo.tblBatch.dtBatchCreated, dbo.tblBatch.intCreatedByID, dbo.tblBatch.strCreateByName, dbo.tblBatch.dtBatchUpdates, 
                         dbo.tblBatch.intBatchStatus, dbo.tblBatch.dtPayDate, dbo.fnPay_BatchTotalNetPay(dbo.tblBatch.strBatchID) AS decBatchNetPayAmount, dbo.fnPay_BatchTotalCompensations(dbo.tblBatch.strBatchID) 
                         AS decBatchCompensationAmount, dbo.fnPay_BatchTotalWithholdings(dbo.tblBatch.strBatchID) AS decBatchDeductionAmount, dbo.tblBatchStatus.strStatusDescription, 
                         dbo.fnPay_BatchTotalTransactionHours(dbo.tblBatch.strBatchID) AS decBatchTransactionHoursAmount, dbo.tblBatchType.strBatchTypeName, dbo.tblBatch.intBatchType, dbo.tblBatch.intTemplateID, 
                         dbo.tblBatch.ClosedByUserID, dbo.tblBatch.ClosedDateTime
FROM            dbo.tblBatch INNER JOIN
                         dbo.tblBatchStatus ON dbo.tblBatch.intBatchStatus = dbo.tblBatchStatus.intBatchStatus INNER JOIN
                         dbo.tblBatchType ON dbo.tblBatch.intBatchType = dbo.tblBatchType.intBatchType
GO
