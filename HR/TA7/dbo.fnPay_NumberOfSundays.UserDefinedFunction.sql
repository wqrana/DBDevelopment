USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fnPay_NumberOfSundays]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Function [dbo].[fnPay_NumberOfSundays](@dFrom datetime, @dTo   datetime)
Returns int as
BEGIN
   Declare @nSundays int
   Set @nSundays = 0
   While @dFrom <= @dTo Begin
      If datepart(dw, @dFrom) = 1 Set @nSundays = @nSundays + 1
      Set @dFrom = DateAdd(d, 1, @dFrom)
   End
   Return (@nSundays)
END
GO
