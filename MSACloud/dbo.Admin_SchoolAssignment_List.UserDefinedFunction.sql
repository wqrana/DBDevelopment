USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_SchoolAssignment_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Heverly
-- Create date: 02/25/2014
-- Description:	Gets a list of assigned schools given the customer id
-- =============================================
CREATE FUNCTION [dbo].[Admin_SchoolAssignment_List]
(	
	-- Add the parameters for the function here
	@ClientID bigint,
	@CustomerID int
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT
		cs.School_Id,
		s.SchoolName as School_Name
	FROM Customer_School cs
		LEFT OUTER JOIN Schools s ON s.Id = cs.School_Id
	WHERE cs.ClientID = @ClientID AND cs.Customer_Id = @CustomerID AND cs.isPrimary = 0
)
GO
