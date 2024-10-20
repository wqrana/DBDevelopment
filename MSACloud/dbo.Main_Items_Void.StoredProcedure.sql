USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_Items_Void]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Main_Items_Void]      
 @ClientID bigint,      
 @ITEMID bigint,      
 @EMPLOYEEID bigint,      
 @ORDERTYPE int,      
 @ORDLOGID bigint = NULL, -- NULL - No record created or updated, -1 new order log created, >0 updates current order log      
 @ORDLOGNOTE varchar(255) = NULL      
AS      
DECLARE @MySalesTax CURSOR,      
 -- Other Variables      
 @ORDLOGEXISTS bit,      
 -- Balance Variables      
 @ABAL float,      
 @MBAL float,      
 @BBAL float,      
 @PRIABAL float,      
 @PRIMBAL float,      
 @PRIBBAL float,      
 @ADIF float,      
 @MDIF float,      
 @BDIF float,      
 -- Order Variables      
 @CUSTID int,      
 @TRANSID int,      
 @ORDNUM int,      
 @ORDTYPE int,      
 @ORDERID int,      
 @ORDID int,      
 @CASHRESID int,      
 @OLDACRED float,      
 @OLDMCRED float,      
 @OLDBCRED float,      
 @TMPORDDATE datetime,      
 -- Item Variables      
 @SOLDTYPE int,      
 @PREORDITEMID int,      
 @MENUID int,      
 @QTY int,      
 @FULLPRICE float,      
 @PAIDPRICE float,      
 @TAXPRICE float,      
 @SALESTAXID int,       
 @TAXRATE float,       
 @SALESTAX float,      
 -- Calculation Variables      
 @TMPTAXTOTAL float,      
 @TAXABLESALES float,      
 @SALES float,      
 @NONTAXABLESALES float,      
 @MEALTOTAL float,      
 @TMPMTAX float,      
 @TMPATAX float,      
 @TMPTAX float,      
 @NEWMCRED float,      
 @NEWACRED float,      
 @NEWBCRED float,      
 @USEBONUS bit,      
      
 --For voiding the orders along with item if all the items get voided      
 @PreOrderId int,      
 @TotalPreOrderCount int,      
 @TotalPreOrderVoidCount int      
       
