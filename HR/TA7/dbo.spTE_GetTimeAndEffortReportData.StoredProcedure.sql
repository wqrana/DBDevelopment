USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spTE_GetTimeAndEffortReportData]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---------------Modification History------------------
-- Author:		Waqar Q
-- Creation date: 4/1/2024
-- Description:	to get the Time and Effort report data to show in cross tab report
-- =============================================
CREATE PROCEDURE [dbo].[spTE_GetTimeAndEffortReportData]
	
	@TAESignIds nvarchar(max)=''
	
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT taeMain.[intTAESignID] as TAEId,
			taeMain.[intUserID] as UserId,
			taeMain.[strUserName] as UserName,
			[intMonth] as [Month],
			[intYear] as [Year],
			IsNull([bitSupervisorSigned],0) as IsSupervisorApproved,
			IIF(IsNull([bitSupervisorSigned],0)=0,'',[strSupervisorEntry]) as strSupervisorEntry,
			IIF(IsNull([bitSupervisorSigned],0)=0,null,[dtSupervisorDateTime]) as dtSupervisorDateTime,
			IsNull([bitEmployeeSigned],0) as IsEmployeeApproved,
			IIF(IsNull([bitEmployeeSigned],0)=0,'',[strEmployeeEntry]) as strEmployeeEntry,
			IIF(IsNull([bitEmployeeSigned],0)=0,null,[dtEmployeeDateTime]) as dtEmployeeDateTime,
			[dtPunchDate] as PunchDate,
			[strCompensationName] as CompensationName,
			[decHours] as EffortHours
	FROM tblTAESignature taeMain
	INNER JOIN tblTAEDetail taeDetail on taeMain.intTAESignID = taeDetail.intTAESignID
	INNER JOIN [dbo].[fn_StringSplit](@TAESignIds,',') as selectedIds on selectedIds.Item = taeDetail.intTAESignID
		
	ORDER BY taeMain.[intUserID],[dtPunchDate],[strCompensationName]
END
GO
