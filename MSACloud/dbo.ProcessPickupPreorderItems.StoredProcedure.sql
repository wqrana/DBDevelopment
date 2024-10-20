USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[ProcessPickupPreorderItems]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Add modified procedure Alter Script (ProcessPickupPreorderItems)
-- =============================================
-- Author:		Inayat
-- Create date: 31-Mar-2017
-- Description:	Process selected preorder items as picked up.
-- Modification History
-- Handling of Client Local Date and UTC Date

-- ===========Modification History================
-- Author:		WaqarQ
-- Create date: 17-Mar-2018
-- Description:	Handling of Preorder Reserved items (by using flag @isReimbursableItem)

-- ===========Modification History================
-- Author:		WaqarQ
-- Create date: 23-Jul-2018
-- Description:	Bug Fixing,  Preorder Reserved items 


-- =============================================
CREATE PROCEDURE [dbo].[ProcessPickupPreorderItems]
    @ClientID BIGINT ,
    @CashierId BIGINT ,
    @LocalDateTime DATETIME2(7) ,
    @SelectedPreorderItems PreorderPickupItemType READONLY ,
    @Result INT OUTPUT ,
    @ErrorMsg NVARCHAR(4000) OUTPUT
AS
    BEGIN

        SET NOCOUNT ON
        SET XACT_ABORT ON

		Declare @UTCDateTime DATETIME2(7) = GETUTCDATE();


        DECLARE @PreorderitemId INT ,
            @PreorderId INT ,
            @PickedupQty INT ,
            @ORDID INT = -1 ,					-- Pass -1 for new, otherwise pass order to be updated
            @CustomerId INT ,
            @Transtype INT ,
            @MCredit FLOAT ,
            @ACredit FLOAT ,
            @BCredit FLOAT ,
            @ORDLOG_ID INT = -1 ,				-- Pass -1 for new, Pass NULL for no log, Pass >0 for update
            @ABalance FLOAT ,
            @MBalance FLOAT ,
            @BonusBalance FLOAT ,
            @OrderResult INT ,
            @OrderErrorMsg NVARCHAR(4000) ,
            @MenuId INT ,
            @FullPrice FLOAT ,
            @SoldType INT ,
            @ServingDate SMALLDATETIME ,
            @LastCustId INT ,
            @LastServingDate SMALLDATETIME,
			@LastisReimbursableItem BIT,
			@LastPreorderitemId INT,
			@isReimbursableItem BIT,
			@PaidPrice FLOAT,
			@ReimbursableItemPrice FLOAT
        DECLARE preorder_cursor CURSOR LOCAL FAST_FORWARD
        FOR
            SELECT  spi.Id ,
                    spi.Qty AS PickupQty ,
                    po.Id AS PreOrderId ,
                    po.Customer_Id AS CustomerId ,
                    CASE WHEN ( c.LunchType IN ( 1, 2, 3, 5 )
                                OR c.isStudent = 1
                              ) THEN 1030
                         ELSE 1040
                    END AS TransType ,
                    po.MCredit ,
                    po.ACredit ,
                    po.BCredit ,
                    ISNULL(ai.ABalance, 0.0) AS ABalance ,
                    ISNULL(ai.MBalance, 0.0) AS MBalance ,
                    ISNULL(ai.BonusBalance, 0.0) AS BonusBalance ,
                    poi.Menu_Id ,
                    poi.FullPrice ,
					
                    poi.SoldType ,
                    poi.ServingDate,
					IsNull(spi.isReimbursableItem,0) AS isReimbursableItem,
					Poi.PaidPrice,
					Case (isNull(spi.isReimbursableItem,0))
							when 1 Then
							spi.Qty *
							 (Case 
									when c.LunchType = 2 then ISNULL(m.StudentRedPrice,0) 
									when c.LunchType = 3 then 0
									ELsE
										ISNULL(m.StudentFullPrice,0) 
								 End )
				     ELSE
						   0
					End As ReimbursableItemPrice
					
            FROM    @SelectedPreorderItems spi
                    LEFT OUTER JOIN PreOrderItems poi ON poi.ClientID = @ClientID
                                                         AND poi.Id = spi.Id
					LEFT OUTER JOIN Menu m   ON  m.ClientID = poi.ClientID	
														AND m.id = poi. menu_id	
                    LEFT OUTER JOIN PreOrders po ON po.ClientID = poi.ClientID
                                                    AND po.Id = poi.PreOrder_Id
                    LEFT OUTER JOIN Customers c ON c.ClientID = po.ClientID
                                                   AND c.Id = po.Customer_Id
                    LEFT OUTER JOIN AccountInfo ai ON ai.ClientID = c.ClientID
                                                      AND ai.Customer_Id = c.Id
			-- If quantity being picked up is zero OR the item is void then ignore this item
			-- because it cannot be processed. 
            WHERE   spi.Qty > 0
                    AND poi.IsVoid = 0
                    AND po.IsVoid = 0
            ORDER BY poi.ServingDate ,
                    po.Customer_Id,spi.isReimbursableItem

        SET @LastCustId = 0
        SET @LastServingDate = NULL	
		SET @LastisReimbursableItem = 0
		SET	@LastPreorderitemId = 0
        BEGIN TRAN
        BEGIN TRY

            OPEN preorder_cursor
            FETCH NEXT FROM preorder_cursor 
			INTO @PreorderitemId, @PickedupQty, @PreorderId, @CustomerId,
                @Transtype, @MCredit, @ACredit, @BCredit, @ABalance, @MBalance,
                @BonusBalance, @MenuId, @FullPrice, @SoldType, @ServingDate, @isReimbursableItem, @PaidPrice,@ReimbursableItemPrice

            WHILE ( @@FETCH_STATUS = 0 )
                BEGIN
					IF ( (@CustomerId <> @LastCustId
                         OR @ServingDate <> @LastServingDate OR @PreorderitemId <> @LastPreorderitemId) AND @isReimbursableItem = 1
                       )
                    BEGIN
							SET @ORDID = -1
						
						   EXEC Main_Order_Save @ClientID, @ORDID OUTPUT, -3,
                                @CashierId, @CustomerId, @Transtype, 0.0, 0.0,
                                @ReimbursableItemPrice, 0.00, 0.00, @UTCDateTime,
                                @ORDLOG_ID OUTPUT, @ABalance OUTPUT,
                                @MBalance OUTPUT, @BonusBalance OUTPUT,
                                @OrderResult OUTPUT, @OrderErrorMsg OUTPUT,
								@ORDERDATE = @LocalDateTime
					
					END
									

                   ELSE IF (( @CustomerId <> @LastCustId
							OR @ServingDate <> @LastServingDate ) AND @isReimbursableItem = 0
                       )
                        BEGIN

				-- Set order Id for new order
                            SET @ORDID = -1

				-- Main_Order_Save will save @ORDID - it is an output parameter
                            EXEC Main_Order_Save @ClientID, @ORDID OUTPUT, -3,
                                @CashierId, @CustomerId, @Transtype, 0.0, 0.0,
                                0.0, 0.0, 0.0, @UTCDateTime,
                                @ORDLOG_ID OUTPUT, @ABalance OUTPUT,
                                @MBalance OUTPUT, @BonusBalance OUTPUT,
                                @OrderResult OUTPUT, @OrderErrorMsg OUTPUT,
								@ORDERDATE = @LocalDateTime
                 END


                 
				    IF ( @OrderResult <> 0 )
                        RAISERROR('Main_Order_Save stored procedure faild', 11, 1)
					
					
					IF (ISNULL(@isReimbursableItem,0) = 1) SET @PaidPrice = @ReimbursableItemPrice


                    EXEC SavePickedupPreorderItem @ClientID, @PreorderitemId,
                        1, @ORDID, @MenuId, @PickedupQty, @FullPrice, @PaidPrice, 0.0,
                        @SoldType, @PickDate = @LocalDateTime
					
					

                    SET @LastCustId = @CustomerId
                    SET @LastServingDate = @ServingDate
					SET @LastisReimbursableItem = @isReimbursableItem
					SET	@LastPreorderitemId = @PreorderitemId

                    FETCH NEXT FROM preorder_cursor 
			INTO @PreorderitemId, @PickedupQty, @PreorderId, @CustomerId,
                        @Transtype, @MCredit, @ACredit, @BCredit, @ABalance,
                        @MBalance, @BonusBalance, @MenuId, @FullPrice,
                        @SoldType, @ServingDate,  @isReimbursableItem, @PaidPrice,@ReimbursableItemPrice
                END
		

            COMMIT TRAN
            SET @Result = 0
            SET @ErrorMsg = N''
	
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
            SET @Result = ERROR_STATE()
            SET @ErrorMsg = ERROR_MESSAGE()
        END CATCH

        CLOSE preorder_cursor
        DEALLOCATE preorder_cursor
    END
GO
