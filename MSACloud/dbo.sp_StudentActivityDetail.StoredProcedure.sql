USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[sp_StudentActivityDetail]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[sp_StudentActivityDetail] --'2016-01-25T13:27:28'
( 
	@LastLBN DATETIME
	
)
AS
BEGIN
	SELECT DISTINCT
		c.ClientID,
		c.Id as Customer_Id,
		ROUND(ISNULL(ai.ABalance,0.0),2) as AlaCarteBalance,
		ROUND(ISNULL(ai.MBalance,0.0),2) as MealPlanBalance,
		ROUND(ISNULL(ai.BonusBalance, 0.0),2) as BonusBalance

		--ROUND(CASE do.UsingBonus
		--		WHEN 1 THEN ISNULL(ai.ABalance,0.0) + ISNULL(ai.MBalance,0.0) + ISNULL(ai.BonusBalance, 0.0)
		--		ELSE ISNULL(ai.ABalance,0.0) + ISNULL(ai.MBalance,0.0)
		--END,2) as Balance
	FROM Customers c
		INNER JOIN CustomerActivity ca on ca.ClientID = c.ClientID and ca.Customer_Id = c.Id
		LEFT OUTER JOIN AccountInfo ai on ai.ClientID = c.ClientID and ai.Customer_Id = c.Id
		LEFT OUTER JOIN DistrictOptions do on do.ClientID = c.ClientID and do.Id = c.District_Id
	WHERE ca.OrderDate >= @LastLBN
END
GO
