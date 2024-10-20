USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewpay_CompanyGLLookupWithholdings]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewpay_CompanyGLLookupWithholdings]
AS
SELECT        dbo.tDept.Name, dbo.tblCompanyGLLookupUserWithholdings.strWithholdingsName, dbo.tblCompanyGLLookupUserWithholdings.strGLAccount, dbo.tblCompanyGLAccountLookup.strCompanyName
FROM            dbo.tblCompanyGLAccountLookup INNER JOIN
                         dbo.tblCompanyGLLookupUserWithholdings ON dbo.tblCompanyGLAccountLookup.intAccountLookup = dbo.tblCompanyGLLookupUserWithholdings.intAccountLookup INNER JOIN
                         dbo.tDept ON dbo.tblCompanyGLAccountLookup.intDepartmentID = dbo.tDept.ID


GO
