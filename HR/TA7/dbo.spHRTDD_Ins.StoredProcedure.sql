USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spHRTDD_Ins]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spHRTDD_Ins]
(
	@e_id int,
	@e_idno nvarchar(14),
	@e_name nvarchar(30),
	@DTPunchDate smalldatetime,
	@sType nvarchar(30),
	@pCode nvarchar(10),
	@HoursWorked float,
	@nWeekID bigint,
	@nIsTransAbsent int,
	@nPunchDateDayOfWeek int,
	@nHRAttendanceCat int,
	@nHRProcessedCode int,
	@nHRReportCode int,
	@sMasterTrans nvarchar(50),
	@nCompanyID int,
	@sCompanyName nvarchar(50),
	@nDeptID int,
	@sDeptName nvarchar(50),
	@nJobTitleID int,
	@sJobTitleName nvarchar(50),
	@nEmployeeTypeID int,
	@sEmployeeTypeName nvarchar(50),
	@nAttendanceRevision int,
	@nTardinessRevision int
)
AS
	SET NOCOUNT OFF;
INSERT INTO tHLTransDailyDetail(e_id, e_idno, e_name, DTPunchDate, sType, pCode, HoursWorked, nWeekID, nIsTransAbsent, nPunchDateDayOfWeek, nHRAttendanceCat, nHRProcessedCode, nHRReportCode, sMasterTrans, nCompanyID, sCompanyName, nDeptID, sDeptName, nJobTitleID, sJobTitleName, nEmployeeTypeID, sEmployeeTypeName, nAttendanceRevision, nTardinessRevision) VALUES (@e_id, @e_idno, @e_name, @DTPunchDate, @sType, @pCode, @HoursWorked, @nWeekID, @nIsTransAbsent, @nPunchDateDayOfWeek, @nHRAttendanceCat, @nHRProcessedCode, @nHRReportCode, @sMasterTrans, @nCompanyID, @sCompanyName, @nDeptID, @sDeptName, @nJobTitleID, @sJobTitleName, @nEmployeeTypeID, @sEmployeeTypeName, @nAttendanceRevision, @nTardinessRevision);
	SELECT tppID, e_id, e_idno, e_name, DTPunchDate, sType, pCode, HoursWorked, nWeekID, nIsTransAbsent, nPunchDateDayOfWeek, nHRAttendanceCat, nHRProcessedCode, nHRReportCode, sMasterTrans, nCompanyID, sCompanyName, nDeptID, sDeptName, nJobTitleID, sJobTitleName, nEmployeeTypeID, sEmployeeTypeName, nAttendanceRevision, nTardinessRevision FROM tHLTransDailyDetail WHERE (tppID = @@IDENTITY)
GO
