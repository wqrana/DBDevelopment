USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Customer_Detail_ForPayment]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Adeel Siddiqui
-- Create date: 23/Aug/2017
-- Description:	Returns Details of the specified Customer With Calculation Related to MealBalance and AlaCarteBalance.
-- =============================================
CREATE PROCEDURE [dbo].[Admin_Customer_Detail_ForPayment]
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@CustomerID bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		c.Id as Customer_Id,

		-- Customer Linked information
		c.District_Id,
		CASE WHEN c.District_Id is null THEN 'Not Assigned' ELSE d.DistrictName END as District_Name,
		cs.School_Id,
		CASE WHEN cs.School_Id is null THEN 'Not Assigned' ELSE s.SchoolName END as School_Name,
		c.Grade_Id,
		CASE WHEN c.Grade_Id is null THEN 'None' ELSE g.Name END as [Grade],
		c.Homeroom_Id,
		CASE WHEN c.Homeroom_Id is null THEN 'None' ELSE h.Name END as [Homeroom],
		c.Language_Id,
		CASE WHEN c.Language_Id is null THEN 'English' ELSE l.Name END as [Language],
		c.Ethnicity_Id,
		CASE WHEN c.Ethnicity_Id is null THEN 'None' ELSE e.Name END as Ethnicity,

		-- Customer Information
		c.UserID,
		c.PIN,
		c.LastName,
		c.FirstName,
		c.Middle,
		c.Gender,
		c.SSN,
		c.Address1 as Customer_Addr1,
		c.Address2 as Customer_Addr2,
		c.City as Customer_City,
		c.State as Customer_State,
		c.Zip as Customer_Zip,
		c.Phone as Customer_Phone,
		c.ExtraInfo as Customer_Notes,
		c.EMail,
		c.DOB as Date_Of_Birth,
		c.GraduationDate, -- Display as Date Only (No Time value)
		c.GraduationDateSet,

		-- Customer Account Status
		c.isActive as Active,
		c.isDeleted as Deleted,
		c.NotInDistrict,  -- Field for Importing Data (Boolean)

		-- Meal Status
		CASE WHEN c.LunchType is null THEN 4 ELSE c.LunchType END as LunchType, -- 1-Paid, 2-Reduced, 3-Free, 4-No LunchType, 5-Meal Plan
		CASE c.LunchType WHEN 1 THEN 'Paid' WHEN 2 THEN 'Reduced' WHEN 3 THEN 'Free' WHEN 5 THEN 'Meal Plan' ELSE 'Adult' END as LunchType_String,

		-- Customer Options
		c.isStudent as Student,
		c.isSnack as Snack_Participant,
		c.isStudentWorker as Student_Worker,

		-- Customer Restrictions
		c.AllowAlaCarte,
		c.CashOnly as No_Credit_On_Account,		

		-- Balances
		ROUND(ISNULL(ai.BonusBalance,0.0),2) as BonusBalance,
		ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, c.Id, ISNULL(do.UsingBonus,0), 2, GETUTCDATE()), 0), 2) as MealPlanBalance,
		ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, c.Id, ISNULL(do.UsingBonus,0), 1, GETUTCDATE()), 0), 2) as AlaCarteBalance,
		ROUND(ISNULL(dbo.GetRecalcBalance(@ClientID, c.Id, ISNULL(do.UsingBonus,0), 0, GETUTCDATE()), 0), 2) as TotalBalance,


		-- Picture information
		p.PictureExtension,
		p.StorageAccountName,
		p.ContainerName,
		p.PictureFileName,
		
		-- Internal Items
		c.CreationDate, -- This is a read-only field only created on a new record.

		-- Unused Items for later
		CASE WHEN c.SchoolDat = 'T' THEN 1 ELSE 0 END as AllowBiometrics,
		c.ACH as Allow_ACH
		--select *
	FROM dbo.Customers c
		LEFT OUTER JOIN [Languages] l ON l.ClientID = c.ClientID AND l.Id = c.Language_Id
		LEFT OUTER JOIN Grades g ON g.ClientID = c.ClientID AND g.Id = c.Grade_Id
		LEFT OUTER JOIN Homeroom h ON h.ClientID = c.ClientID AND h.Id = c.Homeroom_Id
		LEFT OUTER JOIN Ethnicity e ON e.ClientID = c.ClientID AND e.Id = c.Ethnicity_Id
		LEFT OUTER JOIN Customer_School cs ON cs.ClientID = c.ClientID AND cs.Customer_Id = c.Id AND cs.isPrimary = 1
		LEFT OUTER JOIN Schools s ON s.ClientID = cs.ClientID AND s.Id = cs.School_Id
		LEFT OUTER JOIN District d ON d.ClientID = c.ClientID AND d.Id = c.District_Id
		LEFT OUTER JOIN AccountInfo ai ON ai.ClientID = c.ClientID AND ai.Customer_Id = c.Id
		LEFT OUTER JOIN DistrictOptions do ON do.ClientID = c.ClientID AND do.District_Id = c.District_Id
		LEFT OUTER JOIN Pictures p ON p.ClientID = c.ClientID AND p.Customer_Id = c.Id
	WHERE c.ClientID = @ClientID AND
		c.Id = @CustomerID and 
		c.isDeleted = 0 and 
		d.Id = c.District_Id and 
		d.ClientID = @ClientID
END
GO
