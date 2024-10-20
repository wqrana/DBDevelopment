USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_GetCustomers_MultiBuy]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================        
-- Author:  Adeel Siddiqui        
-- Create date: 12-APR-2018      
-- Description: Returns customers for multibuy on the basis of school grade and homeroomid  

--Modification History
-- Author: Waqar Q        
-- Create date: 24-JAN-2019      
-- Description: Change the coditions for data issues   

-- =============================================      
CREATE PROCEDURE [dbo].[Admin_GetCustomers_MultiBuy] (
	@ClientID BIGINT
	,@SchoolID VARCHAR(50)
	,@GradeID VARCHAR(50)
	,@HomeRoomID VARCHAR(50)
	)
AS
BEGIN 

	DECLARE @GradeIDInt INT, @HomeRoomIDInt INT

	SET @GradeIDInt		= CASE WHEN @GradeID='' THEN NULL ELSE CAST( @GradeID AS INT) END
	SET @HomeRoomIDInt	= CASE WHEN @HomeRoomID='' THEN NULL ELSE CAST( @HomeRoomID AS INT) END
    

	SELECT DISTINCT C.Id AS CustomerID
		
		,C.FirstName + ' ' + C.LastName AS NAME
		,H.NAME AS homeroom
		,h.Id homeroomId
		,G.NAME AS grade
		,G.Id AS gradeId
		
	FROM Customers C
	LEFT OUTER JOIN District d ON D.Id = c.District_Id
	LEFT OUTER JOIN AccountInfo AI ON C.ID = AI.Customer_Id
	LEFT OUTER JOIN Grades G ON G.ClientID = c.ClientID
		AND G.Id = c.Grade_Id
	LEFT OUTER JOIN Customer_School CS ON cs.ClientID = C.ClientID
		AND CS.Customer_Id = c.Id
	--	AND CS.isPrimary = 1
	LEFT OUTER JOIN Schools S ON S.ClientID = CS.ClientID
		AND S.Id = CS.School_Id
	LEFT OUTER JOIN Homeroom h ON h.ClientID = c.ClientID
		AND h.Id = c.Homeroom_Id
	WHERE C.IsActive = 1
		AND C.isDeleted = 0
		AND C.ClientID = @ClientID


		AND S.ID = CAST(@SchoolID AS INT)
		AND isnull(G.Id, 0) = ISNULL(@GradeIDInt, isnull(G.Id, 0))
		AND isnull(H.Id, 0) = ISNULL(@HomeRoomIDInt, isnull(H.Id, 0))

		ORDER BY c.ID
		/*
		AND (
			S.ID = @SchoolID
			OR S.ID IN (
				SELECT School_Id
				FROM Customer_School CS
				WHERE S.ID = CS.School_Id
					AND CS.Customer_Id = c.Id
					AND CS.ClientId = @ClientID
					AND CS.School_Id = @SchoolID
				)
			AND (
				
				isnull(G.Id, 0) = CASE 
					WHEN (len(ltrim(rtrim(@GradeID))) > 0)
						THEN @GradeID
					ELSE CASE 
							WHEN @GradeID = ''
								THEN isnull(G.Id, 0)
							ELSE 0
							END
					END
				AND (
					isnull(H.Id, 0) = CASE 
						WHEN (len(ltrim(rtrim(@HomeRoomID))) > 0)
							THEN @HomeRoomID
						ELSE CASE 
								WHEN @HomeRoomID = ''
									THEN isnull(H.Id, 0)
								ELSE 0
								END
						END
					)
				)
			)
			*/
END
GO