BEGIN      
 SET @OLDACRED = 0.0      
 SET @OLDMCRED = 0.0      
 SET @OLDBCRED = 0.0      
 SET @ORDLOGEXISTS = 0      
      
 DECLARE @OrdLogIds TABLE (NewOrdLogId bigint)      
      
    BEGIN TRAN      
 --select 'begin tran'      
 --print 'adeel'      
 BEGIN TRY      
  -- Check for Valid Parameters Passed      
  IF (@ClientID <= 0)      
   RAISERROR('Invalid Client ID %I64d', 11, 1, @ClientID)      
  IF (@ITEMID = -1 OR @ITEMID = 0)      
   RAISERROR('Invalid Item ID %I64d', 11, 1, @ITEMID)      
  IF (@EMPLOYEEID = -1 OR @EMPLOYEEID = 0)      
   RAISERROR('Invalid Employee ID %I64d', 11, 1, @EMPLOYEEID)      
  IF (@ORDLOGID = 0)      
   RAISERROR('Invalid Order Log ID %I64d', 11, 1, @ORDLOGID)      
  IF (@ORDERTYPE < 0 AND @ORDERTYPE not in (2))      
   RAISERROR('Invalid Order Type %d', 11, 1, @ORDERTYPE)      
      
  -- Load Item and Order Information      
  --select '@ORDERTYPE = 1'      
  IF (@ORDERTYPE = 1) BEGIN      
   SELECT      
    @ORDERID = poi.PreOrder_Id,      
    @CUSTID = po.Customer_Id,      
    @MENUID = poi.Menu_Id,       
    @QTY = poi.Qty,       
    @FULLPRICE = poi.FullPrice,       
    @PAIDPRICE = poi.PaidPrice,       
    @TAXPRICE = poi.TaxPrice,       
    @SOLDTYPE = poi.SoldType,      
    @PREORDITEMID = poi.Id,      
    @OLDACRED = po.ACredit,      
    @OLDMCRED = po.MCredit,      
    @OLDBCRED = po.BCredit      
    --@PRIABAL = ISNULL(po.PriorABal,0.0),      
    --@PRIMBAL = ISNULL(po.PriorMBal,0.0),      
    --@PRIBBAL = ISNULL(po.PriorBBal,0.0)      
   FROM PreOrderItems poi      
    INNER JOIN PreOrders po ON po.Id = poi.PreOrder_Id and poi.ClientID = po.ClientID      
   WHERE poi.ClientID = @ClientID      
    and poi.Id = @ITEMID      
   IF (@@ERROR <> 0)      
    RAISERROR('Failed to load information for PreOrderItem ID: %d', 11, 1, @ITEMID)      
  END      
  ELSE BEGIN      
   SELECT       
    @ORDERID = it.Order_Id,      
    @CUSTID = o.Customer_Id,      
    @MENUID = it.Menu_Id,       
    @QTY = it.Qty,       
    @FULLPRICE = it.FullPrice,       
    @PAIDPRICE = it.PaidPrice,       
    @TAXPRICE = it.TaxPrice,       
    @SOLDTYPE = it.SoldType,       
    @PREORDITEMID = it.PreOrderItem_Id,      
    @OLDACRED = o.ACredit,      
    @OLDMCRED = o.MCredit,      
    @OLDBCRED = o.BCredit      
    --@PRIABAL = ISNULL(o.PriorABal,0.0),      
    --@PRIMBAL = ISNULL(o.PriorMBal,0.0),      
    --@PRIBBAL = ISNULL(o.PriorBBal,0.0)      
   FROM Items it      
    INNER JOIN Orders o ON o.Id = it.Order_Id and o.ClientID = it.ClientID      
   WHERE it.ClientID = @ClientID      
    and it.Id = @ITEMID      
   IF (@@ERROR <> 0)      
    RAISERROR('Failed to load information for Item ID: %d', 11, 1, @ITEMID)      
  END     
        
  --select '@CUSTID > 0'      
  -- Load Customer's Balance      
  IF (@CUSTID > 0) BEGIN      
   SELECT       
    @ABAL = ISNULL(ABalance, 0.0),       
    @MBAL = ISNULL(MBalance, 0.0),       
    @BBAL = ISNULL(BonusBalance, 0.0)       
   FROM AccountInfo WITH (UPDLOCK)       
   WHERE ClientID = @ClientID      
    and Customer_Id = @CUSTID      
   IF (@@ERROR <> 0)      
    RAISERROR('Failed to load balance for customer ID: %d', 11, 2, @CUSTID)      
      
   -- Load District Settings      
   SELECT      
    @USEBONUS = ISNULL(do.UsingBonus,0)      
   FROM DistrictOptions do      
    LEFT OUTER JOIN Customers c ON c.District_Id = do.District_Id and c.ClientID = do.ClientID      
   WHERE do.ClientID = @ClientID      
   IF (@@ERROR <> 0)      
    RAISERROR('Failed to Get District Settings for Customer ID: %d', 11, 2, @CUSTID)      
  END      
  ELSE BEGIN      
   SET @ABAL = 0.0      
   SET @MBAL = 0.0      
   SET @BBAL = 0.0      
   SET @USEBONUS = 0      
  END      
      
  -- Insert or Update OrdersLog      
 /* IF (@ORDLOGID = -1) BEGIN      
   EXEC Main_IndexGenerator_GetIndex @ClientID, 21, 1, @ORDLOGID OUTPUT      
   IF (@@ERROR <> 0 OR @ORDLOGID = 0) RAISERROR('Failed to get Orders Log id', 11, 9)      
  END      
      
  SELECT @ORDLOGEXISTS = COUNT(*) FROM OrdersLog WHERE ClientID = @ClientID AND Id = @ORDLOGID      
  IF (@@ERROR <> 0) RAISERROR('Failed seeing if orders log exists from this order.', 11, 9)      
      
  IF (@ORDLOGID IS NOT NULL) BEGIN      
   IF (@ORDLOGEXISTS = 1) BEGIN      
    UPDATE OrdersLog SET      
     Employee_Id = @EMPLOYEEID,      
     ChangedDate = GETDATE(),      
     Notes = @ORDLOGNOTE      
    WHERE ClientID = @ClientID AND Id = @ORDLOGID      
   END      
   ELSE BEGIN      
    INSERT INTO OrdersLog (ClientID, Id, Employee_Id, ChangedDate, Notes)      
     VALUES (@ClientID, @ORDLOGID, @EMPLOYEEID, GETDATE(), @ORDLOGNOTE)      
   END      
   IF (@@ERROR <> 0) RAISERROR('Failed to save Orders Log ID: %d', 11, 2, @ORDLOGID)      
  END*/      
  -- Update or Create order log (by farrukh m (allshore) on 05/09/16: to insert order log      
  --select '@ORDLOGID IS NOT NULL'      
  IF (@ORDLOGID IS NOT NULL) BEGIN      
   MERGE OrdersLog T      
   USING (select @ClientID as ClientID, @ORDLOGID as Id, @EMPLOYEEID as Employee_Id, GETDATE() as ChangedDate, @ORDLOGNOTE as Notes) S      
   ON T.Id = S.Id      
   WHEN MATCHED THEN      
    update set       
     --Notes = T.Notes + '\n' + S.Notes      
  Notes = S.Notes  
   WHEN NOT MATCHED THEN      
    insert (ClientID, Employee_Id, ChangedDate, Notes)      
    values (S.ClientID, S.Employee_Id, S.ChangedDate, S.Notes)      
   OUTPUT inserted.Id into @OrdLogIds;      
         
   IF (@@ERROR <> 0) RAISERROR ('Failed to save order log ID %d', 11, 3, @ORDLOGID)      
         
   SELECT Top 1 @ORDLOGID = NewOrdLogId from @OrdLogIds      
  END      
      
  -- Update Item      
  --select 'Update Item'      
  IF (@ORDERTYPE = 0) BEGIN      
   UPDATE Items SET isVoid = 1 WHERE ClientID = @ClientID and Id = @ITEMID      
   IF (@@ERROR <> 0)      
    BEGIN      
    RAISERROR('Failed to Void Item ID: %d', 11, 3, @ITEMID)      
    END      
      
   IF (@PREORDITEMID IS NOT NULL) BEGIN      
    UPDATE PreOrderItems SET      
     PickupCount = PickupCount - 1,      
     Disposition = 0,      
     PickupDate = CASE PickupCount WHEN 0 THEN NULL ELSE PickupDate END       
    WHERE ClientID = @ClientID      
     and Id = @PREORDITEMID      
    IF (@@ERROR <> 0)      
     BEGIN      
     RAISERROR('Failed to Update pickup status for PreOrderItem ID: %d', 11, 3, @PREORDITEMID)      
     END      
      
      
   END          
  END      
  ELSE IF (@ORDERTYPE = 1) BEGIN      
   -- Check that Item was not picked up      
   DECLARE @ITEMNAME varchar(75), @ORDPICKDATE varchar(20)      
   SELECT       
    @ITEMNAME = ISNULL(m.ItemName,'Misc Item $' + LTRIM(STR(it.PaidPrice,10,2))),       
    @ORDPICKDATE = CONVERT(varchar,o.OrderDate,100)      
   FROM Items it      
    INNER JOIN Orders o ON o.Id = it.Order_Id and o.ClientID = it.ClientID      
    LEFT OUTER JOIN Menu m ON m.Id = it.Menu_Id and m.ClientID = it.ClientID      
   WHERE it.ClientID = @ClientID      
    and it.PreOrderItem_Id = @PREORDITEMID      
   IF (@@ROWCOUNT > 0)       
    RAISERROR('Item %s has already been picked up on %s.\nPlease void the Picked up Item before voiding the Preordered Item.', 11, 4, @ITEMNAME, @ORDPICKDATE)      
         
   UPDATE PreOrderItems SET isVoid = 1 WHERE ClientID = @ClientID and Id = @ITEMID      
      
   --For voiding the orders along with item if all the items get voided      
   --select @PREORDITEMID      
   select @PreOrderId=PreOrder_Id from PreOrderItems where  ID=@PREORDITEMID and ClientID = @ClientID      
   --select 'PreOrderId '      
   --select @PreOrderId      
   select @TotalPreOrderCount =Count(*) from PreOrderItems where PreOrder_Id=@PreOrderId and ClientID = @ClientID      
   --select 'TotalPreOrderCount '      
   --select @TotalPreOrderCount      
   select @TotalPreOrderVoidCount=Count(*) from PreOrderItems where PreOrder_Id=@PreOrderId and ClientID = @ClientID and isVoid=1      
   --select 'TotalPreOrderVoidCount '      
   --select @TotalPreOrderVoidCount      
      
   IF(@TotalPreOrderCount=@TotalPreOrderVoidCount)      
   BEGIN      
    --select 'TotalPreOrderCount=TotalPreOrderVoudCount'      
    UPDATE PreOrders set isVoid=1 where Id=@PreOrderId and ClientID = @ClientID      
   END      
      
   IF (@@ERROR <> 0)      
    RAISERROR('Failed to Void Preordered Item ID: %d', 11, 3, @ITEMID)      
  END      
      
  SET @TMPTAXTOTAL = 0.0      
  SET @TMPMTAX = 0.0      
  SET @TMPATAX = 0.0      
      
  -- Update Sales Tax on POS Orders Only      
  IF (@ORDERTYPE = 0) BEGIN      
   SELECT       
    @TAXABLESALES = dbo.TaxSubtotal(@ClientID, @ORDERID),       
    @NONTAXABLESALES = dbo.NonTaxSubtotal(@ClientID, @ORDERID),       
    @SALES = ROUND(dbo.ItemTotal(@ClientID, @ORDERID), 2),      
    @MEALTOTAL = ROUND(dbo.OrderMealTotal(@ClientID, @ORDERID),2)      
      
   SET @MySalesTax = CURSOR LOCAL FOR      
    SELECT Id, TaxRate FROM SalesTax WHERE ClientID = @ClientID and Order_Id = @ORDERID      
      
   OPEN @MySalesTax      
   FETCH NEXT FROM @MySalesTax INTO @SALESTAXID, @TAXRATE      
         
   WHILE((@@FETCH_STATUS = 0) AND (CURSOR_STATUS('variable','@MySalesTax') > 0)) BEGIN      
    SET @TMPTAX = (CEILING((@TAXRATE * @TAXABLESALES) * 100) / 100)      
    SET @TMPTAXTOTAL = @TMPTAXTOTAL + @TMPTAX      
      
    UPDATE SalesTax SET       
     SalesTax = ROUND(@TMPTAX, 2)      
    WHERE ClientID = @ClientID      
     and Id = @SALESTAXID      
    IF (@@ERROR <> 0)      
     RAISERROR('Failed to Update Sales Tax ID: %d for Order ID: %d', 11, 5, @SALESTAXID, @ORDERID)      
      
    FETCH NEXT FROM @MySalesTax INTO @SALESTAXID, @TAXRATE      
   END      
         
   CLOSE @MySalesTax      
   DEALLOCATE @MySalesTax      
      
   IF (@TMPTAXTOTAL > 0.0) BEGIN      
    SET @TMPMTAX = @MEALTOTAL * dbo.TaxPercentage(@ClientID, @ORDERID)      
    SET @TMPATAX = @TMPTAXTOTAL - @TMPMTAX      
   END      
   ELSE BEGIN      
    SET @TMPMTAX = 0.0      
    SET @TMPATAX = 0.0      
   END      
  END      
  ELSE BEGIN      
   SELECT       
    @TAXABLESALES = 0.0,       
    @SALES = ROUND(dbo.PreorderItemTotal(@ClientID, @ORDERID), 2),      
    @MEALTOTAL = ROUND(dbo.PreOrderMealTotal(@ClientID, @ORDERID),2)      
          
   SET @NONTAXABLESALES = @SALES      
   SET @TMPMTAX = 0.0      
   SET @TMPATAX = 0.0      
  END      
      
  SET @NEWMCRED = @TMPMTAX + @MEALTOTAL      
  SET @NEWACRED = (@SALES + @TMPTAXTOTAL) - @NEWMCRED      
  SET @NEWBCRED = 0.0      
        
  IF (@NEWACRED > 0.0 AND @USEBONUS = 1) BEGIN      
   IF (@PRIBBAL > @NEWACRED) BEGIN      
    SET @NEWBCRED = @NEWACRED      
    SET @NEWACRED = 0.0      
   END      
   ELSE IF (@PRIBBAL > 0.0) BEGIN      
    SET @NEWBCRED = @PRIBBAL      
    SET @NEWACRED = @NEWACRED - @PRIBBAL      
   END      
  END      
        
  SET @ADIF = @OLDACRED - @NEWACRED      
  SET @MDIF = @OLDMCRED - @NEWMCRED      
  SET @BDIF = @OLDBCRED - @NEWBCRED        
      
  IF (@ORDERTYPE = 0) BEGIN      
   -- Update Order      
   UPDATE Orders SET      
    ACredit = ROUND(@NEWACRED,2),       
    MCredit = ROUND(@NEWMCRED,2),       
    BCredit = ROUND(@NEWBCRED,2),      
    OrdersLog_Id = @ORDLOGID      
   WHERE ClientID = @ClientID      
    and Id = @ORDERID      
   IF (@@ERROR <> 0)      
    RAISERROR('Failed to Update Order ID: %d', 11, 5, @ORDERID)      
  END      
  ELSE IF (@ORDERTYPE = 1) BEGIN      
   UPDATE PreOrders SET       
    ACredit = @NEWACRED,       
    MCredit = @NEWMCRED,       
    BCredit = @NEWBCRED,      
    OrdersLog_Id = @ORDLOGID      
   WHERE ClientID = @ClientID      
    and Id = @ORDERID      
   IF (@@ERROR <> 0)      
    RAISERROR('Failed to Update PreOrder ID: %d', 11, 5, @ORDERID)      
  END      
        
  -- Update Account Info      
  IF (@CUSTID > 0) BEGIN      
   SET @ABAL = ROUND(@ABAL + @ADIF,2)      
   SET @MBAL = ROUND(@MBAL + @MDIF,2)      
   SET @BBAL = ROUND(@BBAL + @BDIF,2)      
      
   UPDATE AccountInfo SET       
    ABalance = @ABAL,      
    MBalance = @MBAL,      
    BonusBalance = @BBAL      
   WHERE ClientID = @ClientID      
    and Customer_Id = @CUSTID      
   IF (@@ERROR <> 0)      
    RAISERROR('Failed to Update Account Balance for Customer ID: %d', 11, 6, @CUSTID)      
  END      
      
  -- Update Prior Balances      
  --SELECT @TRANSID = Id FROM Transactions WHERE ClientID = @ClientID and Order_Id = @ORDERID AND OrderType = @ORDERTYPE      
  --IF (@@ERROR <> 0)      
  -- RAISERROR('Failed to Gather Processing Order Number', 11, 7)      
      
  --DECLARE MyOrders CURSOR LOCAL FOR       
  -- SELECT       
  --  t.Id, t.Order_Id, t.Ordertype, t.CashRes_Id, o.OrderDate as OrderDate      
  -- FROM Orders o       
  --  LEFT OUTER JOIN Transactions t ON o.id = t.Order_id and t.OrderType = 0 and t.ClientID = o.ClientID      
  -- WHERE o.ClientID = @ClientID and t.Id > @TRANSID AND o.Customer_Id = @CUSTID       
  -- UNION      
  -- SELECT      
  --  t.Id, t.Order_Id, t.OrderType, t.CashRes_Id, pre.TransferDate as OrderDate      
  -- FROM PreOrders pre      
  --  LEFT OUTER JOIN Transactions t ON pre.Id = t.Order_Id AND t.OrderType = 1      
  -- WHERE pre.ClientID = @ClientID and t.Id > @TRANSID AND pre.Customer_Id = @CUSTID      
  -- ORDER BY OrderDate      
      
  --OPEN MyOrders      
  --FETCH NEXT FROM MyOrders INTO @ORDNUM, @ORDID, @ORDTYPE, @CASHRESID, @TMPORDDATE      
      
  --WHILE (@@FETCH_STATUS = 0) BEGIN      
  -- IF (@ORDTYPE = 0) BEGIN      
  --  -- Standard Order      
  --  UPDATE Orders SET       
  --   PriorMBal = ROUND((PriorMBal + @MDIF),2),      
  --   PriorABal = ROUND((PriorABal + @ADIF),2),      
  --   PriorBBal = ROUND((PriorBBal + @BDIF),2)      
  --  WHERE ClientID = @ClientID      
  --   and Id = @ORDID      
  --  IF (@@ERROR <> 0)      
  --   RAISERROR('Failed to Update Prior Balances for Order ID: %d', 11, 8, @ORDID)      
  -- END       
  -- ELSE IF (@ORDTYPE = 1) BEGIN      
  --  -- PreOrder      
  --  UPDATE Preorders SET      
  --   PriorMBal = ROUND((PriorMBal + @MDIF),2),      
  --   PriorABal = ROUND((PriorABal + @ADIF),2),      
  --   PriorBBal = ROUND((PriorBBal + @BDIF),2)      
  --  WHERE ClientID = @ClientID       
  --   and Id = @ORDID      
  --  IF (@@ERROR <> 0)      
  --   RAISERROR('Failed to Update Prior Balances for PreOrder ID: %d', 11, 8, @ORDID)      
  -- END      
      
  -- FETCH NEXT FROM MyOrders INTO @ORDNUM, @ORDID, @ORDTYPE, @CASHRESID, @TMPORDDATE      
  --END      
      
  --CLOSE MyOrders      
  --DEALLOCATE MyOrders      
        
  -- Commit on Success      
  --       
  COMMIT TRAN      
  SELECT 0 as Result, '' as ErrorMessage, cast(ROUND(@ADIF+@MDIF+@BDIF,2) as numeric(36,2)) as CreditDif, 0.0 as DebitDif, cast(@ABAL as numeric(36,2) )as ABalance, cast(@MBAL as numeric(36,2)) as MBalance,cast(@BBAL as numeric(36,2))as BonusBalance      
 END TRY      
 BEGIN CATCH      
  ROLLBACK TRAN      
  SELECT ERROR_STATE() as Result, ERROR_MESSAGE() as ErrorMessage, 0.0 as CreditDif, 0.0 as DebitDif, 0.0 as ABalance, 0.0 as MBalance, 0.0 as BonusBalance      
 END CATCH      
END
GO
