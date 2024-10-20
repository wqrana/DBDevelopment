USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_CategoryType_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Heverly
-- Create date: 1/27/2014
-- Description:	Returns the Category Type List
-- =============================================
/* 
	Revisions:
*/
-- =============================================
CREATE FUNCTION [dbo].[Admin_CategoryType_List]
(	
	@ClientID bigint
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT 
		ct.Id as Category_Type_Id,
		ct.Name as Category_Type_Name,
		ct.isDeleted as Deleted
		--select *
	FROM dbo.CategoryTypes ct
	WHERE ct.ClientID = @ClientID
)
GO
