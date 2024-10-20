USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[FetchDistinctGradesForGraduateSeniors]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Adeel Siddiqui    
-- Create date: 04-APR-2018  
-- Description: Returns Distinct Grades for Graduate Seniors on the basis of client and schoolID.    
-- =============================================    
-- FetchDistinctGradesForGraduateSeniors 44,73  
-- =============================================  
CREATE PROCEDURE [dbo].[FetchDistinctGradesForGraduateSeniors] (
	@ClientID BIGINT
	,@SchoolID BIGINT
	,@DistrictID BIGINT
	)
AS
BEGIN
	SELECT DISTINCT Isnull(G.NAME, 'Not Assigned') AS NAME
		,isnull(G.Id, '') AS GradeID
		,G.NAME AS GradeName
	FROM Customers C
	LEFT OUTER JOIN District D ON D.ClientID = C.ClientID
		AND D.Id = c.District_Id
	LEFT OUTER JOIN AccountInfo AI ON AI.ClientID = C.ClientID
		AND C.ID = AI.Customer_Id
	LEFT OUTER JOIN Grades G ON G.ClientID = c.ClientID
		AND G.Id = c.Grade_Id
	LEFT OUTER JOIN Customer_School CS ON cs.ClientID = C.ClientID
		AND CS.Customer_Id = c.Id
		AND CS.isPrimary = 1
	LEFT OUTER JOIN Schools S ON S.ClientID = CS.ClientID
		AND S.Id = CS.School_Id
	WHERE C.IsActive = 1
		AND c.isDeleted = 0
		AND C.ClientID = @ClientID
		AND Isnull(s.Id, 0) = @SchoolID
		AND D.Id = @DistrictID
	--AND G.ID IS NOT NULL  
	ORDER BY G.NAME
END
GO
