USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Report_fn_Split_Int]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Waqar Q.
-- Create date: 2017-04-04
-- Description:	used to split ids into int list

-- Modification History
/*


*/
-- =============================================
CREATE FUNCTION [dbo].[Report_fn_Split_Int]  
(  
	@RowData	NVARCHAR(MAX),
	@Delimiter	NVARCHAR(5)
)    
RETURNS @ReturnValue TABLE (Data BIGINT)  
AS
BEGIN

	DECLARE @Counter INT
	SET @Counter = 1

	IF @RowData IS NOT NULL AND @RowData <> ''
	BEGIN
		WHILE (CHARINDEX(@Delimiter, @RowData) > 0)
		BEGIN
		  INSERT INTO @ReturnValue (data)  
		  SELECT Data =
			  LTRIM(RTRIM(SUBSTRING(@RowData,1,CHARINDEX(@Delimiter,@RowData)-1)))
		  SET @RowData =
			  SUBSTRING(@RowData,CHARINDEX(@Delimiter, @RowData)+1,LEN(@RowData))
		  SET @Counter = @Counter + 1  
		END
		
		IF NOT @RowData IS NULL
		BEGIN
			INSERT INTO @ReturnValue (data)  
			SELECT Data = LTRIM(RTRIM(@RowData))  
		END
	END
	
	RETURN 

END
GO
