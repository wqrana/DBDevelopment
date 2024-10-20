USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Customer_WithID]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		Abid H
-- Create date: 08/08/2016

--exec Admin_Customer_WithID 44, '1,2'
-- =============================================
 

CREATE PROCEDURE [dbo].[Admin_Customer_WithID]
	@ClientID bigint,
	@IDList varchar(400) = ''-- client cust id at MSA
AS
BEGIN
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select 
	distinct
	c.Id as Customer_Id,
	c.UserID,
	c.Local_ID,
	c.DOB,
	c.isActive,
	c.isDeleted,
	isNUll(c.LunchType,4) as LunchType,
	-- Balances
	ROUND(ISNULL(ai.MBalance,0.0),2) as MealPlanBalance,
	ROUND(ISNULL(ai.ABalance,0.0),2) as AlaCarteBalance,
	ROUND(ISNULL(ai.BonusBalance,0.0),2) as BonusBalance

	from Customers c
		LEFT OUTER JOIN AccountInfo ai on ai.Customer_Id = c.Id and ai.ClientID = c.ClientID
	where 
		c.id IN (SELECT Value FROM Reporting_fn_Split(@IDList, ',')) 
		AND c.Clientid = @ClientID
END
GO
