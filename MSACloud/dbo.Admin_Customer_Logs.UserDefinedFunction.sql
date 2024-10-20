USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_Customer_Logs]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		Neil Heverly
-- Create date: 2/14/2014
-- Description:	Returns Customer Logs
-- =============================================
/* 
	Revisions:
	6-18-2015 Update UTC date to local date
*/
-- =============================================
CREATE FUNCTION [dbo].[Admin_Customer_Logs]
(
	@ClientID bigint,
	@CustomerID int
)
RETURNS TABLE
AS
RETURN(
	SELECT 
		cl.Customer_Id,
		cl.Emp_Changed_Id as EmployeeID,
		CASE WHEN e.Id is null THEN 'Unknown' ELSE (e.LastName + ', ' + e.FirstName + ' ' + ISNULL(e.Middle,'')) END as Employee_Name,
		cl.ChangedDateLocal,
		isnull(cl.Notes,'') as Note
	FROM CustomerLog cl
		LEFT OUTER JOIN Customers e ON e.ClientID = cl.ClientID AND e.Id = cl.Emp_Changed_Id
	WHERE cl.ClientID = @ClientID AND
		cl.Customer_Id = @CustomerID
)
GO
