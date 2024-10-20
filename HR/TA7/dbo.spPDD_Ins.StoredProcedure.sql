USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPDD_Ins]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPDD_Ins]
(
	@e_id int,
	@DTPunchDate smalldatetime,
	@dblHours float,
	@sType nvarchar(30),
	@sExportCode nvarchar(10),
	@nHRProcessedCode int,
	@nWeekID bigint,
	@sNote nvarchar(50)
)
AS
	SET NOCOUNT OFF;
INSERT INTO tPunchDateDetail(e_id, DTPunchDate, dblHours, sType, sExportCode, nHRProcessedCode, nWeekID, sNote) VALUES (@e_id, @DTPunchDate, @dblHours, @sType, @sExportCode, @nHRProcessedCode, @nWeekID, @sNote);
	SELECT tpdID, e_id, DTPunchDate, dblHours, sType, sExportCode, nHRProcessedCode, nWeekID, sNote FROM tPunchDateDetail WHERE (tpdID = @@IDENTITY)
GO
