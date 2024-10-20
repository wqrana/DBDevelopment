USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_School_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Neil Heverly
-- Create date: 02/03/2014
-- Description:	Gets a List of Schools
-- =============================================
-- Revisions:
--	3/3/2014 - Change to return only non-deleted.
--  2/2/2016-  @District_Id  datatype changed from int to bigint
-- =============================================
-- =============================================
-- Revisions: BY FARRUKH
--  15/3/2016 -  Change (@IncludeDeleted = s.isDeleted) to (@IncludeDeleted = ISNULL(s.isDeleted,0))  
-- =============================================
CREATE FUNCTION [dbo].[Admin_School_List] 
(	
	-- Add the parameters for the function here
	@ClientID bigint,
	@District_Id bigint = null,
	@IncludeDeleted bit = 0
)
RETURNS TABLE 
AS
RETURN 
(
	-- Add the SELECT statement with parameter references here
	SELECT 
		s.Id,
		s.District_Id,
		s.SchoolID as School_ID,
		s.SchoolName as School_Name,
		d.DistrictName as District_Name,
		coalesce(p.posCount, 0) as POSNum
	FROM Schools s
		LEFT OUTER JOIN District d on d.Id = s.District_Id and d.ClientID = s.ClientID
		LEFT OUTER JOIN (Select Count(Id) as posCount, School_Id FROM POS group by School_Id)
		 p on p.School_id = s.Id
	WHERE 
		s.ClientID = @ClientID AND 
		(CASE WHEN @District_Id is null THEN s.District_Id ELSE @District_Id END = s.District_Id) AND 
		(@IncludeDeleted = ISNULL(s.isDeleted,0))
)
GO
