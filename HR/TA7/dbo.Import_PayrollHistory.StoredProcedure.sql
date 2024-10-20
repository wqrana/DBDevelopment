USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[Import_PayrollHistory]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro 
-- Create date: 7/5/2019
-- Description:	Created to import payrolls from Payroll Hisory Format.  
-- =============================================
CREATE PROCEDURE [dbo].[Import_PayrollHistory]
	(	
	@PayrollCompany as nvarchar(50),
	@UserID as  int ,
	@UserName as nvarchar(50),
	@PayDate as date,
	@RegularWages as  [decimal](18,5) ,
	@Overtime [decimal](18,5) ,
	@Overtime2X [decimal](18,5) ,
	@Meal [decimal](18,5) ,
	@Refund [decimal](18,5) ,
	@Sick [decimal](18,5) ,
	@Vacation [decimal](18,5) ,
	@Compensation1 [decimal](18,5) ,
	@Compensation2 [decimal](18,5) ,
	@Compensation3 [decimal](18,5) ,
	@Compensation4 [decimal](18,5) ,
	@Compensation5 [decimal](18,5) ,
	@FICA_SS_EE [decimal](18,5) ,
	@FICA_MED_EE [decimal](18,5) ,
	@FICA_MED_PLUS_EE [decimal](18,5) ,
	@SINOT_EE [decimal](18,5) ,
	@CHOFERIL_EE [decimal](18,5) ,
	@PLAN_MEDICO_EE [decimal](18,5) ,
	@ST_ITAX_EE [decimal](18,5) ,
	@Withholdings1 [decimal](18,5) ,
	@Withholdings2 [decimal](18,5) ,
	@Withholdings3 [decimal](18,5) ,
	@Withholdings4 [decimal](18,5) ,
	@Withholdings5 [decimal](18,5) ,
	@FICA_SS_ER [decimal](18,5) ,
	@FICA_MED_ER [decimal](18,5) ,
	@SINOT_ER [decimal](18,5) ,
	@CHOFERIL_ER [decimal](18,5) ,
	@FUTA_ER  [decimal](18,5) ,
	@SUTA_ER  [decimal](18,5) ,
	@Contributions1 [decimal](18,5) ,
	@Contributions2 [decimal](18,5) ,
	@Contributions3 [decimal](18,5) ,
	@Contributions4 [decimal](18,5) ,
	@Contributions5 [decimal](18,5) 
	  )
AS
BEGIN
	DECLARE @RC int
	DECLARE @BATCHID nvarchar(50)
	DECLARE @PAYROLLDESCRIPTION nvarchar(50) 
	DECLARE @SUPERVISORID int = 6666
	DECLARE @SUPERVISORNAME nvarchar(50) = 'IDENTECH'
	DECLARE @BATCH_TYPE int = 2
	DECLARE @TEMPLATEID int = 0
	DECLARE @PAYWEEKNUM int = 0
	DECLARE @PAYMETHODTYPE int = 0

	SET NOCOUNT ON;

	SET @PAYROLLDESCRIPTION = LEFT( 'IE: '+ left(@USERNAME,20) + ' ' + CONVERT(VARCHAR(10),  @PayDate, 101),30)

--CHECK IF BATCH EXISTS, DELETE IF IT DOES

IF NOT EXISTS(select top(1) * from tblBatch where dtPayDate =@PayDate and strCompanyName  =@PayrollCompany)
BEGIN
	--CREATE BATCH 
	EXECUTE @RC = [dbo].[spPay_Create_CompanyBatch] 
   @BATCHID OUTPUT
  ,@PayrollCompany
  ,@PAYROLLDESCRIPTION
  ,@PAYDATE
  ,@SUPERVISORID
  ,@SUPERVISORNAME
  ,@BATCH_TYPE
  ,@TEMPLATEID
 END
 ELSE
	BEGIN
	 SELECT @BATCHID = strBatchID from tblBatch where dtPayDate =@PayDate and strCompanyName  =@PayrollCompany
	END

--CREATE USER BATCH
IF NOT EXISTS(select top(1) * from tblUserBatch where strBatchID = @BATCHID and intUserID = @USERID)
BEGIN
		--CREATE USER BATCHES FOR ALL USERS IN THE BATCH
		INSERT into tblUserBatch (intUserID, strBatchID, intPayWeekNum, intUserBatchStatus, dtStartDatePeriod, dtEndDatePeriod, intCompanyID, intDepartmentID, intSubdepartmentID, intEmployeeTypeID, intPayMethodType) --VALUES (@USERID,@BATCHID,@PAYWEEKNUM,0,@StartDate,@EndDate)
		SELECT @USERID,@BATCHID,@PAYWEEKNUM,0,@PayDate,@PayDate, nCompanyID, nDeptID,nJobTitleID,nEmployeeType, @PAYMETHODTYPE  FROM tuser where id = @USERID

END

--CREATE COMPENSATIONS MANUAL ENTRY

