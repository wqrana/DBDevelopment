USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_WithholdingsLoansBalances]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_WithholdingsLoansBalances]
-- WITH ENCRYPTION
AS
SELECT        Loan.intUserID, Loan.strWithholdingName AS strWithHoldingsName, Loan.decLoanAmount, Loan.decWithholdingsAmount, Loan.decRemainingBalance, ur.name, ur.nCompanyID, ur.strCompanyName, ur.intPayrollUserStatus, 
                         ur.strStatusName, ur.idno, ur.sCompanyName, ur.sDeptName, ur.sJobTitleName, ur.sEmployeeTypeName, ur.nDeptID, ur.nJobTitleID, ur.nEmployeeType, ur.sSSN
FROM            (SELECT        uwl.intUserID, uwl.strWithholdingName, ISNULL(MAX(uwl.decLoanAmount), 0) AS decLoanAmount, ISNULL(SUM(ubw.decWithholdingsAmount), 0) AS decWithholdingsAmount, ISNULL(MAX(uwl.decLoanAmount), 0) 
                                                    + ISNULL(SUM(ubw.decWithholdingsAmount), 0) AS decRemainingBalance
                          FROM            dbo.tblUserWithholdingsLoans AS uwl INNER JOIN
                                                    dbo.tblWithholdingsItems AS wi ON uwl.strWithholdingName = wi.strWithHoldingsName LEFT OUTER JOIN
                                                    dbo.tblUserBatchWithholdings AS ubw ON ubw.strWithHoldingsName = uwl.strWithholdingName AND ubw.intUserID = uwl.intUserID
                          WHERE        (wi.boolIsLoan = 1)
                          GROUP BY uwl.intUserID, uwl.strWithholdingName) AS Loan INNER JOIN
                         dbo.viewPay_UserRecord AS ur ON Loan.intUserID = ur.intUserID

GO
