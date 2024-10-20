USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_District_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Heverly
-- Create date: 1/27/2014
-- Description:	Returns the District List
-- =============================================
/* 
	Revisions:
*/
-- =============================================
CREATE FUNCTION [dbo].[Admin_District_List]
(	
	@ClientID bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT 
		d.Id as District_Id,
		d.DistrictName as District_Name
		--select *
	FROM dbo.District d
	WHERE d.ClientID = @ClientID
)
GO
