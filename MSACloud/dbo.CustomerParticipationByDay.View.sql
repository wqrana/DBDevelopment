USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[CustomerParticipationByDay]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CustomerParticipationByDay]
AS
select 
 Customer_Id,
 o.GDate,
  CAST((CASE WHEN ct.Id is null THEN 0 ELSE 1 END) as INT) as Participated,
  o.ClientID
from Customers c
 left outer join Orders o on o.ClientID = c.ClientID and o.Customer_Id = c.Id
 left outer join Items it on it.ClientID = o.ClientID and it.Order_Id = o.Id
 left outer join Menu m on m.ClientID = it.ClientID and m.Id = it.Menu_Id
 left outer join Category cat on cat.ClientID = m.ClientID and cat.Id = m.Category_Id
 left outer join CategoryTypes ct on ct.ClientID = cat.ClientID and ct.Id = cat.CategoryType_Id 
 and (ct.CanFree = 1 or ct.CanReduce = 1)
where c.Id > 0 
 group by Customer_id, o.GDate,o.clientid, CASE WHEN ct.Id is null THEN 0 ELSE 1 END
GO
