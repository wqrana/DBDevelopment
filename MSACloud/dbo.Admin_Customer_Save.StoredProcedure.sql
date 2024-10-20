USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Customer_Save]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Neil Heverly
-- Create date: 2/14/2014
-- Description:	Saves a Customer and its options
-- =============================================
-- Revisions:
-- 3/3/2014  - NAH - Changed Results to Parameters (CustomerID, ResultCode, ErrorMessage)
-- 3/8/2014  - Changed inner catch to Use a int for error checking later instead of raising another error
-- 3/17/2014 - Added save picture section and parameters
-- 3/19/2014 - Abid - added check on @ContainerName during picture save (no need to call picture save if user did not select picture) 
-- 01/28/2015 - added graduationDateSet column in insert and update command
-- 03/06/2015 - changed GETDATE to SYSDATETIMEOFFSET for saving to new datetimeoffset fields.
-- 03/11/2015 - change SYSDATETIMEOFFSET back to GETUTCDATE
-- 03/12/2015 - Added Local Times for audit purposes.
-- 03/13/2015 - Added Customer Log entry.
-- 03/26/2015 - Abid - Added Customer Log entry for edit. 
-- 07/10/2015 - remove datetimeoffset for datetime2(7)
-- 12/23/2015 - @CustomerID generation is by pass as ID identity is added in customer table
-- 03/14/2016 - NAH - Removed references to Index Generator
-- =============================================
CREATE PROCEDURE [dbo].[Admin_Customer_Save]
	-- Add the parameters for the stored procedure here
	@ClientID bigint, 

	-- Required information
	@CustomerID int OUTPUT,	-- Pass -1 for new record.
	@DistrictID int,
	@SchoolID int,
	@UserID varchar(16),
	@PIN varchar(16),
	@LastName varchar(24),
	@FirstName varchar(16),
	@LunchType int,
	@Student bit,
	@EatingAssignments as dbo.CustomerSchoolAssignments READONLY,

	-- Links
	@LanguageID int = null,
	@GradeID int = null,
	@HomeroomID int = null,
	@EthnicityID int = null,
	
	-- Optional Info
	@Middle varchar(1) = null, -- Middle Initial Only
	@Gender varchar(1) = null, -- 'F' OR 'M'
	@SSN varchar(11) = null,
	@Addr1 varchar(30) = null,
	@Addr2 varchar(30) = null,
	@City varchar(30) = null,
	@State varchar(2) = null,
	@Zip varchar(10) = null,
	@Phone varchar(14) = null,
	@GraduationDate smalldatetime = null,
	@graduationDateSet bit = 0,
	@Notes varchar(30) = null,
	@Email varchar(60) = null,
	@DateOfBirth smalldatetime = null,

	-- Options
	@Active bit = 1,
	@AllowAlaCarte bit = 1,
	@NoCreditOnAccount bit = 0,
	@AllowACH bit = 1,
	@SnackProgram bit = 0,
	@StudentWorker bit = 0,
	@NotInDistrict bit = 0,

	-- Dates
	@CreationDate datetime2(7) = NULL,	-- This should be UTC
	@LocalTime datetime2(7) = NULL,	-- This is Local Time

	-- Picture Info
	@PictureExtension varchar(5) ,
	@StorageAccountName varchar(256) ,
	@ContainerName varchar(63) ,
	@PictureFileName varchar(1024) ,

	-- Logging Info
	@EmployeeID int,

	-- Results
	@ResultCode int = 0 OUTPUT,
	@ErrorMessage varchar(4000) = '' OUTPUT

