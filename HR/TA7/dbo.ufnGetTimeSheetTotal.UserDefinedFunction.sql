USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[ufnGetTimeSheetTotal]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
         CREATE FUNCTION [dbo].[ufnGetTimeSheetTotal](@WeekID as  bigint) RETURNS float  AS    BEGIN     DECLARE @ret float     SELECT @ret = sum(dblhours) from tPunchDateDetail where nWeekID = @WeekID AND sType NOT IN ('REG NO TRABAJADAS','LATE') group by e_id       IF (@ret IS NULL)          SET @ret = 0     RETURN @ret END       
GO
