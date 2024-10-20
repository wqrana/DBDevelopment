USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnCompensationBalanceReport_Extended]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 7/19/2021
-- Description:	Returns the User Compensation Balances For V1 Or V2
-- Used in TimeAide_7 Reports:
--		Compensation Balances Report
--		Licenses Balanaces Money Report
-- =============================================
CREATE FUNCTION [dbo].[fnCompensationBalanceReport_Extended]  (        	  
   @UserID as int,  	  
   @AccrualType as nvarchar(50),  	  
   @StartDate as datetime,  	  
   @EndDate as datetime 
   )      
   RETURNS TABLE     
   AS RETURN       
   (    
   -- Compensation V2
   	select id as 'User ID',    
	idno as 'ID Number',    
	name as 'User Name',    
	@AccrualType as 'Accrual Type',    
	@StartDate as 'Start Date',    
	@EndDate as 'End Date',       
	[dbo].[fnComp_StartOfDayBalance](   id  ,@AccrualType,@StartDate  ) as 'Start Balance',
	[dbo].[fnComp_DayAccruedHours](id, @AccrualType,dateadd(day,1,@StartDate), @EndDate) as 'Accrued Hours',  
	[dbo].[fnComp_UsedHours](id, @AccrualType, @StartDate, @EndDate) as 'Used Hours',
	[dbo].[fnComp_EndOfDayBalance](id  ,@AccrualType,   @EndDate) as 'End Balance',           	
	[dbo].[fnCompensationRateForPayroll] (id,@AccrualType,@EndDate)  as 'Compensation Rate' ,      	
	[dbo].[fnComp_EndOfDayBalance](id  ,@AccrualType,   @EndDate)  *   [dbo].[fnCompensationRateForPayroll] (id,@AccrualType,@EndDate)  as 'Money Balance',   	
	nCompanyID  ,sCompanyName, nDeptID , sDeptName, nJobTitleID, sJobTitleName, nEmployeeType, sEmployeeTypeName, nStatus       
	from viewUser_Reports     where (id=@UserID or @UserID = 0)  and ISNULL((SELECT nConfigParam  FROM tSoftwareConfiguration WHERE nConfigID = 1055),0) = 1
	UNION ALL
   -- Compensation V1
	select id as 'User ID', 
	idno as 'ID Number', 
	name as 'User Name', 
	@AccrualType as 'Accrual Type', 
	@StartDate as 'Start Date', @EndDate as 'End Date',    
	[dbo].[fnCompensationStartOfDayBalance](   @StartDate  ,id  ,@AccrualType) as 'Start Balance',      
	[dbo].[fnCompensationAccruedHours] (@StartDate, @EndDate,id,@AccrualType) as 'Accrued Hours',   
	[dbo].[fnCompensationUsedHours] (@StartDate, @EndDate,id,@AccrualType) as 'Used Hours',   
	[dbo].[fnCompensationEndOfDayBalance](   @EndDate  ,id  ,@AccrualType) as 'End Balance',      
	[dbo].[fnCompensationRateForPayroll] (id,@AccrualType,@EndDate)  as 'Compensation Rate' ,     
	[dbo].[fnComp_StartOfDayBalance](   id  ,@AccrualType,@StartDate  ) *  [dbo].[fnCompensationRate] (id,@AccrualType)  as 'Money Balance',   	
	nCompanyID  ,sCompanyName, nDeptID , sDeptName, nJobTitleID, sJobTitleName, nEmployeeType, sEmployeeTypeName, nStatus    
	from viewUser_Reports  where (id=@UserID or @UserID = 0) and ISNULL((SELECT nConfigParam  FROM tSoftwareConfiguration WHERE nConfigID = 1055),0) = 0
    )   
GO
