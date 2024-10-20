USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_District_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    
    
    
    
-- =============================================    
-- Author:  Neil Heverly    
-- Create date: 1/23/2014    
-- Description: Saves a District and its options    
-- =============================================    
/*    
 Revisions:    
 1/30/2014 - Add default Values or non-essential fields    
 2/7/2014 - Fixed Calls to Start and End Fiscal Year Dates    
 3/16/2015 - Added ChangedDateLocal field / Changed ChangedDate to be UTC / New @LocalTime parameter    
 12/23/2015 - Munawar - @DistrictID generation is by passed as Id is identity in district table    
 03/14/2016 - NAH - Removed references to Index Generator    
*/    
-- =============================================    
CREATE PROCEDURE [dbo].[Admin_District_Save]    
 -- Add the parameters for the stored procedure here    
 @ClientID bigint,     
 @DistrictID int,    
 @DistrictName varchar(30),    
 @EmployeeTaxable bit,    
 @FreeTaxable bit,    
 @PaidTaxable bit,    
 @RedTaxable bit,    
 @MealPlanTaxable bit,    
 @GuestTaxable bit,    
 @StudentCashTaxable bit,    
 @Deleted bit,    
 @EmpAdminID int = NULL,    
 @EmpDirectorID int = NULL,    
 @DistAddr1 varchar(30) = null,    
 @DistAddr2 varchar(30) = null,    
 @DistCity varchar(30) = null,    
 @DistState varchar(2) = null,    
 @DistZip varchar(10) = null,    
 @DistPhone1 varchar(14) = null,    
 @DistPhone2 varchar(14) = null,    
 @BankName varchar(30) = null,    
 @BankAddr1 varchar(30) = null,    
 @BankAddr2 varchar(30) = null,    
 @BankCity varchar(30) = null,    
 @BankState varchar(2) = null,    
 @BankZip varchar(10) = null,    
 @BankRoute varchar(15) = null,    
 @BankAccount varchar(15) = null,    
 @FiscalYearStart smalldatetime = null,    
 @FiscalYearEnd smalldatetime = null,    
 @LocalTime datetime2(7) = null,    
 @CCProcessor_Id int=null,  
 @EnableGlobalVeriFoneUser bit=null,  
 @LicenseModel varchar(1)=null,  
 @MerchantId varchar(12)=null,    
 @VeriFoneIP varchar(16)=null,    
 @VeriFonePort int=null,    
 @VeriFoneUserId varchar(20)=null,  
 @VeriFonePassword varchar(20)=null,    
 @newDistrictId int output  
AS    
BEGIN    
    
