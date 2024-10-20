USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetEmployeeAccrualBalances]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_GetEmployeeAccrualBalances] 
	-- Add the parameters for the stored procedure here
	@userId int

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @CurrentAccrualBalanceList TABLE
(
      AccrualTypeId int,
	  BalanceStartDate datetime 
)

	Insert Into @CurrentAccrualBalanceList
	Select eab.AccrualTypeId, Max(eab.BalanceStartDate)
	From EmployeeAccrualBalance eab
	Where eab.UserInformationId = @userId 
	And eab.DataEntryStatus =1
	Group By eab.AccrualTypeId

	Select 
	@userId As UserInformationId,
	EmployeeAccrualBalanceId,
	BalanceStartDate,
	AccrualTypeId,
	AccrualTypeName,
	AccruedHours,
	IsCurrent
	From(

	Select currentBalance.EmployeeAccrualBalanceId,
			currentBalance.BalanceStartDate,
			currentBalance.AccrualTypeId,
			accType.AccrualTypeName,
			currentBalance.AccruedHours,
			1 As IsCurrent
	From EmployeeAccrualBalance currentBalance
	Inner Join AccrualType accType On currentBalance.AccrualTypeId = accType.AccrualTypeId	
	Inner Join @CurrentAccrualBalanceList currBalList On currBalList.AccrualTypeId = currentBalance.AccrualTypeId 
												And currBalList.BalanceStartDate = currentBalance.BalanceStartDate
    where currentBalance.UserInformationId = @userId
	And currentBalance.DataEntryStatus=1
	Union

	Select historyBalance.EmployeeAccrualBalanceId,
			historyBalance.BalanceStartDate,
			historyBalance.AccrualTypeId,
			accType.AccrualTypeName,
			historyBalance.AccruedHours,
			0 As IsCurrent
	From EmployeeAccrualBalance historyBalance
	Inner Join AccrualType accType On historyBalance.AccrualTypeId = accType.AccrualTypeId	
	Inner Join @CurrentAccrualBalanceList currBalList On currBalList.AccrualTypeId = historyBalance.AccrualTypeId 
												And currBalList.BalanceStartDate <> historyBalance.BalanceStartDate
    where historyBalance.UserInformationId = @userId
	And historyBalance.DataEntryStatus=1
  ) EmployeeAccrualBalanceData
  Order By BalanceStartDate desc

END
GO
