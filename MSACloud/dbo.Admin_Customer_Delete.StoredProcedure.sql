USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_Customer_Delete]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  Neil Heverly  
-- Create date: 2/18/2014  
-- Description: Checks to see if the Customer can be deleted, if it can it deletes it.  If not, then it returns a message as to why.  
-- =============================================  
/*  
 Revisions:  
 03/18/2016 - Farrukh - Add script to remove rows from tables biometrics, customer_POSNotification, pictures, customer_school  
*/  
-- =============================================  
CREATE PROCEDURE [dbo].[Admin_Customer_Delete]  
 @ClientID bigint,  
 @CustomerID int,  
 @OverrideBalance bit = 0,  
 @OverrideEmployee bit = 0,  
 @OverrideOrders bit = 0,  
 @OverrideBonusPayments bit = 0,  
 @OverridePreorders bit = 0,  
 @OverrideStudentApp bit = 0  
AS  
BEGIN  
 DECLARE   
  @CanDelete bit,  
  @OrderCount int,  
  @BonusPaymentCount int,  
  @PreOrderCount int,  
  @BalanceExists bit,  
  @Balance decimal(16,2),  
  @EmployeeExists bit,  
  @StudentOnApp bit,  
  @HouseholdID varchar(15)  
  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
   
 SET @CanDelete = 0  
 SET @OrderCount = 0  
 SET @BonusPaymentCount = 0  
 SET @PreOrderCount = 0  
 SET @BalanceExists = 0  
 SET @Balance = 0.0  
 SET @EmployeeExists = 0  
 SET @StudentOnApp = 0  
 SET @HouseholdID = '0'  
  
 BEGIN TRAN  
 BEGIN TRY  
  -- Check for valid Ids  
  IF (@ClientID <= 0)  
   RAISERROR('Invalid Client ID (%d) provided', 11, 1, @ClientID)  
  
  IF (@CustomerID <= 0)  
   RAISERROR('Invalid Customer ID (%d) provided', 11, 1, @CustomerID)  
  
  -- Check if can delete.  
  -- Check Orders  
  IF (@OverrideOrders = 0) BEGIN  
   SELECT @OrderCount = COUNT(*) FROM Orders WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
   IF (@@ERROR <> 0)  
    RAISERROR('Failed to see if there are associated orders for this Customer.', 11, 2)  
  END  
  
  -- Check Preorders  
  IF (@OverridePreorders = 0) BEGIN  
   SELECT @PreOrderCount = COUNT(*) FROM PreOrders WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
   IF (@@ERROR <> 0)  
    RAISERROR('Faield to see if there are associated preorders for this Customer', 11, 2)  
  END  
  
  -- Check Bonus Payments  
  IF (@OverrideBonusPayments = 0) BEGIN  
   SELECT @BonusPaymentCount = COUNT(*) FROM BonusPayments WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
   IF (@@ERROR <> 0)  
    RAISERROR('Failed to see if there are associated bonus payments for this Customer.', 11, 2)  
  END  
  
  -- Check Account Balance  
  IF (@OverrideBalance = 0) BEGIN  
   SELECT   
    @BalanceExists = CASE WHEN (ROUND((ABalance + MBalance + BonusBalance),2) <> 0.0) THEN 1 ELSE 0 END,   
    @Balance = ROUND((ABalance + MBalance + BonusBalance),2)   
   FROM AccountInfo WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
   IF (@@ERROR <> 0)  
    RAISERROR('Failed to see if this customer is carrying a balance.', 11, 2)  
  END  
  
  -- Check For Employee Record  
  IF (@OverrideEmployee = 0) BEGIN  
   SELECT @EmployeeExists = COUNT(*) FROM Employee WHERE ClientID = @ClientID AND Customer_Id = @CustomerID   
   AND IsDeleted = 0 AND (select isActive from Customers where ID=@CustomerID)=1--bug#1760  
   IF (@@ERROR <> 0)  
    RAISERROR('Failed to see if there is an associated employee for this customer.', 11, 2)  
  END  
  
  -- Check for Student Record  
  IF (@OverrideStudentApp = 0) BEGIN  
   SELECT @StudentOnApp = ISNULL(Customer_Id,0), @HouseholdID = HouseholdID FROM STUDENT WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
   IF (@@ERROR <> 0)  
    RAISERROR('Failed to see if there is an associated student record for this customer.', 11, 2)  
  END  
  
  -- Existing Records  
  SELECT @CanDelete =   
   CASE   
    WHEN ((@OrderCount + @BonusPaymentCount + @PreOrderCount) <> 0) THEN 0  
    WHEN (@BalanceExists = 1) THEN 0  
    WHEN (@EmployeeExists = 1) THEN 0  
    WHEN (@StudentOnApp = 1) THEN 0  
    ELSE 1  
   END  
  
  IF (@CanDelete = 0) BEGIN  
   DECLARE @msg varchar(max)  
      
    SET @msg = 'Customer ' + (select UserID from Customers where ID=@CustomerID) + ' is '  
  
    IF (@OrderCount <> 0)   
     SET @msg = @msg + 'associated with ' + CAST(@OrderCount as varchar) + ' order record(s).'  
    ELSE IF (@BonusPaymentCount <> 0)  
     SET @msg = @msg + 'associated with ' + CAST(@BonusPaymentCount as varchar) + ' bonus payment record(s).'  
    ELSE IF (@PreOrderCount <> 0)  
     SET @msg = @msg + 'associated with ' + CAST(@PreOrderCount as varchar) + ' preorder record(s).'  
    ELSE IF (@BalanceExists <> 0)  
     SET @msg = @msg + 'carrying a balance of ' + STR(@balance,15,2) + '.'  
    ELSE IF (@EmployeeExists <> 0)  
     --SET @msg = @msg + 'tied to an employee record'  
	 SET @msg = 'A user is associated with this customer'  
    ELSE IF (@StudentOnApp <> 0)  
     SET @msg = @msg + 'on Household Application ' + @HouseholdID + '.'  
    ELSE  
     SET @msg = @msg + 'associated with unknown record(s).'  
  
    RAISERROR(@msg, 11, 3)  
  END  
  
    
  -- Account Info  
  --DELETE FROM AccountInfo WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
  -- Customer School Assignments  
  -- Charge Counts (Warning Letter Notifications)  
  --DELETE FROM ChargeCounts WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
  -- Customer Logs  
  --DELETE FROM CustomerLogs WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
  -- Recalculation Log  
  --DELETE FROM RecalculationLog WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
  -- Customer Record  
  --DELETE FROM Customers WHERE ClientID = @ClientID AND Id = @CustomerID  
  
  -- Remove Customer and Associated Data (by farrukh on 18-03-2016)  
  DELETE FROM dbo.Customer_School WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
  IF (@@ERROR <> 0) RAISERROR('Failed to Delete Customer_School (%d).', 11, 3, @CustomerID)  
  -- Pictures  
  DELETE FROM dbo.Pictures WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
  IF (@@ERROR <> 0) RAISERROR('Failed to Delete Pictures (%d).', 11, 3, @CustomerID)  
  -- Biometrics  
  DELETE FROM dbo.Biometrics WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
  IF (@@ERROR <> 0) RAISERROR('Failed to Delete Biometrics (%d).', 11, 3, @CustomerID)  
  -- Customer_POSNotification  
  DELETE FROM dbo.Customer_POSNotification WHERE ClientID = @ClientID AND Customer_Id = @CustomerID  
  IF (@@ERROR <> 0) RAISERROR('Failed to Delete Customer_POSNotification (%d).', 11, 3, @CustomerID)  
  ------------------------------------------------------------------------------------------  
  
  UPDATE Customers SET isActive = 0, isDeleted = 1 WHERE ClientID = @ClientID AND Id = @CustomerID  
  IF (@@ERROR <> 0) RAISERROR('Failed to Delete Customer (%d).', 11, 4, @CustomerID)  
  
  COMMIT TRAN  
  
  SELECT @CustomerID as Customer_Id, 0 as Result, '' as ErrorMessage  
 END TRY  
 BEGIN CATCH  
  ROLLBACK TRAN  
  
  SELECT 0 as Customer_Id, ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage  
 END CATCH  
END
GO
