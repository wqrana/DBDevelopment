USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[API_Customer_UsingLocalID_BAK]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Heverly
-- Create date: 10/31/2017

--exec API_Customer_UsingLocalID 44, '1,2'
-- =============================================
 

CREATE PROCEDURE [dbo].[API_Customer_UsingLocalID_BAK]
	@ClientID bigint,
	@LocalIDList varchar(400) = ''	--Customer ID from School Server or District_Cust_Id from MSA
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		c.Id as Customer_Id,
		c.Local_ID,
		cs.School_Id,
		c.District_Id,
		c.MealPlan_Id,
		c.UserID,
		c.PIN,
		c.LastName,
		c.FirstName,
		c.Middle,
		isNUll(c.LunchType,4) as LunchType,
		c.DOB,
		ISNULL(c.AllowAlaCarte,0) as AllowAlaCarte,
		ISNULL(c.CashOnly,0) as CashOnly,
		c.IsActive,
		c.isDeleted,
		g.Name as Grade,
		hr.Name as HomeRoom,
		s.SchoolName,
		d.DistrictName,
		c.MealsLeft,
		ISNULL(ai.ABalance,0.0) as ABalance,
		ISNULL(ai.MBalance,0.0) as MBalance,
		round(CASE ISNULL(do.UsingBonus,0) when 1 then ISNULL(ai.BonusBalance,0.0) else 0.0 end,2) as BonusBalance,
		round(
			CASE ISNULL(do.UsingBonus,0) 
				when 1 then (ISNULL(ai.ABalance,0.0) + ISNULL(ai.MBalance,0.0) + ISNULL(ai.BonusBalance,0.0)) 
				else (ISNULL(ai.ABalance,0.0) + ISNULL(ai.MBalance,0.0)) 
			end,2) as TotalBalance
	FROM Customers c
	LEFT OUTER JOIN AccountInfo ai on ai.Customer_id = c.Id
	LEFT OUTER JOIN DistrictOptions do on do.District_Id = c.District_Id
	LEFT OUTER JOIN Customer_School cs on cs.Customer_Id = c.ID and cs.isPrimary = 1
	LEFT OUTER JOIN Schools s on s.Id = cs.School_Id
	LEFT OUTER JOIN District d on d.Id = c.District_Id
	LEFT OUTER JOIN HomeRoom hr on hr.Id = c.Homeroom_Id
	LEFT OUTER JOIN Grades g on g.Id = c.Grade_Id
	where 
		c.Local_ID IN (SELECT Value FROM Reporting_fn_Split(@LocalIDList, ',')) 
		AND c.Clientid = @ClientID
		AND c.Local_ID IS NOT NULL
END
GO
