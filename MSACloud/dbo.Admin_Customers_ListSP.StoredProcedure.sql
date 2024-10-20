USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Customers_ListSP]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Abid H 131701013
-- Create date: 09/02/2016
-- Description:	Returns Details all active customers , used in MSA ADMIN
-- exec Admin_Customers_ListSP 44, '','',4, '1209,953,1214,1175,637,1279,1302','1278,958,1277,1400,1234,642,5247,0,0'
-- =============================================
CREATE PROCEDURE [dbo].[Admin_Customers_ListSP]
	
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@CustomerName varchar(100) ,
	@UserID varchar(100),
	@SearchBy int = 1, -- 1 for customer name , 2 for userID
	@ListClientCustids varchar(2000)  = '',
	@ListDistCustids varchar(2000) = ''

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		c.Id as Customer_Id,

		-- Customer Linked information
		--c.District_Id,
		--CASE WHEN c.District_Id is null THEN 'Not Assigned' ELSE d.DistrictName END as District_Name,
		--cs.School_Id,
		CASE WHEN cs.School_Id is null THEN 'Not Assigned' ELSE s.SchoolName END as School_Name,
		--c.Grade_Id,
		CASE WHEN c.Grade_Id is null THEN 'None' ELSE g.Name END as [Grade],
		--c.Homeroom_Id,
		CASE WHEN c.Homeroom_Id is null THEN 'None' ELSE h.Name END as [Homeroom],
		--c.Language_Id,
		--CASE WHEN c.Language_Id is null THEN 'English' ELSE l.Name END as [Language],
		--c.Ethnicity_Id,
		--CASE WHEN c.Ethnicity_Id is null THEN 'None' ELSE e.Name END as Ethnicity,

		-- Customer Information
		c.UserID,
		--c.PIN,
		c.LastName,
		c.FirstName,
		c.Middle,
		--c.Gender,
		--c.SSN,
		--c.Address1 as Customer_Addr1,
		--c.Address2 as Customer_Addr2,
		--c.City as Customer_City,
		--c.State as Customer_State,
		--c.Zip as Customer_Zip,
		--c.Phone as Customer_Phone,
		--c.ExtraInfo as Customer_Notes,
		--c.EMail,
		 CONVERT(VARCHAR, c.DOB ,101) as Date_Of_Birth,
		--c.GraduationDate, -- Display as Date Only (No Time value)
		--c.GraduationDateSet,

		-- Customer Account Status
		--c.isActive as Active,
		--c.isDeleted as Deleted,
		--c.NotInDistrict,  -- Field for Importing Data (Boolean)

		-- Meal Status
		--CASE WHEN c.LunchType is null THEN 4 ELSE c.LunchType END as LunchType, -- 1-Paid, 2-Reduced, 3-Free, 4-No LunchType, 5-Meal Plan
		--CASE c.LunchType WHEN 1 THEN 'Paid' WHEN 2 THEN 'Reduced' WHEN 3 THEN 'Free' WHEN 5 THEN 'Meal Plan' ELSE 'Adult' END as LunchType_String,

		-- Customer Options
		--c.isStudent as Student,
		--c.isSnack as Snack_Participant,
		--c.isStudentWorker as Student_Worker,

		-- Customer Restrictions
		--c.AllowAlaCarte,
		--c.CashOnly as No_Credit_On_Account,		
		c.Local_id, 
		-- Balances
		ROUND(ISNULL(ai.MBalance,0.0),2) as MealPlanBalance,
		ROUND(ISNULL(ai.ABalance,0.0),2) as AlaCarteBalance,
		ROUND(ISNULL(ai.BonusBalance,0.0),2) as BonusBalance,
		CASE
			WHEN ISNULL(do.UsingMealPlan,0) = 1 THEN 
				ROUND(ISNULL(ai.MBalance,0.0) + ISNULL(ai.ABalance,0.0) + ISNULL(ai.BonusBalance,0.0),2)
			ELSE
				ROUND(ISNULL(ai.MBalance,0.0) + ISNULL(ai.ABalance,0.0),2)
		END as TotalBalance

		-- Picture information
		--p.PictureExtension,
		--p.StorageAccountName,
		--p.ContainerName,
		--p.PictureFileName,
		
		-- Internal Items
		--c.CreationDate, -- This is a read-only field only created on a new record.

		-- Unused Items for later
		--CASE WHEN c.SchoolDat = 'T' THEN 1 ELSE 0 END as AllowBiometrics,
		--c.ACH as Allow_ACH
		--select *
	FROM dbo.Customers c
		--LEFT OUTER JOIN [Languages] l ON l.ClientID = c.ClientID AND l.Id = c.Language_Id
		INNER JOIN Grades g ON g.ClientID = c.ClientID AND g.Id = c.Grade_Id
		LEFT OUTER JOIN Homeroom h ON h.ClientID = c.ClientID AND h.Id = c.Homeroom_Id
		--LEFT OUTER JOIN Ethnicity e ON e.ClientID = c.ClientID AND e.Id = c.Ethnicity_Id
		INNER  JOIN Customer_School cs ON cs.ClientID = c.ClientID AND cs.Customer_Id = c.Id AND cs.isPrimary = 1
		INNER  JOIN Schools s ON s.ClientID = cs.ClientID AND s.Id = cs.School_Id
		INNER  JOIN District d ON d.ClientID = c.ClientID AND d.Id = c.District_Id
		INNER  JOIN AccountInfo ai ON ai.ClientID = c.ClientID AND ai.Customer_Id = c.Id
		INNER  JOIN DistrictOptions do ON do.ClientID = c.ClientID AND do.District_Id = c.District_Id
		--LEFT OUTER JOIN Pictures p ON p.ClientID = c.ClientID AND p.Customer_Id = c.Id
	WHERE c.ClientID = @ClientID AND
		c.isDeleted = 0 and 
		c.isActive = 1 and 
		d.Id = c.District_Id and 
		d.ClientID = @ClientID
		--and c.UserID = @UserID
		AND ( 
				(	
					 @CustomerName <> '' and (upper (c.LastName) like '%' + @CustomerName + '%'  OR upper (c.FirstName) like '%' + @CustomerName + '%') and @SearchBy = 1
				) 
				OR 
				(
					
					@UserID <> '' and c.UserID like '%' + @UserID + '%' and @SearchBy = 2
				)
				OR 
				(
					@SearchBy = 3
				)
				OR 
				(
					c.Id IN (SELECT Value FROM Reporting_fn_Split(@ListClientCustids, ',')) and @SearchBy = 4
				)
				OR
				(
					c.Local_id IN (SELECT Value FROM Reporting_fn_Split(@ListDistCustids, ',')) and @SearchBy = 4
				)
		   )
END
GO