--Regular Wages @RegularWages 
IF @RegularWages <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES
           (@BATCHID,@USERID,'Regular Wages',0,@PayDate,0,@RegularWages,getdate(),'',0,@SUPERVISORID,'Imported',1)

--Overtime 1.5X @Overtime 
IF @Overtime <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES
           (@BATCHID,@USERID,'Overtime',0,@PayDate,0,@Overtime,getdate(),'',0,@SUPERVISORID,'Imported',1)

--Overtime 2X @Overtime2X
IF @Overtime2X <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES
           (@BATCHID,@USERID,'Overtime 2X',0,@PayDate,0,@Overtime2X,getdate(),'',0,@SUPERVISORID,'Imported',1)

--Meal @Meal
IF @Meal <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES
           (@BATCHID,@USERID,'Meal',0,@PayDate,0,@Meal,getdate(),'',0,@SUPERVISORID,'Imported',1)

--Refund @Refund
IF @Refund <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES
           (@BATCHID,@USERID,'Refund',0,@PayDate,0,@Refund,getdate(),'',0,@SUPERVISORID,'Imported',1)

--Sick @Sick
IF @Sick <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES
           (@BATCHID,@USERID,'Sick',0,@PayDate,0,@Sick,getdate(),'',0,@SUPERVISORID,'Imported',1)

--Vacation @Vacation
IF @Vacation <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES
           (@BATCHID,@USERID,'Vacation',0,@PayDate,0,@Vacation,getdate(),'',0,@SUPERVISORID,'Imported',1)

--Compensation1 @Compensation1
IF @Compensation1 <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES
           (@BATCHID,@USERID, 'Holiday' ,0,@PayDate,0,@Compensation1,getdate(),'',0,@SUPERVISORID,'Imported',1)

--Compensation2 @Compensation2
IF @Compensation2 <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES
           (@BATCHID,@USERID, 'Car Allowance' ,0,@PayDate,0,@Compensation2,getdate(),'',0,@SUPERVISORID,'Imported',1)

----Compensation3 @Compensation3
IF @Compensation3 <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES
           (@BATCHID,@USERID, 'Cellular' ,0,@PayDate,0,@Compensation3,getdate(),'',0,@SUPERVISORID,'Imported',1)

----Compensation4 @Compensation4
IF @Compensation4 <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES

           (@BATCHID,@USERID, 'Incentivo' ,0,@PayDate,0,@Compensation4,getdate(),'',0,@SUPERVISORID,'Imported',1)

----Compensation5 @Compensation5
IF @Compensation5 <> 0
INSERT INTO [dbo].[tblUserBatchCompensations_ManualEntry]
           ([strBatchID],[intUserID],[strCompensationName],[decPayRate],[dtPayDate],[decHours],[decPay],[dtTimeStamp],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[intEditType])
     VALUES
           (@BATCHID,@USERID, 'Reembolso' ,0,@PayDate,0,@Compensation5,getdate(),'',0,@SUPERVISORID,'Imported',1)


--CREATE WITHHOLDINGS MANUAL ENTRY

--FICA SS
IF @FICA_SS_EE <> 0
INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'FICA SS',@PayDate,@RegularWages,@FICA_SS_EE,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)

--FICA MED
IF @FICA_MED_EE <> 0
INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'FICA MED',@PayDate,@RegularWages,@FICA_MED_EE,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)

--@FICA_MED_PLUS_EE
IF @FICA_MED_PLUS_EE <> 0
INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'FICA MED PLUS',@PayDate,@RegularWages,@FICA_MED_PLUS_EE,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)
--SINOT
IF @SINOT_EE <> 0
INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'SINOT',@PayDate,@RegularWages,@SINOT_EE,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)
--CHOFERIL
IF @CHOFERIL_EE <> 0
INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'CHOFERIL',@PayDate,@RegularWages,@CHOFERIL_EE,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)

--PLAN_MEDICO_EE
IF @PLAN_MEDICO_EE <> 0
INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'PLAN MEDICO',@PayDate,@RegularWages,@PLAN_MEDICO_EE,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)

--ST ITAX
IF @ST_ITAX_EE <> 0
INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'ST ITAX',@PayDate,@RegularWages,@ST_ITAX_EE,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)

--Withholdings1
IF @Withholdings1 <> 0
INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'ADELANTO',@PayDate,@RegularWages,@Withholdings1,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)

--Withholdings2
IF @Withholdings2 <> 0
INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'AFLAC',@PayDate,@RegularWages,@Withholdings2,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)

--Withholdings3
--IF @Withholdings3 <> 0
--INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
--           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
--     VALUES
--           (@BATCHID,@USERID,'AFLAC',@PayDate,@RegularWages,@Withholdings3,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)

--Withholdings4
--IF @Withholdings4 <> 0
--INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
--           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
--     VALUES
--           (@BATCHID,@USERID,'ASUME 2',@PayDate,@RegularWages,@Withholdings4,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)

