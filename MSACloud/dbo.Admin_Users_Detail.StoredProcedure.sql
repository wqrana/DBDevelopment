USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Users_Detail]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Neil Heverly
-- Create date: 3/20/2014
-- Description:	Returns Details of the specified Employee.
-- =============================================
-- Revisions:
-- =============================================
CREATE PROCEDURE [dbo].[Admin_Users_Detail]
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@EmployeeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		e.Customer_Id as EmployeeID,
		CASE WHEN e.Customer_Id = -2 THEN 'Administrator' ELSE c.FirstName + ' ' + ISNULL(c.Middle + '. ','') + c.LastName END as UserName,
		e.SecurityGroup_Id,
		CASE WHEN (e.SecurityGroup_Id is NULL OR e.SecurityGroup_Id < 0) THEN 'N/A' ELSE sg.GroupName END as SecurityGroup,
		e.LoginName,
		e.Password,
		e.UserRoles_ID
		--select *
	FROM dbo.Employee e
		LEFT OUTER JOIN Customers c ON c.ClientID = e.ClientID AND c.Id = e.Customer_Id
		LEFT OUTER JOIN SecurityGroup sg ON sg.ClientID = sg.ClientID AND sg.Id = e.SecurityGroup_Id
	WHERE e.ClientID = @ClientID AND
		e.Customer_Id = @EmployeeID
END
GO
