USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_POS_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		Neil Heverly
-- Create date: 2/03/2014
-- Description:	Returns the POS List
-- =============================================
/* 
	Revisions:

*/
-- =============================================
CREATE FUNCTION [dbo].[Admin_POS_List]
(
	@ClientID bigint,
	@SchoolID bigint = NULL
)
RETURNS TABLE
AS
RETURN
(
	SELECT 
		p.ClientID,
		p.Id as POS_Id,
		p.Name as POS_Name,
		s.ID AS SchoolID,
		s.SchoolName as School_Name,
		p.EnableCCProcessing as Credit_Card_Enabled,
		CASE WHEN (select COUNT(*) from CashResults cr where cr.ClientID = @ClientID AND cr.POS_Id = p.Id and cr.Finished = 0) > 0 THEN 'Open' ELSE 'Closed' END as POS_Open_Session,
		ISNULL((select TOP 1 e.LoginName from CashResults cr left outer join Employee e on e.Customer_Id = cr.Emp_Cashier_Id and e.ClientID = cr.ClientID where cr.ClientID = @ClientID AND cr.POS_Id = p.Id and cr.Finished = 0 Group by e.LoginName),'N/A') as POS_Open_Cashier,
		(select TOP 1 cr.OpenDate from CashResults cr where cr.ClientID = @ClientID and cr.POS_Id = p.Id and cr.Finished = 0 order by cr.OpenDate desc) as POS_Open_Session_Date,
		p.VeriFoneUserId,
		p.VeriFonePassword
		--select *
	FROM dbo.POS p
		LEFT OUTER JOIN Schools s on s.Id = p.School_Id and s.ClientID = p.ClientID
	WHERE p.ClientID = @ClientID 
		AND (CASE WHEN @SchoolID is NULL THEN p.School_Id ELSE @SchoolID END = p.School_id)
		and (p.isDeleted = 0 or p.isDeleted is null)
)
GO
