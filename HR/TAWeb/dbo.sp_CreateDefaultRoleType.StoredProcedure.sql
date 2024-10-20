USE [TimeAideSouthern_TSEditor]
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateDefaultRoleType]    Script Date: 10/18/2024 8:30:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_CreateDefaultRoleType]
AS
BEGIN

SET IDENTITY_INSERT [dbo].[RoleType] ON 

INSERT [dbo].[RoleType] ([RoleTypeId], [RoleTypeName], [CompanyId], [ClientId], [CreatedBy], [CreatedDate], [DataEntryStatus], [ModifiedBy], [ModifiedDate]) VALUES (1, N'Super Admin', 1, 1, 1, GetDate(), 2, NULL, NULL)

INSERT [dbo].[RoleType] ([RoleTypeId], [RoleTypeName], [CompanyId], [ClientId], [CreatedBy], [CreatedDate], [DataEntryStatus], [ModifiedBy], [ModifiedDate]) VALUES (2, N'Admin', 1, 1, 1, GetDate(), 1, NULL, NULL)

INSERT [dbo].[RoleType] ([RoleTypeId], [RoleTypeName], [CompanyId], [ClientId], [CreatedBy], [CreatedDate], [DataEntryStatus], [ModifiedBy], [ModifiedDate]) VALUES (3, N'Supervisor', 1, 1, 1, GetDate(), 1, NULL, NULL)

INSERT [dbo].[RoleType] ([RoleTypeId], [RoleTypeName], [CompanyId], [ClientId], [CreatedBy], [CreatedDate], [DataEntryStatus], [ModifiedBy], [ModifiedDate]) VALUES (4, N'User', 1, 1, 1, GetDate(), 1, NULL, NULL)

INSERT [dbo].[RoleType] ([RoleTypeId], [RoleTypeName], [CompanyId], [ClientId], [CreatedBy], [CreatedDate], [DataEntryStatus], [ModifiedBy], [ModifiedDate]) VALUES (5, N'None', 1, 1, 1, GetDate(), 1, NULL, NULL)

SET IDENTITY_INSERT [dbo].[RoleType] OFF

END
GO
