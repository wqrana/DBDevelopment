USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_HomeRoom_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Abid H
-- Create date: 2/27/2014
-- Description:	Returns the HomeRoom List
-- =============================================
/* 
	Revisions:
*/
-- =============================================
CREATE FUNCTION [dbo].[Admin_HomeRoom_List]
(	
	@ClientID bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT 
		h.Id as HomeRoom_Id,
		h.Name as HomeRoom_Name
		--select *
	FROM dbo.HomeRoom h
	WHERE h.ClientID = @ClientID
)
GO
