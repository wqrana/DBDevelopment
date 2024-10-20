USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[CustomerNotification]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[CustomerNotification]
AS
SELECT        pn.Id AS Notification_Id, c.Id AS Cst_Id, o.Id AS Order_Id, i.Id AS Item_Id, m.Id AS Menu_Id, ct.Id AS Cat_Type_Id, ca.Id AS Cat_Id, cstd.DistrictName AS CurrentDistrict, 
                         cstd.Id AS Current_District_Id, ord.DistrictName AS ServedDistrict, ord.Id AS Served_District_Id, ISNULL(c.UserID, '') AS CustUserId, ISNULL(c.PIN, '') AS CustPIN, 
                         ISNULL(c.LastName, '') AS LastName, ISNULL(c.FirstName, '') AS FirstName, ISNULL(c.Middle, '') AS Middle, ISNULL(csh.UserID, '') AS CashUserId, ISNULL(csh.PIN, 
                         '') AS CashPIN, ISNULL(csh.LastName, '') AS CashLastName, ISNULL(csh.FirstName, '') AS CashFirstName, ISNULL(csh.Middle, '') AS CashMiddle, 
                         ISNULL(m.ItemName, '') AS ItemName, o.OrderDate, csc.SchoolName, csc.Id AS Cur_School_Id, hsc.SchoolName AS CustomerHistoricalLocation, 
                         hsc.Id AS Cust_Hist_School_Id, ssc.SchoolName AS ServedHistoricalLocation, ssc.Id AS Served_Hist_School_Id, ISNULL(pn.Name, '') AS Notification, i.Qty AS Total, 
                         ISNULL(ct.Name, '') AS CategoryType, ISNULL(ca.Name, '') AS CategoryName, ct.canFree, ct.canReduce, o.Emp_Cashier_Id AS CashierID, o.POS_Id, ISNULL(p.Name, 
                         '') AS POS_Name, c.isActive AS CustomerActive, c.isDeleted AS CustomerDeleted, c.LunchType, c.CreationDate, ISNULL(g.Name, '') AS Grade, ISNULL(h.Name, '') 
                         AS Homeroom, g.Id AS GRID, h.Id AS HRID
FROM            dbo.Customers AS c LEFT OUTER JOIN
                         dbo.Orders AS o ON o.Customer_Id = c.Id AND o.isVoid = 0 LEFT OUTER JOIN
                         dbo.Customers AS csh ON csh.Id = o.Emp_Cashier_Id LEFT OUTER JOIN
                         dbo.Customer_POSNotification AS cpn ON cpn.Customer_Id = c.Id LEFT OUTER JOIN
                         dbo.POSNotifications AS pn ON pn.Id = cpn.POSNotification_Id LEFT OUTER JOIN
                         dbo.POS AS p ON p.Id = o.POS_Id LEFT OUTER JOIN
                         dbo.Items AS i ON i.Order_Id = o.Id AND i.isVoid = 0 INNER JOIN
                         dbo.Customer_School AS cs ON cs.Customer_Id = c.Id AND cs.isPrimary = 1 INNER JOIN
                         dbo.Schools AS csc ON csc.Id = cs.School_Id INNER JOIN
                         dbo.Schools AS ssc ON ssc.Id = o.School_Id INNER JOIN
                         dbo.Schools AS hsc ON hsc.Id = o.Customer_Pr_School_Id INNER JOIN
                         dbo.District AS cstd ON cstd.Id = c.District_Id INNER JOIN
                         dbo.District AS ord ON ord.Id = ssc.District_Id LEFT OUTER JOIN
                         dbo.Menu AS m ON m.Id = i.Menu_Id LEFT OUTER JOIN
                         dbo.Category AS ca ON ca.Id = m.Category_Id LEFT OUTER JOIN
                         dbo.CategoryTypes AS ct ON ct.Id = ca.CategoryType_Id LEFT OUTER JOIN
                         dbo.Grades AS g ON g.Id = c.Grade_Id LEFT OUTER JOIN
                         dbo.HomeRoom AS h ON h.Id = c.HomeRoom_Id
WHERE        (o.Emp_Cashier_Id <> - 99)
GO
