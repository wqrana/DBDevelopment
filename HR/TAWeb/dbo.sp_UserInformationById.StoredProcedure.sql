USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_UserInformationById]    Script Date: 10/18/2024 8:30:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_UserInformationById] 
	-- Add the parameters for the stored procedure here
	@userId int

	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	

	Select distinct *
	From vw_UserInformation
	Where (Id = @userId
	And DataEntryStatus = 1)
END
GO
