USE [Live_MSA_Test_Cloud]
GO
/****** Object:  UserDefinedFunction [dbo].[Admin_AccessRights_List]    Script Date: 10/18/2024 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Admin_AccessRights_List]
(
	@ClientID BIGINT,
	@SecurityGroup VARCHAR(100)
)
RETURNS @AccessRights TABLE 
(
	[ID] BIGINT, [ObjectID] INT, [SecurityGroup_Id] BIGINT, [canInsert] BIT,
	[canDelete] BIT, [canView] BIT, [canEdit] BIT
)
AS
BEGIN
	DECLARE @SecurityGroup_Id BIGINT;
	SELECT @SecurityGroup_Id = ID FROM [SecurityGroup] WHERE ClientID = @ClientID
	AND GroupName = @SecurityGroup

	INSERT INTO @AccessRights
		SELECT [ID] ,[ObjectID], [SecurityGroup_Id], [canInsert], [canDelete], [canView], [canEdit]
		FROM AccessRights WHERE ClientID = @ClientID AND SecurityGroup_Id = @SecurityGroup_Id
	
	RETURN 
END
GO
