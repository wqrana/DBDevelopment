USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Main_Default_FiscalYear_Start]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Heverly
-- Create date: 1/30/2014
-- Description:	Gets the Default Start of the Fiscal Year:  (7/1) of Current Year
-- =============================================
CREATE FUNCTION [dbo].[Main_Default_FiscalYear_Start]
(
	@Date datetime2(7)
)
RETURNS datetime2(7)
AS
BEGIN
	-- Declare the return variable here
	DECLARE 
		@retValue datetime2(7),
		@Year int,
		@Month int,
		@Day int

	SET @Year = YEAR(@Date)
	SET @Month = MONTH(@Date)
	SET @Day = DAY(@Date)

	IF (@Month > 6) BEGIN
		SET @retValue = CAST(('7/1/' + CAST(@Year as varchar)) as datetime2(7))
	END
	ELSE BEGIN
		SET @retValue = CAST(('7/1/' + CAST((@Year-1) as varchar)) as datetime2(7))
	END

	-- Return the result of the function
	RETURN @retValue

END
GO
