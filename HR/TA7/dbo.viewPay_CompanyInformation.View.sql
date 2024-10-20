USE [TIMEAIDE_7_SOUTHERN]
GO
/****** Object:  View [dbo].[viewPay_CompanyInformation]    Script Date: 10/18/2024 8:10:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[viewPay_CompanyInformation]
-- WITH ENCRYPTION
AS
SELECT        dbo.tblCompanyPayrollInformation.strCompanyName, dbo.tblCompanyPayrollInformation.strAddress1, dbo.tblCompanyPayrollInformation.strAddress2, dbo.tblCompanyPayrollInformation.strCity, 
                         dbo.tblCompanyPayrollInformation.strState, dbo.tblCompanyPayrollInformation.strZipCode, dbo.tblCompanyPayrollInformation.strCountry, dbo.tblCompanyPayrollInformation.strPhone, 
                         dbo.tblCompanyPayrollInformation.strFax, dbo.tblCompanyPayrollInformation.strEmail, dbo.tblCompanyPayrollInformation.strWebSite, dbo.tblCompanyPayrollInformation.strContactName, 
                         dbo.tblCompanyPayrollInformation.strPayrollName, dbo.tblCompanyPayrollInformation.strPayrollAddress1, dbo.tblCompanyPayrollInformation.strPayrollAddress2, 
                         dbo.tblCompanyPayrollInformation.strPayrollCountry, dbo.tblCompanyPayrollInformation.strPayrollCity, dbo.tblCompanyPayrollInformation.strPayrollState, dbo.tblCompanyPayrollInformation.strPayrollZipCode, 
                         dbo.tblCompanyPayrollInformation.strEIN, dbo.tblCompanyPayrollInformation.strPayrollFax, dbo.tblCompanyPayrollInformation.strPayrollContactName, dbo.tblCompanyPayrollInformation.strPayrollContactTitle, 
                         dbo.tblCompanyPayrollInformation.strPayrollContactPhone, dbo.tblCompanyPayrollInformation.strPayrollEmail, dbo.tblCompanyLogo.imageLogo
FROM            dbo.tblCompanyPayrollInformation LEFT OUTER JOIN
                         dbo.tblCompanyLogo ON dbo.tblCompanyPayrollInformation.strCompanyName = dbo.tblCompanyLogo.strCompanyName

GO
