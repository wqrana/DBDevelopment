USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_GetCustomer_ByClientId]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Adeel Siddiqui 
-- Create date: 23-OCT-18
-- Description: Get All Customers by ClientId
  
   
-- =============================================  
CREATE PROCEDURE [dbo].[Admin_GetCustomer_ByClientId]  
 -- Add the parameters for the stored procedure here  
 @ClientID bigint  
AS  
BEGIN  
  
 SET NOCOUNT ON;  
   
  
 -- Add the T-SQL statements to compute the return value here  

 select CS.School_Id,S.SchoolName,C.* from customers C
left join Customer_School CS on C.Id=CS.Customer_Id
inner join Schools S on S.Id=CS.School_Id
where C.ClientID=@ClientID AND C.isActive = 1 and C.isDeleted = 0  

 --select * from customers where ClientID = @ClientID  AND isActive = 1 and isDeleted = 0  
  
  
END
GO
