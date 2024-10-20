USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Orders_GetRecentPosClientOrders_old]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Orders_GetRecentPosClientOrders_old]
    @ClientID bigint,
    @LastUpdatedUTC datetime2,
    @MaxRows int = NULL
AS

DECLARE @DefaultMaxRows int = 1000

DECLARE @RecentOrders table (
    [ClientID]              bigint,
    [Id]                    bigint,
    [Customer_Pr_School_Id] int,
    [POS_Id]                int,
    [School_Id]             int,
    [Emp_Cashier_Id]        int,
    [Customer_Id]           int,
    [OrdersLog_Id]          int,
    [GDate]                 smalldatetime,
    [OrderDate]             datetime2(7),
    [OrderDateLocal]        datetime2(7),
    [LunchType]             int,
    [ADebit]                float(53),
    [MDebit]                float(53),
    [ACredit]               float(53),
    [BCredit]               float(53),
    [MCredit]               float(53),
    [CheckNumber]           int,
    [OverRide]              bit,
    [isVoid]                bit,
    [TransType]             int,
    [CreditAuth_Id]         int,
    [PartitionId]           varchar (32),
    [PartitionOffset]       varchar (32),
    [LastUpdatedUTC]        datetime2
)

IF (@MaxRows IS NULL OR @MaxRows < 0)
BEGIN
    SET @MaxRows = @DefaultMaxRows
END

INSERT INTO @RecentOrders (
    ClientID,
    Id,
    Customer_Pr_School_Id,
    POS_Id,
    School_Id,
    Emp_Cashier_Id,
    Customer_Id,
    OrdersLog_Id,
    GDate,
    OrderDate,
    OrderDateLocal,
    LunchType,
    ADebit,
    MDebit,
    ACredit,
    BCredit,
    MCredit,
    CheckNumber,
    [OverRide],
    isVoid,
    TransType,
    CreditAuth_Id,
    PartitionId,
    PartitionOffset,
    LastUpdatedUTC
)
SELECT TOP (@MaxRows)
    o.ClientID,
    o.Id,
    o.Customer_Pr_School_Id,
    o.POS_Id,
    o.School_Id,
    o.Emp_Cashier_Id,
    o.Customer_Id,
    o.OrdersLog_Id,
    o.GDate,
    o.OrderDate,
    o.OrderDateLocal,
    o.LunchType,
    o.ADebit,
    o.MDebit,
    o.ACredit,
    o.BCredit,
    o.MCredit,
    o.CheckNumber,
    o.[OverRide],
    o.isVoid AS IsVoid,
    o.TransType,
    o.CreditAuth_Id,
    o.PartitionId,
    o.PartitionOffset,
    o.LastUpdatedUTC
FROM
    Orders AS o
WHERE 
    o.ClientID = @ClientID
    AND (o.LastUpdatedUTC >= @LastUpdatedUTC)

SELECT * 
FROM @RecentOrders

SELECT olog.*
FROM OrdersLog olog
INNER JOIN @RecentOrders recentOrders ON olog.ClientID = recentOrders.ClientID AND olog.Id = recentOrders.Id

RETURN 0
GO
