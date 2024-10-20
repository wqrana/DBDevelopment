USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[sp_CheckCashIn]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_CheckCashIn]
( 
	@ClientID bigint,
	@Pos_Id int = 0,
	@Emp_cashier_id int = 0
)
AS
BEGIN
	DECLARE @POSCustomerId int
	DECLARE @CustomerPosId int
	
	SELECT @POSCustomerId = emp_cashier_id FROM cashresults WHERE ClientID = @ClientID and Pos_id = @Pos_Id and finished = 0 and closedate is null
	SELECT @CustomerPosId = Pos_id FROM cashresults WHERE ClientID = @ClientID and emp_cashier_id = @Emp_cashier_id and finished = 0 and closedate is null
	
	SELECT 
		ISNULL(@POSCustomerId,-1) as customerloggedinpos, 
		(SELECT loginname FROM employee WHERE ClientID = @ClientID and customer_id = ISNULL(@POSCustomerId,-1)) as customername,   
		ISNULL(@CustomerPosId,-1) as posloggedinbycustomer, 
		(SELECT name FROM pos WHERE ClientID = @ClientID and id = ISNULL(@CustomerPosId,-1)) as posname
end
GO
