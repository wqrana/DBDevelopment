USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_UserBatchWithholdings]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[spPay_Create_UserBatchWithholdings]    Script Date: 8/24/2017 6:22:07 PM ******/
-- =============================================
-- Author:		Alexander Rivera
-- Create date: 6/15/2016
-- Description:	Computes the withholdings and contributions of a batch, user
--				UserID = 0 is all users
--		@BATCHID nvarchar(50) -- Company Batch
--		@UserID int						--User to import transactions
--		@PAYDATE smalldatetime			--NO LONGER USED
-- =============================================
CREATE PROCEDURE [dbo].[spPay_Create_UserBatchWithholdings]
	-- Add the parameters for the stored procedure here
	@BATCHID nvarchar(50),
	@USERID int,
	@PAYDATE as datetime
-- WITH ENCRYPTION
AS
BEGIN
	DECLARE @BatchCount as int
	DECLARE @TEMPLATEID int
	declare @BATCHPROCESSEDCODE as int

	--Check that the Payweek batch has been created.  If it has, then the withholdings can be created
	--DECLARE @PayPeriod int
	DECLARE @PAYROLL_COMPANY nvarchar(50)
	DECLARE @BATCH_TYPE int
	DECLARE @intPayWeekNum int
	IF @USERID = 0
		select TOP(1) @BATCHPROCESSEDCODE = intBatchStatus, @PAYROLL_COMPANY = strCompanyName, @BATCH_TYPE = intBatchType, @PAYDATE = dtPayDate, @TEMPLATEID = intTemplateID , @intPayWeekNum = intPayWeekNum from viewPay_UserBatchStatus where strBatchID =  @BATCHID 
	ELSE
		select @BATCHPROCESSEDCODE = intUserBatchStatus, @PAYROLL_COMPANY = strCompanyName, @BATCH_TYPE = intBatchType, @PAYDATE = dtPayDate, @TEMPLATEID = intTemplateID , @intPayWeekNum = intPayWeekNum from viewPay_UserBatchStatus where strBatchID =  @BATCHID AND intUserID = @USERID
	
	IF @BATCHPROCESSEDCODE >= 0 -- means that compensations have already been computed
		BEGIN TRY
			BEGIN TRANSACTION
			SET NOCOUNT ON;

			--DELETE any previous entries
			DELETE from tblUserBatchWithholdings	where strBatchID = @BATCHID and (intUserID = @USERID OR @USERID = 0)
			DELETE from tblCompanyBatchWithholdings	where strBatchID = @BATCHID and (intUserID = @USERID OR @USERID = 0)

			--declare @TaxableIncome decimal(18,2)
			--set @TaxableIncome = [dbo].[fnPay_BatchTaxablePay] (@BATCHID, @USERID)
			
			--Pay Period according to pay type
			--SELECT @PayPeriod  = [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,@USERID)

			--Process the PreTax First and Create the entries
			--Employee Withholdings
			IF @TEMPLATEID = 0
				BEGIN

				--Pay Period Specific		
				IF @BATCH_TYPE = 0 --Regular Payroll
					BEGIN
						--DEGUG
						SELECT	case 
							when @intPayWeekNum > 300000000 then 'Semimonthly'
							when @intPayWeekNum > 100000000  then 'Biweekly'
							else 'Weekly'
						END as PeriodType
						--DEGUG

						insert into [dbo].[tblUserBatchWithholdings] (strBatchID, intUserID,dtPayDate, strWithHoldingsName, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction,strGLAccount,boolDeleted,intEditType,intUBMESequence)
						select  bcw.strBatchID, bcw.intUserID, @PayDate, bcw.strWithHoldingsName, bcw.decBatchEffectivePay, bcw.decBatchEmployeeWithholding, uw.intPrePostTaxDeduction, uw.strGLAccount, 0 ,0,0
						from dbo.viewPay_UserWithholdingItems uw cross apply   [dbo].[fnPay_tblUserComputeWithholdings] (  @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
						where uw.intPrePostTaxDeduction = 0 and uw.boolDeleted = 0  and bcw.decBatchEmployeeWithholding <> 0 
						AND (uw.intUserID = @USERID OR @USERID = 0) AND
						case 
							when uw.intPeriodEntryID = 0 then 1
							when uw.intPeriodEntryID = -1 then 1
							when uw.intPeriodEntryID =[dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) then 1
							when uw.intPeriodEntryID =-3 then
								case 
								when @intPayWeekNum > 300000000 then 1 --'Semimonthly does not happen more than 2 a month

								when @intPayWeekNum > 100000000  then --'Biweekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) <> 3,1,0)
								else --'Weekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) <> 5,1,0)
								END
						END = 1
					END
				ELSE	
						-- Additional Payroll Specific
						BEGIN
							insert into [dbo].[tblUserBatchWithholdings] (strBatchID, intUserID,dtPayDate, strWithHoldingsName, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction,strGLAccount,boolDeleted,intEditType,intUBMESequence)
							select  bcw.strBatchID, bcw.intUserID, @PayDate, bcw.strWithHoldingsName, bcw.decBatchEffectivePay, bcw.decBatchEmployeeWithholding, uw.intPrePostTaxDeduction, uw.strGLAccount, 0 ,0,0
							from dbo.viewPay_UserWithholdingItems uw cross apply   [dbo].[fnPay_tblUserComputeWithholdings] (  @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
							where uw.intPrePostTaxDeduction = 0 and uw.boolDeleted = 0  and bcw.decBatchEmployeeWithholding <> 0 and uw.intPeriodEntryID IN (0,-2)
							AND (uw.intUserID = @USERID OR @USERID = 0)

						END
				END
			ELSE 
			--USE TEMPLATE 
				BEGIN
					insert into [dbo].[tblUserBatchWithholdings] (strBatchID, intUserID,dtPayDate, strWithHoldingsName, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction,strGLAccount,boolDeleted,intEditType,intUBMESequence)
					select  bcw.strBatchID, bcw.intUserID, @PayDate, bcw.strWithHoldingsName, bcw.decBatchEffectivePay, bcw.decBatchEmployeeWithholding, uw.intPrePostTaxDeduction, uw.strGLAccount, 0 ,0,0
					from dbo.viewPay_UserWithholdingItems uw cross apply   [dbo].[fnPay_tblUserComputeWithholdings] (  @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
					where uw.intPrePostTaxDeduction = 0 and uw.boolDeleted = 0  and bcw.decBatchEmployeeWithholding <> 0
					AND (uw.intUserID = @USERID OR @USERID = 0)
					AND uw.strWithHoldingsName IN (select strWithHoldingsName FROM tblPayrollTemplatesUserWithholdings where intPayrollTemplateID = @TEMPLATEID AND intUserID = uw.intUserID)
				END

	--TIPS (FOR METROPOL)
	
	INSERT INTO [dbo].[tblUserBatchWithholdings]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction]
           ,[strGLAccount],[boolDeleted],[dtTimeStamp]          ,[intEditType]           ,[intUBMESequence])
		   SELECT 
		   bt.strBatchID [strBatchID]
           ,bt.intUserID [intUserID]
           ,tips.strWithholdingsName [strWithHoldingsName]
           ,max(ub.dtPayDate) [dtPayDate]
           ,dbo.fnPay_BatchTaxablePay(bt.strBatchID, bt.intUserID) [decBatchEffectivePay]
           ,-  sum(bt.decMoneyValue) [decWithholdingsAmount]
           ,max(wi.intPrePostTaxDeduction) [intPrePostTaxDeduction]
           ,uwi.strGLAccount [strGLAccount]
           ,0 [boolDeleted]
           ,getdate() [dtTimeStamp]
           ,0 [intEditType]
           ,0 [intUBMESequence]
		   FROM tblUserBatchTransactions bt inner join tblCompensationTransactions ct on bt.strTransactionType = ct.strTransName 
			inner join [dbo].[tblUserCompensationItems] uc ON bt.intUserID = uc.intUserID and ct.strCompensationName = uc.strCompensationName
			inner join viewPay_UserBatchStatus ub ON bt.intUserID = ub.intUserID AND bt.strBatchID = ub.strBatchID
			inner join tblCompensationTips tips on ct.strCompensationName = tips.strCompensationName
			inner join tblUserWithholdingsItems uwi on tips.strWithholdingsName = uwi.strWithHoldingsName AND uwi.intUserID = bt.intUserID
			inner join tblWithholdingsItems wi on uwi.strWithHoldingsName = wi.strWithHoldingsName
			where bt.strBatchID = @BATCHID 
			AND (bt.intUserID = @USERID OR @USERID = 0) 
			GROUP BY bt.strBatchID, bt.intUserID, uc.strCompensationName,TIPS.strWithholdingsName, bt.decPayRate,uwi.strGLAccount

			--Compute the Hacienda settings for all users in the batch.
			IF @USERID = 0
			BEGIN
				DECLARE @LoopUserID int = 0
				WHILE(1 = 1)
				BEGIN
				SELECT @LoopUserID = MIN(ub.intUserID)
				FROM dbo.tblUserBatch ub inner join tblUserHaciendaOptions uho ON ub.intUserID = uho.intUserID
				WHERE ub.strBatchID = @BATCHID and  ub.intUserID > @LoopUserID and uho.intComputePerPayroll <> 0
				IF @LoopUserID IS NULL BREAK
					EXEC	 [dbo].[spPay_ComputeHaciendaTable] @BATCHID, @LoopUserID
				END
			END
			ELSE
				BEGIN
					--Compute that hacienda retention values if 'Compute Per Payroll' is set
					EXEC	 [dbo].[spPay_ComputeHaciendaTable] @BATCHID, @USERID
				END
			IF @TEMPLATEID = 0
				BEGIN
						--Hacienda Withholdings - Only User Withholdings
						insert into [dbo].[tblUserBatchWithholdings] (strBatchID, intUserID,dtPayDate, strWithHoldingsName, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction,strGLAccount,boolDeleted,intEditType,intUBMESequence)			
						select  strBatchID,intUserID, @PAYDATE as dtPayDate,[dbo].[fnPay_GetHaciendaStateTaxName] (intUserID) as strWithHoldingsName,[dbo].[fnPay_BatchTaxablePay] (@BATCHID, intUserID) as decBatchEffectivePay,[dbo].[fnPay_HaciendaWithholdings](@BATCHID, intUserID ,@PAYDATE) as decWithholdingsAmount, 0,
						isnull((select top(1) uwi.strGLAccount from tblUserWithholdingsItems uwi inner join tblWithholdingsItems wi on uwi.strWithHoldingsName = wi.strWithHoldingsName where intUserID = tblUserBatchCompensations.intUserID and wi.intComputationType = -1 and uwi.boolDeleted = 0),'') as HaciendaGLAccunt,0,0,0
						from tblUserBatchCompensations	where strBatchID = @BATCHID and boolDeleted = 0
						AND (intUserID = @USERID OR @USERID = 0) and [dbo].[fnPay_GetHaciendaStateTaxName] (intUserID) <> ''
						Group by strBatchID, intUserID
				END
			ELSE
					--USE TEMPLATE 
				BEGIN
						--Hacienda Withholdings - Only User Withholdings
						insert into [dbo].[tblUserBatchWithholdings] (strBatchID, intUserID,dtPayDate, strWithHoldingsName, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction,strGLAccount,boolDeleted,intEditType,intUBMESequence)			
						select  strBatchID,intUserID, @PAYDATE as dtPayDate,[dbo].[fnPay_GetHaciendaStateTaxName] (intUserID) as strWithHoldingsName,[dbo].[fnPay_BatchTaxablePay] (@BATCHID, intUserID) as decBatchEffectivePay,[dbo].[fnPay_HaciendaWithholdings](@BATCHID, intUserID ,@PAYDATE) as decWithholdingsAmount, 0, 
						isnull((select top(1) uwi.strGLAccount from tblUserWithholdingsItems uwi inner join tblWithholdingsItems wi on uwi.strWithHoldingsName = wi.strWithHoldingsName where intUserID = tblUserBatchCompensations.intUserID and wi.intComputationType = -1 and uwi.boolDeleted = 0),'') as HaciendaGLAccunt,0,0,0
						from tblUserBatchCompensations	where strBatchID = @BATCHID and (intUserID = @USERID OR @USERID = 0) and boolDeleted = 0
						AND [dbo].[fnPay_GetHaciendaStateTaxName] (intUserID) IN (select strWithHoldingsName FROM tblPayrollTemplatesUserWithholdings t where intPayrollTemplateID = @TEMPLATEID
						AND t.intUserID = intUserID) and [dbo].[fnPay_GetHaciendaStateTaxName] (intUserID) <> ''
						Group by strBatchID, intUserID
				END

		  --Company Withholdings
				IF @TEMPLATEID = 0
					BEGIN

					IF @BATCH_TYPE = 0  --REGULAR TEMPLATE
						BEGIN
							insert into [dbo].[tblCompanyBatchWithholdings] (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
							select  bcw.strBatchID, bcw.intUserID, bcw.strWithHoldingsName, @PayDate, bcw.decBatchEffectivePay, bcw.decBatchCompanyWithholding, uw.intPrePostTaxDeduction,uw.strGLAccount_Contributions ,0,getdate(),0,0,strGLContributionPayable
							from dbo.viewPay_UserWithholdingItems uw cross apply   [dbo].[fnPay_tblUserComputeWithholdings] (  @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
							where uw.intPrePostTaxDeduction = 0 and uw.boolDeleted = 0  and bcw.decBatchCompanyWithholding <> 0 
							AND (uw.intUserID = @USERID OR @USERID = 0) AND
							case 
							when uw.intPeriodEntryID = 0 then 1
							when uw.intPeriodEntryID = -1 then 1
							when uw.intPeriodEntryID =[dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) then 1
							when uw.intPeriodEntryID =-3 then
								case 
								when @intPayWeekNum > 300000000 then 1 --'Semimonthly does not happen more than 2 a month

								when @intPayWeekNum > 100000000  then --'Biweekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) <> 3,1,0)
								else --'Weekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) <> 5,1,0)
								END
						END = 1


						END
					ELSE	
						-- Additional Payroll Specific
						BEGIN
							insert into [dbo].[tblCompanyBatchWithholdings] (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
							select  bcw.strBatchID, bcw.intUserID, bcw.strWithHoldingsName, @PayDate, bcw.decBatchEffectivePay, bcw.decBatchCompanyWithholding, uw.intPrePostTaxDeduction,uw.strGLAccount_Contributions ,0,getdate(),0,0,strGLContributionPayable
							from dbo.viewPay_UserWithholdingItems uw cross apply   [dbo].[fnPay_tblUserComputeWithholdings] (  @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
							where uw.intPrePostTaxDeduction = 0 and uw.boolDeleted = 0  and bcw.decBatchCompanyWithholding <> 0 and uw.intPeriodEntryID IN (0,-2)
							AND (uw.intUserID = @USERID OR @USERID = 0) 

						END
					END
				ELSE
					--USE TEMPLATE 
					BEGIN
						insert into [dbo].[tblCompanyBatchWithholdings] (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
						select  bcw.strBatchID, bcw.intUserID, bcw.strWithHoldingsName, @PayDate, bcw.decBatchEffectivePay, bcw.decBatchCompanyWithholding, uw.intPrePostTaxDeduction,uw.strGLAccount_Contributions ,0,getdate(),0,0,strGLContributionPayable
						from dbo.viewPay_UserWithholdingItems uw 
						cross apply   [dbo].[fnPay_tblUserComputeWithholdings] (  @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
						where uw.intPrePostTaxDeduction = 0 and uw.boolDeleted = 0  and bcw.decBatchCompanyWithholding <> 0
						AND (uw.intUserID = @USERID OR @USERID = 0) 
						AND uw.strWithHoldingsName IN (select strWithHoldingsName FROM tblPayrollTemplatesCompanyContributions where intUserID = uw.intUserID AND intPayrollTemplateID = @TEMPLATEID)
					END
		
			--Process the PostTax from  and Create the entries
			--Employee Withholdings
			IF @TEMPLATEID = 0
				BEGIN
				
					IF @BATCH_TYPE = 0  --REGULAR TEMPLATE
						BEGIN
							insert into [dbo].[tblUserBatchWithholdings] (strBatchID, intUserID, dtPayDate, strWithHoldingsName, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction,strGLAccount, boolDeleted,intEditType,intUBMESequence)
							select  bcw.strBatchID, bcw.intUserID, @PayDate, bcw.strWithHoldingsName, bcw.decBatchEffectivePay, bcw.decBatchEmployeeWithholding, uw.intPrePostTaxDeduction,strGLAccount,0,0,0
							from dbo.viewPay_UserWithholdingItems uw cross apply   [fnPay_tblUserComputeWithholdings] (   @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
							where uw.intPrePostTaxDeduction = 1 and uw.boolDeleted = 0 and uw.boolDeleted = 0  and bcw.decBatchEmployeeWithholding <> 0 
							AND (uw.intUserID = @USERID OR @USERID = 0) AND 
							case 
							when uw.intPeriodEntryID = 0 then 1
							when uw.intPeriodEntryID = -1 then 1
							when uw.intPeriodEntryID =[dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) then 1
							when uw.intPeriodEntryID =-3 then
								case 
								when @intPayWeekNum > 300000000 then 1 --'Semimonthly does not happen more than 2 a month

								when @intPayWeekNum > 100000000  then --'Biweekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) <> 3,1,0)
								else --'Weekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) <> 5,1,0)
								END
						END = 1


						END
					ELSE	
						-- Additional Payroll Specific
						BEGIN
								insert into [dbo].[tblUserBatchWithholdings] (strBatchID, intUserID, dtPayDate, strWithHoldingsName, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction,strGLAccount, boolDeleted,intEditType,intUBMESequence)
								select  bcw.strBatchID, bcw.intUserID, @PayDate, bcw.strWithHoldingsName, bcw.decBatchEffectivePay, bcw.decBatchEmployeeWithholding, uw.intPrePostTaxDeduction,strGLAccount,0,0,0
								from dbo.viewPay_UserWithholdingItems uw cross apply   [fnPay_tblUserComputeWithholdings] (   @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
								where uw.intPrePostTaxDeduction = 1 and uw.boolDeleted = 0 and uw.boolDeleted = 0  and bcw.decBatchEmployeeWithholding <> 0 and uw.intPeriodEntryID IN (0,-2)
								AND (uw.intUserID = @USERID OR @USERID = 0) 
						END
					END
			ELSE 
				--USE TEMPLATE 
				BEGIN
					insert into [dbo].[tblUserBatchWithholdings] (strBatchID, intUserID, dtPayDate, strWithHoldingsName, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction,strGLAccount, boolDeleted,intEditType,intUBMESequence)
					select  bcw.strBatchID, bcw.intUserID, @PayDate, bcw.strWithHoldingsName, bcw.decBatchEffectivePay, bcw.decBatchEmployeeWithholding, uw.intPrePostTaxDeduction,strGLAccount,0,0,0
					from dbo.viewPay_UserWithholdingItems uw cross apply   [fnPay_tblUserComputeWithholdings] (   @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
					where uw.intPrePostTaxDeduction = 1 and uw.boolDeleted = 0 and uw.boolDeleted = 0  
					and (uw.intUserID = @USERID OR @USERID =0) and bcw.decBatchEmployeeWithholding <> 0
					AND uw.strWithHoldingsName IN (select strWithHoldingsName FROM tblPayrollTemplatesUserWithholdings where (intUserID = uw.intUserID)  AND intPayrollTemplateID = @TEMPLATEID)
					
				END

		  --Company Withholdings
				IF @TEMPLATEID = 0
					BEGIN

					IF @BATCH_TYPE = 0  --REGULAR TEMPLATE
						BEGIN
							insert into [dbo].[tblCompanyBatchWithholdings] (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
							select  bcw.strBatchID, bcw.intUserID, bcw.strWithHoldingsName, @PayDate, bcw.decBatchEffectivePay, bcw.decBatchCompanyWithholding, uw.intPrePostTaxDeduction,strGLAccount_Contributions ,0,getdate(),0,0,strGLContributionPayable
							FROM dbo.viewPay_UserWithholdingItems uw cross apply   [dbo].[fnPay_tblUserComputeWithholdings] (  @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
							where uw.intPrePostTaxDeduction = 1 and uw.boolDeleted = 0  and bcw.decBatchCompanyWithholding <> 0 
							AND (uw.intUserID = @USERID OR @USERID = 0) AND
							case 
							when uw.intPeriodEntryID = 0 then 1
							when uw.intPeriodEntryID = -1 then 1
							when uw.intPeriodEntryID =[dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) then 1
							when uw.intPeriodEntryID =-3 then
								case 
								when @intPayWeekNum > 300000000 then 1 --'Semimonthly does not happen more than 2 a month

								when @intPayWeekNum > 100000000  then --'Biweekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) <> 3,1,0)
								else --'Weekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uw.intUserID) <> 5,1,0)
								END
						END = 1


						END
					ELSE	
						-- Additional Payroll Specific
						BEGIN
							insert into [dbo].[tblCompanyBatchWithholdings](strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
							select  bcw.strBatchID, bcw.intUserID, bcw.strWithHoldingsName, @PayDate, bcw.decBatchEffectivePay, bcw.decBatchCompanyWithholding, uw.intPrePostTaxDeduction,strGLAccount_Contributions ,0,getdate(),0,0,strGLContributionPayable
							FROM dbo.viewPay_UserWithholdingItems uw cross apply   [dbo].[fnPay_tblUserComputeWithholdings] (  @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
							where uw.intPrePostTaxDeduction = 1 and uw.boolDeleted = 0  and bcw.decBatchCompanyWithholding <> 0 and uw.intPeriodEntryID IN (0, -2)
							AND (uw.intUserID = @USERID OR @USERID = 0) 
						END
					END
				ELSE 
				--USE TEMPLATE 
					BEGIN
						insert into [dbo].[tblCompanyBatchWithholdings] (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
						select  bcw.strBatchID, bcw.intUserID, bcw.strWithHoldingsName, @PayDate, bcw.decBatchEffectivePay, bcw.decBatchCompanyWithholding, uw.intPrePostTaxDeduction,strGLAccount_Contributions ,0,getdate(),0,0,strGLContributionPayable
						FROM dbo.viewPay_UserWithholdingItems uw 
						cross apply   [dbo].[fnPay_tblUserComputeWithholdings] (  @BATCHID  , uw.intUserID  ,uw.strWithHoldingsName)bcw
						where uw.intPrePostTaxDeduction = 1 and uw.boolDeleted = 0  
						and (uw.intUserID = @USERID OR @USERID = 0) and bcw.decBatchCompanyWithholding <> 0
						AND uw.strWithHoldingsName IN (select strWithHoldingsName FROM tblPayrollTemplatesCompanyContributions where  (intUserID = uw.intUserID) AND intPayrollTemplateID = @TEMPLATEID)

					END

			DELETE FROM ubc  
			FROM tblUserBatchWithholdings ubc inner join tblUserBatchWithholdings_ManualEntry ubcme 
			on ubc.strBatchID = ubcme.strBatchID AND ubc.intUserID = ubcme.intUserID 
			and ubc.strWithHoldingsName = ubcme.strWithHoldingsName
			WHERE 
			ubcme.boolDeleted = 1 
			AND ubc.strBatchID = @BATCHID 
			AND (ubc.intUserID = @USERID OR @USERID = 0) 

			--tblUserBatchWithholdings INSERT ADDED Withholdings 
			INSERT INTO tblUserBatchWithholdings 
			(strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted,intEditType,intUBMESequence)
			SELECT
			strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted,intEditType,intSequenceNumber
			FROM tblUserBatchWithholdings_ManualEntry 
			WHERE boolDeleted = 0 and strBatchID = @BATCHID 
			AND (intUserID = @USERID OR @USERID = 0) 


			
			-- LOAN Check that any Remaining Balance in Loans is not less than 0.  Note that the minimum it can be is 0... so make sure the difference is not 
			UPDATE tblUserBatchWithholdings SET decWithholdingsAmount = iif(wlb.decRemainingBalance < 0,iif(ubw.decWithholdingsAmount - decRemainingBalance <= 0,ubw.decWithholdingsAmount - decRemainingBalance,0 ), ubw.decWithholdingsAmount) 
			from tblUserBatchWithholdings ubw inner join tblWithholdingsItems wi on ubw.strWithHoldingsName = wi.strWithHoldingsName 
			inner join viewPay_WithholdingsLoansBalances wlb on ubw.intUserID = wlb.intUserID and wi.strWithHoldingsName = wlb.strWithHoldingsName
			where boolIsLoan = 1 and ubw.strBatchID = @BATCHID 
			AND (ubw.intUserID = @USERID OR @USERID = 0) 

			--Company Withholdings
			IF @TEMPLATEID = 0
				BEGIN
					IF @BATCH_TYPE = 0  --REGULAR TEMPLATE
						BEGIN

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- LANCO TYPE = 1
							--401KPlan (Not affected by pre-post tax)
							insert into [dbo].[tblCompanyBatchWithholdings] (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
							select  ubw.strBatchID, ubw.intUserID, ubw.strWithHoldingsName, ubw.dtPayDate, ubw.decBatchEffectivePay, 
									iif(-[dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
									- iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay *decERMatchPercent/100* decERPeriodMaxPercent/100 ,
									-decBatchEffectivePay * decERMatchPercent/100* decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  ) > wlb.decERMaxYearlyAmount,
									iif(-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
									>0,0,-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName)) ,
									iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay * decERMatchPercent/100*decERPeriodMaxPercent/100 ,
									-decBatchEffectivePay *decERMatchPercent/100* decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  )) decBatchCompanyWithholding, 
									wi.intPrePostTaxDeduction,uwi.strGLAccount_Contributions ,0,getdate(),0,0 ,uwi.strGLContributionPayable
									from viewPay_UserBatchWithholdings ubw inner join tblWithholdingsItems wi on ubw.strWithHoldingsName = wi.strWithHoldingsName 
							inner join tblUserWithholdingsItems uwi on ubw.strWithHoldingsName = uwi.strWithHoldingsName and ubw.intUserID = uwi.intUserID 
							inner join tblWithholdings401K wlb on wlb.strWithholdingName = ubw.strWithHoldingsName
							where wlb.intUseERLimitPercent = 1 and  uwi.boolApply401kPlan = 1 
							AND (ubw.intUserID = @USERID OR @USERID = 0) and ubw.strBatchID = @BATCHID and 
							case 
							when uwi.intPeriodEntryID = 0 then 1
							when uwi.intPeriodEntryID = -1 then 1
							when uwi.intPeriodEntryID =[dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uwi.intUserID) then 1
							when uwi.intPeriodEntryID =-3 then
								case 
								when @intPayWeekNum > 300000000 then 1 --'Semimonthly does not happen more than 2 a month
								when @intPayWeekNum > 100000000  then --'Biweekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uwi.intUserID) <> 3,1,0)
								else --'Weekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uwi.intUserID) <> 5,1,0)
								END
						END = 1
-- SU TIENDA TYPE = 2

							--401KPlan (Not affected by pre-post tax)
							insert into [dbo].[tblCompanyBatchWithholdings] (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
							select  ubw.strBatchID, ubw.intUserID, ubw.strWithHoldingsName, ubw.dtPayDate, ubw.decBatchEffectivePay, 
									iif(-[dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
									- iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay * decERPeriodMaxPercent/100 ,
									-decBatchEffectivePay *decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  ) > wlb.decERMaxYearlyAmount,
									iif(-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
									>0,0,-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName)) ,
									iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay *decERPeriodMaxPercent/100 ,
									-decBatchEffectivePay * decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  )) decBatchCompanyWithholding, 
									wi.intPrePostTaxDeduction,uwi.strGLAccount_Contributions ,0,getdate(),0,0 ,uwi.strGLContributionPayable
									from viewPay_UserBatchWithholdings ubw inner join tblWithholdingsItems wi on ubw.strWithHoldingsName = wi.strWithHoldingsName 
							inner join tblUserWithholdingsItems uwi on ubw.strWithHoldingsName = uwi.strWithHoldingsName and ubw.intUserID = uwi.intUserID 
							inner join tblWithholdings401K wlb on wlb.strWithholdingName = ubw.strWithHoldingsName
							where wlb.intUseERLimitPercent = 2 and  uwi.boolApply401kPlan = 1 
							AND (ubw.intUserID = @USERID OR @USERID = 0) and ubw.strBatchID = @BATCHID and 
							case 
							when uwi.intPeriodEntryID = 0 then 1
							when uwi.intPeriodEntryID = -1 then 1
							when uwi.intPeriodEntryID =[dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uwi.intUserID)  then 1
							when uwi.intPeriodEntryID =-3 then
								case 
								when @intPayWeekNum > 300000000 then 1 --'Semimonthly does not happen more than 2 a month
								when @intPayWeekNum > 100000000  then --'Biweekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uwi.intUserID) <> 3,1,0)
								else --'Weekly'
									IIF( [dbo].[fnPay_PayPeriodsInMonthSearchDate] (@PAYROLL_COMPANY,@PAYDATE,@BATCH_TYPE,uwi.intUserID) <> 5,1,0)
								END
						END = 1

					END
				ELSE	
						-- Additional Payroll Specific
					BEGIN

--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- LANCO
							--401KPlan (Not affected by pre-post tax)
							insert into [dbo].[tblCompanyBatchWithholdings] (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
							select  ubw.strBatchID, ubw.intUserID, ubw.strWithHoldingsName, ubw.dtPayDate, ubw.decBatchEffectivePay, 
									iif(-[dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
									- iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay *decERMatchPercent/100* decERPeriodMaxPercent/100 ,
									-decBatchEffectivePay * decERMatchPercent/100* decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  ) > wlb.decERMaxYearlyAmount,
									iif(-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
									>0,0,-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName)) ,
									iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay * decERMatchPercent/100*decERPeriodMaxPercent/100 ,
									-decBatchEffectivePay *decERMatchPercent/100* decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  )) decBatchCompanyWithholding, 
									wi.intPrePostTaxDeduction,uwi.strGLAccount_Contributions ,0,getdate(),0,0 ,uwi.strGLContributionPayable
									from viewPay_UserBatchWithholdings ubw inner join tblWithholdingsItems wi on ubw.strWithHoldingsName = wi.strWithHoldingsName 
									inner join tblUserWithholdingsItems uwi on ubw.strWithHoldingsName = uwi.strWithHoldingsName and ubw.intUserID = uwi.intUserID 
									inner join tblWithholdings401K wlb on wlb.strWithholdingName = ubw.strWithHoldingsName
									where wlb.intUseERLimitPercent = 1 and uwi.boolApply401kPlan = 1 
									AND (ubw.intUserID = @USERID OR @USERID = 0) and ubw.strBatchID = @BATCHID  
									and uwi.intPeriodEntryID IN (0,-2)
			
			--SU TIENDA
							--401KPlan (Not affected by pre-post tax)
							insert into [dbo].[tblCompanyBatchWithholdings] (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
							select  ubw.strBatchID, ubw.intUserID, ubw.strWithHoldingsName, ubw.dtPayDate, ubw.decBatchEffectivePay, 
							iif(-[dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
							- iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay * decERPeriodMaxPercent/100 ,
							-decBatchEffectivePay *decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  ) > wlb.decERMaxYearlyAmount,
							iif(-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
							>0,0,-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName)) ,
							iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay *decERPeriodMaxPercent/100 ,
							-decBatchEffectivePay * decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  )) decBatchCompanyWithholding, 
							wi.intPrePostTaxDeduction,uwi.strGLAccount_Contributions ,0,getdate(),0,0 ,uwi.strGLContributionPayable
							from viewPay_UserBatchWithholdings ubw inner join tblWithholdingsItems wi on ubw.strWithHoldingsName = wi.strWithHoldingsName 
							inner join tblUserWithholdingsItems uwi on ubw.strWithHoldingsName = uwi.strWithHoldingsName and ubw.intUserID = uwi.intUserID 
							inner join tblWithholdings401K wlb on wlb.strWithholdingName = ubw.strWithHoldingsName
							where wlb.intUseERLimitPercent = 2 and uwi.boolApply401kPlan = 1 
							AND (ubw.intUserID = @USERID OR @USERID = 0) and ubw.strBatchID = @BATCHID and 
									 uwi.intPeriodEntryID IN (0,-2)
		----

					END
				END
			ELSE 
				--USE TEMPLATE 
				BEGIN
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				--LANCO
						--401KPlan (Not affected by pre-post tax)
						insert into [dbo].[tblCompanyBatchWithholdings] (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
						select  ubw.strBatchID, ubw.intUserID, ubw.strWithHoldingsName, ubw.dtPayDate, ubw.decBatchEffectivePay, 
								iif(-[dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
								- iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay *decERMatchPercent/100* decERPeriodMaxPercent/100 ,
								-decBatchEffectivePay * decERMatchPercent/100* decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  ) > wlb.decERMaxYearlyAmount,
								iif(-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
								>0,0,-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName)) ,
								iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay * decERMatchPercent/100*decERPeriodMaxPercent/100 ,
								-decBatchEffectivePay *decERMatchPercent/100* decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  )) decBatchCompanyWithholding, 
								wi.intPrePostTaxDeduction,uwi.strGLAccount_Contributions ,0,getdate(),0,0 ,uwi.strGLContributionPayable
								from viewPay_UserBatchWithholdings ubw inner join tblWithholdingsItems wi on ubw.strWithHoldingsName = wi.strWithHoldingsName 
								inner join tblUserWithholdingsItems uwi on ubw.strWithHoldingsName = uwi.strWithHoldingsName and ubw.intUserID = uwi.intUserID 
								inner join tblWithholdings401K wlb on wlb.strWithholdingName = ubw.strWithHoldingsName
								where wlb.intUseERLimitPercent = 1  AND uwi.boolApply401kPlan = 1 
								AND (ubw.intUserID = @USERID OR @USERID = 0) and ubw.strBatchID = @BATCHID  
								and ubw.strWithHoldingsName IN (select strWithHoldingsName FROM tblPayrollTemplatesCompanyContributions where (intUserID = ubw.intUserID) AND intPayrollTemplateID = @TEMPLATEID)
--
-- SU TIENDA 
						--401KPlan (Not affected by pre-post tax)
						insert into [dbo].[tblCompanyBatchWithholdings] (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted, dtTimeStamp,intEditType,intUBMESequence,strGLContributionPayable)
							select  ubw.strBatchID, ubw.intUserID, ubw.strWithHoldingsName, ubw.dtPayDate, ubw.decBatchEffectivePay, 
							iif(-[dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
							- iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay * decERPeriodMaxPercent/100 ,
							-decBatchEffectivePay *decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  ) > wlb.decERMaxYearlyAmount,
							iif(-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName) 
							>0,0,-wlb.decERMaxYearlyAmount - [dbo].[fnPay_YTDUserCompanyBatchWithholdings](ubw.strWithHoldingsName,ubw.intUserID,ubw.dtPayDate,ubw.strCompanyName)) ,
							iif( -decWithholdingsAmount * decERMatchPercent/100  > decBatchEffectivePay *decERPeriodMaxPercent/100 ,
							-decBatchEffectivePay * decERPeriodMaxPercent/100 ,decWithholdingsAmount * decERMatchPercent/100  )) decBatchCompanyWithholding, 
							wi.intPrePostTaxDeduction,uwi.strGLAccount_Contributions ,0,getdate(),0,0 ,uwi.strGLContributionPayable
							from viewPay_UserBatchWithholdings ubw inner join tblWithholdingsItems wi on ubw.strWithHoldingsName = wi.strWithHoldingsName 
							inner join tblUserWithholdingsItems uwi on ubw.strWithHoldingsName = uwi.strWithHoldingsName and ubw.intUserID = uwi.intUserID 
							inner join tblWithholdings401K wlb on wlb.strWithholdingName = ubw.strWithHoldingsName
							where wlb.intUseERLimitPercent = 2 and uwi.boolApply401kPlan = 1 
							AND (ubw.intUserID = @USERID OR @USERID = 0) and ubw.strBatchID = @BATCHID and 
							ubw.strWithHoldingsName IN (select strWithHoldingsName FROM tblPayrollTemplatesCompanyContributions where (intUserID = uwi.intUserID)  AND intPayrollTemplateID = @TEMPLATEID)
--

				END

					----Check 401K Plan limits - Percent Limits
					UPDATE ubw SET decWithholdingsAmount= IIF(-[dbo].[fnPay_BatchUserCompensations](@BATCHID, ubw.intUserID) * decERPeriodMaxPercent/100 > decWithholdingsAmount,
					 -[dbo].[fnPay_BatchUserCompensations](@BATCHID, ubw.intUserID) * decERPeriodMaxPercent/100 , decWithholdingsAmount )
					from tblCompanyBatchWithholdings ubw inner join tblWithholdingsItems wi on ubw.strWithHoldingsName = wi.strWithHoldingsName 
					inner join tblUserWithholdingsItems uwi on ubw.strWithHoldingsName = uwi.strWithHoldingsName and ubw.intUserID = uwi.intUserID 
					inner join tblWithholdings401K wlb on wlb.strWithholdingName = ubw.strWithHoldingsName
					where uwi.boolApply401kPlan = 1  and ubw.strBatchID = @BATCHID 	AND (wlb.decERPeriodMaxPercent >0 AND wlb.decERPeriodMaxPercent <100) AND (ubw.intUserID = @USERID OR @USERID = 0) 
		
		--Delete contributions that where deleted
		--Moved here so that 401K contributions can be edited
			DELETE FROM ubc  
			FROM tblCompanyBatchWithholdings ubc inner join tblCompanyBatchWithholdings_ManualEntry ubcme 
			on ubc.strBatchID = ubcme.strBatchID AND ubc.intUserID = ubcme.intUserID 
			and ubc.strWithHoldingsName = ubcme.strWithHoldingsName
			WHERE 
			ubcme.boolDeleted = 1 
			AND ubc.strBatchID = @BATCHID 
			AND (ubc.intUserID = @USERID OR @USERID = 0)

			--tblCompanyBatchWithholdings INSERT ADDED Company Withholdings 
			INSERT INTO tblCompanyBatchWithholdings (strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted,intEditType,intUBMESequence,strGLContributionPayable)
			SELECT
			strBatchID, intUserID, strWithHoldingsName, dtPayDate, decBatchEffectivePay, decWithholdingsAmount, intPrePostTaxDeduction, strGLAccount, boolDeleted,intEditType,intSequenceNumber,strGLContributionPayable
			FROM tblCompanyBatchWithholdings_ManualEntry 
			WHERE boolDeleted = 0 and strBatchID = @BATCHID 
			AND (intUserID = @USERID OR @USERID = 0) 

		COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK ;
			 SELECT   
				ERROR_NUMBER() AS ErrorNumber  
			   ,ERROR_MESSAGE() AS ErrorMessage; 
		END CATCH
	ELSE
	BEGIN
		if @BatchProcessedCode = 0
			THROW 100002, 'Batch does not exist.',1
		else if @BatchProcessedCode = 1
			THROW 100003, 'Batch Commpensations not processed.',1
		else 
			THROW 100004, 'Batch Withholdings already processed.',1
	END
END


GO
