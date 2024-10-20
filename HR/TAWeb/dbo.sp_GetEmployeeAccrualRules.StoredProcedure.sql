USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetEmployeeAccrualRules]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetEmployeeAccrualRules] 
	-- Add the parameters for the stored procedure here
	@userId int

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @CurrentAccrualList TABLE
(
      AccrualTypeId int,
	  StartOfRuleDate datetime 
)

	Insert Into @CurrentAccrualList
	Select ear.AccrualTypeId, Max(ear.StartOfRuleDate)
	From EmployeeAccrualRule ear
	Where ear.UserInformationId = @userId 
	And ear.DataEntryStatus =1
	Group By ear.AccrualTypeId

	Select 
	@userId As UserInformationId,
	EmployeeAccrualRuleId,
	StartOfRuleDate,
	AccrualTypeId,
	AccrualTypeName,
	AccrualRuleId,
	AccrualRuleName,
	AccrualDailyHours,
	IsCurrent
	From(

	Select currentRule.EmployeeAccrualRuleId,
			currentRule.StartOfRuleDate,
			currentRule.AccrualTypeId,
			accType.AccrualTypeName,
			currentRule.AccrualRuleId,
			accRule.AccrualRuleName,
			currentRule.AccrualDailyHours,
			1 As IsCurrent
	From EmployeeAccrualRule currentRule
	Inner Join AccrualType accType On currentRule.AccrualTypeId = accType.AccrualTypeId
	Inner Join AccrualRule accRule On currentRule.AccrualRuleId = accRule.AccrualRuleId
	Inner Join @CurrentAccrualList currRuleList On currRuleList.AccrualTypeId = currentRule.AccrualTypeId 
												And currRuleList.StartOfRuleDate = currentRule.StartOfRuleDate
    where currentRule.UserInformationId = @userId
	And currentRule.DataEntryStatus =1
	Union

	Select HistoryRule.EmployeeAccrualRuleId,
			HistoryRule.StartOfRuleDate,
			HistoryRule.AccrualTypeId,
			accType.AccrualTypeName,
			HistoryRule.AccrualRuleId,
			accRule.AccrualRuleName,
			HistoryRule.AccrualDailyHours,
			0 As IsCurrent
	From EmployeeAccrualRule HistoryRule
	Inner Join AccrualType accType On HistoryRule.AccrualTypeId = accType.AccrualTypeId
	Inner Join AccrualRule accRule On HistoryRule.AccrualRuleId = accRule.AccrualRuleId
	Inner Join @CurrentAccrualList currRuleList On currRuleList.AccrualTypeId = HistoryRule.AccrualTypeId 
												And currRuleList.StartOfRuleDate <> HistoryRule.StartOfRuleDate
   Where HistoryRule.UserInformationId = @userId
   And HistoryRule.DataEntryStatus=1
  ) EmployeeAccrualRuleData
  Order By StartOfRuleDate desc

END
GO
