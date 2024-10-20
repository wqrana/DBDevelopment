USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[daHLAttendanceLetterGeneration_Upd]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[daHLAttendanceLetterGeneration_Upd]
(
	@nWarningLetterID bigint,
	@dStartDate datetime,
	@dEndDate datetime,
	@dProcessDate datetime,
	@nSupervisorrID int,
	@sSupevisorrName nvarchar(50),
	@Original_ID int,
	@Original_dEndDate datetime,
	@Original_dProcessDate datetime,
	@Original_dStartDate datetime,
	@Original_nSupervisorrID int,
	@Original_nWarningLetterID bigint,
	@Original_sSupevisorrName nvarchar(50),
	@ID int
)
AS
	SET NOCOUNT OFF;
UPDATE tHLAttendanceLetterGeneration SET nWarningLetterID = @nWarningLetterID, dStartDate = @dStartDate, dEndDate = @dEndDate, dProcessDate = @dProcessDate, nSupervisorrID = @nSupervisorrID, sSupevisorrName = @sSupevisorrName WHERE (ID = @Original_ID) AND (dEndDate = @Original_dEndDate OR @Original_dEndDate IS NULL AND dEndDate IS NULL) AND (dProcessDate = @Original_dProcessDate OR @Original_dProcessDate IS NULL AND dProcessDate IS NULL) AND (dStartDate = @Original_dStartDate OR @Original_dStartDate IS NULL AND dStartDate IS NULL) AND (nSupervisorrID = @Original_nSupervisorrID OR @Original_nSupervisorrID IS NULL AND nSupervisorrID IS NULL) AND (nWarningLetterID = @Original_nWarningLetterID OR @Original_nWarningLetterID IS NULL AND nWarningLetterID IS NULL) AND (sSupevisorrName = @Original_sSupevisorrName OR @Original_sSupevisorrName IS NULL AND sSupevisorrName IS NULL);
	SELECT ID, nWarningLetterID, dStartDate, dEndDate, dProcessDate, nSupervisorrID, sSupevisorrName FROM tHLAttendanceLetterGeneration WHERE (ID = @ID) ORDER BY ID DESC
GO
