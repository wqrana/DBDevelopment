USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_ApplicantInformation]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ApplicantInformation] 
	-- Add the parameters for the stored procedure here

	@applicantName nvarchar(250) = '',
	@positionId int = 0,
	@applicantStatusId int = 0,
	@locationId int = 0,
	@applicantQAQuery nvarchar(max) = '',
	@applicantQACriteriaCount int = 0,
	@clientId int,
	@companyId int
	
AS
BEGIN
DECLARE @ApplicantInterviewQuestionCheck TABLE
(
      ApplicantInformationId int,
	  QuestionAnswerCount int 
)
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	if @applicantQAQuery<>''
	begin
	Insert Into @ApplicantInterviewQuestionCheck
	execute  sp_executesql @applicantQAQuery
	end
	
		 
	Select distinct applicantInfo.*,
	cmp.CompanyName,	
	appStatus.ApplicantStatusName,
	appStatus.UseAsHire,
	CelNumber,
	PersonalEmail,
	aApp.PositionId as PositionId,
	apos.PositionName,
	(Select STRING_AGG(locInner.LocationName, ', ') 
		From ApplicantApplicationLocation aAppInner
		Inner Join Location locInner on aAppInner.LocationId = locInner.LocationId
		where aAppInner.ApplicantApplicationId = aApp.ApplicantApplicationId
	) as LocationName
	From ApplicantInformation applicantInfo
	Left Join ApplicantContactInformation applicantCntInfo On applicantCntInfo.ApplicantInformationId = applicantInfo.ApplicantInformationId
	Left Join ApplicantApplication aApp On aApp.ApplicantInformationId = applicantInfo.ApplicantInformationId
	Left Join Company cmp On applicantInfo.CompanyID = cmp.CompanyId		
	Left Join ApplicantStatus appStatus On applicantInfo.ApplicantStatusId = appStatus.ApplicantStatusId
	Left Join Gender gnd ON gnd.GenderId = applicantInfo.GenderId
	Left Join Position apos On aApp.PositionId = apos.PositionId
	Left Join ApplicantApplicationLocation  aApploc on aApploc.ApplicantApplicationId = aApp.ApplicantApplicationId
	Left Join @ApplicantInterviewQuestionCheck aiqc on aiqc.ApplicantInformationId = applicantInfo.ApplicantInformationId
	WHERE  applicantInfo.ShortFullName like '%'+ @applicantName + '%'
	AND IsNull(aApp.PositionId,0)	= IIF(@positionId = 0,IsNull(aApp.PositionId,0),@positionId)
	AND IsNull(aApploc.LocationId,0)		= IIF(@locationId = 0,IsNull(aApploc.LocationId,0),@locationId)
	AND applicantInfo.ApplicantStatusId		= IIF(@applicantStatusId = 0,applicantInfo.ApplicantStatusId,@applicantStatusId)
	AND applicantInfo.ApplicantStatusId		= IIF(@applicantStatusId = 0,applicantInfo.ApplicantStatusId,@applicantStatusId)

	AND	(@applicantQACriteriaCount =0 OR aiqc.QuestionAnswerCount = @applicantQACriteriaCount)													
	AND applicantInfo.clientid =  @clientId
	AND applicantInfo.companyid = @companyId
	AND applicantInfo.dataentrystatus = 1
END
GO
