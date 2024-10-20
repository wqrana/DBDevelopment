USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_School_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Neil Heverly
-- Create date: 2/3/2014
-- Description:	Saves a School and its options
-- =============================================
/*
	Revisions:
	03/18/2015 - NAH - Added @LocalTime for storing local time offset along with UTC time.
	12/23/2013- Munawar- @SchoolID is By passed as ID is identity in School 
	03/14/2016 - NAH - Rmeove references to Index Generator
	17/03/2016 - Farrukh - Update Customer's District Id in customer table when district change attached to school
*/
-- =============================================
CREATE PROCEDURE [dbo].[Admin_School_Save]
	-- Add the parameters for the stored procedure here
	@ClientID bigint, 
	@SchoolID bigint,
	@District_ID bigint,
	@School_Id_Num varchar(30),
	@School_Name varchar(30),
	@LocalTime datetime2(7),		-- Local Date Time offset
	@Emp_Director_ID bigint = null,
	@Emp_Administrator_ID bigint = null,
	@School_Addr1 varchar(30) = null,
	@School_Addr2 varchar(30) = null,
	@School_City varchar(30) = null,
	@School_State varchar(2) = null,
	@School_Zip varchar(10) = null,
	@School_Phone1 varchar(14) = null,
	@School_Phone2 varchar(14) = null,
	@School_Notes varchar(100) = null,
	@Severe_Need_School bit = 0,
	@Deleted bit = 0,
	@UseDistDirAdmin bit = 1,
	@AlaCarteLimit float = 0.0,
	@MealPlanLimit float = 0.0,
	@UsePinPrefix bit = 0,
	@PinPrefix varchar(4) = null,
	@UsePhotos bit = 1,
	@UseFingerIdent bit = 0,
	@BarCodePinLength int = 0,
	@FiscalStart smalldatetime = null,
	@FiscalEnd smalldatetime = null,
	@StripZeros bit = 0
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @New bit, @SchoolOptsExist BIT, @OldDistrict_ID INT
     IF (@Deleted is NULL)
		SET @Deleted = 0 -- As isDeleted does not allow null value - Abid 

	BEGIN TRAN
	BEGIN TRY
		--Validate Data
		-- Ids
		IF (@ClientID <= 0) RAISERROR('Invalid ClientID (%d) passed.', 11, 1, @ClientID)
		IF ((@SchoolID < -1) OR (@SchoolID = 0)) RAISERROR('Invalid School ID (%d) provided', 11, 1, @SchoolID)

		-- Fiscal Year
		IF (@FiscalStart is null) BEGIN
			SET @FiscalStart = dbo.Main_Default_FiscalYear_Start(GETUTCDATE())
		END

		IF (@FiscalEnd is null) BEGIN
			SET @FiscalEnd = dbo.Main_Default_FiscalYear_End(GETUTCDATE())
		END

		-- Format Limits
		SET @AlaCarteLimit = ROUND(@AlaCarteLimit,2)
		SET @MealPlanLimit = ROUND(@MealPlanLimit,2)
		
		SET @New = CASE @SchoolID WHEN -1 THEN 1 ELSE 0 END

		-- Insert statements for procedure here
		IF (@New = 1) BEGIN
			-- Get an Index
			/*
			EXEC dbo.[Main_IndexGenerator_GetIndex] @ClientID, 16, 1, @SchoolID OUTPUT
			IF ((@@ERROR <> 0) AND (@SchoolID <= 0))
				RAISERROR('Failed to Get School Index', 11, 2)
			*/

			-- Insert the School
			INSERT INTO Schools ([ClientID],[District_Id],[Emp_Director_Id],[Emp_Administrator_Id],[SchoolID],[SchoolName],[Address1],[Address2],[City],
									[State],[Zip],[Phone1],[Phone2],[Comment],[isSevereNeed],[isDeleted],[UseDistDirAdmin],[Forms_Director_Id],[Forms_Admin_Id],
									[UseDistFormsDirAdmin],[UseDistNameDirector],[UseDistNameAdmin],[Forms_Admin_Title],[Forms_Admin_Phone],[Forms_Dir_Title],[Forms_Dir_Phone]) 
					VALUES (@ClientID, @District_ID, @Emp_Director_ID, @Emp_Administrator_ID, @School_Id_Num, @School_Name, @School_Addr1, @School_Addr2, @School_City, 
									@School_State, @School_Zip, @School_Phone1, @School_Phone2, @School_Notes, @Severe_Need_School, @Deleted, @UseDistDirAdmin, null, null, 
									1, 1, 1, null, null, null, null)

			--Getting last id for refrence
			IF (@@ERROR <> 0) RAISERROR('Failed to insert new School.', 11, 3)
			
			SELECT @SchoolID = SCOPE_IDENTITY()

			-- Remove any old district option setup (Should not be any)
			DELETE FROM SchoolOptions WHERE ClientID = @ClientID and School_Id = @SchoolID
			IF (@@ERROR <> 0) RAISERROR('Failed to Remove any old school options', 11, 4)

			-- Insert the School's Options
			INSERT INTO SchoolOptions ([ClientID],[School_Id],[ChangedDate],[AlaCarteLimit],[MealPlanLimit],[DoPinPreFix],[PinPreFix],[PhotoLogging],[FingerPrinting],
											[BarCodeLength],[StartSchoolYear],[EndSchoolYear],[StripZeros],[ChangedDateLocal]) 
					VALUES (@ClientID, @SchoolID, GETUTCDATE(), @AlaCarteLimit, @MealPlanLimit, @UsePinPrefix, @PinPrefix, @UsePhotos, @UseFingerIdent,
								@BarCodePinLength, @FiscalStart, @FiscalEnd, @StripZeros, @LocalTime)	
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Save the School''s Options', 11, 5)
		END
		ELSE BEGIN
		
		SELECT @OldDistrict_ID=District_ID FROM dbo.Schools WHERE Id = @SchoolID AND ClientID = @ClientID  

			UPDATE [dbo].[Schools] SET 
						[District_Id] = @District_ID
						,[Emp_Director_Id] = @Emp_Director_ID
						,[Emp_Administrator_Id] = @Emp_Administrator_ID
						,[SchoolID] = @School_Id_Num
						,[SchoolName] = @School_Name
						,[Address1] = @School_Addr1
						,[Address2] = @School_Addr2
						,[City] = @School_City
						,[State] = @School_State
						,[Zip] = @School_Zip
						,[Phone1] = @School_Phone1
						,[Phone2] = @School_Phone2
						,[Comment] = @School_Notes
						,[isSevereNeed] = @Severe_Need_School
						,[isDeleted] = @Deleted
						,[UseDistDirAdmin] = @UseDistDirAdmin
			WHERE Id = @SchoolID AND ClientID = @ClientID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Update the School', 11, 6)

	IF(@OldDistrict_ID <>  @District_ID)
	BEGIN
		UPDATE dbo.Customers SET District_Id = @District_ID WHERE District_Id = @OldDistrict_ID AND ClientID = @ClientID
	IF (@@ERROR <> 0)
			RAISERROR('Failed to Update the Customer District', 11, 7)
	END 

			SELECT @SchoolOptsExist = COUNT(*) FROM SchoolOptions WHERE School_Id = @SchoolID AND ClientID = @ClientID
			IF (@@ERROR <> 0) RAISERROR('Failed trying to find existing School Options.', 11, 8)
				
			IF (@SchoolOptsExist = 0) BEGIN
				INSERT INTO SchoolOptions ([ClientID],[School_Id],[ChangedDate],[AlaCarteLimit],[MealPlanLimit],[DoPinPreFix],[PinPreFix],[PhotoLogging],[FingerPrinting],
											[BarCodeLength],[StartSchoolYear],[EndSchoolYear],[StripZeros],[ChangedDateLocal]) 
					VALUES (@ClientID, @SchoolID, GETUTCDATE(), @AlaCarteLimit, @MealPlanLimit, @UsePinPrefix, @PinPrefix, @UsePhotos, @UseFingerIdent,
								@BarCodePinLength, @FiscalStart, @FiscalEnd, @StripZeros, @LocalTime)	
			END
			ELSE BEGIN		
				UPDATE [dbo].[SchoolOptions] SET 
					[ChangedDate] = GETUTCDATE()
					,[ChangedDateLocal] = @LocalTime
					,[AlaCarteLimit] = @AlaCarteLimit
					,[MealPlanLimit] = @MealPlanLimit
					,[DoPinPreFix] = @UsePinPrefix
					,[PinPreFix] = @PinPrefix
					,[PhotoLogging] = @UsePhotos
					,[FingerPrinting] = @UseFingerIdent
					,[BarCodeLength] = @BarCodePinLength
					,[StartSchoolYear] = @FiscalStart
					,[EndSchoolYear] = @FiscalEnd
					,[StripZeros] = @StripZeros
				WHERE School_Id = @SchoolID AND ClientID = @ClientID
			END
			
			IF (@@ERROR <> 0) RAISERROR('Failed to Save the School''s Options', 11, 9)
				
		END

		COMMIT TRAN
		SELECT @SchoolID as School_Id, 0 as Result, '' as ErrorMessage
	END TRY
	BEGIN CATCH
		
		ROLLBACK TRAN
		SELECT 0 as School_Id, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
	END CATCH
END
GO
