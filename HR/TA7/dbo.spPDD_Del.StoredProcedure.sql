USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPDD_Del]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPDD_Del]
(
	@Original_tpdID int,
	@Original_DTPunchDate smalldatetime,
	@Original_dblHours float,
	@Original_e_id int,
	@Original_nHRProcessedCode int,
	@Original_nWeekID bigint,
	@Original_sExportCode nvarchar(10),
	@Original_sNote nvarchar(50),
	@Original_sType nvarchar(30)
)
AS
	SET NOCOUNT OFF;
DELETE FROM tPunchDateDetail WHERE (tpdID = @Original_tpdID) AND (DTPunchDate = @Original_DTPunchDate OR @Original_DTPunchDate IS NULL AND DTPunchDate IS NULL) AND (dblHours = @Original_dblHours OR @Original_dblHours IS NULL AND dblHours IS NULL) AND (e_id = @Original_e_id) AND (nHRProcessedCode = @Original_nHRProcessedCode OR @Original_nHRProcessedCode IS NULL AND nHRProcessedCode IS NULL) AND (nWeekID = @Original_nWeekID OR @Original_nWeekID IS NULL AND nWeekID IS NULL) AND (sExportCode = @Original_sExportCode OR @Original_sExportCode IS NULL AND sExportCode IS NULL) AND (sNote = @Original_sNote OR @Original_sNote IS NULL AND sNote IS NULL) AND (sType = @Original_sType OR @Original_sType IS NULL AND sType IS NULL)
GO
