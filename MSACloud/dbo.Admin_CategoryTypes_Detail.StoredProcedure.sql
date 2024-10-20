USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[Admin_CategoryTypes_Detail]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Neil Heverly
-- Create date: 1/27/2014
-- Description:	Gets Details for the Category Type Specified.
-- =============================================
CREATE PROCEDURE [dbo].[Admin_CategoryTypes_Detail]
	-- Add the parameters for the stored procedure here
	@ClientID bigint,
	@CategoryTypeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
		ct.Id as Category_Type_Id,
		ct.Name as Category_Type_Name,
		ct.canFree as Can_Be_Free,
		ct.canReduce as Can_Be_Reduced,
		ct.isDeleted as Deleted
		--select *
	FROM dbo.CategoryTypes ct
	WHERE ct.ClientID = @ClientID AND
		ct.Id = @CategoryTypeID
END
GO
