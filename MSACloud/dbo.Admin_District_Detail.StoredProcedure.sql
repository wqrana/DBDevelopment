USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_District_Detail]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Heverly
-- Create date: 1/27/2014
-- Description:	Returns Details of the specified district.
-- =============================================
CREATE PROCEDURE [dbo].[Admin_District_Detail]
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@DistrictID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		d.Id as District_Id,
		d.DistrictName as District_Name,
		d.Address1 as District_Addr1,
		d.Address2 as District_Addr2,
		d.City as District_City,
		d.State as District_State,
		d.Zip as District_Zip,
		d.Phone1 as District_Phone1,
		d.Phone2 as District_Phone2,
		--d.Fax as District_Fax,
		--Tax Infomration:  (checkboxes)
		ISNULL(do.isStudentPaidTaxable,0) as Tax_Paid_Student,
		ISNULL(do.isStudentRedTaxable,0) as Tax_Reduced_Student,
		ISNULL(do.isStudentFreeTaxable,0) as Tax_Free_Student,
		ISNULL(do.isEmployeeTaxable,1) as Tax_Employee,
		ISNULL(do.isMealPlanTaxable,0) as Tax_Meal_Plan_Person,
		ISNULL(do.isGuestTaxable,1) as Tax_Guest_Cash_Sale,
		ISNULL(do.isStudCashTaxable,0) as Tax_Student_Cash_Sale,
		CASE
			WHEN MONTH(GETDATE()) > MONTH(do.StartSchoolYear) THEN CAST(CAST(MONTH(do.StartSchoolYear) as varchar) + '/' + CAST(DAY(do.StartSchoolYear) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as datetime)
			ELSE CAST(CAST(MONTH(do.StartSchoolYear) as varchar) + '/' + CAST(DAY(do.StartSchoolYear) as varchar) + '/' + CAST((YEAR(GETDATE()) - 1) as varchar) as datetime)
		END as Fiscal_Year_Start_Date,
		CASE
			WHEN MONTH(GETDATE()) > MONTH(do.EndSchoolYear) THEN CAST(CAST(MONTH(do.EndSchoolYear) as varchar) + '/' + CAST(DAY(do.EndSchoolYear) as varchar) + '/' + CAST((YEAR(GETDATE())+1) as varchar) as datetime)
			ELSE CAST(CAST(MONTH(do.EndSchoolYear) as varchar) + '/' + CAST(DAY(do.EndSchoolYear) as varchar) + '/' + CAST(YEAR(GETDATE()) as varchar) as datetime)
		END as Fiscal_Year_End_Date,
		d.BankRoute as Bank_Routing_Num,
		d.BankAccount as Bank_Account_Num,
		d.BankName as Bank_Name,
		d.BankAddr1 as Bank_Address1,
		d.BankAddr2 as Bank_Address2,
		d.BankCity as Bank_City,
		d.BankState as Bank_State,
		d.BankZip as Bank_Zip
		--select *
	FROM dbo.District d
		LEFT OUTER JOIN DistrictOptions do on do.District_Id = d.Id and do.ClientID = d.ClientID
	WHERE d.ClientID = @ClientID AND
		d.Id = @DistrictID
END
GO
