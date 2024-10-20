USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblPrymedMissingGLReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--==========================
-- Author:           Alexander Rivera Toro
-- Create date: 05/03/2018
-- Description:      For PryMed Export.  Returns any GLs that are not well configured

-- =============================================

CREATE FUNCTION [dbo].[fnPay_tblPrymedMissingGLReport]

(     

       @BATCHID nvarchar(50)
)

RETURNS

@tblPrymedMissingGLReport TABLE

(
			intUserID int, 
			strUserName nvarchar(50),	
			 strCompensationName nvarchar(50),
			New_GLAccount nvarchar(50),
			ExistsInGLAccounts int,
			BaseGLAccount nvarchar(50),
			Dept_Code nvarchar(50),
			JobCode_Code nvarchar(50),
			SubDept_Code nvarchar(50),
			Fund_Code nvarchar(50),
			strGLAccount nvarchar(50)
)

-- WITH ENCRYPTION

AS

BEGIN

 


------ Get Compensation's Compound GL Account
--INSERT INTO @tblPrymedMissingGLReport
--SELECT
--	intUserID, 
--	name,	
--	strCompensationName,
--	New_GLAccount,
--	CASE ISNULL(tGL.strAccountID,'')
--		WHEN '' THEN 0
--		ELSE 1
--	END AS ExistsInGLAccounts,
--	BaseGLAccount,
--	Dept_Code,
--	JobCode_Code,
--	SubDept_Code,
--	Fund_Code,
--	strGLAccount
--FROM
--	(
--		SELECT
--			intUserID, 
--			tu.name,	
--			tUBC.strCompensationName,
--			CONVERT(varchar(100),
--				tCC.strGLAccount
--				+ '-'
--				+ tD.Code 
--				+ '-'
--				+ tJC.sPayCode
--				+ '-'
--				+ tSD.Code
--				+ '-'
--				+ tC.sCustomerPayCode) as New_GLAccount,
--			tCC.strGLAccount AS BaseGLAccount,
--			tD.Code Dept_Code,
--			tJC.sPayCode JobCode_Code,
--			tSD.Code SubDept_Code,
--			tC.sCustomerPayCode Fund_Code,
--			tUBC.strGLAccount
--		FROM 
--			tblUserBatchCompensations AS tUBC
--			LEFT OUTER JOIN tUser AS tU ON tU.id = tUBC.intUserID
--			LEFT OUTER JOIN tDept AS tD ON tD.ID = tU.nDeptID
--			LEFT OUTER JOIN tJobTitle AS tSD ON tSD.ID = tU.nJobTitleID
--			LEFT OUTER JOIN tJobCode AS tJC ON tJC.nJobCodeID = tU.sNotes
--			LEFT OUTER JOIN tProject AS tP ON tP.nProjectID = tJC.nProjectID
--			LEFT OUTER JOIN tCustomers AS tC ON tC.nCustomerID = tP.nCustomerID
--			LEFT OUTER JOIN tblCompanyCompensations AS tCC ON tCC.strCompensationName = tUBC.strCompensationName
--		WHERE
--			strBatchID =@BATCHID
--	) AS tblCompoundGL
--	LEFT OUTER JOIN tblGLAccounts AS tGL ON tGL.strAccountID = tblCompoundGL.New_GLAccount
--WHERE
--	ISNULL(tGL.strAccountID,'') = '' -- Traer solo las entradas que el GL Compuesto NO existe en tblGLAccounts.
--ORDER BY
--	intUserID asc, strCompensationName asc


------ Get Company Contribution's Compound GL Account
--INSERT INTO @tblPrymedMissingGLReport
--SELECT	
--	intUserID, 
--	name,	
--	strWithHoldingsName,
--	New_GLAccount,
--	CASE ISNULL(tGL.strAccountID,'')
--		WHEN '' THEN 0
--		ELSE 1
--	END AS ExistsInGLAccounts,
--	BaseGLAccount,
--	Dept_Code,
--	JobCode_Code,
--	SubDept_Code,
--	Fund_Code,
--	strGLAccount
--FROM
--	(
--		SELECT
--			intUserID, 
--			tu.name,	
--			tCBW.strWithHoldingsName,
--			CONVERT(varchar(100),
--				tCW.strGLAccount_Contributions
--				+ '-'
--				+ tD.Code 
--				+ '-'
--				+ tJC.sPayCode
--				+ '-'
--				+ tSD.Code
--				+ '-'
--				+ tC.sCustomerPayCode) as New_GLAccount,
--			tCW.strGLAccount_Contributions AS BaseGLAccount,
--			tD.Code Dept_Code,
--			tJC.sPayCode JobCode_Code,
--			tSD.Code SubDept_Code,
--			tC.sCustomerPayCode Fund_Code,
--			tCBW.strGLAccount
--		FROM 
--			tblCompanyBatchWithholdings AS tCBW
--			LEFT OUTER JOIN tUser AS tU ON tU.id = tCBW.intUserID
--			LEFT OUTER JOIN tDept AS tD ON tD.ID = tU.nDeptID
--			LEFT OUTER JOIN tJobTitle AS tSD ON tSD.ID = tU.nJobTitleID
--			LEFT OUTER JOIN tJobCode AS tJC ON tJC.nJobCodeID = tU.sNotes
--			LEFT OUTER JOIN tProject AS tP ON tP.nProjectID = tJC.nProjectID
--			LEFT OUTER JOIN tCustomers AS tC ON tC.nCustomerID = tP.nCustomerID
--			LEFT OUTER JOIN tblCompanyWithholdings AS tCW ON tCW.strWithHoldingsName = tCBW.strWithHoldingsName
--		WHERE
--			strBatchID = @BATCHID
--	) AS tblCompoundGL
--	LEFT OUTER JOIN tblGLAccounts AS tGL ON tGL.strAccountID = tblCompoundGL.New_GLAccount
--WHERE
--	ISNULL(tGL.strAccountID,'') = '' -- Traer solo las entradas que el GL Compuesto NO existe en tblGLAccounts.
--ORDER BY
--	intUserID asc, strWithHoldingsName asc

RETURN
END

GO