--Withholdings5
--IF @Withholdings5 <> 0
--INSERT INTO [dbo].[tblUserBatchWithholdings_ManualEntry]
--           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
--     VALUES
--           (@BATCHID,@USERID,'EMBARGO',@PayDate,@RegularWages,@Withholdings5,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)



--CREATE COMPANY CONTRIBUTIONS MANUAL ENTRY

--FICA SS
IF @FICA_SS_ER <> 0
INSERT INTO [dbo].[tblCompanyBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'FICA SS',@PayDate,@RegularWages,@FICA_SS_ER,0 ,'',0,@SUPERVISORID,'Imported',getdate(),1)

--FICA MED
IF @FICA_MED_ER <> 0
INSERT INTO [dbo].[tblCompanyBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'FICA MED',@PayDate,@RegularWages,@FICA_MED_ER,0,'',0,@SUPERVISORID,'Imported',getdate(),1)

--SINOT
IF @SINOT_ER <> 0
INSERT INTO [dbo].[tblCompanyBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'SINOT',@PayDate,@RegularWages,@SINOT_ER,0,'',0,@SUPERVISORID,'Imported',getdate(),1)

-- CHOFERIL_ER
IF @CHOFERIL_ER <> 0
INSERT INTO [dbo].[tblCompanyBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'CHOFERIL',@PayDate,@RegularWages,@CHOFERIL_ER,0,'',0,@SUPERVISORID,'Imported',getdate(),1)

-- FUTA_ER
IF @FUTA_ER <> 0
INSERT INTO [dbo].[tblCompanyBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'FUTA',@PayDate,@RegularWages,@FUTA_ER,0,'',0,@SUPERVISORID,'Imported',getdate(),1)

-- SUTA_ER
IF @SUTA_ER <> 0
INSERT INTO [dbo].[tblCompanyBatchWithholdings_ManualEntry]
           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
     VALUES
           (@BATCHID,@USERID,'SUTA',@PayDate,@RegularWages,@SUTA_ER,0,'',0,@SUPERVISORID,'Imported',getdate(),1)

-- @Contributions1
--IF @Contributions1 <> 0
--INSERT INTO [dbo].[tblCompanyBatchWithholdings_ManualEntry]
--           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
--     VALUES
--           (@BATCHID,@USERID,'PLAN MEDICO',@PayDate,@RegularWages,@Contributions1,0,'',0,@SUPERVISORID,'Imported',getdate(),1)

---- @Contributions2
--IF @Contributions2 <> 0
--INSERT INTO [dbo].[tblCompanyBatchWithholdings_ManualEntry]
--           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
--     VALUES
--           (@BATCHID,@USERID,<FIELDNAME>,@PayDate,@RegularWages,@Contributions2,0,'',0,@SUPERVISORID,'Imported',getdate(),1)

---- @Contributions3
--IF @Contributions3 <> 0
--INSERT INTO [dbo].[tblCompanyBatchWithholdings_ManualEntry]
--           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
--     VALUES
--           (@BATCHID,@USERID,<FIELDNAME>,@PayDate,@RegularWages,@Contributions3,0,'',0,@SUPERVISORID,'Imported',getdate(),1)

---- @Contributions4
--IF @Contributions4 <> 0
--INSERT INTO [dbo].[tblCompanyBatchWithholdings_ManualEntry]
--           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
--     VALUES
--           (@BATCHID,@USERID,<FIELDNAME>,@PayDate,@RegularWages,@Contributions4,0,'',0,@SUPERVISORID,'Imported',getdate(),1)

---- @Contributions5
--IF @Contributions5 <> 0
--INSERT INTO [dbo].[tblCompanyBatchWithholdings_ManualEntry]
--           ([strBatchID],[intUserID],[strWithHoldingsName],[dtPayDate],[decBatchEffectivePay],[decWithholdingsAmount],[intPrePostTaxDeduction],[strGLAccount],[boolDeleted],[intSupervisorID],[strNote],[dtTimeStamp],[intEditType])
--     VALUES
--           (@BATCHID,@USERID,<FIELDNAME>,@PayDate,@RegularWages,@Contributions5,0,'',0,@SUPERVISORID,'Imported',getdate(),1)

IF NOT EXISTS(select top(1) * from tblCompanySchedulesProcessed where strBatchID =@BATCHID and strCompanyName  =@PayrollCompany)
INSERT INTO [dbo].[tblCompanySchedulesProcessed]
           ([strCompanyName]
           ,[intPayrollScheduleID]
           ,[strBatchID]
           ,[intPayWeekNumber])
     VALUES
           (@PayrollCompany,0,@BATCHID, 0)

END

--EXECUTE @RC = [dbo].[spPay_Create_UserBatch] 
--   @BATCHID
--  ,@USERID
--  ,@PAYWEEKNUM
--  ,@SUPERVISORID
--  ,@SUPERVISORNAME
--  ,@PAYMETHODTYPE





GO
