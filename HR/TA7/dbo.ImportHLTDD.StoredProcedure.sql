USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[ImportHLTDD]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[ImportHLTDD] 
@nImportDate as int
AS
DECLARE @ERROR1 as int
DECLARE @ERROR2 as int

BEGIN TRAN 

INSERT INTO tHLTransDailyDetail 
SELECT tPunchDateDetail.e_id, vewHoursLost_AllEmployees.idno AS e_idno, vewHoursLost_AllEmployees.name AS e_name, 
tPunchDateDetail.DTPunchDate as DTPunchDate, tPunchDateDetail.sType as sType, tPunchDateDetail.sExportCode AS pCode, 
tPunchDateDetail.dblHours AS HoursWorked, tPunchDateDetail.nWeekID, tTransDef.nIsAbsent AS nIsTransAbsent, 0 AS nPunchDateDayOfWeek, 
tTransDef.nAttendaceCategory AS nHRAttendanceCat, @nImportDate as nHRProcessedCode, 0 AS nHRReportCode, tTransDef.sParentCode AS sMasterTrans, 
vewHoursLost_AllEmployees.nCompanyID AS nCompanyID, vewHoursLost_AllEmployees.sCompanyName AS sCompanyName, 
vewHoursLost_AllEmployees.nDeptID AS nDeptID, vewHoursLost_AllEmployees.sDeptName AS sDeptName, 
vewHoursLost_AllEmployees.nJobTitleID AS nJobTitleID, vewHoursLost_AllEmployees.sJobTitleName AS sJobTitleName, 
vewHoursLost_AllEmployees.nEmployeeType AS nEmployeeTypeID, vewHoursLost_AllEmployees.sEmployeeTypeName AS sEmployeeTypeName, 
tTransDef.nAttendanceRevision, tTransDef.nTardinessRevision, tUserExtended.sSupervisorID AS nSupervisorID, tUserExtended.sSupervisorName, 
0 as nAttendanceProcessed,  0 as nAttendanceReportCode, 0 as nTardinessProcessed, 0 as nTardinessReportCode
FROM tPunchDateDetail INNER JOIN tPunchDate ON tPunchDateDetail.e_id = tPunchDate.e_id AND tPunchDateDetail.DTPunchDate = tPunchDate.DTPunchDate 
INNER JOIN vewHoursLost_AllEmployees ON tPunchDateDetail.e_id = vewHoursLost_AllEmployees.id INNER JOIN tTransDef ON tPunchDateDetail.sType = tTransDef.Name 
LEFT OUTER JOIN tUserExtended ON tPunchDateDetail.e_id = tUserExtended.nUserID WHERE (tPunchDate.bLocked = 1) AND (tPunchDateDetail.nHRProcessedCode = 0)

SET @ERROR1 = @@ERROR

--UPDATE tPunchDateDetail SET tPunchDateDetail.nHRProcessedCode = @nImportDate FROM tPunchDateDetail INNER JOIN tPunchDate ON tPunchDateDetail.e_id = tPunchDate.e_id AND tPunchDateDetail.DTPunchDate = tPunchDate.DTPunchDate WHERE (tPunchDate.bLocked = 1) AND (tPunchDateDetail.nHRProcessedCode = 0)
UPDATE tPunchDateDetail SET tPunchDateDetail.nHRProcessedCode = @nImportDate 
FROM tPunchDateDetail INNER JOIN tPunchDate ON tPunchDateDetail.e_id = tPunchDate.e_id AND tPunchDateDetail.DTPunchDate = tPunchDate.DTPunchDate 
INNER JOIN vewHoursLost_AllEmployees ON tPunchDateDetail.e_id = vewHoursLost_AllEmployees.id INNER JOIN tTransDef ON tPunchDateDetail.sType = tTransDef.Name 
LEFT OUTER JOIN tUserExtended ON tPunchDateDetail.e_id = tUserExtended.nUserID WHERE (tPunchDate.bLocked = 1) AND (tPunchDateDetail.nHRProcessedCode = 0)

--FROM tPunchDateDetail INNER JOIN tPunchDate ON 
--tPunchDateDetail.e_id = tPunchDate.e_id AND tPunchDateDetail.DTPunchDate = tPunchDate.DTPunchDate INNER JOIN vewHoursLost_AllEmployees 
--ON tPunchDateDetail.e_id = vewHoursLost_AllEmployees.id  WHERE (tPunchDate.bLocked = 1) AND (tPunchDateDetail.nHRProcessedCode = 0)

SET @ERROR2 =@@ERROR

IF @ERROR1 != 0 OR @ERROR2 !=0
BEGIN
	ROLLBACK TRAN 
END
ELSE
BEGIN
	COMMIT TRAN 
END
GO
