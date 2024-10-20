USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnGetAccrualDays]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Alexander Rivera
-- Create date: 9/21/2019
-- Description:	Set days estimate in compensation
-- =============================================
CREATE FUNCTION [dbo].[fnGetAccrualDays](	@dblAccruedHours decimal(18,5), @dblDailyHours decimal(18,5))
RETURNS nvarchar (50)
AS
BEGIN
DECLARE @AccrualDays as nvarchar(50);
declare @numDailyHours as numeric(19,4);
set @numDailyHours = convert(numeric(19,4),@dblDailyHours);
if @numDailyHours > 0
	set @AccrualDays = FORMAT( ROUND(@dblAccruedHours / @numDailyHours, 5),'0.#####')
else
	set @AccrualDays =  '0.0'

RETURN @AccrualDays

END;
GO
