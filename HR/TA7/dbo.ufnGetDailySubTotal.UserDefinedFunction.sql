USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[ufnGetDailySubTotal]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE FUNCTION [dbo].[ufnGetDailySubTotal](@UserID as  int, @PunchDate as datetime) RETURNS float      BEGIN     DECLARE @ret float     SELECT @ret = sum(dblhours) from tPunchDateDetail where e_id = @UserID and DTPunchDate = @PunchDate AND sType IN ('REG NO TRABAJADAS') group by e_id       IF (@ret IS NULL)          SET @ret = 0     RETURN @ret END   
GO
