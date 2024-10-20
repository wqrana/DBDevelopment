USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[procEndOfDayBalance]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[procEndOfDayBalance]
	@id int = 0,
	@dtDate datetime ,
	@balances varchar(80) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

-- View Accrual Balances for TimeAide's Compensation
	SET @balances = 'Vacation: '
					+ (SELECT CONVERT(VARCHAR,CONVERT(DECIMAL(8,2), [dbo].[fnCompensationEndOfDayBalance] (GETDATE(),@id,'VA'),8),8))
					+ '     '
					+ 'SICK: '
					+ (SELECT CONVERT(VARCHAR,CONVERT(DECIMAL(8,2), [dbo].[fnCompensationEndOfDayBalance] (GETDATE(),@id,'SA'),8),8))
					+ '     '
-- View Accrual Balances for TimeAide's regular Accrual
/*
	SET @balances = 'Vacation: ' 
					+ (
						SELECT convert(varchar,convert(decimal(8,2),[dblAccruedHours],8),8)
						FROM [dbo].[tUserAccrual]
						WHERE nUserID = @id AND sLicenseCode = 'VA'
					  ) 
					+ '     '
					+ 'AP: ' 
					+ (
						SELECT convert(varchar,convert(decimal(8,2),[dblAccruedHours],8),8)
						FROM [dbo].[tUserAccrual]
						WHERE nUserID = @id AND sLicenseCode = 'AP'
					  ) 
					+ '     '
*/
	SELECT @balances
END
GO
