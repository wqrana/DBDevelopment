USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spED_WFNUserVAAndSABalances]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <6/4/2024>
-- Description:	<To extract data for WFN UserVAand SA Balances excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_WFNUserVAAndSABalances]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @YSDate datetime = Cast(concat('01/01/',year(getdate())) as datetime)
Declare @YTDate datetime = Getdate()

Drop table if exists #tempSAVABalances
Select nUserID,sAccrualType,[Used Hours],[End Balance] 
Into #tempSAVABalances
From tUserCompensationRules ucr
Cross Apply	[dbo].[fnCompensationBalanceReport_Extended]  (        	  
			   ucr.nUserID,  	  
			   ucr.sAccrualType,  	  
			   @YSDate,  	  
			   @YTDate)
 where sAccrualType in('VA','SA')
SELECT 
	userInfo.strCompanyName as [Company Code],	
	userInfo.[name] as [Employee Name],
	userInfo.intUserId as [Position ID],
	-- VA
	1 as [Allowed/Taken Position Number],
	'NA' as [Allowed Adjustment Amt],
	VABal.[Used Hours] as [Taken Adjustment Amt],
	VABal.[End Balance] as [VA Accrued Hours],
	CONVERT(Varchar,@YTDate,101) as [VA Acrrued Date],
	-- SA
	2 as [Allowed/Taken Position Number],
	'NA' as [Allowed Adjustment Amt],
	SABal.[Used Hours] as [Taken Adjustment Amt],
	SABal.[End Balance] as [SA Accrued Hours],
	CONVERT(Varchar,@YTDate,101) as [SA Acrrued Date]

FROM viewPay_UserRecord userInfo
INNER JOIN #tempSAVABalances VABal On VABal.nUserID = userInfo.intUserID And VABal.sAccrualType='VA'
INNER JOIN #tempSAVABalances SABal On SABal.nUserID = userInfo.intUserID And SABal.sAccrualType='SA'
Order by userInfo.strCompanyName, userInfo.intUserID
 
END
GO
