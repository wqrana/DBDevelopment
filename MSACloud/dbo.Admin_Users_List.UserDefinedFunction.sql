USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Users_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Neil Heverly
-- Create date: 03/20/2014
-- Description:	Gets a List of Users
-- =============================================
-- Revisions:
-- 4/4/2014: Removed Deleted Records from list
-- =============================================
CREATE FUNCTION [dbo].[Admin_Users_List] 
(	
	-- Add the parameters for the function here
	@ClientID bigint,
	@SearchString varchar(60) = '',
	-- 0 - (Login,User First Name, User Last Name); 1 - Login; 2 - UserName;
	@SearchBy int = 0 ,
	@FilterString varchar(max) = '',
	-- 0 - No Filter; 1 - Student;
	@FilterBy int = 0
)
RETURNS @MyUserList TABLE(
	Customer_Id int,
	LoginName varchar(16), 
	UserName varchar(45), 
	SecurityGroup varchar(16), 
	CashedInStatus varchar(10), 
	POSName varchar(16),
	UserRoleName varchar(20),
	UserRole_Id int
	) 
AS
BEGIN
	-- Add the SELECT statement with parameter references here

	-- Exact Match
	INSERT INTO @MyUserList
	SELECT 
		e.Customer_Id,
		e.LoginName,
		CASE c.Id
			WHEN -2 THEN 'Administrator'
			ELSE c.FirstName + ' ' + ISNULL(c.Middle+'. ','') + c.LastName 
		END as UserName,
		ISNULL(sg.GroupName,'N/A') as SecurityGroup,
		CASE WHEN cr.OpenSessions > 0 THEN 'OPEN' ELSE 'CLOSED' END as CashedInStatus,
		CASE WHEN p.Emp_Cashier_Id IS NULL THEN '-' ELSE p.POSName END as POSName,
		CASE WHEN ur.UserRoleName IS NULL THEN '-' ELSE ur.UserRoleName END as UserRoleName,
		ur.Id as UserRole_Id
	FROM Employee e
		LEFT OUTER JOIN Customers c ON c.ClientID = e.ClientID AND c.Id = e.Customer_Id
		LEFT OUTER JOIN UserRoles ur ON ur.ClientID = e.ClientID AND ur.Id = e.UserRoles_ID
		LEFT OUTER JOIN SecurityGroup sg ON sg.ClientID = e.ClientID AND sg.Id = e.SecurityGroup_Id
		LEFT OUTER JOIN (Select ISNULL(Count(Id),0) as OpenSessions, Emp_Cashier_Id from CashResults where ClientID = @ClientID AND Finished = 0 group by Emp_Cashier_Id) cr on cr.Emp_Cashier_Id = e.Customer_Id
		LEFT OUTER JOIN (Select cr.Emp_Cashier_Id, p.Name as POSName from CashResults cr LEFT OUTER JOIN POS p ON p.ClientID = cr.ClientID AND p.Id = cr.POS_Id where cr.ClientID = @ClientID AND Finished = 0) p on p.Emp_Cashier_Id = e.Customer_Id
	WHERE e.ClientID = @ClientID AND e.isDeleted = 0 AND
			(
				(c.LastName = @SearchString AND @SearchBy in (0,2))
					OR
				(c.FirstName = @SearchString AND @SearchBy in (0,2))
					OR
				(e.LoginName = @SearchString AND @SearchBy in (0,1))
			)

	-- Begins With
	INSERT INTO @MyUserList
	SELECT 
		e.Customer_Id,
		e.LoginName,
		CASE c.Id
			WHEN -2 THEN 'Administrator'
			ELSE c.FirstName + ' ' + ISNULL(c.Middle+'. ','') + c.LastName 
		END as UserName,
		ISNULL(sg.GroupName,'N/A') as SecurityGroup,
		CASE WHEN cr.OpenSessions > 0 THEN 'OPEN' ELSE 'CLOSED' END as CashedInStatus,
		CASE WHEN p.Emp_Cashier_Id IS NULL THEN '-' ELSE p.POSName END as POSName,
		CASE WHEN ur.UserRoleName IS NULL THEN '-' ELSE ur.UserRoleName END as UserRoleName,
		ur.id as UserRole_Id
	FROM Employee e
		LEFT OUTER JOIN Customers c ON c.ClientID = e.ClientID AND c.Id = e.Customer_Id
		LEFT OUTER JOIN UserRoles ur ON ur.ClientID = e.ClientID AND ur.Id = e.UserRoles_ID
		LEFT OUTER JOIN SecurityGroup sg ON sg.ClientID = e.ClientID AND sg.Id = e.SecurityGroup_Id
		LEFT OUTER JOIN (Select ISNULL(Count(Id),0) as OpenSessions, Emp_Cashier_Id from CashResults where ClientID = @ClientID AND Finished = 0 group by Emp_Cashier_Id) cr on cr.Emp_Cashier_Id = e.Customer_Id
		LEFT OUTER JOIN (Select cr.Emp_Cashier_Id, p.Name as POSName from CashResults cr LEFT OUTER JOIN POS p ON p.ClientID = cr.ClientID AND p.Id = cr.POS_Id where cr.ClientID = @ClientID AND Finished = 0) p on p.Emp_Cashier_Id = e.Customer_Id
	WHERE e.ClientID = @ClientID AND e.isDeleted = 0 AND
			(
				(c.LastName LIKE (@SearchString + '%') AND @SearchBy in (0,2))
					OR
				(c.FirstName LIKE (@SearchString + '%') AND @SearchBy in (0,2))
					OR
				(e.LoginName LIKE (@SearchString + '%') AND @SearchBy in (0,1))
			)

	RETURN
END
GO
