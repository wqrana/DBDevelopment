USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[FetchDistinctHomeRoomForBeginningBalance]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Adeel Siddiqui    
-- Create date: 12-APR-2018  
-- Description: Returns Distinct HomeRooms for Beginning Balance on the basis of client, schoolID and GradeID.    
-- =============================================    
-- FetchDistinctHomeRoomForBeginningBalance 44,73,11  
-- =============================================  
CREATE PROCEDURE [dbo].[FetchDistinctHomeRoomForBeginningBalance] (  
 @ClientID BIGINT  
 ,@SchoolID BIGINT  
 ,@GradeID BIGINT  
 ,@DistrictId BIGINT  
 )  
AS  
BEGIN  
 SELECT DISTINCT Isnull(H.NAME,  'Not Assigned') AS NAME
  ,isnull(H.Id, '') AS HomeRoomId  
		,H.NAME AS HomeName
 FROM Customers C  
 LEFT OUTER JOIN District d on D.Id=c.District_Id
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
  --AND G.ID = @GradeID  
  AND Isnull(G.Id, 0) = @GradeID
  AND h.Id is not null
  AND D.Id=  @DistrictId
 ORDER BY H.NAME  
END
GO
