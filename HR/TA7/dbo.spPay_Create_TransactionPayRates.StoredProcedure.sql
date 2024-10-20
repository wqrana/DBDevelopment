USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spPay_Create_TransactionPayRates]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spPay_Create_TransactionPayRates]
	-- Add the parameters for the stored procedure here
	@PayrollCompany nvarchar(50),
	@Punchdate date
-- WITH ENCRYPTION
AS

BEGIN

	DECLARE @LastUserID int
	DECLARE @NextUserID int
	DECLARE @RC int

	BEGIN TRY
		BEGIN TRAN
			SET @LastUserID = -1
			SET @NextUserID = 0
			--Iterate throguh all the employees and create the UserBath for each
			while @NextUSerID <> @LastUserID
			BEGIN
			 
				Set @LastUserID = @NextUserID

				SELECT top(1) @NextUSerID= upr.intUserID FROM [dbo].[tblUserPayRatesRules] upr inner join tblUserCompanyPayroll ucp on upr.intUserID = ucp.intUserID 
				WHERE upr.intUserID > @LastUserID and ucp.intPayrollUserStatus > 0 and ucp.strCompanyName = @PayrollCompany
				ORDER BY upr.intUserID

				IF @NextUSerID <> @LastUserID
				BEGIN
								EXECUTE @RC = [dbo].[spPay_Create_UserTransactionPayRates]@NextUSerID  ,@Punchdate
				END 
			END
			COMMIT
		END TRY
		BEGIN CATCH
			ROLLBACK ;
			SELECT   
			ERROR_NUMBER() AS ErrorNumber  
		   ,ERROR_MESSAGE() AS ErrorMessage; 
		END CATCH

END
GO
