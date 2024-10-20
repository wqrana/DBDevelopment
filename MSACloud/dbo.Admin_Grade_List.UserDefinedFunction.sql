USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Grade_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Heverly
-- Create date: 2/19/2014
-- Description:	Returns the Grades List
-- =============================================
/* 
	Revisions:
*/
-- =============================================
CREATE FUNCTION [dbo].[Admin_Grade_List]
(
	@ClientID bigint
)
RETURNS TABLE
AS
RETURN
(
	SELECT 
		g.Id as Grade_Id,
		g.Name as Grade
		--select *
	FROM dbo.Grades g
	WHERE g.ClientID = @ClientID 
)
GO
