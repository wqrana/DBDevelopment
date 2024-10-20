USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[LockNotesDates]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[LockNotesDates] 
@Company as nvarchar(50),
@StartDate as datetime,
@EndDate as datetime,
@Lock as bit
AS
update tPunchDate set bLocked=@Lock
FROM         tPunchDate INNER JOIN
                      tuser ON tPunchDate.e_id = tuser.id
WHERE    ( tuser.sNotes = @Company) AND (tPunchDate.DTPunchDate BETWEEN @StartDate AND @EndDate)
GO
