USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Main_Default_FiscalYear_End]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Heverly
-- Create date: 1/30/2014
-- Description:	Gets the Default End of the Fiscal Year:  (6/30)
-- =============================================
CREATE FUNCTION [dbo].[Main_Default_FiscalYear_End]
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

	IF (@Month < 7) BEGIN
		SET @retValue = CAST(('6/30/' + CAST(@Year as varchar)) as datetime2(7))
	END
	ELSE BEGIN
		SET @retValue = CAST(('6/30/' + CAST((@Year+1) as varchar)) as datetime2(7))
	END

	-- Return the result of the function
	RETURN @retValue

END
GO
