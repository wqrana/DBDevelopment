USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_ExecuteSetupUserAsSuperAdmin]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_ExecuteSetupUserAsSuperAdmin]
	@ClientId int
AS
BEGIN
		EXEC [dbo].[sp_SetupUserAsSuperAdmin]	@UserInformationId = 1,	@ClientId = 1, @CompanyId = 1
END
GO
