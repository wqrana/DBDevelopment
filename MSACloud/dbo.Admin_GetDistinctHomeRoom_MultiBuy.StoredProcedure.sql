USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_GetDistinctHomeRoom_MultiBuy]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  Adeel Siddiqui      
-- Create date: 12-APR-2018    
-- Description: Returns Distinct HomeRooms for multi buy on the basis of client and GradeID.   
--Modification History
-- Author:  Waqar Q      
-- Create date: 23-JAN-2019    
-- Description: Returns the HomeRooms for multi buy on the basis of clientID and schoolID.   

   
-- =============================================      
-- =============================================    
CREATE PROCEDURE [dbo].[Admin_GetDistinctHomeRoom_MultiBuy] (
	@ClientID BIGINT
	--,@GradeID BIGINT
	,@SchoolID BIGINT
	)
AS
BEGIN
	--SELECT DISTINCT Cast(Isnull(H.NAME, 'None Selected') as nvarchar(60)) AS NAME
	--	,isnull(H.Id, '') AS HomeRoomId
	--	,H.NAME AS HomeRoomName
	--FROM Customers C
	--LEFT OUTER JOIN District d ON D.Id = c.District_Id
	--LEFT OUTER JOIN AccountInfo AI ON C.ID = AI.Customer_Id
	--LEFT OUTER JOIN Grades G ON G.ClientID = c.ClientID
	--	AND G.Id = c.Grade_Id
	--LEFT OUTER JOIN Customer_School CS ON cs.ClientID = C.ClientID
	--	AND CS.Customer_Id = c.Id
	--	AND CS.isPrimary = 1
	--LEFT OUTER JOIN Schools S ON S.ClientID = CS.ClientID
	--	AND S.Id = CS.School_Id
	--LEFT OUTER JOIN Homeroom h ON h.ClientID = c.ClientID
	--	AND h.Id = c.Homeroom_Id
	--WHERE C.IsActive = 1
	--	AND c.isDeleted = 0
	--	AND C.ClientID = @ClientID
	--	--AND G.ID = @GradeID    
	--	AND G.Id = @GradeID
	--AND h.Id is not null  
	--ORDER BY H.NAME


	SELECT DISTINCT Cast(Isnull(NAME, 'None Selected') as nvarchar(60)) AS NAME
	,isnull(Id, '') AS HomeRoomId
	,NAME AS HomeRoomName
	FROM dbo.Homeroom 
	WHERE ClientID = @ClientID
	AND School_Id = @SchoolID
    ORDER BY NAME
END
GO
