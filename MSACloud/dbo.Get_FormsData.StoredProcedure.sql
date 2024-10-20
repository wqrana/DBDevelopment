USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Get_FormsData]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Inayat
-- Create date: 7-Aug-2017
-- Description:	Gets forms data.
-- =============================================
CREATE PROCEDURE [dbo].[Get_FormsData] 
	@ClientID BIGINT,
	@LastSyncDate DATETIME2
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb.dbo.#TempFormsData', 'U') IS NOT NULL
	DROP TABLE #TempFormsData

	IF OBJECT_ID('tempdb.dbo.#TempHousehold', 'U') IS NOT NULL
	DROP TABLE #TempHousehold

	   SELECT
	  a.ClientId,
	  a.District_Id,
	  a.Parent_Id,
	  a.Household_Size,
	  a.id AS [ApplicationID],
	  a.Homeless_On_App,
	  a.Migrant_On_App,
	  ISNULL(a.Beneficiary_Name, '') AS Beneficiary_Name,
	  a.Case_Number AS Case_Number,
	  a.Total_Income,
	  a.Total_Frequency_Id,

	  a.Fee_Waiver AS Fee_Waiver,
	  a.Language_Id AS Language_Id,
	  am.customer_id AS customer_id,

	  am.Member_ID AS Member_ID,
	  am.Foster,

	  am.homeless AS Homeless,
	  am.migrant AS Migrant,
	  am.runaway AS Runaway,

	  am.NoIncome,
	  ISNULL(m.member_status_Id, 0) AS Member_Status_Id,

	  CASE 
		WHEN am.member_id IS NULL AND am.isStudent = 1 THEN c.SSN
		ELSE  'N/A'
	  END AS MemberSSN,

	  ISNULL(CONVERT(varchar, m.DOB, 101), '') AS DOB,
	  ISNULL(m.email, '') AS Email,
	  ISNULL(c.UserID, '') AS UserID,
	  am.isStudent,
	  CASE
		WHEN am.member_id IS NULL AND am.isStudent = 1 THEN c.FirstName
		ELSE m.First_Name
	  END AS MemberFirstName,
	  CASE
		WHEN am.member_id IS NULL AND am.isStudent = 1 THEN ISNULL(c.Middle, '')
		ELSE m.Middle
	  END AS MemberMiddleName,
	  CASE
		WHEN am.member_id IS NULL AND am.isStudent = 1 THEN c.LastName
		ELSE m.Last_Name
	  END AS MemberLastName,

	  sgn.First_Name AS SignerFirstName,
	  sgn.Middle AS SignerMiddle,
	  sgn.Last_Name AS SignerLastName,
	  aps.ssn AS SignerSSN,

	  sgnam.NoIncome AS SignerNoIncome,
	  
	  CASE
		WHEN aps.Address1 IS NULL THEN c.Address1
		ELSE aps.Address1
	  END AS Address1,

	  CASE
		WHEN aps.Address1 IS NULL THEN c.Address2
		ELSE aps.Address2
	  END AS Address2,

	  CASE WHEN aps.City IS NULL THEN c.City
		ELSE aps.City
	  END AS City,

	  CASE WHEN aps.[State] IS NULL THEN c.[State]
		ELSE aps.[State]
	  END AS [State],

	  CASE WHEN aps.Zip IS NULL THEN c.Zip
		ELSE aps.Zip
	  END AS Zip,

	  CASE WHEN aps.phone IS NULL OR aps.phone = '(   )    -' OR aps.phone = '(000) 000-0000' THEN c.Phone
		ELSE aps.phone
	  END AS Phone,

	  aps.cell_phone AS Cell_Phone,
	  aps.other_phone AS Other_Phone,

	  CONVERT(varchar, aps.Signed_Date, 101) + ' ' + CONVERT(varchar, aps.Signed_Date, 108) AS Signed_Date,
	  am.id,
	  ISNULL(an.Comment, '') AS Comment,
	
	  mi.Income_Type1 AS Income_Type1,
	  mi.F1 AS F1,
	  mi.Income_Type2 AS Income_Type2,
	  mi.F2 AS F2,
	  mi.Income_Type3 AS Income_Type3,
	  mi.F3 AS F3,
	  mi.Income_Type4 AS Income_Type4,
	  mi.F4 AS F4,
	  mi.Income_Type5 AS Income_Type5,
	  mi.F5 AS F5,
	  mi.Income_Type6 AS Income_Type6,
	  mi.F6 AS F6,

	  a.LastUpdatedUTC AS AppLastUpdatedUTC,
	  am.LastUpdatedUTC AS AppMemLastUpdatedUTC
	  INTO #TempFormsData
	FROM Applications a
	LEFT OUTER JOIN District d
	  ON a.district_id = d.ID
	INNER JOIN App_Members am
	  ON am.application_id = a.id
	LEFT OUTER JOIN Members m
	  ON am.member_id = m.id
	INNER JOIN App_Signers aps
	  ON a.id = aps.application_id
	INNER JOIN App_Members sgnam
	  ON sgnam.id = aps.app_member_id
	INNER JOIN Members sgn
	  ON sgn.id = sgnam.member_id
	LEFT OUTER JOIN app_notes an
	  ON a.id = an.application_id
	LEFT OUTER JOIN memberIncomes mi
	  ON mi.app_member_id = am.id
	LEFT OUTER JOIN customers c
	  ON c.id = am.customer_id
	WHERE a.ClientId = @ClientID
	AND (a.LastUpdatedUTC IS NULL OR a.LastUpdatedUTC > @LastSyncDate 
	OR ISNULL(a.UpdatedBySync, 0) = 0 OR ISNULL(a.CloudIDSync, 0) = 0)
	ORDER BY a.id

	------------------------------ Households Temps -------------------------------

	SELECT
	  a.ClientId,
	  a.District_Id,
	  a.Household_Size,
	  a.id AS [ApplicationID],
	  a.Homeless_On_App,
	  a.Migrant_On_App,
	  ISNULL(a.Beneficiary_Name, '') AS Beneficiary_Name,
	  a.Case_Number AS Case_Number,
	  
	  a.Fee_Waiver AS Fee_Waiver,

	  a.homeless_on_app AS Homeless,
	  a.migrant_on_app AS Migrant,
	  a.runaway_on_app AS Runaway,

	  sgn.First_Name AS SignerFirstName,
	  sgn.Middle AS SignerMiddle,
	  sgn.Last_Name AS SignerLastName,
	  aps.ssn AS SignerSSN,

	  sgnam.NoIncome AS SignerNoIncome,
	  
	  CASE
		WHEN aps.Address1 IS NULL THEN c.Address1
		ELSE aps.Address1
	  END AS Address1,

	  CASE
		WHEN aps.Address1 IS NULL THEN c.Address2
		ELSE aps.Address2
	  END AS Address2,

	  CASE WHEN aps.City IS NULL THEN c.City
		ELSE aps.City
	  END AS City,

	  CASE WHEN aps.[State] IS NULL THEN c.[State]
		ELSE aps.[State]
	  END AS [State],

	  CASE WHEN aps.Zip IS NULL THEN c.Zip
		ELSE aps.Zip
	  END AS Zip,

	  CASE WHEN aps.phone IS NULL OR aps.phone = '(   )    -' OR aps.phone = '(000) 000-0000' THEN c.Phone
		ELSE aps.phone
	  END AS Phone,

	  aps.cell_phone AS Cell_Phone,
	  aps.other_phone AS Other_Phone,

	  CONVERT(varchar, aps.Signed_Date, 101) + ' ' + CONVERT(varchar, aps.Signed_Date, 108) AS Signed_Date,
	  ISNULL(an.Comment, '') AS Comment,


	  a.LastUpdatedUTC AS AppLastUpdatedUTC
	  INTO #TempHousehold
	FROM Applications a
	LEFT OUTER JOIN District d
	  ON a.district_id = d.ID
	INNER JOIN App_Signers aps
	  ON a.id = aps.application_id
	INNER JOIN App_Members sgnam
	  ON sgnam.id = aps.app_member_id
	INNER JOIN Members sgn
	  ON sgn.id = sgnam.member_id
	LEFT OUTER JOIN app_notes an
	  ON a.id = an.application_id
	LEFT OUTER JOIN customers c
	  ON c.id = sgnam.customer_id
	WHERE a.ClientId = @ClientID
	AND (a.LastUpdatedUTC IS NULL OR a.LastUpdatedUTC > @LastSyncDate 
	OR ISNULL(a.UpdatedBySync, 0) = 0 OR ISNULL(a.CloudIDSync, 0) = 0)
	ORDER BY a.id

	------------------------------ Households -------------------------------

		SELECT DISTINCT
		ApplicationID AS HouseholdID,
		Household_Size AS HHSize,
		0 AS AdditionalMembers,
		Signed_Date AS DateSigned,
		Case_Number AS FSNum,
		IsNULL(Address1, '----') AS Addr1,
		ISNULL(Address2, '----') AS Addr2,
		ISNULL(City, 'No City Info') AS City,
		ISNULL([State], 'PA') AS [State],
		ISNULL(Zip, '00000-0000') AS Zip,
		ISNULL(Phone, '(000) 000-0000') AS Phone1,
		Cell_Phone AS Phone2,
		'E' AS [Language],
		'N' AS [Cert],
		'N' AS MilkOnly,
		'N' AS HealthDept,
		NULL AS TempCode,
		NULL AS TempCodeExpDate,
		Comment,
		ISNULL(SignerSSN, 'N/A') AS Signed_SSN,
		ISNULL(SignerLastName, 'Signed') AS SignedLName,
		ISNULL(SignerFirstName, 'Digitally') AS SignedFName,
		SignerMiddle AS SignedMI,
		NULL AS HHAreaCode, -- -- Find
		ClientId AS District_Id,
		ApplicationID AS Id,
		NULL AS TANF,  ---- Find
		0 AS TempStatus,
		CAST(0 AS BIT) AS AppLetterSent,
		SignerNoIncome AS NoIncome,
		'N' AS Migrant,
		CASE WHEN Migrant = 1 THEN 'Migrant'
			WHEN Runaway = 1 THEN 'Runaway'
			WHEN Homeless = 1 THEN 'Homeless'
			WHEN Case_Number IS NOT NULL THEN 'Foodstamp'
			ELSE '(None)'
		END AS AppStatHousehold,
		Fee_Waiver AS FeeWaiver,
		ApplicationID AS RS_ID,
		NULL AS RS_ImagePath,
		NULL AS Local_Id,
		AppLastUpdatedUTC AS LastUpdatedUTC
		FROM #TempHousehold

		------------------------ Parents ---------------------------

		SELECT DISTINCT Id,
		ApplicationID AS HouseholdID,
		MemberLastName AS LName,
		MemberFirstName AS FName,
		MemberMiddleName AS MI,
		MemberSSN AS SSN,
		CASE WHEN Member_ID IS NULL AND UserID IS NOT NULL THEN 'Student'
			ELSE 'Member'
		END AS ParentalStatus,
		Income_Type1 AS Income1,
		Income_Type2 AS Income2,
		Income_Type3 AS Income3,
		Income_Type4 AS Income4,
		Income_Type5 AS Income5,
		--0.0 AS TotalIncome,
		((ISNULL(Income_Type1, 0.0) * ISNULL(F1, 1)) + (ISNULL(Income_Type2, 0.0) * ISNULL(F2, 1))
		+ (ISNULL(Income_Type3, 0.0) * ISNULL(F3, 1)) + (ISNULL(Income_Type4, 0.0) * ISNULL(F4, 1))
		+ (ISNULL(Income_Type5, 0.0) * ISNULL(F5, 1))) AS TotalIncome,
		F1 AS Frequency1,
		F2 AS Frequency2,
		F3 AS Frequency3,
		F4 AS Frequency4,
		F5 AS Frequency5,
		District_Id AS District_Id,
		NULL AS Local_Id,
		AppMemLastUpdatedUTC AS LastUpdatedUTC
		FROM #TempFormsData
		-- If student has no income do not add them to parent table. It must exists in the customers
		-- table otherwise we cannot store its name in students table.
		EXCEPT
		SELECT DISTINCT Id,
		ApplicationID AS HouseholdID,
		MemberLastName AS LName,
		MemberFirstName AS FName,
		MemberMiddleName AS MI,
		MemberSSN AS SSN,
		CASE WHEN Member_ID IS NULL AND UserID IS NOT NULL THEN 'Student'
			ELSE 'Member'
		END AS ParentalStatus,
		Income_Type1 AS Income1,
		Income_Type2 AS Income2,
		Income_Type3 AS Income3,
		Income_Type4 AS Income4,
		Income_Type5 AS Income5,
		--0.0 AS TotalIncome,
		((ISNULL(Income_Type1, 0.0) * ISNULL(F1, 1)) + (ISNULL(Income_Type2, 0.0) * ISNULL(F2, 1))
		+ (ISNULL(Income_Type3, 0.0) * ISNULL(F3, 1)) + (ISNULL(Income_Type4, 0.0) * ISNULL(F4, 1))
		+ (ISNULL(Income_Type5, 0.0) * ISNULL(F5, 1))) AS TotalIncome,
		F1 AS Frequency1,
		F2 AS Frequency2,
		F3 AS Frequency3,
		F4 AS Frequency4,
		F5 AS Frequency5,
		District_Id AS District_Id,
		NULL AS Local_Id,
		AppMemLastUpdatedUTC AS LastUpdatedUTC
		FROM #TempFormsData WHERE Customer_id IS NOT NULL AND IsStudent = 1 AND NoIncome = 1
		
	---------------------------- Students--------------------------------

		SELECT DISTINCT Id,
		UserID AS UserID,
		'N/A' AS Race,
		NULL AS AppDate,
		Foster AS FosterChild,
		0.0 AS FosterIncome,
		NULL AS ApprovalStatus,
		Getdate() AS DateEntered, -- Find
		Getdate() AS DateChanged,
		ApplicationID AS HouseholdID,
		District_Id AS District_Id,
		customer_id AS Customer_Id,
		CAST(0 AS BIT) AS AppLetterSent,
		NULL AS AppStatStudent, -- -- Find
		ApplicationID AS STUD_RS_ID,
		Getdate() AS RS_MOD_DATE,
		NULL AS STATUS_EFFECTIVE_DATE,  -- -- Find
		CAST(0 AS BIT) AS STATUS_UPDATED,  -- -- Find
		NULL AS Local_Id,
		AppMemLastUpdatedUTC AS LastUpdatedUTC
		FROM #TempFormsData
		WHERE isStudent = 1

		-------------------- Deleted Parents-------------------------------

		SELECT DISTINCT Id,
		Application_Id AS HouseholdID,
		NULL AS LName,
		NULL AS FName,
		NULL AS MI,
		NULL AS SSN,
		NULL AS ParentalStatus,
		NULL AS Income1,
		NULL AS Income2,
		NULL AS Income3,
		NULL AS Income4,
		NULL AS Income5,
		0.0 AS TotalIncome,
		NULL AS Frequency1,
		NULL AS Frequency2,
		NULL AS Frequency3,
		NULL AS Frequency4,
		NULL AS Frequency5,
		NULL AS District_Id,
		NULL AS Local_Id
		
		FROM deleted.app_members
		WHERE ClientId = @ClientID
		AND (LastUpdatedUTC IS NULL OR LastUpdatedUTC > @LastSyncDate 
		OR ISNULL(UpdatedBySync, 0) = 0 OR ISNULL(CloudIDSync, 0) = 0)
		ORDER BY Id
		
		----------------------Deleted Students-----------------------------

		SELECT DISTINCT Id,
		NULL AS UserID,
		'N/A' AS Race,
		NULL AS AppDate,
		NULL AS FosterChild,
		0.0 AS FosterIncome,
		NULL AS ApprovalStatus,
		Getdate() AS DateEntered,
		Getdate() AS DateChanged,
		Application_Id AS HouseholdID,
		NULL AS District_Id,
		Customer_id AS Customer_Id,
		CAST(0 AS BIT) AS AppLetterSent,
		NULL AS AppStatStudent,
		Application_Id AS STUD_RS_ID,
		Getdate() AS RS_MOD_DATE,
		NULL AS STATUS_EFFECTIVE_DATE,
		CAST(0 AS BIT) AS STATUS_UPDATED,
		NULL AS Local_Id

		FROM Deleted.App_Members
		WHERE isStudent = 1
		AND ClientId = @ClientID
		AND (LastUpdatedUTC IS NULL OR LastUpdatedUTC > @LastSyncDate 
		OR ISNULL(UpdatedBySync, 0) = 0 OR ISNULL(CloudIDSync, 0) = 0)
		ORDER BY Id

		IF OBJECT_ID('tempdb.dbo.#TempFormsData', 'U') IS NOT NULL
		DROP TABLE #TempFormsData

		IF OBJECT_ID('tempdb.dbo.#TempHousehold', 'U') IS NOT NULL
		DROP TABLE #TempHousehold

END
GO
