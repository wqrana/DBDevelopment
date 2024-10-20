USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spSS_GetTimeAndEffortDataForWeb]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------Modification History------------------
-- Author:		Waqar Q
-- Creation date: 4/1/2024
-- Description:	to get the Time and Effort data to show in web

-- =============================================
CREATE PROCEDURE [dbo].[spSS_GetTimeAndEffortDataForWeb]
	@userId int = 0,
	@userName nvarchar(max)='',
	@year int=0,
	@month int=0 
	--@deptId int=0,
	--@subDepId int=0,
	--@employeeTypeId int=0,	
	--@companyId int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT taeMain.[intTAESignID] as TAEId,
			taeMain.[intUserID] as UserId,
			taeMain.[strUserName] as UserName,
			[intMonth] as [Month],
			[intYear] as [Year],
			IsNull([bitSupervisorSigned],0) as IsSupervisorApproved,
			IsNull([bitEmployeeSigned],0) as IsEmployeeApproved,
			[dtPunchDate] as PunchDate,
			[strCompensationName] as CompensationName,
			[decHours] as EffortHours
	FROM tblTAESignature taeMain
	INNER JOIN tblTAEDetail taeDetail on taeMain.intTAESignID = taeDetail.intTAESignID
	WHERE (taeMain.intYear=@year AND taeMain.intMonth = @month)
	--AND intCompanyID = @companyId
	AND taeMain.strUserName like '%'+@userName+'%'
	 --based on selected Users
	AND  taeMain.intUserID = IIF(@userId=0, taeMain.intUserID,@userId)
	--AND intDepartmentID = IIF(@deptId=0, intDepartmentID,@deptId)
	--AND IsNull(intSubdepartmentID,0) =  IIF(@subDepId=0, IsNull(intSubdepartmentID,0),@deptId)
	--AND intEmployeeType = IIF(@employeeTypeId=0, intEmployeeType,@employeeTypeId)
	ORDER BY taeMain.[intUserID],[dtPunchDate],[strCompensationName]
END
GO
