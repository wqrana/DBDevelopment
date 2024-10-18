USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Connected_Customers_MSA]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Usman F
-- Create date: 09/06/2017
-- Description:	Returns Details all active customers those are connected with a parent , used in MSA ADMIN
 --exec Admin_Connected_Customers 44, '1175,16,637,1211', '1234,14,642,1400';
 --exec Admin_Connected_Customers_MSA 44, '1175,16,637,1211', '1234,14,642,1400';


-- =============================================
CREATE PROCEDURE [dbo].[Admin_Connected_Customers_MSA]
	
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
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
		c.Local_id,
		CASE WHEN cs.School_Id is null THEN 'Not Assigned' ELSE s.SchoolName END as School_Name,
		c.UserID,
		c.LastName,
		c.FirstName,
		c.isActive , 
		--ROUND(ISNULL(ai.ABalance,0.0),2) as AlaCarteBalance,
		--ROUND(ISNULL(ai.BonusBalance,0.0),2) as BonusBalance,
		CASE
			WHEN ISNULL(do.UsingMealPlan,0) = 1 THEN 
				ROUND(ISNULL(ai.MBalance,0.0) + ISNULL(ai.ABalance,0.0) + ISNULL(ai.BonusBalance,0.0),2)
			ELSE
				ROUND(ISNULL(ai.MBalance,0.0) + ISNULL(ai.ABalance,0.0),2)
		END as TotalBalance,
		c.DOB,
		c.Grade_Id,
		c.Homeroom_Id,
		h.Name AS HomeroomName
	FROM dbo.Customers c
		INNER  JOIN Customer_School cs ON cs.ClientID = c.ClientID AND cs.Customer_Id = c.Id AND cs.isPrimary = 1
		INNER  JOIN Schools s ON s.ClientID = cs.ClientID AND s.Id = cs.School_Id
		INNER  JOIN District d ON d.ClientID = c.ClientID AND d.Id = c.District_Id
		LEFT  JOIN DistrictOptions do ON do.ClientID = c.ClientID AND do.District_Id = c.District_Id
		LEFT  JOIN AccountInfo ai ON ai.ClientID = c.ClientID AND ai.Customer_Id = c.Id
		LEFT   JOIN dbo.Homeroom h ON h.ID = c.Homeroom_Id
	WHERE c.ClientID = @ClientID AND
		c.isDeleted = 0 and 
		c.isActive = 1 and 
		d.Id = c.District_Id and 
		d.ClientID = @ClientID and
		( 
			c.Id IN (SELECT Value FROM Reporting_fn_Split(@ListClientCustids, ','))
			OR
			c.Local_id IN (SELECT Value FROM Reporting_fn_Split(@ListDistCustids, ','))
		
		)
				
END
GO
