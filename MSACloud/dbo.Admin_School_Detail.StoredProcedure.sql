USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_School_Detail]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Neil Heverly
-- Create date: 1/31/2014
-- Description:	Returns Details of the specified School.
-- =============================================
CREATE PROCEDURE [dbo].[Admin_School_Detail]
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@SchoolID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		s.Id as School_Id,
		s.SchoolID as School_Id_Num,
		s.SchoolName as School_Name,
		s.District_Id,
		s.Emp_Director_Id,
		s.Emp_Administrator_Id,
		s.Address1 as School_Addr1,
		s.Address2 as School_Addr2,
		s.City as School_City,
		s.State as School_State,
		s.Zip as School_Zip,
		s.Phone1 as School_Main_Phone,
		s.Phone2 as School_Alternate_Phone,
		s.Comment as School_Notes,
		s.isSevereNeed as Severe_Need_School,
		s.isDeleted as Deleted,
		s.UseDistDirAdmin as Use_District_Administrators,
		so.AlaCarteLimit as School_AlaCart_Balance_Limit,
		so.MealPlanLimit as School_MealPlan_Balance_Limit,
		so.DoPinPreFix as Use_Pin_Prefix,
		so.PinPreFix as Pin_Prefix,
		so.PhotoLogging as Use_Photos,
		so.FingerPrinting as Use_Finger_Identification,
		so.BarCodeLength as Max_Bar_Code_Pin_Length,
		so.StartSchoolYear as School_FiscalYear_Start,
		so.EndSchoolYear as School_FiscalYear_End,
		so.StripZeros as Strip_Leading_Zeros
		--select *
	FROM dbo.Schools s
		LEFT OUTER JOIN SchoolOptions so on so.School_Id = s.Id and so.ClientID = s.ClientID
	WHERE s.ClientID = @ClientID AND
		s.Id = @SchoolID
END
GO
