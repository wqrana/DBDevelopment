USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spHRTDD_Del]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spHRTDD_Del]
(
	@Original_tppID int,
	@Original_DTPunchDate smalldatetime,
	@Original_HoursWorked float,
	@Original_e_id int,
	@Original_e_idno nvarchar(14),
	@Original_e_name nvarchar(30),
	@Original_nAttendanceRevision int,
	@Original_nCompanyID int,
	@Original_nDeptID int,
	@Original_nEmployeeTypeID int,
	@Original_nHRAttendanceCat int,
	@Original_nHRProcessedCode int,
	@Original_nHRReportCode int,
	@Original_nIsTransAbsent int,
	@Original_nJobTitleID int,
	@Original_nPunchDateDayOfWeek int,
	@Original_nTardinessRevision int,
	@Original_nWeekID bigint,
	@Original_pCode nvarchar(10),
	@Original_sCompanyName nvarchar(50),
	@Original_sDeptName nvarchar(50),
	@Original_sEmployeeTypeName nvarchar(50),
	@Original_sJobTitleName nvarchar(50),
	@Original_sMasterTrans nvarchar(50),
	@Original_sType nvarchar(30)
)
AS
	SET NOCOUNT OFF;
DELETE FROM tHLTransDailyDetail WHERE (tppID = @Original_tppID) AND (DTPunchDate = @Original_DTPunchDate OR @Original_DTPunchDate IS NULL AND DTPunchDate IS NULL) AND (HoursWorked = @Original_HoursWorked OR @Original_HoursWorked IS NULL AND HoursWorked IS NULL) AND (e_id = @Original_e_id OR @Original_e_id IS NULL AND e_id IS NULL) AND (e_idno = @Original_e_idno OR @Original_e_idno IS NULL AND e_idno IS NULL) AND (e_name = @Original_e_name OR @Original_e_name IS NULL AND e_name IS NULL) AND (nAttendanceRevision = @Original_nAttendanceRevision OR @Original_nAttendanceRevision IS NULL AND nAttendanceRevision IS NULL) AND (nCompanyID = @Original_nCompanyID OR @Original_nCompanyID IS NULL AND nCompanyID IS NULL) AND (nDeptID = @Original_nDeptID OR @Original_nDeptID IS NULL AND nDeptID IS NULL) AND (nEmployeeTypeID = @Original_nEmployeeTypeID OR @Original_nEmployeeTypeID IS NULL AND nEmployeeTypeID IS NULL) AND (nHRAttendanceCat = @Original_nHRAttendanceCat OR @Original_nHRAttendanceCat IS NULL AND nHRAttendanceCat IS NULL) AND (nHRProcessedCode = @Original_nHRProcessedCode OR @Original_nHRProcessedCode IS NULL AND nHRProcessedCode IS NULL) AND (nHRReportCode = @Original_nHRReportCode OR @Original_nHRReportCode IS NULL AND nHRReportCode IS NULL) AND (nIsTransAbsent = @Original_nIsTransAbsent OR @Original_nIsTransAbsent IS NULL AND nIsTransAbsent IS NULL) AND (nJobTitleID = @Original_nJobTitleID OR @Original_nJobTitleID IS NULL AND nJobTitleID IS NULL) AND (nPunchDateDayOfWeek = @Original_nPunchDateDayOfWeek OR @Original_nPunchDateDayOfWeek IS NULL AND nPunchDateDayOfWeek IS NULL) AND (nTardinessRevision = @Original_nTardinessRevision OR @Original_nTardinessRevision IS NULL AND nTardinessRevision IS NULL) AND (nWeekID = @Original_nWeekID OR @Original_nWeekID IS NULL AND nWeekID IS NULL) AND (pCode = @Original_pCode OR @Original_pCode IS NULL AND pCode IS NULL) AND (sCompanyName = @Original_sCompanyName OR @Original_sCompanyName IS NULL AND sCompanyName IS NULL) AND (sDeptName = @Original_sDeptName OR @Original_sDeptName IS NULL AND sDeptName IS NULL) AND (sEmployeeTypeName = @Original_sEmployeeTypeName OR @Original_sEmployeeTypeName IS NULL AND sEmployeeTypeName IS NULL) AND (sJobTitleName = @Original_sJobTitleName OR @Original_sJobTitleName IS NULL AND sJobTitleName IS NULL) AND (sMasterTrans = @Original_sMasterTrans OR @Original_sMasterTrans IS NULL AND sMasterTrans IS NULL) AND (sType = @Original_sType OR @Original_sType IS NULL AND sType IS NULL)
GO
