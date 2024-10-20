USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewpay_CompanyGLContributions]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewpay_CompanyGLContributions]
AS
SELECT        dbo.tDept.Name, dbo.tblCompanyGLLookupCompanyWithholdings.strWithholdingsName, dbo.tblCompanyGLLookupCompanyWithholdings.strGLAccount, dbo.tblCompanyGLAccountLookup.strCompanyName, 
                         dbo.tblCompanyGLLookupCompanyWithholdings.strGLContributionPayable
FROM            dbo.tblCompanyGLAccountLookup INNER JOIN
                         dbo.tblCompanyGLLookupCompanyWithholdings ON dbo.tblCompanyGLAccountLookup.intAccountLookup = dbo.tblCompanyGLLookupCompanyWithholdings.intAccountLookup INNER JOIN
                         dbo.tDept ON dbo.tblCompanyGLAccountLookup.intDepartmentID = dbo.tDept.ID

GO
