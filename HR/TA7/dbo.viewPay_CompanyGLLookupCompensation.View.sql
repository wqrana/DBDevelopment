USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_CompanyGLLookupCompensation]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[viewPay_CompanyGLLookupCompensation]
AS
SELECT        dbo.tDept.Name, dbo.tblCompanyGLLookupCompensation.strCompensationName, dbo.tblCompanyGLLookupCompensation.strGLAccount, 
                         dbo.tblCompanyGLAccountLookup.strCompanyName, dbo.tblCompanyGLAccountLookup.intAccountLookup
FROM            dbo.tblCompanyGLAccountLookup INNER JOIN
                         dbo.tblCompanyGLLookupCompensation ON dbo.tblCompanyGLAccountLookup.intAccountLookup = dbo.tblCompanyGLLookupCompensation.intAccountLookup INNER JOIN
                         dbo.tDept ON dbo.tblCompanyGLAccountLookup.intDepartmentID = dbo.tDept.ID

GO
