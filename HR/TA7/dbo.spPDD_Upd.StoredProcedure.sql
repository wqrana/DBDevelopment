USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPDD_Upd]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPDD_Upd]
(
	@e_id int,
	@DTPunchDate smalldatetime,
	@dblHours float,
	@sType nvarchar(30),
	@sExportCode nvarchar(10),
	@nHRProcessedCode int,
	@nWeekID bigint,
	@sNote nvarchar(50),
	@Original_tpdID int,
	@Original_DTPunchDate smalldatetime,
	@Original_dblHours float,
	@Original_e_id int,
	@Original_nHRProcessedCode int,
	@Original_nWeekID bigint,
	@Original_sExportCode nvarchar(10),
	@Original_sNote nvarchar(50),
	@Original_sType nvarchar(30),
	@tpdID int
)
AS
	SET NOCOUNT OFF;
UPDATE tPunchDateDetail SET e_id = @e_id, DTPunchDate = @DTPunchDate, dblHours = @dblHours, sType = @sType, sExportCode = @sExportCode, nHRProcessedCode = @nHRProcessedCode, nWeekID = @nWeekID, sNote = @sNote WHERE (tpdID = @Original_tpdID) AND (DTPunchDate = @Original_DTPunchDate OR @Original_DTPunchDate IS NULL AND DTPunchDate IS NULL) AND (dblHours = @Original_dblHours OR @Original_dblHours IS NULL AND dblHours IS NULL) AND (e_id = @Original_e_id) AND (nHRProcessedCode = @Original_nHRProcessedCode OR @Original_nHRProcessedCode IS NULL AND nHRProcessedCode IS NULL) AND (nWeekID = @Original_nWeekID OR @Original_nWeekID IS NULL AND nWeekID IS NULL) AND (sExportCode = @Original_sExportCode OR @Original_sExportCode IS NULL AND sExportCode IS NULL) AND (sNote = @Original_sNote OR @Original_sNote IS NULL AND sNote IS NULL) AND (sType = @Original_sType OR @Original_sType IS NULL AND sType IS NULL);
	SELECT tpdID, e_id, DTPunchDate, dblHours, sType, sExportCode, nHRProcessedCode, nWeekID, sNote FROM tPunchDateDetail WHERE (tpdID = @tpdID)
GO
