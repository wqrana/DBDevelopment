USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateDefaultExpirationNotificationLog]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera Toro, Salman
-- Create date: 6/9/2020
-- Description:	Creates the Notification Log.
--				Creates an entry for each new item. Any notifications  
--				before the date that have not been sent will be created.
-- =============================================
CREATE PROCEDURE [dbo].[sp_CreateDefaultExpirationNotificationLog] 
	-- Add the parameters for the stored procedure here
	@CreateLogDate date,
	@CreatedBy int
AS
BEGIN
	DECLARE @RowCount int = 0
	BEGIN TRY
	Declare @NotificationScheduleDetailId int
	Declare @ApplicationConfigurationValue as varchar(20)
	Declare @NotificationLookupStartDate as date
	Select @ApplicationConfigurationValue = [ApplicationConfigurationValue] from ApplicationConfiguration 
	where ApplicationConfigurationName ='NotificationLookupStartDate'
	
	Select Top 1 @NotificationScheduleDetailId =  NotificationScheduleDetailId from NotificationScheduleDetail where DaysBefore=0;
	
	Select @NotificationLookupStartDate = Cast( @ApplicationConfigurationValue as date) 

	
	Select @NotificationScheduleDetailId = ISNULL( @NotificationScheduleDetailId,1) 

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

    -- DOCUMENTS

		
		INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[IsNotificationAsExpired]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	select	   @NotificationScheduleDetailId as [NotificationScheduleDetailId]
			   ,ed.[EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,NULL as [EmployeeCustomFieldId]
			   ,1 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,1 as [IsNotificationAsExpired]
			   ,ui.[CompanyId]
			   ,ed.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeeDocument ed 
	inner join UserInformation ui on ed.UserInformationId = ui.UserInformationId
	left outer join dbo.NotificationLog nl on nl.EmployeeDocumentId = ed.EmployeeDocumentId AND nl.IsNotificationAsExpired=1 And nl.DataEntryStatus=1
    WHERE @NotificationLookupStartDate<=ed.ExpirationDate AND 
		  (CAST(ed.ExpirationDate as date) <= CAST(@CreateLogDate as date))  And 
		  nl.NotificationLogId is null And ui.EmployeeStatusId=1--New only
	
	SET  @RowCount = @@ROWCOUNT;

	--CREDENTIALS

	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[IsNotificationAsExpired]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	select	    @NotificationScheduleDetailId as [NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,ec.EmployeeCredentialId as [EmployeeCredentialId]
			   ,NULL as [EmployeeCustomFieldId]
			   ,2 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,1 as [IsNotificationAsExpired]
			   ,ui.[CompanyId]
			   ,ui.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeeCredential ec 
	inner join UserInformation ui on ec.UserInformationId = ui.UserInformationId
	left outer join dbo.NotificationLog nl on nl.EmployeeCredentialId = ec.EmployeeCredentialId AND nl.IsNotificationAsExpired=1 And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=ec.ExpirationDate AND 
	      (CAST(ec.ExpirationDate as date) <= CAST(@CreateLogDate as date))  And 
		  nl.NotificationLogId is null And ui.EmployeeStatusId=1--New only
	
	
	SET  @RowCount = @RowCount + @@ROWCOUNT;

	--CUSTOM FIELDS


	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[IsNotificationAsExpired]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	select	   @NotificationScheduleDetailId as [NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,ec.EmployeeCustomFieldId as [EmployeeCustomFieldId]
			   ,3 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,1 as [IsNotificationAsExpired]
			   ,ui.[CompanyId]
			   ,ui.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeeCustomField ec 
	inner join UserInformation ui on ec.UserInformationId = ui.UserInformationId
	left outer join dbo.NotificationLog nl on nl.EmployeeCustomFieldId = ec.EmployeeCustomFieldId AND nl.IsNotificationAsExpired=1 And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=ec.ExpirationDate AND 
	      (CAST(ec.ExpirationDate as date) <= CAST(@CreateLogDate as date))  And 
		  nl.NotificationLogId is null And ui.EmployeeStatusId=1--New only
	
	SET  @RowCount = @RowCount + @@ROWCOUNT

	--Employee Notification


	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[EmploymentId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[IsNotificationAsExpired]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	select	   @NotificationScheduleDetailId as [NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,emp.EmploymentId as [EmploymentId]
			   ,4 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,1 as [IsNotificationAsExpired]
			   ,(Select top 1 CompanyId from EmploymentHistory empHistory where empHistory.EmploymentId=emp.EmploymentId order by EmploymentHistoryId desc) CompanyId
			   ,EHP_HIS.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	
	Employment emp 
	INNER JOIN UserInformation ui on emp.UserInformationId = ui.UserInformationId
	inner join EmployeeNotification d on d.EmployeeNotificationTypeId=1
	INNER JOIN EmploymentHistory EHP_HIS on EHP_HIS.EmploymentHistoryId = (Select top 1 EmploymentHistoryId from EmploymentHistory empHistory where empHistory.UserInformationId=emp.UserInformationId order by EmploymentHistoryId desc)
	left outer join dbo.NotificationLog nl on nl.EmploymentId = emp.EmploymentId AND nl.IsNotificationAsExpired=1 And nl.DataEntryStatus=1
	WHERE EMP.ProbationEndDate is not null And EMP.TerminationDate is null And @NotificationLookupStartDate<=EMP.ProbationEndDate AND (CAST(emp.ProbationEndDate as date) <= CAST(@CreateLogDate as date))  And nl.NotificationLogId is null --New only
		  AND (d.CompanyId=EHP_HIS.CompanyId Or d.CompanyId is NULL) And ui.EmployeeStatusId=1
	SET  @RowCount = @RowCount + @@ROWCOUNT


	--Performance Expiration Notification=5
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[EmploymentId]
			   ,[EmployeePerformanceId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[IsNotificationAsExpired]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	   @NotificationScheduleDetailId as [NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,null as [EmploymentId]
			   ,Performance.EmployeePerformanceId as EmployeePerformanceId
			   ,5 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,1 as [IsNotificationAsExpired]
			   ,EHP_HIS.CompanyId
			   ,Performance.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeePerformance  Performance 
	INNER JOIN UserInformation ui on Performance.UserInformationId = ui.UserInformationId
	INNER JOIN EmploymentHistory EHP_HIS on EHP_HIS.EmploymentHistoryId = (Select top 1 EmploymentHistoryId from EmploymentHistory empHistory where empHistory.UserInformationId=Performance.UserInformationId order by EmploymentHistoryId desc)
	INNER JOIN EmployeeNotification d on d.EmployeeNotificationTypeId=2
	left outer join dbo.NotificationLog nl on nl.EmployeePerformanceId = Performance.EmployeePerformanceId AND nl.IsNotificationAsExpired=1 And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=Performance.ExpiryDate AND (CAST(Performance.ExpiryDate as date) <= CAST(@CreateLogDate as date))  And nl.NotificationLogId is null --New only
		  AND (d.CompanyId=EHP_HIS.CompanyId Or d.CompanyId is NULL) And ui.EmployeeStatusId=1
	SET  @RowCount = @RowCount + @@ROWCOUNT

	--Training Expiration Notification=6
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[EmploymentId]
			   ,[EmployeePerformanceId]
			   ,EmployeeTrainingId
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[IsNotificationAsExpired]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	   @NotificationScheduleDetailId as [NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,null as [EmploymentId]
			   ,null as EmployeePerformanceId
			   ,Training.EmployeeTrainingId
			   ,6 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,1 as [IsNotificationAsExpired]
			   ,EHP_HIS.CompanyId
			   ,Training.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeeTraining  Training 
	INNER JOIN UserInformation ui on Training.UserInformationId = ui.UserInformationId
	INNER JOIN EmploymentHistory EHP_HIS on EHP_HIS.EmploymentHistoryId = (Select top 1 EmploymentHistoryId from EmploymentHistory empHistory where empHistory.UserInformationId=Training.UserInformationId order by EmploymentHistoryId desc)
	INNER JOIN EmployeeNotification d on d.EmployeeNotificationTypeId=3
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.EmployeeTrainingId = Training.EmployeeTrainingId AND nl.IsNotificationAsExpired=1 And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=Training.ExpiryDate AND (CAST(Training.ExpiryDate as date) <= CAST(@CreateLogDate as date))  And nl.NotificationLogId is null --New only
	AND (d.CompanyId=EHP_HIS.CompanyId Or d.CompanyId is NULL) And ui.EmployeeStatusId=1
	SET  @RowCount = @RowCount + @@ROWCOUNT


	--Employee Health Insurance Notification=7
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[EmploymentId]
			   ,[EmployeePerformanceId]
			   ,[EmployeeTrainingId]
			   ,[EmployeeHealthInsuranceId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[IsNotificationAsExpired]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	   @NotificationScheduleDetailId as [NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,null as [EmploymentId]
			   ,null as EmployeePerformanceId
			   ,null as EmployeeTrainingId
			   ,Insurance.EmployeeHealthInsuranceId
			   ,7 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,1 as [IsNotificationAsExpired]
			   ,EHP_HIS.CompanyId
			   ,Insurance.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeeHealthInsurance  Insurance 
	INNER JOIN UserInformation ui on Insurance.UserInformationId = ui.UserInformationId
	INNER JOIN EmploymentHistory EHP_HIS on EHP_HIS.EmploymentHistoryId = (Select top 1 EmploymentHistoryId from EmploymentHistory empHistory where empHistory.UserInformationId=Insurance.UserInformationId order by EmploymentHistoryId desc)
	INNER JOIN EmployeeNotification d on d.EmployeeNotificationTypeId=4
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.EmployeeHealthInsuranceId = Insurance.EmployeeHealthInsuranceId AND nl.IsNotificationAsExpired=1 And nl.DataEntryStatus=1
	WHERE  @NotificationLookupStartDate<=Insurance.InsuranceExpiryDate AND (CAST(Insurance.InsuranceExpiryDate as date) <= CAST(@CreateLogDate as date))  And nl.NotificationLogId is null --New only
	AND (d.CompanyId=EHP_HIS.CompanyId Or d.CompanyId is NULL) And ui.EmployeeStatusId=1
	SET  @RowCount = @RowCount + @@ROWCOUNT

	--Employee Dental Insurance Notification=8
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[EmploymentId]
			   ,[EmployeePerformanceId]
			   ,[EmployeeTrainingId]
			   ,[EmployeeHealthInsuranceId]
			   ,[EmployeeDentalInsuranceId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[IsNotificationAsExpired]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	   @NotificationScheduleDetailId as [NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,null as [EmploymentId]
			   ,null as EmployeePerformanceId
			   ,null as EmployeeTrainingId
			   ,null as EmployeeHealthInsuranceId
			   ,Dental.EmployeeDentalInsuranceId
			   ,8 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,1 as [IsNotificationAsExpired]
			   ,EHP_HIS.CompanyId
			   ,Dental.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeeDentalInsurance  Dental 
	INNER JOIN UserInformation ui on Dental.UserInformationId = ui.UserInformationId
	INNER JOIN EmploymentHistory EHP_HIS on EHP_HIS.EmploymentHistoryId = (Select top 1 EmploymentHistoryId from EmploymentHistory empHistory where empHistory.UserInformationId=Dental.UserInformationId order by EmploymentHistoryId desc)
	INNER JOIN EmployeeNotification d on d.EmployeeNotificationTypeId=5
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.EmployeeDentalInsuranceId = Dental.EmployeeDentalInsuranceId AND nl.IsNotificationAsExpired=1 And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=Dental.InsuranceExpiryDate AND (CAST(Dental.InsuranceExpiryDate as date) <= CAST(@CreateLogDate as date))  And nl.NotificationLogId is null --New only
	AND (d.CompanyId=EHP_HIS.CompanyId Or d.CompanyId is NULL) And ui.EmployeeStatusId=1
	SET  @RowCount = @RowCount + @@ROWCOUNT


	--Employee Action Id Notification=9
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[EmploymentId]
			   ,[EmployeePerformanceId]
			   ,[EmployeeTrainingId]
			   ,[EmployeeHealthInsuranceId]
			   ,[EmployeeDentalInsuranceId]
			   ,[EmployeeActionId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[IsNotificationAsExpired]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	   @NotificationScheduleDetailId as [NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,null as [EmploymentId]
			   ,null as EmployeePerformanceId
			   ,null as EmployeeTrainingId
			   ,null as EmployeeHealthInsuranceId
			   ,null as EmployeeDentalInsuranceId
			   ,[EAction].EmployeeActionId
			   ,9 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,1 as [IsNotificationAsExpired]
			   ,EHP_HIS.CompanyId
			   ,[EAction].[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeeAction  [EAction] 
	INNER JOIN UserInformation ui on [EAction].UserInformationId = ui.UserInformationId
	INNER JOIN EmploymentHistory EHP_HIS on EHP_HIS.EmploymentHistoryId = (Select top 1 EmploymentHistoryId from EmploymentHistory empHistory where empHistory.UserInformationId=[EAction].UserInformationId order by EmploymentHistoryId desc)
	INNER JOIN EmployeeNotification d on d.EmployeeNotificationTypeId=6
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.EmployeeActionId = [EAction].EmployeeActionId AND nl.IsNotificationAsExpired=1 And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=[EAction].ActionExpiryDate AND (CAST([EAction].ActionExpiryDate as date) <= CAST(@CreateLogDate as date))  And nl.NotificationLogId is null --New only
	AND (d.CompanyId=EHP_HIS.CompanyId Or d.CompanyId is NULL) And ui.EmployeeStatusId=1
	SET  @RowCount = @RowCount + @@ROWCOUNT


	--Employee Benefit History Notification=10
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[EmploymentId]
			   ,[EmployeePerformanceId]
			   ,[EmployeeTrainingId]
			   ,[EmployeeHealthInsuranceId]
			   ,[EmployeeDentalInsuranceId]
			   ,[EmployeeActionId]
			   ,[EmployeeBenefitHistoryId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[IsNotificationAsExpired]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	   @NotificationScheduleDetailId AS [NotificationScheduleDetailId]
			   ,NULL AS [EmployeeDocumentId]
			   ,NULL AS [EmployeeCredentialId]
			   ,NULL AS [EmployeeCustomFieldId]
			   ,NULL AS [EmploymentId]
			   ,NULL AS EmployeePerformanceId
			   ,NULL AS EmployeeTrainingId
			   ,NULL AS EmployeeHealthInsuranceId
			   ,NULL AS EmployeeDentalInsuranceId
			   ,NULL AS EmployeeActionId
			   ,EBenefit.EmployeeBenefitHistoryId
			   ,10 AS [NotificationTypeId]
			   ,1 AS [DeliveryStatusId]
			   ,1 AS [IsNotificationAsExpired]
			   ,EHP_HIS.CompanyId
			   ,EBenefit.[ClientId]
			   , @CreatedBy AS [CreatedBy]
			   ,GETDATE() AS  [CreatedDate]
			   ,1 AS [DataEntryStatus]
			   ,NULL AS [ModifiedBy]
			   ,NULL AS[ModifiedDate]
	FROM
	EmployeeBenefitHistory  EBenefit 
	INNER JOIN UserInformation ui on EBenefit.UserInformationId = ui.UserInformationId
	INNER JOIN EmploymentHistory EHP_HIS ON EHP_HIS.EmploymentHistoryId = (SELECT TOP 1 EmploymentHistoryId FROM EmploymentHistory empHistory WHERE empHistory.UserInformationId=EBenefit.UserInformationId ORDER BY EmploymentHistoryId DESC)
	INNER JOIN EmployeeNotification d ON d.EmployeeNotificationTypeId=7
	LEFT OUTER JOIN dbo.NotificationLog nl ON nl.EmployeeBenefitHistoryId = EBenefit.EmployeeBenefitHistoryId AND nl.IsNotificationAsExpired=1 AND nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=EBenefit.ExpiryDate AND (CAST(EBenefit.ExpiryDate AS DATE) <= CAST(@CreateLogDate AS date))  And nl.NotificationLogId is null --New only
	AND (d.CompanyId=EHP_HIS.CompanyId Or d.CompanyId is NULL) And ui.EmployeeStatusId=1
	SET  @RowCount = @RowCount + @@ROWCOUNT

	END TRY
	BEGIN CATCH
		 SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 
		   SET @RowCount = 0
	END CATCH
	RETURN @RowCount
END
GO
