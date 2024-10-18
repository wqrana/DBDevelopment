USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spHRTDD_Sel]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spHRTDD_Sel]
AS
	SET NOCOUNT ON;
SELECT tppID, e_id, e_idno, e_name, DTPunchDate, sType, pCode, HoursWorked, nWeekID, nIsTransAbsent, nPunchDateDayOfWeek, nHRAttendanceCat, nHRProcessedCode, nHRReportCode, sMasterTrans, nCompanyID, sCompanyName, nDeptID, sDeptName, nJobTitleID, sJobTitleName, nEmployeeTypeID, sEmployeeTypeName, nAttendanceRevision, nTardinessRevision FROM tHLTransDailyDetail
GO
