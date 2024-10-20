USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_InsertEligibilityCounts]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Create date: 5/26/2016
-- Description:	fill data to EditCheckElig table.
-- =============================================
 --exec Admin_InsertEligibilityCounts '44'
 --select * from [dbo].[EditCheckElig]
-- =============================================
CREATE PROCEDURE [dbo].[Admin_InsertEligibilityCounts]
	-- Add the parameters for the stored procedure here
	@ClientIDLIST varchar(2048) = '',
	@Result int OUTPUT,
	@ErrorMsg nvarchar(4000) OUTPUT
AS
BEGIN
	SET @Result = 0
	SET @ErrorMsg = N''
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN

			insert into EditCheckElig(ClientID,[Date],School_Id,FreeElig,RedElig,PaidElig,LastUpdatedUTC)
			select 
			c.ClientID, 
			GETUTCDATE(),
			cs.School_Id, 

			sum(case lunchtype when 3 then 1 else 0 end) as Free,
			sum(case lunchtype when 2 then 1 else 0 end) as Reduced,
			sum(case lunchtype when 1 then 1 else 0 end) as Paid,
			GETUTCDATE()


			from Customers c
			LEFT OUTER JOIN Customer_School cs ON cs.ClientID = c.ClientID AND cs.Customer_Id = c.Id AND cs.isPrimary = 1
			where isActive = 1 and
			c.ClientID IN (SELECT Value FROM Reporting_fn_Split(@ClientIDLIST, ','))

			group by c.ClientID, School_Id
			order by c.ClientID, School_Id

		COMMIT TRAN
		SET @Result = 0
		SET @ErrorMsg = N''
	END TRY
	BEGIN CATCH
			SET @Result = ERROR_STATE()
			SET @ErrorMsg = ERROR_MESSAGE()
			ROLLBACK TRAN
	END CATCH
	

END
GO
