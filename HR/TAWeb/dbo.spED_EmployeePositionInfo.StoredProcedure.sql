USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[spED_EmployeePositionInfo]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<WaqarQ>
-- Create date: <5/23/2024>
-- Description:	<To extract data for Masterfile excel file>
-- =============================================
CREATE PROCEDURE [dbo].[spED_EmployeePositionInfo]
@ClientId int = 2
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
  SELECT 
  cmp.CompanyName as [Company Name],
  '' as [Company Federal ID],
  userInfo.EmployeeId as [File #/Employee ID],
  userInfo.ShortFullName as [Employee Full Name],
   case ISNUMERIC(dbo.fn_CLREnDecriptSSN(IsNull(userInfo.SSNEncrypted,'0'),'D'))
  When 1 then 
  format(CAST(dbo.fn_CLREnDecriptSSN(IsNull(userInfo.SSNEncrypted,'0'),'D')as int),'###-##-####') 
  else
  dbo.fn_CLREnDecriptSSN(IsNull(userInfo.SSNEncrypted,'0'),'D')
  end as [Social Security Number],
  Convert(nvarchar,employmentHistory.StartDate,101) as [Position Start Date],
  employmentHistory.EmploymentTypeName as [Worker Category/Employee Type],
  employmentHistory.PositionName [Job Title],
  employmentHistory.DepartmentName [Home Department],
  '' as [Home Cost Number],
  '' as [Location Code],
  '' as [NAICS Workers Comp Code],
  '' as [Job Class],
  '' as [Job Function],
  cat.EEOCategoryName  as [EEOC Job Code],
  '' as [Business Unit],
  '' as [Shift],
  '' as [FTE],
  '' as [Hours Period],
  '' as [Scheduled Hours],
  '' as [Union Code],
  '' as [Union Local],
  '' as [Worked In Country],
  'EMP' as [Officer/Owner Indicator],
  '' as [EEO Establishment],
  '' as [Benefits Eligibility Class]


  FROM vw_UserInformation userInfo
  INNER JOIN Company cmp ON cmp.CompanyId = userInfo.CompanyID
  LEFT JOIN vw_rpt_EmployeeEmploymentHistory employmentHistory ON userInfo.EmploymentHistoryId = employmentHistory.EmploymentHistoryId
  LEFT JOIN Position pos ON pos.PositionId = employmentHistory.PositionId
  LEFT JOIN EEOCategory cat on cat.EEOCategoryId = pos.DefaultEEOCategoryId
  WHERE userInfo.ClientId=@ClientId
  Order by cmp.CompanyName, userInfo.EmployeeId
END
GO
