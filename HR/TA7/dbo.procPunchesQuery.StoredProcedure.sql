USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[procPunchesQuery]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procPunchesQuery]
	-- Add the parameters for the stored procedure here
	@UserID int, 
	@PunchDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @Punches as varchar(8000) 
	
	SET @Punches = 'TIME   ' + '         '  + 'Type ' + '       ' + 'Job' + char(10)
	SELECT @Punches = COALESCE(@Punches + '', '') + convert(varchar,TimeConverted + '     ' + convert(varchar,e_mode) + '               ' + convert(varchar,nJobCodeID) + char(10))
	FROM (
			SELECT top 100 
				right('0000000' + ltrim(right(convert(varchar,[DTPunchDateTime]),7)),7) as TimeConverted,
				e_mode,
				nJobCodeID,
				DTPunchDateTime
			FROM tPunchData
			WHERE e_id = @UserID
			AND DTPunchDate = @PunchDate
			ORDER BY DTPunchDateTime DESC
		  ) AS tblConverted
	ORDER BY DTPunchDateTime ASC
	
	SELECT ISNULL(@Punches,'')
END
GO
