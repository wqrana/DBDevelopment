USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Update_CFSEAssignmentFields]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 3/21/2019
-- Description:	Updates any CFSE assignments from Department or Subdepartment
--				CFSE must be created.
--				This stored procedure may need customization for each client
-- =============================================
CREATE PROCEDURE [dbo].[spPay_Update_CFSEAssignmentFields]
AS
BEGIN

	SET NOCOUNT ON;
	--UPDATE CFSE company contribution based on department
	UPDATE uwi set decCompanyPercent= d.decCFSECompanyPercent, strClassIdentifier = d.strCFSECode from tblUserWithholdingsItems uwi inner join tuser u on uwi.intUserID = u.id
	inner join tDept d on u.nDeptID = d.ID
	where strWithHoldingsName ='CFSE' and d.boolUSECFSEAssignment =  1 
	and intUserID not in (select intUserID from tblCSFEAssignmentExclude where boolExcludeAssignment = 1)
	--UPDATE CFSE company contribution based on subdepartment
	UPDATE uwi set decCompanyPercent= jt.decCFSECompanyPercent, strClassIdentifier = jt.strCFSECode from tblUserWithholdingsItems uwi inner join tuser u on uwi.intUserID = u.id
	inner join tJobTitle jt on u.nJobTitleID = jt.ID
	where strWithHoldingsName ='CFSE' and jt.boolUSECFSEAssignment = 1
	and intUserID not in (select intUserID from tblCSFEAssignmentExclude where boolExcludeAssignment = 1)

END

GO
