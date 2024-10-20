USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Adjust_GLAccounts]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera
-- Create date: 5/2/2019
-- Description:	Adjust any GL Accounts after the payroll has been computed.
--				Designed for Prymed in order to compute the gl accounts based on the jobs.
--				Returns any non-existent GL account
-- Parameters:
--				@BATCHDID nvarchar(50) --		--Batch ID
-- =============================================


CREATE PROCEDURE [dbo].[spPay_Adjust_GLAccounts]
	-- Add the parameters for the stored procedure here
	@BATCHID nvarchar(50)
	,@USERID int
-- -- WITH ENCRYPTION
AS

BEGIN
	DECLARE @SQL_SCRIPT NVARCHAR(MAX)
	DECLARE @BatchCount as int
	
	--Check that the Payweek batch has been created and get other necessary information
	DECLARE @BatchProcessedCode as int
	DECLARE @PayPeriod int
	DECLARE @PAYROLL_COMPANY nvarchar(50)
	DECLARE @BATCH_TYPE int
	select @PAYROLL_COMPANY = strCompanyName, @BatchProcessedCode = intBatchStatus from viewPay_UserBatchStatus where strBatchID =  @BATCHID 
	 and (intUserid = @USERID OR @USERID = 0)
	
	if @PAYROLL_COMPANY = 'PryMed Medical Care Inc' 
	BEGIN
		IF @BatchProcessedCode >= 0 
		BEGIN
		BEGIN TRY
			BEGIN TRANSACTION
			-- Update the batch's compensation's GL Account with the Compound GL Account
			-- FORMAT: ZZZZ-YY-XX-W-VV
			-- Z = Base GL Account
			-- Y = Department (tDept.Code)
			-- X = Program (tJobCode.sPayCode)
			-- W = Location (tJobTitle.Code)
			-- V = Fund (tCustomers.sCustomerPayCode)
		UPDATE 
			tUBC
		SET
		strGLAccount = ISNULL(	CONVERT(varchar(50),
							tCC.strGLAccount
							+ '-'
							+ tD.Code 
							+ '-'
							+ tJC.sPayCode
							+ '-'
							+ tSD.Code
							+ '-'
							+ tC.sCustomerPayCode),
							'')
		FROM	tblUserBatchCompensations AS tUBC
		LEFT OUTER JOIN tUser AS tU ON tU.id = tUBC.intUserID
		LEFT OUTER JOIN tDept AS tD ON tD.ID = tU.nDeptID
		LEFT OUTER JOIN tJobTitle AS tSD ON tSD.ID = tU.nJobTitleID
		LEFT OUTER JOIN tJobCode AS tJC ON tJC.nJobCodeID = tU.sNotes
		LEFT OUTER JOIN tProject AS tP ON tP.nProjectID = tJC.nProjectID
		LEFT OUTER JOIN tCustomers AS tC ON tC.nCustomerID = tP.nCustomerID
		LEFT OUTER JOIN tblCompanyCompensations AS tCC ON tCC.strCompensationName = tUBC.strCompensationName
		WHERE
		strBatchID = @BATCHID
		and(intUserid = @USERID OR @USERID = 0)
		and (tUBC.intEditType =0 OR len(tubc.strGLAccount) <= 4) --only those that are not edited or edits that do not have the full GL

	
	--Insert copies of the employees wth userjobocde data into a temporary table		
	--Update the records of the 4 employees
		IF OBJECT_ID('tempdb..#tblUserBatchCompensations') IS NOT NULL 
		BEGIN 
			DROP TABLE #tblUserBatchCompensations
		END
		
		select ubc.* into #tblUserBatchCompensations from  tblUserBatchCompensations ubc 
			where strBatchID = @BATCHID and  (intUserID = @USERID OR @USERID = 0)
			and intUserID IN (select nuserid from tUserJobCodes group by nUserID having count(*)>1 )

			--Delete the employees from tblUserBatchCompensations
		DELETE ubc from  tblUserBatchCompensations ubc  	
			where strBatchID = @BATCHID and  (intUserID = @USERID OR @USERID = 0)
			and intUserID IN (select nuserid from tUserJobCodes group by nUserID having count(*)>1 )

	INSERT INTO [dbo].[tblUserBatchCompensations]
          ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours]
          ,[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intEditType],[intUBMESequence],[strGLAccount_AJB],[intJobCodeID])
	SELECT [strBatchID] ,[intUserID],
			[strCompensationName],
			[decPayRate],
			[dtPayDate],
			[decHours] * ujc.dblPercent/100 as decHours
           ,[decPay] * ujc.dblPercent/100 
           ,[dtTimeStamp]
           ,ujc.strGLAccount as [strGLAccount]
           ,[boolDeleted]
           ,[intEditType]
           ,[intUBMESequence]
           ,[strGLAccount_AJB]
           ,ujc.nJobCodeID as [intJobCodeID]
     from  #tblUserBatchCompensations ubc 
	inner join tUserJobCodes ujc on ubc.intUserID = ujc.nUserID 
	where strBatchID = @BATCHID and (intUserid = @USERID OR @USERID = 0)

		--Fix any differences in compensations due to split
	UPDATE cbw set  [decPay] = cbw.[decPay] -Diff
		from [tblUserBatchCompensations] cbw
		INNER JOIN 
		(select cbw.strbatchid, (sum(cbw.decWithholdingsAmount) - max(t.[decPay])) Diff, 
		cbw.intUserID, cbw.strWithHoldingsName, sum(cbw.decWithholdingsAmount) decWithholdingsAmount, max(t.[decPay]) TAmount 
		, max(cbw.intSequenceNumber) as intSequenceNumber
		from tblCompanyBatchWithholdings cbw inner join #tblUserBatchCompensations t 
		on cbw.strBatchID = t.strBatchID  and cbw.strWithHoldingsName = t.[strCompensationName] and cbw.intUserID = t.intUserID
		group by cbw.strbatchid,cbw.intUserID, cbw.strWithHoldingsName
		having sum(cbw.decWithholdingsAmount) <> max(t.[decPay]) ) ADJ
		ON cbw.intSequenceNumber = adj.intSequenceNumber

	--SET PLAN MEDICO
		-- Update the batch's company contribution's GL Account with the Compound GL Account
	-- FORMAT: ZZZZ-YY-XX-W-VV
	-- Z = Base GL Account
	-- Y = Department (tDept.Code)
	-- X = Program (tJobCode.sPayCode)
	-- W = Location (tJobTitle.Code)
	-- V = Fund (tCustomers.sCustomerPayCode)
		UPDATE 
			tCBW
		SET
			strGLAccount = ISNULL(	CONVERT(varchar(50),
									tCW.strGLAccount_Contributions
									+ '-'
									+ tD.Code 
									+ '-'
									+ tJC.sPayCode
									+ '-'
									+ tSD.Code
									+ '-'
									+ tC.sCustomerPayCode),
									'')
									,strGLContributionPayable = tcw.strGLContributionPayable
		FROM
			tblCompanyBatchWithholdings AS tCBW
			LEFT OUTER JOIN tUser AS tU ON tU.id = tCBW.intUserID
			LEFT OUTER JOIN tDept AS tD ON tD.ID = tU.nDeptID
			LEFT OUTER JOIN tJobTitle AS tSD ON tSD.ID = tU.nJobTitleID
			LEFT OUTER JOIN tJobCode AS tJC ON tJC.nJobCodeID = tU.sNotes
			LEFT OUTER JOIN tProject AS tP ON tP.nProjectID = tJC.nProjectID
			LEFT OUTER JOIN tCustomers AS tC ON tC.nCustomerID = tP.nCustomerID
			LEFT OUTER JOIN tblCompanyWithholdings AS tCW ON tCW.strWithHoldingsName = tCBW.strWithHoldingsName
		WHERE
			strBatchID = @BATCHID  
					and (intUserid = @USERID OR @USERID = 0)
					and tCBW.intEditType = 0 --only those that are not edited
		and tCBW.strWithHoldingsName LIKE '%PLAN MED%'
	
	-- Update the batch's company contribution's GL Account with the Compound GL Account
	-- FORMAT: ZZZZ-YY-XX-W-VV
	-- Z = Base GL Account
	-- Y = Department (tDept.Code)
	-- X = Program (tJobCode.sPayCode)
	-- W = Location (tJobTitle.Code)
	-- V = Fund (tCustomers.sCustomerPayCode)
	
	DECLARE @Split as int = 2
	IF @USERID = 0
		SET @Split =2
	ELSE
		select @Split = count( distinct right(strGLAccount,11)) from tblUserBatchCompensations where strBatchID = @BATCHID and intUserID = @USERID
	
	IF @Split > 1
		BEGIN
	--Drop temp if exists
	IF OBJECT_ID('tempdb..#tblCompanyBatchWithholdings ') IS NOT NULL 
	BEGIN 
		DROP TABLE #tblCompanyBatchWithholdings 
	END
		
		select ROW_NUMBER() OVER(order by intuserID ASC ) as intUnique , * into #tblCompanyBatchWithholdings FROM  [dbo].[tblCompanyBatchWithholdings]
		where strBatchID = @BATCHID 
		and boolDeleted = 0
		and decBatchEffectivePay <> 0
		and (intUserid = @USERID OR @USERID = 0)
		and strWithHoldingsName not like '%PLAN MED%'

		delete FROM  [dbo].[tblCompanyBatchWithholdings]
		where strBatchID = @BATCHID 
		and boolDeleted = 0
		and decBatchEffectivePay <> 0
		and (intUserid = @USERID OR @USERID = 0)
		and strWithHoldingsName not like '%PLAN MED%'

		INSERT INTO [dbo].[tblCompanyBatchWithholdings]
				   ([strBatchID]
				   ,[intUserID]
				   ,[strWithHoldingsName]
				   ,[dtPayDate]
				   ,[decBatchEffectivePay]
				   ,[decWithholdingsAmount]
				   ,[intPrePostTaxDeduction]
				   ,[strGLAccount]
				   ,[boolDeleted]
				   ,[dtTimeStamp]
				   ,[intEditType]
				   ,[intUBMESequence]
				   ,[strGLAccount_AJB]
				   ,[strGLContributionPayable])
		select @BATCHID, cbw.intUserID,cbw.strWithHoldingsName,cbw.dtPayDate,cbw.decBatchEffectivePay,
		round(cbw.decWithholdingsAmount * ubc.decPay / cbw.decBatchEffectivePay ,2)  decWithholdingsAmount
		,cbw.intPrePostTaxDeduction
				   ,left(cbw.strGLAccount,4) + right(ubc.strGLAccount,11) strGLAccount
				   ,[boolDeleted]
				   ,[dtTimeStamp]
				   ,[intEditType]
				   ,[intUBMESequence]
				   ,[strGLAccount_AJB]
				   ,[strGLContributionPayable]
		FROM
		(		
		select strBatchID, right(strGLAccount,11) strGLAccount, intUserID, sum(decPay) decPay from tblUserBatchCompensations ubc 
		where strBatchID = @BATCHID and (intUserID = @USERID OR @USERID =0)
		group by strBatchID, right(strGLAccount,11), intUserID
				)ubc
		inner join
		#tblCompanyBatchWithholdings cbw 
		ON ubc.strBatchID = cbw.strBatchID AND ubc.intUserID = cbw.intUserID
		where ubc.strBatchID = @BATCHID 
		and(ubc.intUserid = @USERID OR @USERID = 0)
		and cbw.boolDeleted = 0
		and cbw.decBatchEffectivePay <> 0
	


		--Fix any differences in contributions due to split
		UPDATE cbw set  decWithholdingsAmount = cbw.decWithholdingsAmount -Diff
		from tblCompanyBatchWithholdings cbw
		INNER JOIN 
		(select cbw.strbatchid, (sum(cbw.decWithholdingsAmount) - max(t.decWithholdingsAmount)) Diff, 
		cbw.intUserID, cbw.strWithHoldingsName, sum(cbw.decWithholdingsAmount) decWithholdingsAmount, max(t.decWithholdingsAmount) TAmount 
		, max(cbw.intSequenceNumber) as intSequenceNumber
		from tblCompanyBatchWithholdings cbw inner join #tblCompanyBatchWithholdings t 
		on cbw.strBatchID = t.strBatchID  and cbw.strWithHoldingsName = t.strWithHoldingsName and cbw.intUserID = t.intUserID
		group by cbw.strbatchid,cbw.intUserID, cbw.strWithHoldingsName
		having sum(cbw.decWithholdingsAmount) <> max(t.decWithholdingsAmount) ) ADJ
		ON cbw.intSequenceNumber = adj.intSequenceNumber
		END
	ELSE
		BEGIN
	
	-- Update the batch's company contribution's GL Account with the Compound GL Account
	-- FORMAT: ZZZZ-YY-XX-W-VV
	-- Z = Base GL Account
	-- Y = Department (tDept.Code)
	-- X = Program (tJobCode.sPayCode)
	-- W = Location (tJobTitle.Code)
	-- V = Fund (tCustomers.sCustomerPayCode)
		UPDATE 
			tCBW
		SET
			strGLAccount = ISNULL(	CONVERT(varchar(50),
									tCW.strGLAccount_Contributions
									+ '-'
									+ tD.Code 
									+ '-'
									+ tJC.sPayCode
									+ '-'
									+ tSD.Code
									+ '-'
									+ tC.sCustomerPayCode),
									'')
									,strGLContributionPayable = tcw.strGLContributionPayable
		FROM
			tblCompanyBatchWithholdings AS tCBW
			LEFT OUTER JOIN tUser AS tU ON tU.id = tCBW.intUserID
			LEFT OUTER JOIN tDept AS tD ON tD.ID = tU.nDeptID
			LEFT OUTER JOIN tJobTitle AS tSD ON tSD.ID = tU.nJobTitleID
			LEFT OUTER JOIN tJobCode AS tJC ON tJC.nJobCodeID = tU.sNotes
			LEFT OUTER JOIN tProject AS tP ON tP.nProjectID = tJC.nProjectID
			LEFT OUTER JOIN tCustomers AS tC ON tC.nCustomerID = tP.nCustomerID
			LEFT OUTER JOIN tblCompanyWithholdings AS tCW ON tCW.strWithHoldingsName = tCBW.strWithHoldingsName
		WHERE
			strBatchID = @BATCHID  
					and (intUserid = @USERID OR @USERID = 0)
					and tCBW.intEditType = 0 --only those that are not edited
		END
	
--Commit the transaction
		COMMIT


	--	return @@rowcount
		END TRY
		BEGIN CATCH
			ROLLBACK ;
			 SELECT   
				ERROR_NUMBER() AS ErrorNumber  
			   ,ERROR_MESSAGE() AS ErrorMessage; 
		END CATCH
	END
	ELSE
	if @BatchProcessedCode is null 
			THROW 100002, 'Batch does not exist.',1
	END
END
GO
