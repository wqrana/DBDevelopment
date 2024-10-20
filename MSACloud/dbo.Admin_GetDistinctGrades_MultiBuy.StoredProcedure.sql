USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_GetDistinctGrades_MultiBuy]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  Adeel Siddiqui      
-- Create date: 12-APR-2018    
-- Description: Returns Distinct HomeRooms for multi buy on the basis of client and schoolID.     
-- Modification History
-- Author:  Waqar Q      
-- Create date: 24-JAN-2019    
-- Description: Returns Grade for multi buy on the basis of client.     
 
-- =============================================      
-- =============================================    
CREATE PROCEDURE [dbo].[Admin_GetDistinctGrades_MultiBuy] (
	@ClientID BIGINT
	,@SchoolID BIGINT
	)
AS
BEGIN
/*
	SELECT DISTINCT Isnull(G.NAME, 'None Selected') AS NAME
		,isnull(G.Id, '') AS GradeId
		,G.NAME AS GradeName
	FROM Customers C
	LEFT OUTER JOIN District d ON D.Id = c.District_Id
	LEFT OUTER JOIN AccountInfo AI ON C.ID = AI.Customer_Id
	LEFT OUTER JOIN Grades G ON G.ClientID = c.ClientID
		AND G.Id = c.Grade_Id
	LEFT OUTER JOIN Customer_School CS ON cs.ClientID = C.ClientID
		AND CS.Customer_Id = c.Id
		AND CS.isPrimary = 1
	LEFT OUTER JOIN Schools S ON S.ClientID = CS.ClientID
		AND S.Id = CS.School_Id
	LEFT OUTER JOIN Homeroom h ON h.ClientID = c.ClientID
		AND h.Id = c.Homeroom_Id
	WHERE C.IsActive = 1
		AND c.isDeleted = 0
		AND C.ClientID = @ClientID
		AND S.ID = @SchoolID
		AND G.ID is not null
	ORDER BY G.NAME
*/
	SELECT DISTINCT Isnull(NAME, 'None Selected') AS NAME
		,isnull(Id, 0) AS GradeId
		,NAME AS GradeName
	FROM Grades
	WHERE ClientID = @ClientID
	ORDER BY NAME
		
END
GO
