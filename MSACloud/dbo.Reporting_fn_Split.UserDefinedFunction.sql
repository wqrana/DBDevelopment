USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Reporting_fn_Split]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Abid H
-- Create date: 03/25/2016
-- =============================================
CREATE  FUNCTION [dbo].[Reporting_fn_Split](@text varchar(2048), @delimiter varchar(20) = ' ')
RETURNS @Strings TABLE
(   
  position int IDENTITY PRIMARY KEY,
  value varchar(8000)  
)
AS
BEGIN

DECLARE @index int
SET @index = -1

WHILE (LEN(@text) > 0)
  BEGIN 
    SET @index = CHARINDEX(@delimiter , @text) 
    IF (@index = 0) AND (LEN(@text) > 0) 
      BEGIN  
        INSERT INTO @Strings VALUES (@text)
          BREAK 
      END 
    IF (@index > 1) 
      BEGIN  
        INSERT INTO @Strings VALUES (LEFT(@text, @index - 1))  
        SET @text = RIGHT(@text, (LEN(@text) - @index)) 
      END 
    ELSE
      SET @text = RIGHT(@text, (LEN(@text) - @index))
    END
  RETURN
END
GO
