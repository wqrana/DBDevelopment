USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spTA_ADJUST_PayCyclePeriod]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[spTA_ADJUST_PayCyclePeriod]    Script Date: 6/9/2017 8:04:37 PM ******/


-- =============================================
-- Author:		Alexander Rivera Toro
-- Create date: 08/02/2019
-- Description:	Adjusts the PayCyclePeriod .  Note that the PREVIOUS PERIOD is checked and adjusments added to THIS period.
--				Now takes into account Payroll Company
--				10/14/2021: Fixed so that adjust takes into account the Payroll Schedule
--				6/28/2023: Added temp table to allow several adjustments to be inserted together 
-- =============================================
CREATE PROCEDURE [dbo].[spTA_ADJUST_PayCyclePeriod]
	@PAYWEEKNUM INT,
	@PAYROLL_SCHEDULEID INT
-- WITH ENCRYPTION
AS

BEGIN
		DECLARE @PayCycleStatus  as nvarchar(50)

	--Get the paycycle status
		SELECT @PayCycleStatus = sAdjustStatus from tblPayCycleLog 
		WHERE  nPayWeekNum = @PAYWEEKNUM AND intPayrollScheduleID = @PAYROLL_SCHEDULEID
		if @PayCycleStatus <> 'ADJUSTED'
		BEGIN 
	BEGIN TRY
		BEGIN TRANSACTION


		DECLARE @PayCycleAdjust TABLE 
	(
		[e_id] [int] NOT NULL,
		[DTPunchDate] [smalldatetime] NOT NULL,
		[dblHours] [decimal](18, 2) NOT NULL,
		[sType] [nvarchar](30) NOT NULL,
		[nWeekID] [bigint] NOT NULL,
		[nPayWeekNum] [int] NOT NULL,
		[bRejected] [bit] NOT NULL,
		[strAdjustType] [nvarchar](50) NOT NULL,
		[decAdjustAmount] [decimal](18, 2) NOT NULL,
		[decPayRate] [decimal](18, 2) NOT NULL,
		[intPayrollScheduleID] [int] NULL
	)
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		DECLARE @ADJUST_PAYWEEKNUM int
		DECLARE @ADJUST_DATE datetime
		
		--For future a
		DECLARE @USERID int
		SET @USERID = 0

		--Get the start date of the period for adjustment
		Select top(1) @ADJUST_DATE = DTStartDate from tReportWeek where nPayWeekNum = @PAYWEEKNUM 
		select top(1) @ADJUST_PAYWEEKNUM =  nPayWeekNum from tReportWeek where DTEndDate < @ADJUST_DATE ORDER BY DTEndDate DESC
	
		DECLARE		@PAYROLLCOMPANY nvarchar(50)
		select @PAYROLLCOMPANY =  strCompanyName from  [dbo].[tblCompanyPayrollSchedules] where intPayrollScheduleID = @PAYROLL_SCHEDULEID
		SELECT @PAYROLLCOMPANY 
		

	--CHECK DIFFERENCES IN TRANSACTIONS IN HR HOURS
		INSERT INTO @PayCycleAdjust
		(e_id, DTPunchDate, dblHours, sType, nWeekID, nPayWeekNum, bRejected, strAdjustType, decAdjustAmount, decPayRate,intPayrollScheduleID)
		select pdd.e_id, @ADJUST_DATE, (pcd.dblhours -pdd.dblhours ) as dblHours,pdd.sType, pcd.nWeekID ,@PAYWEEKNUM,0  
		, [dbo].[fnTA_PayCycleAdjustTrans](pdd.e_id,pdd.sType)
		,[dbo].[fnPay_UserTransaction_MoneyAmount](pdd.e_id, @ADJUST_DATE, pdd.sType, (pcd.dblhours -pdd.dblhours ) ) as decAdjustAmount
		,dbo.[fnPay_UserTransaction_PayRate](pdd.e_id, @ADJUST_DATE, pdd.sType) as decPayRate
		,@PAYROLL_SCHEDULEID intPayrollScheduleID
		FROM
		(select ub.strCompanyName, pcd.e_id, pcd.sType, sum(pcd.dblhours) as dblhours, pcd.nWeekID, max(rw.nPayRuleID) nPayRuleID
		from tblPayCycleDailyDetail pcd inner join tTransDef td on pcd.sType = td.Name 
		inner join tReportWeek rw on pcd.nWeekID = rw.nWeekID 
		inner join viewPay_UserBatchStatus ub on rw.e_id = ub.intUserID and ub.intPayWeekNum = rw.nPayWeekNum
		
		where (pcd.e_id = @USERID OR @USERID = 0)   and pcd.nPayWeekNum = @ADJUST_PAYWEEKNUM AND (nIsMoneyTrans =1 OR nPayRateTransaction = 1) And nParentCode NOT IN (35,36,37,38,41,42,43,44,45)
		group by  ub.strCompanyName, pcd.e_id, pcd.sType,pcd.nWeekID) pcd INNER JOIN
		(select e_id, sType, sum(dblhours) as dblhours from tblPunchDateDetail pdd 
		where (e_id = @USERID OR @USERID = 0)  and intPayWeekNum = @ADJUST_PAYWEEKNUM 
		group by e_id, sType) pdd ON  pcd.e_id = pdd.e_id and pcd.sType = pdd.sType where  (pcd.dblhours -pdd.dblhours ) <> 0 
		and pdd.e_id in (Select id from tuser where nStatus = 1)
		and strCompanyName = @PAYROLLCOMPANY
		and nPayRuleID IN (select pr.ID from [dbo].[tblCompanyPayrollRules] cpr inner join tPayrollRule pr on cpr.intPayrollRule = pr.ID where cpr.intPaymentSchedule = @PAYROLL_SCHEDULEID)

		--CHECK DIFFERENCES IN TRANSACTIONS THAT ARE IN BOTH THAT ARE NOT HR
		INSERT INTO @PayCycleAdjust
		(e_id, DTPunchDate, dblHours, sType, nWeekID, nPayWeekNum, bRejected, strAdjustType, decAdjustAmount, decPayRate,intPayrollScheduleID)
		SELECT PREVIOUS.e_id,@ADJUST_DATE, PREVIOUS.PreviousHours - PAYCYCLE.PayCycleHours as Difference , PREVIOUS.sType, PREVIOUS.nWeekID,@PAYWEEKNUM,0
		, [dbo].[fnTA_PayCycleAdjustTrans](PREVIOUS.e_id,PREVIOUS.sType) as AdjustTrans
		,[dbo].[fnPay_UserTransaction_MoneyAmount](PREVIOUS.e_id, @ADJUST_DATE,PREVIOUS.sType, PREVIOUS.PreviousHours - PAYCYCLE.PayCycleHours ) as decAdjustAmount
		,dbo.[fnPay_UserTransaction_PayRate](PREVIOUS.e_id, @ADJUST_DATE, PREVIOUS.sType) as decPayRate
		,@PAYROLL_SCHEDULEID intPayrollScheduleID

		FROM (select ub.strCompanyName, pdd.e_id, sType, sum(dblHours)as PreviousHours ,pdd.nWeekID , max(rw.nPayRuleID) nPayRuleID
		from tPunchDateDetail pdd inner join tReportWeek rw on pdd.nWeekID = rw.nWeekID
		inner join viewPay_UserBatchStatus ub on rw.e_id = ub.intUserID and ub.intPayWeekNum = rw.nPayWeekNum
		where nPayWeekNum = @ADJUST_PAYWEEKNUM and sType <> 'HR' GROUP bY UB.strCompanyName, pdd.e_id, sType,pdd.nWeekID)  PREVIOUS
		inner join
		(select pdd.e_id,  sType, sum(dblHours) as PayCycleHours from tblPunchDateDetail pdd inner join tReportWeek rw on pdd.nWeekID = rw.nWeekID
		where nPayWeekNum = @ADJUST_PAYWEEKNUM and sType IN 
		( select Name from tTransDef where (nIsMoneyTrans =1 OR nPayRateTransaction = 1) And nParentCode NOT IN (1,35,36,37,38,41,42,43,44,45)) group by pdd.e_id, sType ) PAYCYCLE
		ON PREVIOUS.e_id = PAYCYCLE.e_id and PREVIOUS.sType = PAYCYCLE.sType
		WHERE PREVIOUS.PreviousHours <> PAYCYCLE.PayCycleHours
		and PREVIOUS.e_id in (Select id from tuser where nStatus = 1)
		and strCompanyName = @PAYROLLCOMPANY
		and nPayRuleID IN (select pr.ID from [dbo].[tblCompanyPayrollRules] cpr inner join tPayrollRule pr on cpr.intPayrollRule = pr.ID where cpr.intPaymentSchedule = @PAYROLL_SCHEDULEID)

		----CHECK ENTRIES ONLY IN PunchDateDetail   NOT HR
		INSERT INTO @PayCycleAdjust
		(e_id, DTPunchDate, dblHours, sType, nWeekID, nPayWeekNum, bRejected, strAdjustType, decAdjustAmount, decPayRate,intPayrollScheduleID)
		select pdd.e_id, @ADJUST_DATE, sum( pdd.dblHours)  as PDDdblHours,pdd.sType, pdd.nWeekID,@PAYWEEKNUM,0  
		, [dbo].[fnTA_PayCycleAdjustTrans](pdd.e_id,pdd.sType)
		,[dbo].[fnPay_UserTransaction_MoneyAmount](pdd.e_id, @ADJUST_DATE, pdd.sType, sum( pdd.dblHours) ) as decAdjustAmount
		,dbo.[fnPay_UserTransaction_PayRate](pdd.e_id, @ADJUST_DATE, pdd.sType) as decPayRate
		,@PAYROLL_SCHEDULEID intPayrollScheduleID

		from tPunchDateDetail pdd inner join tReportWeek rw on pdd.nWeekID = rw.nWeekID inner join tTransDef td2 on pdd.sType = td2.Name
		inner join viewPay_UserBatchStatus ub on rw.e_id = ub.intUserID and ub.intPayWeekNum = rw.nPayWeekNum
		where (pdd.e_id = @USERID OR @USERID = 0)  and rw.nPayWeekNum = @ADJUST_PAYWEEKNUM  And td2.nParentCode NOT IN (1,35,36,37,38,41,42,43,44,45)
		and (td2.nIsMoneyTrans = 1 OR td2.nPayRateTransaction = 1) and pdd.sType NOT IN ( select distinct pddpc.sType from tblPunchDateDetail pddpc inner join tTransDef td 
		ON pddpc.sType = td.Name WHERE   (nIsMoneyTrans =1 OR nPayRateTransaction = 1) and pddpc.e_id = pdd.e_id and pddpc.intPayWeekNum = @ADJUST_PAYWEEKNUM ) 
		and nPayWeekNum = @ADJUST_PAYWEEKNUM
		GROUP BY ub.strCompanyName , pdd.e_id, pdd.sType, pdd.nWeekID
		having  pdd.e_id in (Select id from tuser where nStatus = 1)
		and strCompanyName = @PAYROLLCOMPANY
		and max(nPayRuleID) IN (select pr.ID from [dbo].[tblCompanyPayrollRules] cpr inner join tPayrollRule pr on cpr.intPayrollRule = pr.ID where cpr.intPaymentSchedule = @PAYROLL_SCHEDULEID)

		----CHECK ENTRIES ONLY IN tblPunchDateDetail NOT HR
		INSERT INTO @PayCycleAdjust
		(e_id, DTPunchDate, dblHours, sType, nWeekID, nPayWeekNum, bRejected, strAdjustType, decAdjustAmount, decPayRate,intPayrollScheduleID)
		select pdd.e_id, @ADJUST_DATE, -sum( pdd.dblHours)  as PDDdblHours,pdd.sType, pdd.nWeekID ,@PAYWEEKNUM,0  
		, [dbo].[fnTA_PayCycleAdjustTrans](pdd.e_id,pdd.sType)
		,[dbo].[fnPay_UserTransaction_MoneyAmount](pdd.e_id, @ADJUST_DATE, pdd.sType, sum( pdd.dblHours)) as decAdjustAmount
		,dbo.[fnPay_UserTransaction_PayRate](pdd.e_id, @ADJUST_DATE, pdd.sType) as decPayRate
		,@PAYROLL_SCHEDULEID intPayrollScheduleID

		from tblPunchDateDetail pdd  inner join tTransDef td2 on pdd.sType = td2.Name
		inner join tReportWeek rw on pdd.nWeekID = rw.nWeekID
		inner join viewPay_UserBatchStatus ub on rw.e_id = ub.intUserID and ub.intPayWeekNum = rw.nPayWeekNum
		where (pdd.e_id = @USERID OR @USERID = 0)  and pdd.intPayWeekNum = @ADJUST_PAYWEEKNUM and (td2.nIsMoneyTrans = 1 OR td2.nPayRateTransaction = 1) 
		and pdd.sType NOT IN ( select distinct pdt.sType from tPunchDateDetail pdt inner join tReportWeek rw on pdt.nWeekID = rw.nWeekID 
		inner join tTransDef td ON pdt.sType = td.Name where (nIsMoneyTrans =1 OR nPayRateTransaction = 1) and rw.nPayWeekNum = @ADJUST_PAYWEEKNUM and pdt.e_id = pdd.e_id)
		GROUP BY ub.strCompanyName,pdd.e_id, pdd.sType,pdd.nWeekID
		having  pdd.e_id in (Select id from tuser where nStatus = 1)
		and strCompanyName = @PAYROLLCOMPANY  and -sum( pdd.dblHours) <> 0
		and max(nPayRuleID) IN (select pr.ID from [dbo].[tblCompanyPayrollRules] cpr inner join tPayrollRule pr on cpr.intPayrollRule = pr.ID where cpr.intPaymentSchedule = @PAYROLL_SCHEDULEID)
		
		--INSERT INTO TABLE
		INSERT INTO dbo.tblPayCycleAdjust
		(e_id, DTPunchDate, dblHours, sType, nWeekID, nPayWeekNum, bRejected, strAdjustType, decAdjustAmount, decPayRate,intPayrollScheduleID)
		select
		e_id, DTPunchDate, sum(dblHours), sType, max(nWeekID), max(nPayWeekNum), 0 bRejected, max(strAdjustType), sum(decAdjustAmount), max(decPayRate),max(intPayrollScheduleID)
		from @PayCycleAdjust group by e_id, DTPunchDate,sType

		--Update PayCycleLog Status to Closed
		UPDATE tblPayCycleLog SET sAdjustStatus = 'ADJUSTED'
		WHERE  nPayWeekNum = @PAYWEEKNUM AND intPayrollScheduleID = @PAYROLL_SCHEDULEID 

		-- Set the previous period as locked.
		UPDATE tPunchDate SET  bLocked = 1 FROM tPunchDate pdt inner join tReportWeek rw on pdt.nWeekID = rw.nWeekID
		WHERE  rw.nPayWeekNum = @ADJUST_PAYWEEKNUM AND rw.nPayRuleID  
		IN (select pr.ID from [dbo].[tblCompanyPayrollRules] cpr inner join tPayrollRule pr on cpr.intPayrollRule = pr.ID where cpr.intPaymentSchedule = @PAYROLL_SCHEDULEID)

		COMMIT
	END TRY
		BEGIN CATCH
			ROLLBACK ;
			 SELECT   
				ERROR_NUMBER() AS ErrorNumber  
			   ,ERROR_MESSAGE() AS ErrorMessage; 
				DECLARE @Msg as varchar(max) 
				select @Msg = ERROR_MESSAGE() 
				RAISERROR(@Msg,16,1)
		END CATCH
	END
	ELSE
		BEGIN;
		THROW 110000, 'Pay Cycle Period Already Adjusted.',1
		END
END

GO
