USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Customer_Balance]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Abid H
-- Create date: 02/16/2014
-- Description:	to get customer balance data for report
-- =============================================
-- Revisions:


-- =============================================
CREATE FUNCTION [dbo].[Admin_Customer_Balance] 
(	
	@ClientID bigint
)
RETURNS TABLE 
AS
RETURN 
(

SELECT 
 Cust.UserID, 
 Cust.LastName, 
 Cust.FirstName, Cust.isActive, 
 CSCH.isPrimary, 
 S.SchoolName, G.Name as GradeName, 
 H.Name as HomeroomName, AI.ABalance, 
 
 AI.MBalance, AI.BonusBalance,
 H.id as HRID,
 G.id as GRID,
 S.id as SCHID,
 Cust.ClientID as ClientID

 FROM   ((AccountInfo "AI" LEFT OUTER JOIN 
 (( Customer_School CSCH 
 INNER JOIN  Customers Cust ON CSCH.Customer_Id=Cust.ID) 
 INNER JOIN Schools S ON CSCH.School_Id= S.ID) 
 ON AI.Customer_Id = Cust.ID) INNER JOIN Grades G 
 ON Cust.Grade_Id =G.ID ) INNER JOIN Homeroom H ON Cust.Homeroom_Id = H.ID
 WHERE  Cust.LastName <> 'CASH SALE' AND CSCH.isPrimary = 1
 AND Cust.ClientID = @ClientID
 )
GO
