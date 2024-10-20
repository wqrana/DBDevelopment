USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[DateOnly]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[DateOnly]
(
    @date datetime
)
RETURNS Datetime
AS
BEGIN
    
    RETURN DATEADD(dd, 0, DATEDIFF(dd, 0, isnull(@date, getdate())))
END
GO