SET XACT_ABORT ON    
    
 SET NOCOUNT ON;    
    
 DECLARE @New bit, @DistOptsExist bit    
 BEGIN TRY    
    
 BEGIN TRAN    
      
  IF (@Deleted is NULL)    
  SET @Deleted = 0 -- As isDeleted does not allow null value - Abid      
    
  IF (@ClientID <= 0) RAISERROR('Invalid Client ID (%d)', 11, 1, @ClientID)    
  IF ((@DistrictID < -1) OR (@DistrictID = 0)) RAISERROR('Invalid District ID (%d) provided', 11, 1, @DistrictID)    
    
  IF (@FiscalYearStart is null) BEGIN    
   SET @FiscalYearStart =  dbo.Main_Default_FiscalYear_Start(GETDATE())    
  END    
    
  IF (@FiscalYearEnd is null) BEGIN    
   SET @FiscalYearEnd =  dbo.Main_Default_FiscalYear_End(GETDATE())    
  END    
    
  SET @New = CASE @DistrictID WHEN -1 THEN 1 ELSE 0 END    
    
  -- Insert statements for procedure here    
  IF (@New = 1) BEGIN    
   -- Get an Index    
   /* Cloud DB does not use Index Generator *    
   EXEC dbo.[Main_IndexGenerator_GetIndex] @ClientID, 13, 1, @DistrictID OUTPUT    
   IF ((@@ERROR <> 0) AND (@DistrictID <= 0))    
    RAISERROR('Failed to Get District Index', 11, 2)    
   */    
    
   -- Insert the District    
   INSERT INTO District ([ClientID],[Emp_Administrator_Id],[Emp_Director_Id],[DistrictName],[Address1],[Address2],[City],[State],[Zip],[Phone1],[Phone2],[isDeleted],[BankCity]    
         ,[BankState],[BankZip],[BankName],[BankAddr1],[BankAddr2],[BankRoute],[BankAccount],[BankMICR],[SpecialSetup],[Forms_Admin_Id],[Forms_Director_Id],[UseDistNameDirector]    
         ,[UseDistNameAdmin],[Forms_Admin_Title],[Forms_Admin_Phone],[Forms_Dir_Title],[Forms_Dir_Phone],[AppUpdateDelay],[UpdatePositiveID])     
     VALUES (@ClientID, @EmpAdminID, @EmpDirectorID,  @DistrictName, @DistAddr1, @DistAddr2, @DistCity, @DistState, @DistZip, @DistPhone1, @DistPhone2, @Deleted, @BankCity,    
         @BankState, @BankZip, @BankName, @BankAddr1, @BankAddr2, @BankRoute, @BankAccount, NULL, 0, NULL, NULL, 0,    
         0, NULL, NULL, NULL, NULL, 0, 0)    
   IF (@@ERROR <> 0) RAISERROR('Failed to Save the District', 11, 3)    
       
   --GETTING LAST ID FOR REFRENCE    
   SELECT @DistrictID = SCOPE_IDENTITY()    
    
   -- Remove any old district option setup (Should not be any)    
   DELETE FROM DistrictOptions WHERE ClientID = @ClientID and District_Id = @DistrictID    
   IF (@@ERROR <> 0) RAISERROR('Failed to Remove any old district options', 11, 4)    
    
   SET @DistOptsExist = 0    
  END    
  ELSE BEGIN    
   UPDATE District SET    
      [DistrictName] = @DistrictName    
      ,[Address1] = @DistAddr1    
      ,[Address2] = @DistAddr2    
      ,[City] = @DistCity    
      ,[State] = @DistState    
      ,[Zip] = @DistZip    
      ,[Phone1] = @DistPhone1    
      ,[Phone2] = @DistPhone2    
      ,[isDeleted] = @Deleted    
      ,[BankCity] = @BankCity    
      ,[BankState] = @BankState    
      ,[BankZip] = @BankZip    
      ,[BankName] = @BankName    
      ,[BankAddr1] = @BankAddr1    
      ,[BankAddr2] = @BankAddr2    
      ,[BankRoute] = @BankRoute    
      ,[BankAccount] = @BankAccount    
      ,[Emp_Administrator_Id] = @EmpAdminID    
      ,[Emp_Director_Id] = @EmpDirectorID    
   WHERE ClientID = @ClientID and     
    Id = @DistrictID    
   IF (@@ERROR <> 0)    
    RAISERROR('Failed to Update the District', 11, 6)    
    
   select @DistOptsExist = COUNT(*) FROM DistrictOptions WHERE District_Id = @DistrictID AND ClientID = @ClientID    
   IF (@@ERROR <> 0)    
    RAISERROR('Failed trying to find existing District Options.', 11, 7)    
  END    
    
  -- Apply District Option Settings    
  IF (@DistOptsExist = 0) BEGIN    
   INSERT INTO DistrictOptions ([ClientID],[District_Id],[ChangedDate],[LetterWarning1],[LetterWarning2],[LetterWarning3],[TaxPercent],[isEmployeeTaxable],[isStudentFreeTaxable],[isStudentPaidTaxable]    
          ,[isStudentRedTaxable],[StartSchoolYear],[EndSchoolYear],[StartForms],[EndForms],[isMealPlanTaxable],[UsingMealPlan],[UsingMealEqual],[UsingBonus]    
          ,[BlindCashOut],[isGuestTaxable],[isStudCashTaxable],[LetterWarning4],[LetterWarning5],[LetterWarning6],[MaxLetter],[LetterResetLimit],[LetterResetRule]    
          ,[ReqSecondAuth],[SecondAuthType],[CCProcessor_Id],[EnableGlobalVeriFoneUser],[LicenseModel],[MerchantId],[VeriFoneIP],[VeriFonePort],[VeriFoneUserId]    
          ,[VeriFonePassword],[IncomePercentage],[FSTANFPercentage],[AnnualAmountToQualify],[ChangedDateLocal])     
    VALUES (@ClientID, @DistrictID, GETUTCDATE(), 0,0,0,6,@EmployeeTaxable,@FreeTaxable, @PaidTaxable, @RedTaxable, @FiscalYearStart, @FiscalYearEnd, NULL, NULL, @MealPlanTaxable, 0, 0, 0,    
          0, @GuestTaxable, @StudentCashTaxable, 0, 0, 0, 1, 0, 0,   
    0, 0, @CCProcessor_Id, @EnableGlobalVeriFoneUser, @LicenseModel, @MerchantId, @VeriFoneIP, @VeriFonePort, @VeriFoneUserId,    
          @VeriFonePassword, 0, 0, 0, @LocalTime)  
  END    
  ELSE BEGIN    
   UPDATE DistrictOptions SET    
     [ChangedDate] = GETUTCDATE()    
     ,[ChangedDateLocal] = @LocalTime    
     ,[isEmployeeTaxable] = @EmployeeTaxable    
     ,[isStudentFreeTaxable] = @FreeTaxable    
     ,[isStudentPaidTaxable] = @PaidTaxable    
     ,[isStudentRedTaxable] = @RedTaxable    
     ,[StartSchoolYear] = @FiscalYearStart    
     ,[EndSchoolYear] = @FiscalYearEnd    
     ,[isMealPlanTaxable] = @MealPlanTaxable    
     ,[isGuestTaxable] = @GuestTaxable    
     ,[isStudCashTaxable] = @StudentCashTaxable  
  ,[CCProcessor_Id]=@CCProcessor_Id  
  ,[EnableGlobalVeriFoneUser]=@EnableGlobalVeriFoneUser  
  ,[LicenseModel]=@LicenseModel  
  ,[MerchantId]=@MerchantId  
  ,[VeriFoneIP]=@VeriFoneIP  
  ,[VeriFonePort]=@VeriFonePort  
  ,[VeriFoneUserId]=@VeriFoneUserId  
  ,[VeriFonePassword]=@VeriFonePassword     
   WHERE District_Id = @DistrictID AND ClientID = @ClientID    
  END    
  IF (@@ERROR <> 0)    
   RAISERROR('Failed to Save the District''s Options', 11, 8)    
    
  COMMIT TRAN    
  SET @newDistrictId = @DistrictID    
  SELECT @DistrictID as District_Id, 0 as Result, '' as ErrorMessage    
 END TRY     BEGIN CATCH    
  ROLLBACK TRAN    
  SET @newDistrictId = 0    
  SELECT 0 as District_Id, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage    
 END CATCH    
END
GO
