USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Main_Error_Log]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Main_Error_Log]
	@ClientID bigint,
	@ERRORNUM int,
	@ERROROBJ varchar(255) = '',
	@ERRORMSG varchar(1024) = ''
AS
BEGIN
    -- Insert statements for procedure here
	INSERT INTO ErrorLog (ClientID, ErrorDate, Number, Object, Message) VALUES (@ClientID, GETDATE(), @ERRORNUM, @ERROROBJ, @ERRORMSG)
END
GO
