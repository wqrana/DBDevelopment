USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Language_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Heverly
-- Create date: 02/24/2014
-- Description:	Gets a list of Languages created in the system.
-- =============================================
CREATE FUNCTION [dbo].[Admin_Language_List]
(	
	-- Add the parameters for the function here
	@ClientID bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT
		l.Id as Language_Id,
		CASE WHEN l.Id is null THEN 'English' ELSE l.Name END as Language_Name
	FROM Languages l
	WHERE l.ClientID = @ClientID
)
GO
