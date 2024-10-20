USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_tblTimeAndEffortReport]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 03/31/2020
-- Description:	Time And Effort Report function. 
-- Compensations and Transaction Hours
-- =============================================
CREATE FUNCTION [dbo].[fnPay_tblTimeAndEffortReport]
(
	@BATCHID nvarchar(50) ,
	@PAYROLLCOMPANY as nvarchar(50) ,
	@STARTDATE date ,
	@ENDDATE date ,
	@USERID int 
)
RETURNS 
@tblTimeAndEffort  TABLE 
(
	strBatchID  nvarchar(50), 
	strBatchDescription  nvarchar(50), 
	intUserID  int, 
	strUserName  nvarchar(50), 
	strCompensationName  nvarchar(50), 
	decPayRate  decimal(18,2), 
	decHours   decimal(18,2), 
	intEditType  int, 
	dtPunchDate  date,  
	decPay  decimal(18,2),
	strCompanyName  nvarchar(50), 
	strCompany  nvarchar(50),
	strDepartment  nvarchar(50),
	strSubdepartment  nvarchar(50),
	strEmployeeType  nvarchar(50)
 )
AS
BEGIN
IF @BATCHID <> ''
	BEGIN
	INSERT INTO @tblTimeAndEffort
	select ubc.strBatchID, UBC.strBatchDescription,UBC.intUserID, UBC.strUserName, UBC.strCompensationName+'- '+ UBC.strGLAccount, 0 as decPayRate, 
	ISNULL(ubt.decHours,0) *
	ubc.decPay  / iif((select sum(decPay) from tblUserBatchCompensations ubc2 where ubc.strBatchID = ubc2.strBatchID AND ubc.intUserID = ubc2.intUserID and ubc.strCompensationName = ubc2.strCompensationName )=0,1,(select sum(decPay) from tblUserBatchCompensations ubc2 where ubc.strBatchID = ubc2.strBatchID AND ubc.intUserID = ubc2.intUserID and ubc.strCompensationName = ubc2.strCompensationName ))
	 as decHours,
	ubc.intEditType,  iif(ubt.dtPunchDate is null,ubc.dtPayDate,ubt.dtPunchdate) as dtPunchDate,  
	0 as decPay
	,UBC.strCompanyName, UBC.strCompany, UBC.strDepartment, UBC.strSubdepartment, UBC.strEmployeeType
	FROM
	tblUserBatchTransactions ubt	
	inner join tTransDef td on ubt.strTransactionType = td.Name
	inner join tblCompensationTransactions ct on ubt.strTransactionType = ct.strTransName
	inner join viewPay_UserBatchCompensations UBC on ubc.strBatchID = ubt.strBatchID and ubt.intUserID = ubc.intUserID  and ct.strCompensationName = ubc.strCompensationName
	and ct.strCompensationName = ubc.strCompensationName
	where  
	(ubc.strBatchID = @BATCHID) AND
	(ubt.intUserID = @USERID OR @USERID = 0) and strTransactionType NOT IN ('MEAL','MEAL_HALFT')
	and td.nPayRateTransaction = 1 
	END
ELSE
	BEGIN
	INSERT INTO @tblTimeAndEffort
	select ubc.strBatchID, UBC.strBatchDescription,UBC.intUserID, UBC.strUserName, UBC.strCompensationName+'- '+ UBC.strGLAccount, 0 as decPayRate, 
	ISNULL(ubt.decHours,0) *
	ubc.decPay  / iif((select sum(decPay) from tblUserBatchCompensations ubc2 where ubc.strBatchID = ubc2.strBatchID AND ubc.intUserID = ubc2.intUserID and ubc.strCompensationName = ubc2.strCompensationName )=0,1,(select sum(decPay) from tblUserBatchCompensations ubc2 where ubc.strBatchID = ubc2.strBatchID AND ubc.intUserID = ubc2.intUserID and ubc.strCompensationName = ubc2.strCompensationName ))
	 as decHours,
	ubc.intEditType,  iif(ubt.dtPunchDate is null,ubc.dtPayDate,ubt.dtPunchdate) as dtPunchDate,  
	0 as decPay
	,UBC.strCompanyName, UBC.strCompany, UBC.strDepartment, UBC.strSubdepartment, UBC.strEmployeeType
	FROM
	tblUserBatchTransactions ubt	
	inner join tTransDef td on ubt.strTransactionType = td.Name
	inner join tblCompensationTransactions ct on ubt.strTransactionType = ct.strTransName
	inner join viewPay_UserBatchCompensations UBC on ubc.strBatchID = ubt.strBatchID and ubt.intUserID = ubc.intUserID and ct.strCompensationName = ubc.strCompensationName
	and ct.strCompensationName = ubc.strCompensationName
	where  
	(ubc.strCompanyName= @PAYROLLCOMPANY) AND ubt.dtPunchDate BETWEEN @STARTDATE AND @ENDDATE AND
	(ubc.intUserID = @USERID OR @USERID = 0) and ubt.strTransactionType NOT IN ('MEAL','MEAL_HALFT')
	and td.nPayRateTransaction = 1 

END
	RETURN 
END
GO
