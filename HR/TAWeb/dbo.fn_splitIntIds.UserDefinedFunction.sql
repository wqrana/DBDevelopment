USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_splitIntIds]    Script Date: 10/18/2024 8:30:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Waqar Q.
-- Create date: 2019-06-16
-- Description:	used to split ids into int list

-- Modification History
/*


*/
-- =============================================
Create FUNCTION [dbo].[fn_splitIntIds]  
(  
	@RowData	NVARCHAR(MAX),
	@Delimiter	NVARCHAR(5)
)    
RETURNS @ReturnValue TABLE (Id BIGINT)  
AS
BEGIN

	DECLARE @Counter INT
	SET @Counter = 1

	IF @RowData IS NOT NULL AND @RowData <> ''
	BEGIN
		WHILE (CHARINDEX(@Delimiter, @RowData) > 0)
		BEGIN
		  INSERT INTO @ReturnValue (Id)  
		  SELECT Id =
			  LTRIM(RTRIM(SUBSTRING(@RowData,1,CHARINDEX(@Delimiter,@RowData)-1)))
		  SET @RowData =
			  SUBSTRING(@RowData,CHARINDEX(@Delimiter, @RowData)+1,LEN(@RowData))
		  SET @Counter = @Counter + 1  
		END
		
		IF NOT @RowData IS NULL
		BEGIN
			INSERT INTO @ReturnValue (Id)  
			SELECT Id = LTRIM(RTRIM(@RowData))  
		END
	END
	
	RETURN 

END


GO
