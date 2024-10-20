USE [Live_MSA_Test_Cloud]
GO
/****** Object:  StoredProcedure [dbo].[GetPreorderSyncData]    Script Date: 10/18/2024 11:30:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetPreorderSyncData]
	@tableName varchar(50),
	@numberOfRows VARCHAR(50),
	@clientID BIGINT,
	@lastSyncDate DATETIME = NULL,
	@PageIndex INT = 1,
    @PageSize INT = 20    
AS
BEGIN
	declare @sqlstatement NVARCHAR(max)

IF @tableName = 'dbo.CategoryTypes'
BEGIN
	-- Get Category Types
	SELECT ROW_NUMBER() OVER
		(
			ORDER BY ID ASC
		) AS RowNumber,
		ClientID, ID, Name, canFree, canReduce, isDeleted, isMealPlan, isMealEquiv, Local_ID 
		INTO #TempCategoryTypes
	FROM dbo.CategoryTypes 
	WHERE [ClientID] = @clientID AND 
		([LastUpdatedUTC] IS NULL OR
		[LastUpdatedUTC] > ISNULL(@lastSyncDate, '1900-01-01'))				

	SELECT * FROM #TempCategoryTypes WHERE RowNumber BETWEEN (@PageIndex -1) * @PageSize + 1 AND (((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	DROP TABLE #TempCategoryTypes

	-- Get Deleted CategoryTypes
	SELECT ClientID,ID,isDeleted,Local_ID FROM DeletedMSA.CategoryTypes WHERE [ClientID] = @clientID

END 

ELSE IF  @tableName = 'dbo.Category'
BEGIN
	-- Get Categories
	SELECT ROW_NUMBER() OVER
		(
			ORDER BY c.ID ASC
		) AS RowNumber,
	    c.ClientID, c.ID, ct.Local_ID as CategoryType_Id, c.Name, IsActive, c.isDeleted, 
		CONVERT(INT, CONVERT(VARBINARY, SUBSTRING(color,2, LEN(Color)), 2)) as Color, AccountNumber, c.Local_ID 
		INTO #TempCategory
	FROM dbo.Category c
		LEFT OUTER JOIN CategoryTypes ct on ct.Id = c.CategoryType_Id and ct.ClientID = c.ClientID
	WHERE c.[ClientID] = @clientID AND 
		(c.[LastUpdatedUTC] IS NULL OR
		c.LastUpdatedUTC > ISNULL(@lastSyncDate, '1900-01-01'))
		
	SELECT * FROM #TempCategory WHERE RowNumber BETWEEN (@PageIndex -1) * @PageSize + 1 AND (((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	DROP TABLE #TempCategory

	-- Get Deleted Categories
	SELECT  ClientID,ID,isDeleted,Local_ID FROM DeletedMSA.Category WHERE [ClientID] = @clientID

END

ELSE IF  @tableName = 'dbo.Menu'
BEGIN
	-- Get Menu
	SELECT ROW_NUMBER() OVER
		(
			ORDER BY m.ID ASC
		) AS RowNumber,
		m.ClientID, m.ID, c.Local_Id as Category_Id, ItemName, M_F6_Code, StudentFullPrice, StudentRedPrice,
		EmployeePrice, GuestPrice, isTaxable, m.isDeleted, isScaleItem, ItemType, isOnceDay,
		KitchenItem, MealEquivItem, UPC, PreOrderDesc, ButtonCaption, m.Local_ID 
		INTO #TempMenu 
	FROM dbo.Menu m
		LEFT OUTER JOIN Category c on c.Id = m.Category_Id and c.ClientID = m.ClientID
	WHERE m.[ClientID] = @clientID AND  
		(m.LastUpdatedUTC IS NULL OR
		m.[LastUpdatedUTC] > ISNULL(@lastSyncDate, '1900-01-01'))				

	SELECT * FROM #TempMenu WHERE RowNumber BETWEEN(@PageIndex -1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	DROP TABLE #TempMenu

	-- Get Deleted Menu
	SELECT 	ClientID,ID,isDeleted,Local_ID	FROM DeletedMSA.Menu WHERE [ClientID] = @clientID

END

ELSE IF @tableName = 'dbo.Schools'
BEGIN

	-- Get Schools
	SELECT ROW_NUMBER() OVER
		(
			ORDER BY s.ID ASC
		) AS RowNumber,
		s.ClientID, s.ID, ed.Local_Id as Emp_Director_Id, ea.Local_Id as Emp_Administrator_Id, SchoolID, SchoolName,
		s.Address1, s.Address2, s.City, s.[State], s.Zip, s.Phone1, s.Phone2, s.Comment, isSevereNeed, s.isDeleted,
		UseDistDirAdmin, fd.Local_Id as Forms_Director_Id, fa.Local_Id as Forms_Admin_Id, UseDistFormsDirAdmin,
		UseDistNameDirector, UseDistNameAdmin, Forms_Admin_Title, Forms_Admin_Phone, Forms_Dir_Title, Forms_Dir_Phone, s.Local_ID
		INTO #TempSchools 
	FROM dbo.Schools s
		LEFT OUTER JOIN Customers ed on ed.Id = s.Emp_Director_Id and ed.ClientID = s.ClientID
		LEFT OUTER JOIN Customers ea on ea.Id = s.Emp_Administrator_Id and ea.ClientID = s.ClientID
		LEFT OUTER JOIN Customers fa on fa.Id = s.Forms_Admin_Id and fa.ClientID = s.ClientID
		LEFT OUTER JOIN Customers fd on fd.Id = s.Forms_Director_Id and fd.ClientID = s.ClientID
	WHERE s.[ClientID] = @clientID AND  
		(s.LastUpdatedUTC IS NULL OR
		s.[LastUpdatedUTC] > ISNULL(@lastSyncDate, '1900-01-01'))
		
	SELECT * FROM #TempSchools WHERE RowNumber BETWEEN (@PageIndex -1) * @PageSize + 1 AND (((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
	DROP TABLE #TempSchools

	-- Get Deleted Schools
	SELECT 	ClientID,ID,isDeleted,Local_ID		FROM DeletedMSA.Schools WHERE [ClientID] = @clientID

END 




END
GO
