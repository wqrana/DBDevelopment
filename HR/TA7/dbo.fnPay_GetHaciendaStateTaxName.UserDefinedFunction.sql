USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_GetHaciendaStateTaxName]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Alexander Rivera	
-- Create date: 1/22/2017
-- Description:	Returns configured User's Hacienda State Tax 
--				Return "" if none configured
-- =============================================
CREATE FUNCTION [dbo].[fnPay_GetHaciendaStateTaxName]
(
	@USERID  int
)
RETURNS nvarchar(50)  -- WITH ENCRYPTION
AS
BEGIN
	declare @HaciendaName nvarchar(50)

	-- Add the T-SQL statements to compute the return value here
		select @HaciendaName= uwi.strWithHoldingsName from tblUserWithholdingsItems uwi inner join tblWithholdingsItems wi on uwi.strWithHoldingsName = wi.strWithHoldingsName
		where intUserID = @USERID and wi.intComputationType = -1 and uwi.boolDeleted = 0
	
	if @HaciendaName is null SET @HaciendaName  = ''

	-- Return the result of the function
	RETURN @HaciendaName
END

GO
