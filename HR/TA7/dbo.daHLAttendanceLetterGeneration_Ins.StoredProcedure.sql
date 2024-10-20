USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[daHLAttendanceLetterGeneration_Ins]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[daHLAttendanceLetterGeneration_Ins]
(
	@nWarningLetterID bigint,
	@dStartDate datetime,
	@dEndDate datetime,
	@dProcessDate datetime,
	@nSupervisorrID int,
	@sSupevisorrName nvarchar(50)
)
AS
	SET NOCOUNT OFF;
INSERT INTO tHLAttendanceLetterGeneration(nWarningLetterID, dStartDate, dEndDate, dProcessDate, nSupervisorrID, sSupevisorrName) VALUES (@nWarningLetterID, @dStartDate, @dEndDate, @dProcessDate, @nSupervisorrID, @sSupevisorrName);
	SELECT ID, nWarningLetterID, dStartDate, dEndDate, dProcessDate, nSupervisorrID, sSupevisorrName FROM tHLAttendanceLetterGeneration WHERE (ID = @@IDENTITY) ORDER BY ID DESC
GO
