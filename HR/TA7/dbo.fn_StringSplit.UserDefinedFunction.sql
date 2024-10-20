USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_StringSplit]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Splits Input parameter into a table of Item Values
CREATE FUNCTION [dbo].[fn_StringSplit]
(    
      @Input NVARCHAR(MAX),
      @Character CHAR(1)
)
RETURNS @Output TABLE (
      Item NVARCHAR(1000)
)
AS
BEGIN
      DECLARE @StartIndex INT, @EndIndex INT

      SET @StartIndex = 1
      IF SUBSTRING(@Input, LEN(@Input) - 1, LEN(@Input)) <> @Character
      BEGIN
            SET @Input = @Input + @Character
      END

      WHILE CHARINDEX(@Character, @Input) > 0
      BEGIN
            SET @EndIndex = CHARINDEX(@Character, @Input)
           
            INSERT INTO @Output(Item)
            SELECT SUBSTRING(@Input, @StartIndex, @EndIndex - 1)
           
            SET @Input = SUBSTRING(@Input, @EndIndex + 1, LEN(@Input))
      END

      RETURN
END
GO
