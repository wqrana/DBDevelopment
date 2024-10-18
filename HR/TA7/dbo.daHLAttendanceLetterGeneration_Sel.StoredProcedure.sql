USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[daHLAttendanceLetterGeneration_Sel]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[daHLAttendanceLetterGeneration_Sel]
AS
	SET NOCOUNT ON;
SELECT ID, nWarningLetterID, dStartDate, dEndDate, dProcessDate, nSupervisorrID, sSupevisorrName FROM tHLAttendanceLetterGeneration ORDER BY ID DESC
GO
