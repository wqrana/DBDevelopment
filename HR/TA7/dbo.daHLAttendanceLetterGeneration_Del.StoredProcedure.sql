USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[daHLAttendanceLetterGeneration_Del]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[daHLAttendanceLetterGeneration_Del]
(
	@Original_ID int,
	@Original_dEndDate datetime,
	@Original_dProcessDate datetime,
	@Original_dStartDate datetime,
	@Original_nSupervisorrID int,
	@Original_nWarningLetterID bigint,
	@Original_sSupevisorrName nvarchar(50)
)
AS
	SET NOCOUNT OFF;
DELETE FROM tHLAttendanceLetterGeneration WHERE (ID = @Original_ID) AND (dEndDate = @Original_dEndDate OR @Original_dEndDate IS NULL AND dEndDate IS NULL) AND (dProcessDate = @Original_dProcessDate OR @Original_dProcessDate IS NULL AND dProcessDate IS NULL) AND (dStartDate = @Original_dStartDate OR @Original_dStartDate IS NULL AND dStartDate IS NULL) AND (nSupervisorrID = @Original_nSupervisorrID OR @Original_nSupervisorrID IS NULL AND nSupervisorrID IS NULL) AND (nWarningLetterID = @Original_nWarningLetterID OR @Original_nWarningLetterID IS NULL AND nWarningLetterID IS NULL) AND (sSupevisorrName = @Original_sSupevisorrName OR @Original_sSupevisorrName IS NULL AND sSupevisorrName IS NULL)
GO
