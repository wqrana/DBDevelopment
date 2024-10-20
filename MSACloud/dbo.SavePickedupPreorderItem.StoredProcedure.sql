USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[SavePickedupPreorderItem]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SavePickedupPreorderItem]
    (
	  @ClientID BIGINT ,
      @PreOrderItem_Id INT ,
      @Disposition INT ,
      @Order_Id INT ,
      @Menu_Id INT ,
      @Qty INT ,
      @FullPrice FLOAT ,
      @PaidPrice FLOAT ,
      @TaxPrice FLOAT ,
      @SoldType INT ,
      @PickDate DATETIME = NULL ,
      @SaveLocal BIT = 0
    )
AS
    BEGIN
        BEGIN TRAN
        BEGIN TRY
            IF ( @SaveLocal = 0 )
                BEGIN	
                    INSERT  INTO Items
                            ( ClientID,
							  Order_Id ,
                              Menu_Id ,
                              Qty ,
                              FullPrice ,
                              PaidPrice ,
                              TaxPrice ,
                              isVoid ,
                              SoldType ,
                              PreOrderItem_Id,
							  LastUpdatedUTC,
							  UpdatedBySync,
							  Local_ID,
							  CloudIDSync
                            )
                    VALUES  ( @ClientID,
							  @Order_Id ,
                              @Menu_Id ,
                              @Qty ,
                              ROUND(@FullPrice, 2) ,
                              ROUND(@PaidPrice, 2) ,
                              @TaxPrice ,
                              0 ,
                              @SoldType ,
                              @PreOrderItem_Id,
							  GETUTCDATE(),
							  0,
							  NULL,
							  0
                            )
                    IF ( @@ERROR <> 0 )
                        RETURN 1
                END

		-- Finally mark the item as picked up
            IF ( @PickDate IS NULL )
                BEGIN
                    SET @PickDate = GETUTCDATE()
                END

            UPDATE  PreOrderItems
            SET     Disposition = CASE WHEN ( ( PickupCount + @Qty ) >= Qty )
                                       THEN @Disposition
                                       ELSE 0
                                  END ,
                    PickupDate = @PickDate ,
                    PickupCount = ( PickupCount + @Qty )
            WHERE   Id = @PreOrderItem_Id
			AND ClientID = @ClientID
            IF ( @@ERROR <> 0 )
                RETURN 2
			
            COMMIT TRAN		
            RETURN 0
        END TRY
        BEGIN CATCH
            ROLLBACK TRAN
            RETURN 0
        END CATCH
    END
GO
