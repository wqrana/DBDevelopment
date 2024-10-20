USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Customer_WithLocalID]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Abid H
-- Create date: 05/17/2016

--exec Admin_Customer_WithLocalID 44, '1,2'
-- =============================================
 

CREATE PROCEDURE [dbo].[Admin_Customer_WithLocalID]
	@ClientID bigint,
	@LocalIDList varchar(400) = ''--district customer id at MSA
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
distinct
c.Id as Customer_Id,
c.UserID,
c.LastName,
c.FirstName,
c.Middle,
c.DOB,
c.AllowAlaCarte,
g.Name as Grade,
c.IsActive,
hr.Name as HomeRoom,
c.Local_ID,
c.isDeleted,
cs.School_Id,
s.SchoolName,
isNUll(c.LunchType,4) as LunchType

from Customers c
left join Customer_School cs on cs.Customer_Id=c.ID and cs.isPrimary = 1
left join Schools s on s.Id = cs.School_Id
left join HomeRoom hr on hr.Id = c.Homeroom_Id
left join Grades g on g.Id = c.Grade_Id
where 
	c.Local_ID IN (SELECT Value FROM Reporting_fn_Split(@LocalIDList, ',')) 
	AND c.Clientid = @ClientID
	AND c.Local_ID IS NOT NULL
END
GO
