USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[PaymentTransfers]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[PaymentTransfers]
AS
SELECT
	o1.OrderDate as TransactionDate, 
	o1.CheckNumber as TransactionID, 
	s1.Id as FromSchID,
	s2.Id as ToSchID,
	c1.UserId as FromUserID, 
	c2.UserId as ToUserID, 
	c1.LastName as FromLastName,
	c1.FirstName as FromFirstName,
	c1.Middle as FromMiddle,
	c2.LastName as ToLastName,
	c2.FirstName as ToFirstName,
	c2.Middle as ToMiddle,
	(o1.aDebit + o1.mDebit) as FromPayment, 
	(o2.aDebit + o2.mDebit) as ToPayment, 
	s1.SchoolName as FromSchoolName, 
	s2.SchoolName as ToSchoolName, 
	h1.Name as FromHomeroom, 
	h2.Name as ToHomeroom, 
	g1.Name as FromGrade, 
	g2.Name as ToGrade 
FROM Orders o1 
	INNER JOIN Schools s1 on s1.Id = o1.School_Id
	INNER JOIN Customers c1 on c1.id = o1.customer_id 
	LEFT OUTER JOIN grades g1 on g1.id = c1.grade_id 
	LEFT OUTER JOIN homeroom h1 on h1.id = c1.homeroom_id 
	INNER JOIN Orders o2 on o1.checknumber = o2.checknumber 
	INNER JOIN Schools s2 on s2.Id = o2.School_Id
	INNER JOIN Customers c2 on c2.id = o2.customer_id 
	LEFT OUTER JOIN grades g2 on g2.id = c2.grade_id 
	LEFT OUTER JOIN homeroom h2 on h2.id = c2.homeroom_id 
WHERE (o1.TransType = 4501) AND (o2.TransType = 4502)
GO