AS
BEGIN
	SET NOCOUNT ON;

	DECLARE 
		@New bit, 
		@CurrentlyActive bit,
		@SchoolIDAssign int,
		@ErrorNum int,
		@PictureExists bit,
		@CurrentUTCDatetime datetime2(7),
		@CustomerLogID int

	SET @ErrorNum = 0

	BEGIN TRAN
	BEGIN TRY
		-- Check Values
		IF ((@ClientID <= 0) OR (@CustomerID < -1) OR (@CustomerID = 0))
			RAISERROR('Invalid Client ID (%d) or Customer ID (%d) provided', 11, 1, @ClientID, @CustomerID)
		
		IF (@DistrictID <= 0 AND @DistrictID != -3)
			RAISERROR('Invalid District ID (%d) provided', 11, 1, @DistrictID)

		IF ((@EmployeeID = 0))
			RAISERROR('Invalid User ID (%d) provided', 11, 1, @EmployeeID)

		-- Format the Data
		IF (@LanguageID <= 0) SET @LanguageID = null
		IF (@GradeID <= 0) SET @GradeID = null
		IF (@HomeroomID <= 0) SET @HomeroomID = null
		IF (@EthnicityID <= 0) SET @EthnicityID = null

		-- Add formatting for Others here.
		-- Get Current UTC DateTime
		SET @CurrentUTCDatetime = GETUTCDATE()

		-- Mark if New or Update
		SET @New = CASE @CustomerID WHEN -1 THEN 1 ELSE 0 END

		-- Insert statements for procedure here
		IF (@New = 1) BEGIN
			IF (@CreationDate = NULL)
				SET @CreationDate = @CurrentUTCDatetime

			-- Get an Index
			/* Cloud DB does not use Index Generator *
			EXEC dbo.[Main_IndexGenerator_GetIndex] @ClientID, 18, 1, @CustomerID OUTPUT
			IF ((@@ERROR <> 0) AND (@CustomerID <= 0))
				RAISERROR('Failed to Get Customer Index', 11, 2)
			*/
				
			-- Insert the Customer
			INSERT INTO Customers ([ClientID],[District_Id],[Language_Id],[Grade_Id],[Homeroom_Id],[isStudent],[UserID],[PIN],[LastName],[FirstName],[Middle],[Gender],[SSN],
									[Address1],[Address2],[City],[State],[Zip],[Phone],[LunchType],[AllowAlaCarte],[CashOnly],[isActive],[GraduationDate],[GraduationDateSet], [SchoolDat],[isDeleted],
									[ExtraInfo],[EMail],[DOB],[ACH],[isSnack],[isStudentWorker],[isVeteran],[Ethnicity_Id],[Disability],[isHomeless],[Disabled],[CreationDate],
									[NotInDistrict],[MealsLeft],[MealPlan_Id],[STUD_MGMT_ID],[DeactiveDate],[ReactiveDate],[GradDate],
									[CreationDateLocal],[DeactiveDateLocal],[ReactiveDateLocal])
							VALUES
								(@ClientID,  @DistrictID, @LanguageID, @GradeID, @HomeroomID, @Student, @UserID, @PIN, @LastName, @FirstName, @Middle, @Gender, @SSN,
									@Addr1, @Addr2, @City, @State, @Zip, @Phone, @LunchType, @AllowAlaCarte, @NoCreditOnAccount, @Active, @GraduationDate, @graduationDateSet, 'T', 0,
									@Notes, @Email, @DateOfBirth, @AllowACH, @SnackProgram, @StudentWorker, 0, @EthnicityID, 0, 0, 0, @CreationDate,
									@NotInDistrict, 0, NULL, NULL, NULL, NULL, NULL,
									@LocalTime, NULL, NULL)

			IF (@@ERROR <> 0) RAISERROR('Failed to Save the Customer', 11, 3)

			--Getting last id for refrence
			SELECT @CustomerID = SCOPE_IDENTITY()

			-- Add Log
			SET @CustomerLogID = -1
			EXEC dbo.Main_CustomerLog_Save @ClientID, @CustomerLogID output, @CustomerID, @EmployeeID, @LocalTime, 'Customer Account Created', @ResultCode output, @ErrorMessage output
			IF (@ResultCode > 0) RAISERROR(@ErrorMessage, 11, @ResultCode)

		END
		ELSE BEGIN
			-- Update Customer
			UPDATE Customers SET
				[District_Id] = @DistrictID
				  ,[Language_Id] = @LanguageID
				  ,[Grade_Id] = @GradeID
				  ,[Homeroom_Id] = @HomeroomID
				  ,[isStudent] = @Student
				  ,[UserID] = @UserID
				  ,[PIN] = @PIN
				  ,[LastName] = @LastName
				  ,[FirstName] = @FirstName
				  ,[Middle] = @Middle
				  ,[Gender] = @Gender
				  ,[SSN] = @SSN
				  ,[Address1] = @Addr1
				  ,[Address2] = @Addr2
				  ,[City] = @City
				  ,[State] = @State
				  ,[Zip] = @Zip
				  ,[Phone] = @Phone
				  ,[LunchType] = @LunchType
				  ,[AllowAlaCarte] = @AllowAlaCarte
				  ,[CashOnly] = @NoCreditOnAccount
				  ,[isActive] = @Active
				  ,[GraduationDate] = @GraduationDate
				  ,[graduationDateSet] = @graduationDateSet
				  ,[ExtraInfo] = @Notes
				  ,[EMail] = @Email
				  ,[DOB] = @DateOfBirth
				  ,[ACH] = @AllowACH
				  ,[isSnack] = @SnackProgram
				  ,[isStudentWorker] = @StudentWorker
				  ,[NotInDistrict] = @NotInDistrict
			WHERE ClientID = @ClientID AND Id = @CustomerID
			IF (@@ERROR <> 0)
				RAISERROR('Failed to Update the Customer', 11, 3)

			-- Add Log
			SET @CustomerLogID = -1
			EXEC dbo.Main_CustomerLog_Save @ClientID, @CustomerLogID output, @CustomerID, @EmployeeID, @LocalTime, 'Customer Account Edited', @ResultCode output, @ErrorMessage output
			IF (@ResultCode > 0)
				RAISERROR(@ErrorMessage, 11, @ResultCode)


			SELECT @CurrentlyActive = isActive FROM Customers WHERE ClientID = @ClientID AND Id = @CustomerID
			IF (@@ERROR <> 0)
				RAISERROR('Could not get current active status.  Failed to update Activation Dates', 11, 4)

			IF (@CurrentlyActive <> @Active) BEGIN
				DECLARE @CustLogMsg varchar(255)
				-- Set Deactivate Date if necessary
				IF (@Active = 0) BEGIN
					SET @CustLogMsg = 'Customer has been deactivated'
					UPDATE Customers SET 
						DeactiveDate = @CurrentUTCDatetime,
						DeactiveDateLocal = @LocalTime
					WHERE ClientID = @ClientID AND Id = @CustomerID
				END
				-- Set Reactivate Date if necessary
				ELSE BEGIN
					SET @CustLogMsg = 'Customer has been reactivated'
					UPDATE Customers SET 
						ReactiveDate = @CurrentUTCDatetime,
						ReactiveDateLocal = @LocalTime
					WHERE ClientID = @ClientID AND Id = @CustomerID
				END
				IF (@@ERROR <> 0) BEGIN
					DECLARE @msg varchar(255)
					SET @msg = 'Failed to update the ' + CASE @Active WHEN 1 THEN 'ReactiveDate' ELSE 'DeactiveDate' END + '.'
					RAISERROR(@msg, 11, 5)
				END

				-- Add Log
				SET @CustomerLogID = -1
				EXEC dbo.Main_CustomerLog_Save @ClientID, @CustomerLogID output, @CustomerID, @EmployeeID, @LocalTime, @CustLogMsg, @ResultCode output, @ErrorMessage output
				IF (@ResultCode > 0)
					RAISERROR(@ErrorMessage, 11, @ResultCode)
			END
		END

		-- Save Picture information
		SELECT @PictureExists = COUNT(*) FROM Pictures WHERE ClientID = @ClientID AND Customer_Id = @CustomerID
		IF (@@ERROR <> 0) RAISERROR('Failed to check if picture exists for Customer ID %d', 11, 6, @CustomerID)

		IF (@PictureExists = 1 and @ContainerName <> '') BEGIN
			UPDATE Pictures SET 
				PictureExtension = @PictureExtension,
				StorageAccountName = @StorageAccountName,
				ContainerName = @ContainerName
			WHERE ClientID = @ClientID AND Customer_Id = @CustomerID
		END
		ELSE BEGIN
			IF (@ContainerName <> '') BEGIN
				INSERT INTO Pictures (ClientID, Customer_Id, PictureExtension, StorageAccountName, ContainerName)
					VALUES (@ClientID, @CustomerID, @PictureExtension, @StorageAccountName, @ContainerName)
			END
		END
		IF (@@ERROR <> 0) RAISERROR('Failed to save picture information for Customer ID %d', 11, 6, @CustomerID)

		-- Save Primary School and Eating Assignments
		-- Remove Current Assignments
		DELETE FROM Customer_School WHERE ClientID = @ClientID AND Customer_Id = @CustomerID
		IF (@@ERROR <> 0) RAISERROR('Failed to remove all current assignments', 11, 7)
		
		-- Add Primary School
		INSERT INTO Customer_School (ClientID, Customer_Id, School_Id, isPrimary) VALUES (@ClientID, @CustomerID, @SchoolID, 1)
		IF (@@ERROR <> 0) RAISERROR('Failed to create primary school assignment', 11, 7)

		DECLARE MyCursor CURSOR LOCAL FOR SELECT School_Id FROM @EatingAssignments
		OPEN MyCursor

		BEGIN TRY
			FETCH NEXT FROM MyCursor INTO @SchoolIDAssign

			WHILE (@@FETCH_STATUS = 0) BEGIN
				INSERT INTO Customer_School (ClientID, Customer_Id, School_Id, isPrimary) VALUES (@ClientID, @CustomerID, @SchoolIDAssign, 0)
				IF (@@ERROR <> 0) RAISERROR('Failed to Save School (%d) as an eating assignment for Customer (%d)', 11, 7, @SchoolIDAssign, @CustomerID)

				FETCH NEXT FROM MyCursor INTO @SchoolIDAssign
			END

			CLOSE MyCursor
			DEALLOCATE MyCursor
		END TRY
		BEGIN CATCH
			CLOSE MyCursor
			DEALLOCATE MyCursor

			SET @ErrorNum = @ErrorNum + 1

			--DECLARE @ErrorMsg nvarchar(4000)
			--SET @ErrorMsg = ERROR_MESSAGE()
		END CATCH
		-- End Save Primary and Eating Assignments

		IF (@ErrorNum = 0) BEGIN
			COMMIT TRAN
			--SELECT @CustomerID as Customer_Id, 0 as Result, '' as ErrorMessage
			SET @ResultCode = 0
			SET @ErrorMessage = ''
		END
		ELSE BEGIN
			ROLLBACK TRAN
			SET @ResultCode = 10
			SET @ErrorMessage = 'Failed to Process All School Assignments'
		END
	END TRY
	BEGIN CATCH
		
		--SELECT 0 as Customer_Id, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage
		SET @CustomerID = 0
		SET @ResultCode = CASE ERROR_STATE() WHEN 0 THEN ERROR_NUMBER() ELSE ERROR_STATE() END
		SET @ErrorMessage = 
			'NUMBER: ' + CAST(ERROR_NUMBER() as varchar) + '\r\n' +
			'LINE: ' + CAST(ERROR_LINE() as varchar) + '\r\n' +
			'Procedure: ' + ERROR_PROCEDURE() + '\r\n' +
			'Message: ' + ERROR_MESSAGE()
			--abid

			DECLARE @ErrorMessage2 NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

			SELECT 
        @ErrorMessage2 = ERROR_MESSAGE(),
        @ErrorSeverity = ERROR_SEVERITY(),
        @ErrorState = ERROR_STATE();

		RAISERROR (@ErrorMessage2, -- Message text.
               @ErrorSeverity, -- Severity.
               @ErrorState -- State.
               );

		ROLLBACK TRAN
	END CATCH
END
GO
