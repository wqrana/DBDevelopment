USE [Live_MSA_Test_Cloud]
GO
/****** Object:  View [dbo].[CustomerRoster]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[CustomerRoster]
AS
SELECT 
	c.ClientID,
	c.Id as CSTID,
	c.District_Id as DISTID,
	c.Language_Id as LANGUAGEID,
	sc.Id as SCHID,
	g.Id as GRID,
	h.Id as HRID,
	CASE c.CreationDate WHEN '12/30/1900' THEN NULL ELSE c.CreationDate END AS CreationDate,
	CASE c.GraduationDate WHEN '12/30/1900' THEN NULL ELSE c.GraduationDate END AS GraduationDate,
	CASE c.DeactiveDate WHEN '12/30/1900' THEN NULL ELSE c.DeactiveDate END AS DeactiveDate,
	CASE c.ReactiveDate WHEN '12/30/1900' THEN NULL ELSE c.ReactiveDate END AS ReactiveDate,
	c.isActive,
	c.isDeleted,
	/* Added by Abid*/
	case 
		when( c.isActive is null or c.isActive =0 ) Then 0
		else 1
	end as isActiveInt,
	case 
		when( c.isDeleted is null or c.isDeleted = 0 ) Then 0
		else 1
	end as isDeletedInt,
	/* end abid changes*/
	CAST((CASE WHEN c.SchoolDat = 'T' THEN 1 ELSE 0 END) as BIT) as AllowBio,
	CAST((CASE WHEN b.Customer_Id IS NULL THEN 0 ELSE 1 END) as BIT) as BioPresent,
	c.UserID,
	c.PIN, 
	c.AllowAlaCarte, c.CashOnly, ISNULL(c.LunchType, 4) as LunchType, c.isStudent, 
	CASE 
		WHEN (c.AllowAlaCarte = 0 OR c.CashOnly = 1) THEN 1
		ELSE 0
	END AS isFrozen, 
	RTRIM(c.LastName) as LastName, RTRIM(c.FirstName) as FirstName, ISNULL(c.Middle, ' ') as Middle,
	c.Address1, c.Address2, c.City, c.State, c.Zip, c.Phone, c.EMail, c.ExtraInfo, c.SSN, 
	ISNULL(RTRIM(g.Name), 'None') as Grade,
	ISNULL(RTRIM(h.Name), 'None') as Homeroom,	
	ISNULL(RTRIM(sc.SchoolName), '**UNASSIGNED**') as SchoolName,
	ISNULL(sc.SchoolID,'**UNASSIGNED**') as SchoolID,
	ISNULL(sc.Address1, '') as SchoolAddress1,
	ISNULL(sc.Address2, '') as SchoolAddress2,
	ISNULL(sc.City, '') as SchoolCity,
	ISNULL(sc.[State], '') as SchoolState,
	ISNULL(sc.Zip, '') as SchoolZip,
	ISNULL(sc.Phone1, '') as SchoolPhone1,
	ISNULL(sc.Phone2, '') as SchoolPhone2,
	ISNULL(d.DistrictName, '**UNASSIGNED**') as DistrictName,
	ISNULL(d.Address1, '') as DistrictAddress1,
	ISNULL(d.Address2, '') as DistrictAddress2,
	ISNULL(d.City, '') as DistrictCity,
	ISNULL(d.State,'') as DistrictState,
	ISNULL(d.Zip, '') as DistrictZip,
	ISNULL(d.Phone1, '') as DistrictPhone1,
	ISNULL(d.Phone2, '') as DistrictPhone2,
	CASE c.LunchType
		WHEN 1 THEN 'PAID'
		WHEN 2 THEN 'REDUCED'
		WHEN 3 THEN 'FREE'
		--WHEN 5 THEN 'MEAL PLAN'
		--Changed NO PLAN TO MEAL PLAN
		--WHEN 5 THEN ISNULL(lt.name, 'NO PLAN')
		WHEN 5 THEN ISNULL(lt.Name, 'MEAL PLAN')
		ELSE 'ADULT'
	END as LunchTypeStatus,
	CASE c.LunchType
		WHEN 1 THEN 1
		WHEN 2 THEN 2
		WHEN 3 THEN 3
		WHEN 5 THEN 0
		ELSE 4
	END as LunchTypeSort,
	lt.Name as MealPlanAssignment,
	c.MealsLeft as NumMealsLeft,
	CASE 
		WHEN (c.isActive = 1 AND c.isDeleted = 0) THEN 'ACTIVE'
		WHEN (c.isActive = 0 AND c.isDeleted = 0) THEN 'INACTIVE'
		WHEN (c.isActive = 0 AND c.isDeleted = 1) THEN 'DELETED'
		ELSE 'UNKNOWN'
	END as ActiveStatus,
	CASE 
		WHEN (c.isActive = 1 AND c.isDeleted = 0) THEN 0
		WHEN (c.isActive = 0 AND c.isDeleted = 0) THEN 1
		WHEN (c.isActive = 0 AND c.isDeleted = 1) THEN 2
		ELSE 'UNKNOWN'
	END as ActiveStatusSort,
	CASE ISNULL(c.LunchType, 4) WHEN 1 THEN 1 ELSE 0 END AS QTYPaid,
	CASE ISNULL(c.LunchType, 4) WHEN 2 THEN 1 ELSE 0 END AS QTYReduced,
	CASE ISNULL(c.LunchType, 4) WHEN 3 THEN 1 ELSE 0 END AS QTYFree,
	CASE ISNULL(c.LunchType, 4) WHEN 4 THEN 1 ELSE 0 END AS QTYAdult,
	CASE ISNULL(c.LunchType, 4) WHEN 5 THEN 1 ELSE 0 END AS QTYMealPlan,
	CASE WHEN ISNULL(c.LunchType, 4) BETWEEN 1 AND 3 THEN 1 ELSE 0 END AS QTYPFR

FROM Customers c
	LEFT OUTER JOIN Customer_School cs ON (cs.Customer_Id = c.Id and cs.isPrimary = 1 AND cs.ClientID = c.ClientID)
	LEFT OUTER JOIN Schools sc ON (sc.Id = cs.School_Id AND sc.ClientID = cs.ClientID)
	LEFT OUTER JOIN District d ON (d.Id = c.District_Id AND d.ClientID = c.ClientID)
	LEFT OUTER JOIN Grades g ON (g.Id = c.Grade_Id AND g.ClientID = c.ClientID)
	LEFT OUTER JOIN Homeroom h ON (h.Id = c.Homeroom_Id AND h.ClientID = c.ClientID)
	LEFT OUTER JOIN Biometrics b ON (b.Customer_Id = c.Id AND b.ClientID = c.ClientID)
	LEFT OUTER JOIN LunchTypes lt ON (lt.Id = c.MealPlan_Id AND c.LunchType = 5 AND lt.ClientID = c.ClientID)
WHERE c.Id > 0
GO
