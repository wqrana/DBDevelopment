USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPDD_Sel]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPDD_Sel]
AS
	SET NOCOUNT ON;
SELECT tpdID, e_id, DTPunchDate, dblHours, sType, sExportCode, nHRProcessedCode, nWeekID, sNote FROM tPunchDateDetail
GO
