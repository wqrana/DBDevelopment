USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateNotificationLog]    Script Date: 10/18/2024 8:30:43 PM ******/
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

CREATE PROCEDURE [dbo].[sp_CreateNotificationLog] 
	-- Add the parameters for the stored procedure here
	@CreateLogDate date,
	@CreatedBy int
AS
BEGIN
	DECLARE @RowCount int = 0
	BEGIN TRY

	Declare @ApplicationConfigurationValue as varchar(20)
	Declare @NotificationLookupStartDate as date
	Select @ApplicationConfigurationValue = [ApplicationConfigurationValue] from ApplicationConfiguration 
	where ApplicationConfigurationName ='NotificationLookupStartDate'

	Select @NotificationLookupStartDate = Cast( @ApplicationConfigurationValue as date) 

	--Select @NotificationLookupStartDate)

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--

    -- DOCUMENTS=1
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
			   ,ed.[EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,NULL as [EmployeeCustomFieldId]
			   ,1 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,ui.[CompanyId]
			   ,ui.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeeDocument ed INNER JOIN UserInformation ui on ed.UserInformationId = ui.UserInformationId
	INNER JOIN Document d on ed.DocumentId = d.DocumentId
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	and nl.EmployeeDocumentId = ed.EmployeeDocumentId
	WHERE @NotificationLookupStartDate<=ed.ExpirationDate AND
	DATEADD(DAY,-nsl.DaysBefore,ed.ExpirationDate) <=@CreateLogDate  and DATEADD(DAY,-nsl.PreviousDaysBefore,ed.ExpirationDate) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null And ui.EmployeeStatusId=1--New only
	SET  @RowCount = @@ROWCOUNT;

	--CREDENTIALS=2
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,ec.EmployeeCredentialId as [EmployeeCredentialId]
			   ,NULL as [EmployeeCustomFieldId]
			   ,2 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,ui.[CompanyId]
			   ,ui.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeeCredential ec INNER JOIN UserInformation ui on ec.UserInformationId = ui.UserInformationId
	INNER JOIN Credential d on ec.CredentialId = d.CredentialId
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	and nl.EmployeeCredentialId = ec.EmployeeCredentialId
	WHERE @NotificationLookupStartDate<=ec.ExpirationDate AND
	DATEADD(DAY,-nsl.DaysBefore,ec.ExpirationDate) <=@CreateLogDate and DATEADD(DAY,-nsl.PreviousDaysBefore,ec.ExpirationDate) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null And ui.EmployeeStatusId=1--New only
	SET  @RowCount = @RowCount + @@ROWCOUNT;

	--CUSTOM FIELDS=3
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,ec.EmployeeCustomFieldId as [EmployeeCustomFieldId]
			   ,3 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,ui.[CompanyId]
			   ,ui.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeeCustomField ec INNER JOIN UserInformation ui on ec.UserInformationId = ui.UserInformationId
	INNER JOIN CustomField d on ec.CustomFieldId = d.CustomFieldId
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	and nl.EmployeeCustomFieldId= ec.EmployeeCustomFieldId
	WHERE @NotificationLookupStartDate<=ec.ExpirationDate AND
	DATEADD(DAY,-nsl.DaysBefore,ec.ExpirationDate) <=@CreateLogDate and DATEADD(DAY,-nsl.PreviousDaysBefore,ec.ExpirationDate) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null And ui.EmployeeStatusId=1--New only
	SET  @RowCount = @RowCount + @@ROWCOUNT

	--Employement - Probation Period Notification=4
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[EmploymentId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,emp.EmploymentId as [EmploymentId]
			   ,4 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,EHP_HIS.CompanyId
			   ,emp.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	Employment EMP 
	INNER JOIN UserInformation ui on EMP.UserInformationId = ui.UserInformationId
	INNER JOIN EmploymentHistory EHP_HIS on EHP_HIS.EmploymentHistoryId = (Select top 1 EmploymentHistoryId from EmploymentHistory empHistory where empHistory.EmploymentId=emp.EmploymentId order by EmploymentHistoryId desc)
	INNER JOIN EmployeeNotification d on d.EmployeeNotificationTypeId=1
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	WHERE EMP.ProbationEndDate is not null And EMP.TerminationDate is null And @NotificationLookupStartDate<=EMP.ProbationEndDate AND
	DATEADD(DAY,-nsl.DaysBefore,EMP.ProbationEndDate) <=@CreateLogDate and DATEADD(DAY,-nsl.PreviousDaysBefore,EMP.ProbationEndDate) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null --New only
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
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,null as [EmploymentId]
			   ,Performance.EmployeePerformanceId as EmployeePerformanceId
			   ,5 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
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
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=Performance.ExpiryDate AND
	DATEADD(DAY,-nsl.DaysBefore,Performance.ExpiryDate) <=@CreateLogDate and DATEADD(DAY,-nsl.PreviousDaysBefore,Performance.ExpiryDate) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null --New only
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
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,null as [EmploymentId]
			   ,null as EmployeePerformanceId
			   ,Training.EmployeeTrainingId
			   ,6 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
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
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=Training.ExpiryDate AND
	DATEADD(DAY,-nsl.DaysBefore,Training.ExpiryDate) <=@CreateLogDate and DATEADD(DAY,-nsl.PreviousDaysBefore,Training.ExpiryDate) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null --New only
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
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,null as [EmploymentId]
			   ,null as EmployeePerformanceId
			   ,null as EmployeeTrainingId
			   ,Insurance.EmployeeHealthInsuranceId
			   ,7 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
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
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=Insurance.InsuranceExpiryDate AND
	DATEADD(DAY,-nsl.DaysBefore,Insurance.InsuranceExpiryDate) <=@CreateLogDate and DATEADD(DAY,-nsl.PreviousDaysBefore,Insurance.InsuranceExpiryDate) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null --New only
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
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
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
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=Dental.InsuranceExpiryDate AND
	DATEADD(DAY,-nsl.DaysBefore,Dental.InsuranceExpiryDate) <=@CreateLogDate and DATEADD(DAY,-nsl.PreviousDaysBefore,Dental.InsuranceExpiryDate) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null --New only
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
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
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
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=[EAction].ActionExpiryDate AND
	DATEADD(DAY,-nsl.DaysBefore,[EAction].ActionExpiryDate) <=@CreateLogDate and DATEADD(DAY,-nsl.PreviousDaysBefore,[EAction].ActionExpiryDate) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null --New only
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
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,null as [EmploymentId]
			   ,null as EmployeePerformanceId
			   ,null as EmployeeTrainingId
			   ,null as EmployeeHealthInsuranceId
			   ,null as EmployeeDentalInsuranceId
			   ,null as EmployeeActionId
			   ,EBenefit.EmployeeBenefitHistoryId
			   ,10 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,(Select top 1 CompanyId from EmploymentHistory empHistory where empHistory.UserInformationId=EBenefit.UserInformationId order by EmploymentHistoryId desc) CompanyId
			   ,EBenefit.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	EmployeeBenefitHistory  EBenefit 
	INNER JOIN UserInformation ui on EBenefit.UserInformationId = ui.UserInformationId
	INNER JOIN EmploymentHistory EHP_HIS on EHP_HIS.EmploymentHistoryId = (Select top 1 EmploymentHistoryId from EmploymentHistory empHistory where empHistory.UserInformationId=EBenefit.UserInformationId order by EmploymentHistoryId desc)
	INNER JOIN EmployeeNotification d on d.EmployeeNotificationTypeId=7
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	WHERE @NotificationLookupStartDate<=EBenefit.ExpiryDate AND
	DATEADD(DAY,-nsl.DaysBefore,EBenefit.ExpiryDate) <=@CreateLogDate and DATEADD(DAY,-nsl.PreviousDaysBefore,EBenefit.ExpiryDate) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null --New only
	AND (d.CompanyId=EHP_HIS.CompanyId Or d.CompanyId is NULL) And ui.EmployeeStatusId=1
	SET  @RowCount = @RowCount + @@ROWCOUNT

	--Select @ApplicationConfigurationValue = [ApplicationConfigurationValue] from ApplicationConfiguration 
	----Employee Action Id Notification=11
	--INSERT INTO [dbo].[NotificationLog]
	--		   (
	--		    [UserInformationActivationId]
	--		   ,[NotificationTypeId]
	--		   ,[DeliveryStatusId]
	--		   ,[CompanyId]
	--		   ,[ClientId]
	--		   ,[CreatedBy]
	--		   ,[CreatedDate]
	--		   ,[DataEntryStatus]
	--		   ,[ModifiedBy]
	--		   ,[ModifiedDate])
	--SELECT	 
	--		   [UIA].[UserInformationActivationId]
	--		   ,20 as [NotificationTypeId]
	--		   ,1 as [DeliveryStatusId]
	--		   ,null
	--		   ,[UIA].[ClientId]
	--		   , @CreatedBy as [CreatedBy]
	--		   ,getdate() as  [CreatedDate]
	--		   ,1 as [DataEntryStatus]
	--		   ,NULL as [ModifiedBy]
	--		   ,NULL as[ModifiedDate]
	--FROM
	--UserInformationActivation  [UIA] 
	--LEFT OUTER JOIN dbo.NotificationLog nl on nl.[UserInformationActivationId] = [UIA].[UserInformationActivationId] And nl.DataEntryStatus=1
	--LEFT OUTER JOIN dbo.ApplicationConfiguration aapConfig on [UIA].[ClientId] =aapConfig.[ClientId] and aapConfig.ApplicationConfigurationName='UserActivationCodeDays'
	--WHERE aapConfig.ApplicationConfigurationValue < DATEDIFF(dd, [UIA].CreatedDate, GetDate()) 

	--Employement - Work Anniversary Notification=12
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[EmploymentId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,emp.EmploymentId as [EmploymentId]
			   ,12 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,EHP_HIS.CompanyId
			   ,emp.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	Employment EMP 
	INNER JOIN UserInformation ui on EMP.UserInformationId = ui.UserInformationId
	INNER JOIN EmploymentHistory EHP_HIS on EHP_HIS.EmploymentHistoryId = (Select top 1 EmploymentHistoryId from EmploymentHistory empHistory where empHistory.EmploymentId=emp.EmploymentId order by EmploymentHistoryId desc)
	INNER JOIN EmployeeNotification d on d.EmployeeNotificationTypeId=9
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	WHERE IsNull(EMP.EffectiveHireDate,EMP.OriginalHireDate) is not null And EMP.TerminationDate is null And @NotificationLookupStartDate<=IsNull(DATEFROMPARTS(YEAR(GETDATE()),MONTH(EMP.EffectiveHireDate),DAY(EMP.EffectiveHireDate)),DATEFROMPARTS(YEAR(GETDATE()),MONTH(EMP.OriginalHireDate),DAY(EMP.OriginalHireDate))) AND
	DATEADD(DAY,-nsl.DaysBefore,IsNull(DATEFROMPARTS(YEAR(GETDATE()),MONTH(EMP.EffectiveHireDate),DAY(EMP.EffectiveHireDate)),DATEFROMPARTS(YEAR(GETDATE()),MONTH(EMP.OriginalHireDate),DAY(EMP.OriginalHireDate)))) <=@CreateLogDate and DATEADD(DAY,-nsl.PreviousDaysBefore,IsNull(DATEFROMPARTS(YEAR(GETDATE()),MONTH(EMP.EffectiveHireDate),DAY(EMP.EffectiveHireDate)),DATEFROMPARTS(YEAR(GETDATE()),MONTH(EMP.OriginalHireDate),DAY(EMP.OriginalHireDate)))) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null --New only
	AND (d.CompanyId=EHP_HIS.CompanyId Or d.CompanyId is NULL) And ui.EmployeeStatusId=1
	SET  @RowCount = @RowCount + @@ROWCOUNT

	--Employement - Birthday Notification=11
	INSERT INTO [dbo].[NotificationLog]
			   ([NotificationScheduleDetailId]
			   ,[EmployeeDocumentId]
			   ,[EmployeeCredentialId]
			   ,[EmployeeCustomFieldId]
			   ,[ReferredUserInformationId]
			   ,[NotificationTypeId]
			   ,[DeliveryStatusId]
			   ,[CompanyId]
			   ,[ClientId]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[DataEntryStatus]
			   ,[ModifiedBy]
			   ,[ModifiedDate])
	SELECT	 nsl.[NotificationScheduleDetailId]
			   ,NULL as [EmployeeDocumentId]
			   ,NULL as [EmployeeCredentialId]
			   ,null as [EmployeeCustomFieldId]
			   ,emp.UserInformationId as [UserInformationId]
			   ,11 as [NotificationTypeId]
			   ,1 as [DeliveryStatusId]
			   ,EHP_HIS.CompanyId
			   ,emp.[ClientId]
			   , @CreatedBy as [CreatedBy]
			   ,getdate() as  [CreatedDate]
			   ,1 as [DataEntryStatus]
			   ,NULL as [ModifiedBy]
			   ,NULL as[ModifiedDate]
	FROM
	UserInformation EMP 
	INNER JOIN EmploymentHistory EHP_HIS on EHP_HIS.EmploymentHistoryId = (Select top 1 EmploymentHistoryId from EmploymentHistory empHistory where empHistory.UserInformationId=emp.UserInformationId order by EmploymentHistoryId desc)
	INNER JOIN EmployeeNotification d on d.EmployeeNotificationTypeId=8
	INNER JOIN dbo.NotificationSchedule ns on d.NotificationScheduleId = ns.NotificationScheduleId
	INNER JOIN dbo.vNotificationScheduleDetail nsl on ns.NotificationScheduleId = nsl.NotificationScheduleId
	LEFT OUTER JOIN dbo.NotificationLog nl on nl.NotificationScheduleDetailId = nsl.NotificationScheduleDetailId And nl.DataEntryStatus=1
	WHERE EMP.BirthDate is not null And @NotificationLookupStartDate<= DATEFROMPARTS(YEAR(GETDATE()),MONTH(EMP.BirthDate),DAY(EMP.BirthDate)) AND
	DATEADD(DAY,-nsl.DaysBefore,DATEFROMPARTS(YEAR(GETDATE()), MONTH(EMP.BirthDate) , DAY(EMP.BirthDate) )) <=@CreateLogDate and DATEADD(DAY,-nsl.PreviousDaysBefore,DATEFROMPARTS( YEAR(GETDATE()),MONTH(EMP.BirthDate),DAY(EMP.BirthDate))) >=@CreateLogDate-- Date selection
	AND nl.NotificationLogId is null --New only
	AND (d.CompanyId=EHP_HIS.CompanyId Or d.CompanyId is NULL) And EMP.EmployeeStatusId=1
	SET  @RowCount = @RowCount + @@ROWCOUNT

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
