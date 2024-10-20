USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_VoidGroup_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Neil Heverly
-- Create date: 04/29/2014
-- Description:	Gets List of Voids given the search
-- =============================================
-- Revisions:
-- Added UserID: in case of customers

--select * from dbo.Admin_VoidGroup_List (44, '12/23/2016', '12/24/2016','', 3)

--select [dbo].[GetRecalcBalance](44, 52, 1,1, '3/15/2016')
-- =============================================
CREATE FUNCTION [dbo].[Admin_VoidGroup_List] 
(	
	-- Add the parameters for the function here
	@ClientID bigint,
	@DateStart datetime,
	@DateEnd datetime,
	@SearchString varchar(max) = '',
	-- 0 - CASHIER, 1 - POS, 2 - CUSTOMER, 3 - SCHOOL
	@SearchBy int = 0
)
RETURNS @MyUserList TABLE(
	GroupID int,
	Active bit,
	UserID varchar(50),
	GroupName varchar(300),
	CustomerBalance float
		
)
AS
BEGIN
	Declare 
	@MyTempTable TABLE(
	GroupID int,
	Active bit,
	UserID varchar(50),
	GroupName varchar(300),
	CustomerBalance float
		
)

	INSERT INTO @MyTempTable
	SELECT
		DISTINCT
		CASE @SearchBy
			WHEN 0 THEN e.Id
			WHEN 1 THEN p.Id
			WHEN 2 THEN c.Id
			WHEN 3 THEN s.Id
			ELSE c.Id
		END as GroupID,
		-- Get Active status of Customer, else they are all active.
		CASE @SearchBy
			WHEN 2 THEN c.isActive
			ELSE 1
		END as Active,
		-- Get User ID of Customer, else they are all blank.
		CASE @SearchBy
			WHEN 2 THEN c.UserID
			ELSE ''
		END as UserID,
		
		-- Get Name of the Group	
		CASE @SearchBy
			WHEN 0 THEN (CASE WHEN e.Id = -2 THEN 'Administrator' ELSE e.LastName + ', ' + e.FirstName + ' ' + ISNULL(e.Middle,'') END)
			WHEN 1 THEN (CASE WHEN p.Id = -3 THEN 'ADMIN' ELSE ISNULL(p.Name, '') END)
			WHEN 2 THEN c.LastName + ', ' + c.FirstName + ' ' + ISNULL(c.Middle,'')
			WHEN 3 THEN (CASE WHEN s.Id = -3 THEN 'Administrative' ELSE ISNULL(s.SchoolName, '') END)

			ELSE CASE 
					WHEN c.Id = -2 THEN 'CASH SALE GUEST' 
					WHEN c.Id = -3 THEN 'CASH SALE STUDENT' 
					ELSE c.LastName + ', ' + c.FirstName + ' ' + ISNULL(c.Middle,'')
				END
		END as GroupName,
		CASE @SearchBy
			WHEN  2 THEN '2' --ISNULL(dbo.GetRecalcBalance(@ClientID, c.Id, 1 , 0, @DateEnd),0)
			ELSE '0'
		END as CustomerBalance
	FROM CustomerActivity ca
		LEFT OUTER JOIN Customers c ON (c.ClientID = ca.ClientID AND c.Id = ca.Customer_Id)
		LEFT OUTER JOIN POS p ON (p.ClientID = ca.ClientID AND p.Id = ca.POS_Id)
		LEFT OUTER JOIN Customers e ON (e.ClientID = ca.ClientID AND e.Id = ca.Emp_Cashier_Id)
		LEFT OUTER JOIN Schools s ON (s.ClientID = ca.ClientID AND s.Id = ca.School_Id)
	WHERE 
		--ca.OrderDate >= @DateStart AND  ca.OrderDate < DATEADD(Day, 1,@DateEnd)  
		--AND 
		ca.Customer_Id > (CASE @SearchBy WHEN 2 THEN 0 ELSE -4 END)
		AND ca.ClientID = @ClientID
		AND (@SearchString = '' OR 
			(
				(c.LastName LIKE (@SearchString + '%') AND @SearchBy in (2))
					OR
				(c.FirstName LIKE (@SearchString + '%') AND @SearchBy in (2))
					OR
				(c.UserID  = @SearchString AND @SearchBy in (2))
					OR
				(e.LastName LIKE (@SearchString + '%') AND @SearchBy in (0))
					OR
				(e.FirstName LIKE (@SearchString + '%') AND @SearchBy in (0))
					OR
				(p.Name LIKE (@SearchString + '%') AND @SearchBy in (1))
					OR
				(s.SchoolName LIKE (@SearchString + '%') AND @SearchBy in (3))
			))


	insert into @MyUserList
	select GroupID, Active, UserID, GroupName, 
	CASE @SearchBy
	when 2 then ISNULL(dbo.GetRecalcBalance(@ClientID, t.GroupID, 1 , 0, @DateEnd),0)
	else 0
	end
	 
	as CustomerBalance from  @MyTempTable t
	

	RETURN 
END
GO
