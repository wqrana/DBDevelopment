USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  StoredProcedure [dbo].[spProjectBillingLookup]    Script Date: 10/18/2024 8:10:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectBillingLookup] 
	@ProjectID as int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT     tProject.sProjectName, tTransDef_1.Name, tTransDef.Name AS LookupName, tProjectBillingLookup.dblRateMultiplier
FROM         tProject INNER JOIN
                      tProjectBillingLookup ON tProject.nProjectID = tProjectBillingLookup.nProjectID INNER JOIN
                      tTransDef AS tTransDef_1 ON tProjectBillingLookup.nTransOrigID = tTransDef_1.ID INNER JOIN
                      tTransDef ON tProjectBillingLookup.nTransLookUpID = tTransDef.ID
where (tProject.nProjectID = @ProjectID or @ProjectID = '')

END
GO
